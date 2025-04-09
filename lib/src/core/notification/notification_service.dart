import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce/hive.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/features/notification/model/notification_model.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:platform/platform.dart';

@pragma('vm:entry-point')
Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  // Ensure you can handle background messages
  print('Handling background message: ${message.messageId}');
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  BuildContext? _context;

  static const _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
    showBadge: true,
  );

  Future<void> initialize(BuildContext context) async {
    _context = context;

    try {
      // 1. Create notification channel first
      await _createNotificationChannel();

      // 2. Request permission
      await _requestPermission();

      // 3. Set up message handlers
      _setupMessageHandlers();

      print('NotificationService initialized successfully');
    } catch (e) {
      print('Error initializing NotificationService: $e');
    }
  }

  Future<void> _createNotificationChannel() async {
    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    // Remove existing channel if it exists
    await platform?.deleteNotificationChannel(_channel.id);

    // Create new channel
    await platform?.createNotificationChannel(_channel);

    // Initialize local notifications
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final initSettings = InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        _handleNotificationTap(response.payload);
      },
    );
  }

  Future<void> _requestPermission() async {
    try {
      // Kiểm tra quyền hiện tại trước
      final currentSettings =
          await _firebaseMessaging.getNotificationSettings();
      print(
          'Current notification settings: ${currentSettings.authorizationStatus}');

      // Luôn hiển thị dialog xin quyền khi khởi động app
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
        announcement: true,
        carPlay: true,
        criticalAlert: true,
      );

      print('User notification settings: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
        final token = await _firebaseMessaging.getToken();
        print('FCM Token: $token');
      } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
        print('User denied permission');

        // Hiển thị dialog tùy chỉnh khi user từ chối
        if (_context != null) {
          showDialog(
            context: _context!,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: Text('Cần quyền thông báo'),
              content: Text(
                'Ứng dụng cần quyền thông báo để gửi cho bạn các thông tin quan trọng về lịch học, điểm danh và tin nhắn mới.\n\nVui lòng cấp quyền thông báo trong cài đặt để không bỏ lỡ thông tin quan trọng.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Để sau'),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      if (const LocalPlatform().isAndroid) {
                        final packageInfo = await PackageInfo.fromPlatform();
                        final intent = AndroidIntent(
                          action: 'android.settings.APP_NOTIFICATION_SETTINGS',
                          arguments: <String, dynamic>{
                            'android.provider.extra.APP_PACKAGE':
                                packageInfo.packageName,
                          },
                        );
                        await intent.launch();
                      }
                    } catch (e) {
                      print('Error opening settings: $e');
                    }
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Mở cài đặt',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          );
        }
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        print('User granted provisional permission');
      } else {
        print(
            'User declined permission with status: ${settings.authorizationStatus}');
      }

      // Kiểm tra lại quyền sau khi xử lý
      final finalSettings = await _firebaseMessaging.getNotificationSettings();
      print(
          'Final notification settings: ${finalSettings.authorizationStatus}');
    } catch (e) {
      print('Error requesting permission: $e');
    }
  }

  void _setupMessageHandlers() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((message) {
      print('Got foreground message: ${message.messageId}');
      _showNotification(message);
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

    // Handle notification taps
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Notification tapped in background: ${message.messageId}');
      _handleNotificationTap(json.encode(message.data));
    });

    // Configure foreground presentation
    _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _showNotification(RemoteMessage message) async {
    if (message.notification == null) return;

    try {
      // Save notification in background
      _saveNotification(message);

      // Show notification immediately
      await _localNotifications.show(
        message.hashCode,
        message.notification!.title,
        message.notification!.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            enableLights: true,
            enableVibration: true,
            playSound: true,
            icon: '@mipmap/ic_launcher',
            styleInformation: BigTextStyleInformation(
              message.notification!.body ?? '',
              htmlFormatBigText: true,
              contentTitle: message.notification!.title,
              htmlFormatContentTitle: true,
            ),
          ),
        ),
        payload: json.encode(message.data),
      );

      print('Notification shown successfully');
    } catch (e) {
      print('Error showing notification: $e');
    }
  }

  void _handleNotificationTap(String? payload) {
    if (_context == null || payload == null) return;

    try {
      final data = json.decode(payload) as Map<String, dynamic>;
      final type = data['type']?.toString().toLowerCase();

      switch (type) {
        case 'chat':
          final roomId = data['id']?.toString();
          final title = data['title']?.toString();
          final avatarUrl = data['avatarUrl']?.toString();
          if (roomId != null) {
            AppRoute.roomChat.push(_context!, queryParameters: {
              "id": roomId,
              "title": title,
              "avatarUrl": avatarUrl
            });
          } else {
            _context!.go(AppRoute.chat.path);
          }
          break;

        case 'profile':
          final userId = data['userId']?.toString();
          if (userId != null) {
            _context!.go('/profile/$userId');
          } else {
            _context!.go(AppRoute.profile.path);
          }
          break;

        case 'timetable':
          _context!.go(AppRoute.timetable.path);
          break;

        default:
          _context!.go(AppRoute.notifications.path);
      }
    } catch (e) {
      print('Error handling notification tap: $e');
      _context?.go(AppRoute.notifications.path);
    }
  }

  Future<void> _saveNotification(RemoteMessage message) async {
    try {
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
    } catch (e) {
      print('Error saving notification: $e');
    }
  }
}
