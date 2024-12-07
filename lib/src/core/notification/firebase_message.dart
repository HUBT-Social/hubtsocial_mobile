import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';

import '../app/providers/hive_provider.dart';
import '../navigation/route.dart';
import '../navigation/router.import.dart';
import 'local_message.dart';

// Định nghĩa các key cho từng shell branch để dễ quản lý
final GlobalKey<NavigatorState> _shellNavigatorHome =
    GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final GlobalKey<NavigatorState> _shellNavigatorSettings =
    GlobalKey<NavigatorState>(debugLabel: 'shellSettings');
final GlobalKey<NavigatorState> _shellNavigatorNotifications =
    GlobalKey<NavigatorState>(debugLabel: 'shellNotifications');
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  logInfo('Handling a background message: ${message.messageId}');
  logInfo('Title: ${message.notification?.title}');
  logInfo('Body: ${message.notification?.body}');
}

class FirebaseMessage {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    // Request permission for notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Firebase token handling
      _firebaseMessaging.getToken().then((token) async {
        if (!await Hive.boxExists('token')) {
          await Hive.openBox('token');
        }
        var tokenBox = Hive.box('token');
        await tokenBox.put('fcmToken', token);
      });
    }

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          HiveProvider.addNotification();
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ),
            payload: message.data['Data'].toString(),
          );
        }
      },
    );

    // Listen for when app is opened from a background notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _navigateToNotificationScreen(message);
    });

    // Check if app was opened from a terminated state (completely closed)
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _navigateToNotificationScreen(initialMessage);
    }
  }

  // Function to navigate to the notification screen
  void _navigateToNotificationScreen(RemoteMessage message) {
    if (message.data.containsKey('Data')) {
      var payload = message.data['Data'].toString();
      var data = jsonDecode(payload);
      router.go(
        '${AppRoute.notifications.path}?id=${data['PackageId'] ?? ''}',
      );
    } else {
      router.go(AppRoute.notifications.path); // Default screen
    }
  }
}
