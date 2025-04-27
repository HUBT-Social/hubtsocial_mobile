import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/core/notification/LocalMessage.dart';
import 'package:hubtsocial_mobile/src/features/notification/model/notification_model.dart';
import 'package:hubtsocial_mobile/src/core/local_storage/local_storage_type_id.dart';
import 'package:hubtsocial_mobile/hive/hive_adapters.dart';
import '../../router/route.dart';
import '../../router/router.import.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    // Initialize Hive
    await Hive.initFlutter();

    // Register the adapter if not registered
    if (!Hive.isAdapterRegistered(LocalStorageTypeId.notification)) {
      Hive.registerAdapter(NotificationModelAdapter());
    }

    // Store notification in Hive
    final notification = NotificationModel(
      id: message.messageId ?? DateTime.now().toString(),
      title: message.notification?.title,
      body: message.notification?.body,
      time: DateTime.now().toIso8601String(),
      isRead: false,
      data: message.data,
      type: message.data['type']?.toString(),
    );

    final box = await Hive.openBox<NotificationModel>('notifications');
    await box.add(notification);

    logger
        .i('Background notification saved successfully: ${message.messageId}');
  } catch (e) {
    logger.e('Error saving background notification: $e');
  }
}

class FirebaseMessage {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    try {
      // 1. Set background message handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

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

  Future<void> deleteFCMToken() async {
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

      // Kiểm tra xem thông báo đã tồn tại chưa
      final box = await Hive.openBox<NotificationModel>('notifications');
      bool notificationExists = false;

      for (var existingNotification in box.values) {
        if (existingNotification.id == notification.id) {
          notificationExists = true;
          break;
        }
      }

      // Chỉ lưu nếu thông báo chưa tồn tại
      if (!notificationExists) {
        await box.add(notification);
        logger.i('Foreground notification saved: ${notification.id}');
      } else {
        logger.i('Notification already exists: ${notification.id}');
      }

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

    // Ensure Hive is initialized and box is opened before navigation
    _initializeAndNavigate(data);
  }

  Future<void> _initializeAndNavigate(Map<String, dynamic> data) async {
    try {
      // Initialize Hive
      await Hive.initFlutter();

      // Register adapter if needed
      if (!Hive.isAdapterRegistered(LocalStorageTypeId.notification)) {
        Hive.registerAdapter(NotificationModelAdapter());
      }

      // Now handle navigation based on notification type
      final type = data['type']?.toString().toLowerCase();

      // Các loại thông báo cần điều hướng trực tiếp
      switch (type) {
        case 'chat':
          final roomId = data['id']?.toString();
          final isGroupMessage = data['isGroupMessage'] == true;
          final title = data['title']?.toString();
          final avatarUrl = data['avatarUrl']?.toString();

          if (isGroupMessage) {
            if (roomId != null) {
              router.go('/chat/group/$roomId');
            } else {
              router.go(AppRoute.chat.path);
            }
          } else {
            if (roomId != null) {
              router.go(
                  '/chat/$roomId?title=${Uri.encodeComponent(title ?? '')}&avatarUrl=${Uri.encodeComponent(avatarUrl ?? '')}');
            } else {
              router.go(AppRoute.chat.path);
            }
          }
          return;

        case 'timetable':
          final classId = data['classId']?.toString();
          if (classId != null) {
            router.go('${AppRoute.timetable.path}?classId=$classId');
          } else {
            router.go(AppRoute.timetable.path);
          }
          return;

        case 'home':
          router.go(AppRoute.home.path);
          return;

        case 'profile':
          final userId = data['userId']?.toString();
          if (userId != null) {
            router.go('/profile/$userId');
          } else {
            router.go(AppRoute.profile.path);
          }
          return;
      }

      // Đối với các loại thông báo khác (maintenance, academic_warning, exam, broadcast, v.v.)
      // Đảm bảo thông báo được lưu và box được mở trước khi điều hướng
      final notificationId = data['messageId'] ?? DateTime.now().toString();

      // Kiểm tra xem thông báo đã tồn tại chưa
      final box = await Hive.openBox<NotificationModel>('notifications');
      bool notificationExists = false;

      for (var existingNotification in box.values) {
        if (existingNotification.id == notificationId) {
          notificationExists = true;
          break;
        }
      }

      // Chỉ lưu nếu thông báo chưa tồn tại
      if (!notificationExists) {
        final notification = NotificationModel(
          id: notificationId,
          title: data['title'],
          body: data['body'],
          time: DateTime.now().toIso8601String(),
          isRead: false,
          data: data,
          type: type,
        );

        await box.add(notification);
        logger.i('Notification saved: ${notification.id}');
      } else {
        logger.i('Notification already exists: $notificationId');
      }

      // Đợi một chút để đảm bảo dữ liệu được lưu
      await Future.delayed(Duration(milliseconds: 500));

      // Điều hướng đến màn thông báo
      router.go(AppRoute.notifications.path);
    } catch (e) {
      logger.e('Error initializing and navigating: $e');
      router.go(AppRoute.notifications.path);
    }
  }

