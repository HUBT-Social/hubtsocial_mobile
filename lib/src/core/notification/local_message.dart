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
  Future<void> initNotification() async {
    // Tạo kênh thông báo cho Android
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Khởi tạo cài đặt thông báo Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // Khởi tạo plugin thông báo
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
  }

  // Xử lý khi người dùng nhấn vào thông báo
  void _onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;

    if (payload != null && payload.isNotEmpty) {
      // Nếu có payload, kiểm tra có 'PackageId' hay không
      if (payload.contains('PackageId')) {
        var data = json.decode(payload) as Map<String, dynamic>;
        router.go(
          '/${AppRoute.notifications.path}/?id=${data['PackageId']}',
        );
      } else {
        // Nếu không có 'PackageId', điều hướng đến màn hình thông báo
        router.go(AppRoute.notifications.path);
      }
    } else {
      // Nếu không có payload, điều hướng đến màn hình chính
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
      channel.id, // This is not a constant value
      channel.name,
      channelDescription: channel.description,
      importance: Importance.high,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );

    final NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    // Hiển thị thông báo
    await flutterLocalNotificationsPlugin.show(
      0, // ID của thông báo
      title, // Tiêu đề thông báo
      body, // Nội dung thông báo
      notificationDetails, // Thông tin chi tiết thông báo
      payload: payload, // Dữ liệu kèm theo
    );
  }
}
// Gọi hàm để hiển thị thông báo cục bộ
// LocalMessage().showNotification(
//   title: "Thông báo mới",
//   body: "Bạn có một thông báo mới!",
//   payload: jsonEncode({'PackageId': '12345'}), // Thêm dữ liệu kèm theo
// );
