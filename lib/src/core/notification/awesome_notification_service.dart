import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class AwesomeNotificationService {
  static Future<void> initialize() async {
    AwesomeNotifications().initialize(
      'resource://drawable/res_app_icon',
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Channel for basic notifications',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        ),
      ],
    );
  }

  static Future<void> showLocalNotification(String title, String body) async {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(1000),
        channelKey: 'basic_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }
}