  void _showLocalNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null) {
      logger.i('Showing local notification: ${message.data}');

      // Xác định loại thông báo để điều hướng
      final type =
          message.data['type']?.toString().toLowerCase() ?? 'notification';
      final isNavigationType =
          ['timetable', 'home', 'profile', 'chat'].contains(type);

      // Tạo payload với đầy đủ thông tin
      final payload = json.encode({
        ...message.data,
        'type': type,
        'isNavigationType': isNavigationType,
        'messageId': message.messageId,
        'title': notification.title,
        'body': notification.body,
      });

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
        payload: payload,
      );
    }
  }

  void _navigateToNotificationScreen(RemoteMessage message) {
    final type = message.data['type']?.toString().toLowerCase();

    switch (type) {
      case 'timetable':
        final classId = message.data['classId']?.toString();
        if (classId != null) {
          router.go('${AppRoute.timetable.path}?classId=$classId');
        } else {
          router.go(AppRoute.timetable.path);
        }
        break;

      case 'chat':
        if (message.data.containsKey('chatUserId')) {
          router.go('/chat/${message.data['chatUserId']}');
        } else {
          router.go(AppRoute.chat.path);
        }
        break;

      case 'profile':
        if (message.data.containsKey('userId')) {
          router.go('/profile/${message.data['userId']}');
        } else {
          router.go(AppRoute.profile.path);
        }
        break;

      default:
        router.go(AppRoute.notifications.path);
    }
  }

  Future<void> _handleTerminatedState() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      // Đảm bảo thông báo được lưu vào Hive trước khi điều hướng
      await _saveNotificationToHive(initialMessage);
      _navigateToNotificationScreen(initialMessage);
    }
  }

  Future<void> _saveNotificationToHive(RemoteMessage message) async {
    try {
      // Initialize Hive
      await Hive.initFlutter();

      // Register adapter if needed
      if (!Hive.isAdapterRegistered(LocalStorageTypeId.notification)) {
        Hive.registerAdapter(NotificationModelAdapter());
      }

      // Create notification model
      final notificationId = message.messageId ?? DateTime.now().toString();

      // Combine data with imageUrl if it exists
      final Map<String, dynamic> data = Map.from(message.data);
      if (!data.containsKey('imageUrl') &&
          message.notification?.android?.imageUrl != null) {
        data['imageUrl'] = message.notification?.android?.imageUrl;
      }

      final notification = NotificationModel(
        id: notificationId,
        title: message.notification?.title,
        body: message.notification?.body,
        time: DateTime.now().toIso8601String(),
        isRead: false,
        data: data,
        type: message.data['type']?.toString(),
      );

      // Open box and check if notification already exists
      final box = await Hive.openBox<NotificationModel>('notifications');
      bool notificationExists = false;

      for (var existingNotification in box.values) {
        if (existingNotification.id == notificationId) {
          notificationExists = true;
          break;
        }
      }

      // Only save if notification doesn't exist
      if (!notificationExists) {
        await box.add(notification);
        logger.i('Terminated state notification saved: ${notification.id}');
      } else {
        logger.i(
            'Terminated state notification already exists: ${notification.id}');
      }

      // Wait to ensure data is saved
      await Future.delayed(Duration(milliseconds: 500));
    } catch (e) {
      logger.e('Error saving terminated state notification: $e');
    }
  }
}
