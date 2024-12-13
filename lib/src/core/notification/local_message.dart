import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../navigation/route.dart';
import '../navigation/router.import.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class LocalMessage {
  // Khởi tạo thông báo

  Future<void> initLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
  }

  void _onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) {
    final String? payload = notificationResponse.payload;
    if (payload != null && payload.isNotEmpty) {
      try {
        final data = json.decode(payload) as Map<String, dynamic>;
        if (data.containsKey('PackageId')) {
          router.go(
            '${AppRoute.notifications.path}?id=${data['PackageId']}',
          );
        } else {
          router.go(AppRoute.notifications.path);
        }
      } catch (e) {
        print('Lỗi khi xử lý payload: $e');
        router.go(AppRoute.notifications.path);
      }
    } else {
      router.go(AppRoute.notifications.path);
    }
  }

  // Hàm để hiển thị thông báo local
  Future<void> showNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );

    final NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
// Gọi hàm để hiển thị thông báo cục bộ
// LocalMessage().showNotification(
//   title: "Thông báo mới",
//   body: "Bạn có một thông báo mới!",
//   payload: jsonEncode({'PackageId': '12345'}), // Thêm dữ liệu kèm theo
// );
