import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

class NotificationService {
  static Future<void> initialize() async {
    if (Platform.isAndroid) {
      final channel = NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Channel for basic notifications',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
      );

      await AwesomeNotifications().initialize(
        'resource://drawable/app_icon',
        [channel],
      );

      // Kiểm tra và yêu cầu quyền thông báo
      if (await AwesomeNotifications().isNotificationAllowed() == false) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    }

    // Kiểm tra trạng thái thông báo
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? notificationsEnabled = prefs.getBool('notifications_enabled');

    if (notificationsEnabled == null || !notificationsEnabled) {
      _showNotificationPermissionDialog();
    }

    // Đăng ký nhận thông báo từ Firebase
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: Uuid().v4().hashCode,
            channelKey: 'basic_channel',
            title: message.notification!.title,
            body: message.notification!.body,
            notificationLayout: NotificationLayout.Default,
            icon: 'resource://drawable/ic_notification',
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Thêm logic điều hướng ở đây
      print('Thông báo mở từ trạng thái background');
    });
  }

  // Phương thức để cài đặt thông báo cục bộ
  static Future<void> scheduleLocalNotification(DateTime scheduleDate) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: Uuid().v4().hashCode,
        channelKey: 'basic_channel',
        title: 'Thông báo cài đặt',
        body: 'Đây là thông báo cục bộ đã được lên lịch!',
        notificationLayout: NotificationLayout.Default,
        icon: 'resource://drawable/ic_notification',
      ),
      schedule: NotificationCalendar.fromDate(date: scheduleDate),
    );
  }

  // Hiển thị hộp thoại yêu cầu quyền thông báo
  static void _showNotificationPermissionDialog() {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: Text("Bật thông báo"),
          content: Text("Bạn có muốn nhận thông báo từ ứng dụng không?"),
          actions: [
            TextButton(
              child: Text("Không"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Có"),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('notifications_enabled', true);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
