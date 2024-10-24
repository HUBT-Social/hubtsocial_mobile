import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Đăng ký nhận thông báo từ Firebase
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print('Nhận thông báo từ Firebase: ${message.notification!.title}');

        // Tạo thông báo với Awesome Notifications
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: DateTime.now().millisecondsSinceEpoch.remainder(1000),
            channelKey: 'basic_channel',
            title: message.notification!.title,
            body: message.notification!.body,
            notificationLayout: NotificationLayout.Default,
            icon: 'resource://drawable/res_app_icon',
          ),
        );
      }
    });

    // Xử lý thông báo khi ứng dụng được mở từ trạng thái background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Thông báo mở từ trạng thái background');
      // điều hướng đến màn hình tương ứng ở đây
    });
  }
}
