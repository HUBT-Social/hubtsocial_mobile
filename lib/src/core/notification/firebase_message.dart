import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/features/notification/model/notification_model.dart';
import '../navigation/route.dart';
import '../navigation/router.import.dart';
import 'local_message.dart';

class FirebaseMessage {
  final _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    logger.i('Handling a background message: ${message.messageId}');
    logger.i('Title: ${message.notification?.title}');
    logger.i('Body: ${message.notification?.body}');

    // Lưu notification vào Hive khi nhận được ở background
    final notification = NotificationModel(
      id: message.messageId ?? DateTime.now().toString(),
      title: message.notification?.title,
      body: message.notification?.body,
      time: DateTime.now().toIso8601String(),
      isRead: false,
      data: message.data,
    );

    final box = await Hive.openBox<NotificationModel>('notifications');
    await box.add(notification);
  }

  Future<void> initNotification() async {
    await _requestPermission();
    await _configureForegroundNotification();
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
    _handleForegroundMessage();
    FirebaseMessaging.onMessageOpenedApp.listen(_navigateToNotificationScreen);
    await _handleTerminatedState();
  }

  Future<void> _requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await _firebaseMessaging.getToken();
      print('FCM Token: $token');
    }
  }

  Future<void> _configureForegroundNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _handleForegroundMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // Lưu notification vào Hive
      final notification = NotificationModel(
        id: message.messageId ?? DateTime.now().toString(),
        title: message.notification?.title,
        body: message.notification?.body,
        time: DateTime.now().toIso8601String(),
        isRead: false,
        data: message.data,
      );

      final box = await Hive.openBox<NotificationModel>('notifications');
      await box.add(notification);

      // Hiển thị local notification
      _showLocalNotification(message);
    });
  }

  void _showLocalNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'Thông báo quan trọng',
            channelDescription: 'Kênh nhận thông báo từ server',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  }

  void _navigateToNotificationScreen(RemoteMessage message) {
    router.go(AppRoute.notifications.path);
  }

  Future<void> _handleTerminatedState() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _navigateToNotificationScreen(initialMessage);
    }
  }
}
