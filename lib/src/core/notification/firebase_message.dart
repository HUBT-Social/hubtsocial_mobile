import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/features/notification/model/notification_model.dart';
import '../../router/route.dart';
import '../../router/router.import.dart';
import 'local_message.dart';

class FirebaseMessage {
  final _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    logger.i('Handling a background message: ${message.messageId}');
    logger.i('Title: ${message.notification?.title}');
    logger.i('Body: ${message.notification?.body}');

    // Store notification in Hive when received in background
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

  Future<void> initialize() async {
    try {
      // 1. Set background message handler
      FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

      // 2. Request permission
      await _requestPermission();

      // 3. Configure foreground notification
      await _configureForegroundNotification();

      // 4. Set up foreground handler
      _handleForegroundMessage();

      // 5. Handle terminated state
      await _handleTerminatedState();

      // 6. Setup notification tap handling
      await _setupNotificationTapHandling();

      logger.i('FirebaseMessage initialized successfully');
    } catch (e) {
      logger.e('Error initializing FirebaseMessage: $e');
    }
  }

  void deleteFCMToken() async {
    await _firebaseMessaging.deleteToken();
  }

  Future<void> _requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
      criticalAlert: true,
      announcement: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await _firebaseMessaging.getToken();
      logger.i('FCM Token: $token');
    } else {
      logger.w(
          'User declined notification permission: ${settings.authorizationStatus}');
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
      logger.i('Got a message whilst in the foreground!');
      logger.i('Message data: ${message.data}');

      if (message.notification != null) {
        logger.i(
            'Message also contained a notification: ${message.notification}');
      }

      // Lưu notification vào Hive với custom data
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

  Future<void> _setupNotificationTapHandling() async {
    // Initialize flutter_local_notifications
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final initSettings = InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        logger.i('Notification tapped with payload: ${response.payload}');
        if (response.payload != null) {
          try {
            final data = json.decode(response.payload!) as Map<String, dynamic>;
            _handleNotificationTap(data);
          } catch (e) {
            logger.e('Error handling notification tap: $e');
          }
        }
      },
    );
  }

  void _handleNotificationTap(Map<String, dynamic> data) {
    logger.i('Handling notification tap with data: $data');
    final type = data['type']?.toString().toLowerCase();

    switch (type) {
      case 'timetable':
        final classId = data['classId']?.toString();
        if (classId != null) {
          router.go('${AppRoute.timetable.path}?classId=$classId');
        } else {
          router.go(AppRoute.timetable.path);
        }
        break;

      case 'chat':
        final chatId = data['chatUserId']?.toString();
        if (chatId != null) {
          router.go('/chat/$chatId');
        } else {
          router.go(AppRoute.chat.path);
        }
        break;

      case 'profile':
        final userId = data['userId']?.toString();
        if (userId != null) {
          router.go('/profile/$userId');
        } else {
          router.go(AppRoute.profile.path);
        }
        break;

      default:
        router.go(AppRoute.notifications.path);
    }
  }

  void _showLocalNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null) {
      logger.i('Showing local notification: ${message.data}');

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
            enableVibration: true,
            playSound: true,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: json.encode({
          ...message.data,
          'type': message.data['type'] ?? 'notification',
        }),
      );
    }
  }

  void _navigateToNotificationScreen(RemoteMessage message) {
    router.go(AppRoute.notifications.path);
    // Kiểm tra va đh
    if (message.data.containsKey('chatUserId')) {
      //cjat
      router.go('/chat/${message.data['chatUserId']}');
    } else if (message.data.containsKey('notificationId')) {
      router.go(
          '${AppRoute.notifications.path}?id=${message.data['notificationId']}');
    } else {
      // Mặc định điều hướng đến màn hình thông báo
      router.go(AppRoute.notifications.path);
    }
  }

  Future<void> _handleTerminatedState() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _navigateToNotificationScreen(initialMessage);
    }
  }
}
