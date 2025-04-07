import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce/hive.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/features/notification/model/notification_model.dart';
import 'package:hubtsocial_mobile/src/features/timetable/models/class_schedule.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  BuildContext? _context;

  // Notification channels
  static const mainChannel = AndroidNotificationChannel(
    'main_channel',
    'Main Notifications',
    description: 'Main channel for all notifications',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
    showBadge: true,
  );

  static const scheduleChannel = AndroidNotificationChannel(
    'schedule_channel',
    'Schedule Notifications',
    description: 'Channel for class schedule notifications',
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
    showBadge: true,
  );

  Future<void> initialize(BuildContext context) async {
    _context = context;

    try {
      print('[NotificationService] Initializing...');

      // 1. Set background message handler
      FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

      // 2. Request permission with all options
      await _requestPermission();

      // 3. Configure notification settings
      await _configureForegroundNotification();

      // 4. Enable auto initialization
      await _firebaseMessaging.setAutoInitEnabled(true);

      // 5. Subscribe to broadcast topic
      await _firebaseMessaging.subscribeToTopic('broadcast');

      // 6. Set up handlers
      _handleForegroundMessage();
      FirebaseMessaging.onMessageOpenedApp
          .listen(_navigateToNotificationScreen);

      // 7. Handle terminated state
      await _handleTerminatedState();

      // 8. Setup notification tap handling
      await _setupNotificationTapHandling();

      // 9. Setup time zones
      await _setupTimeZones();

      // 10. Setup notifications
      await _setupNotifications();

      // 11. Start schedule checker
      _startScheduleChecker();

      logger.i('NotificationService initialized successfully');
    } catch (e, stackTrace) {
      print('[NotificationService] Initialization error: $e');
      print(stackTrace);
      logger.e('Error initializing NotificationService: $e');
    }
  }

  Future<void> _requestPermission() async {
    try {
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        provisional: false,
        sound: true,
        criticalAlert: true,
        announcement: true,
        carPlay: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        String? token = await _firebaseMessaging.getToken();
        logger.i('FCM Token: $token');
      } else {
        logger.w(
            'User declined notification permission: ${settings.authorizationStatus}');
      }
    } catch (e) {
      logger.e('Error requesting permission: $e');
    }
  }

  Future<void> _configureForegroundNotification() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
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

        // Save to storage with additional metadata
        await _saveNotification(
          message,
          additionalData: {
            'type': message.data['type'] ?? 'notification',
          },
        );

        // Show local notification
        // await _showLocalNotification(message);
      }
    });
  }

  Future<void> _setupNotificationTapHandling() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final initSettings = InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        logger.i('Notification tapped with payload: ${response.payload}');
        if (response.payload != null) {
          try {
            final data = json.decode(response.payload!) as Map<String, dynamic>;
            _handleNavigation(data);
          } catch (e) {
            logger.e('Error handling notification tap: $e');
          }
        }
      },
    );
  }

  void _navigateToNotificationScreen(RemoteMessage message) {
    if (_context == null) return;

    final type = message.data['type']?.toString().toLowerCase();
    final isGroupMessage = message.data['isGroupMessage'] == true;
    final isBroadcast = message.data['isBroadcast'] == true;

    if (isBroadcast) {
      _context!.go(AppRoute.notifications.path);
      return;
    }

    switch (type) {
      case 'chat':
        final roomId = message.data['id']?.toString();
        final title = message.data['title']?.toString();
        final avatarUrl = message.data['avatarUrl']?.toString();
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
        final userId = message.data['userId']?.toString();
        _context!
            .go(userId != null ? '/profile/$userId' : AppRoute.profile.path);
        break;

      default:
        _context!.go(AppRoute.notifications.path);
    }
  }

  Future<void> _handleTerminatedState() async {
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _navigateToNotificationScreen(initialMessage);
    }
  }

  void _showLocalNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null) {
      logger.i('Showing local notification: ${message.data}');

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            mainChannel.id,
            mainChannel.name,
            channelDescription: mainChannel.description,
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

  Future<void> _setupTimeZones() async {
    try {
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
    } catch (e) {
      logger.e('Error setting up timezones: $e');
    }
  }

  Future<void> _setupNotifications() async {
    try {
      // Android settings
      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS settings if needed
      // final iOSSettings = IOSInitializationSettings();

      // Combined settings
      final initSettings = InitializationSettings(android: androidSettings);

      // Initialize
      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTap,
      );

      // Create channels
      final android = _localNotifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      await android?.createNotificationChannel(mainChannel);
      await android?.createNotificationChannel(scheduleChannel);

      logger.i('Notification setup completed');
    } catch (e) {
      logger.e('Error setting up notifications: $e');
    }
  }

  Future<void> _handleMessage(
      RemoteMessage message, BuildContext context) async {
    try {
      print('[NotificationService] Handling message...');
      logger.i('Received foreground message: ${message.messageId}');

      final notificationType = message.data['type'] ?? 'system';
      final isBroadcast = notificationType == 'broadcast';
      final targetUsers = message.data['targetUsers'];
      final groupId = message.data['groupId'];

      // Nếu là thông báo broadcast, không cần kiểm tra targetUsers
      if (!isBroadcast && targetUsers != null) {
        final userList = List<String>.from(json.decode(targetUsers));
        final currentUserId = context.userProvider.user?.idUser;
        if (currentUserId == null || !userList.contains(currentUserId)) {
          return; // Không hiển thị nếu không phải người nhận
        }
      }

      // Save to storage with additional metadata
      await _saveNotification(
        message,
        additionalData: {
          'groupId': groupId,
          'isGroupMessage': groupId != null,
          'isBroadcast': isBroadcast,
        },
      );

      // Show notification
      await showNotification(
        title: message.notification?.title ?? 'New Message',
        body: message.notification?.body ?? '',
        payload: json.encode({
          ...message.data,
          'groupId': groupId,
          'isGroupMessage': groupId != null,
          'isBroadcast': isBroadcast,
        }),
      );
    } catch (e) {
      print('[NotificationService] Error handling message: $e');
      logger.e('Error handling foreground message: $e');
    }
  }

  Future<void> _saveNotification(RemoteMessage message,
      {Map<String, dynamic>? additionalData}) async {
    try {
      final notification = NotificationModel(
        id: message.messageId ?? DateTime.now().toString(),
        title: message.notification?.title,
        body: message.notification?.body,
        time: DateTime.now().toIso8601String(),
        isRead: false,
        data: {
          ...message.data,
          ...?additionalData,
        },
      );

      final box = await Hive.openBox<NotificationModel>('notifications');
      // Thêm thông báo mới vào đầu danh sách
      await box.add(notification);

      // Sắp xếp lại box để thông báo mới nhất lên đầu
      final notifications = box.values.toList()
        ..sort(
            (a, b) => DateTime.parse(b.time).compareTo(DateTime.parse(a.time)));

      // Xóa toàn bộ và thêm lại theo thứ tự mới
      await box.clear();
      await box.addAll(notifications);
    } catch (e) {
      logger.e('Error saving notification: $e');
    }
  }

  void _onNotificationTap(NotificationResponse response) {
    try {
      if (response.payload != null) {
        final data = json.decode(response.payload!) as Map<String, dynamic>;
        _handleNavigation(data);
      }
    } catch (e) {
      logger.e('Error handling notification tap: $e');
    }
  }

  void _handleNavigation(Map<String, dynamic> data) {
    if (_context == null) return;

    try {
      final type = data['type']?.toString().toLowerCase() ?? 'notification';
      final isGroupMessage = data['isGroupMessage'] == true;
      final isBroadcast = data['isBroadcast'] == true;

      // Xử lý điều hướng dựa trên loại thông báo
      if (isBroadcast) {
        // Thông báo broadcast luôn đưa về màn notifications
        _context!.go(AppRoute.notifications.path);
        return;
      }

      switch (type) {
        case 'chat':
          // if (isGroupMessage) {
          //   final groupId = data['groupId']?.toString();
          //   if (groupId != null) {
          //     // _context!.go('/chat/group/$groupId');

          //     _context!.push('/room?id=${groupId}');
          //   } else {
          //     _context!.go(AppRoute.chat.path);
          //   }
          // } else {
          //   final chatId = data['chatId']?.toString();
          //   _context!.go(chatId != null ? '/chat/$chatId' : AppRoute.chat.path);
          // }
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
          _context!
              .go(userId != null ? '/profile/$userId' : AppRoute.profile.path);
          break;

        default:
          _context!.go(AppRoute.notifications.path);
      }
    } catch (e) {
      logger.e('Error navigating: $e');
      if (_context != null) {
        _context!.go(AppRoute.notifications.path);
      }
    }
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
    AndroidNotificationChannel channel = mainChannel,
  }) async {
    try {
      print('[NotificationService] Attempting to show notification');
      print('[NotificationService] Title: $title');
      print('[NotificationService] Body: $body');
      print('[NotificationService] Channel: ${channel.id}');

      // Check if notifications are enabled
      final android = _localNotifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      final areNotificationsEnabled = await android?.areNotificationsEnabled();
      print(
          '[NotificationService] Notifications enabled: $areNotificationsEnabled');

      if (areNotificationsEnabled != true) {
        print(
            '[NotificationService] Notifications are disabled in system settings');
        return;
      }

      final androidDetails = AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
        styleInformation: BigTextStyleInformation(body),
        icon: '@mipmap/ic_launcher', // Make sure this icon exists
      );

      await _localNotifications.show(
        DateTime.now().millisecond,
        title,
        body,
        NotificationDetails(android: androidDetails),
        payload: payload,
      );
      print('[NotificationService] Notification sent successfully');
    } catch (e) {
      print('[NotificationService] Error showing notification: $e');
      logger.e('Error showing notification: $e');
    }
  }

  void _startScheduleChecker() {
    Future.delayed(const Duration(minutes: 1), () async {
      await _checkSchedules();
      _startScheduleChecker();
    });
  }

  Future<void> _checkSchedules() async {
    try {
      final box = await Hive.openBox<ClassSchedule>('class_schedules');
      final now = DateTime.now();

      for (var schedule in box.values) {
        if (!schedule.notified &&
            schedule.startTime.isAfter(now) &&
            schedule.startTime.difference(now).inMinutes <= 30) {
          await _scheduleNotification(schedule);
        }
      }
    } catch (e) {
      logger.e('Error checking schedules: $e');
    }
  }

  Future<void> _scheduleNotification(ClassSchedule schedule) async {
    try {
      final body = '''
Môn học: ${schedule.subject}
Phòng: ${schedule.room}
Thời gian: ${schedule.startTime.hour.toString().padLeft(2, '0')}:${schedule.startTime.minute.toString().padLeft(2, '0')}
Thời lượng: ${schedule.duration} phút
''';

      await showNotification(
        title: 'Sắp đến giờ học!',
        body: body,
        channel: scheduleChannel,
        payload: json.encode({
          'type': 'timetable',
          'classId': schedule.id,
        }),
      );

      schedule.notified = true;
      await schedule.save();
    } catch (e) {
      logger.e('Error scheduling notification: $e');
    }
  }

  // Test functions
  Future<void> testNotification() async {
    await showNotification(
      title: 'Test Notification',
      body: 'This is a test notification',
      payload: json.encode({'type': 'notification', 'test': true}),
    );
  }

  Future<void> testScheduleNotification() async {
    try {
      final now = DateTime.now().add(Duration(minutes: 1));
      final testSchedule = ClassSchedule(
        id: now.millisecondsSinceEpoch.toString(),
        subject: 'Test Subject',
        room: 'A101',
        weekDay: now.weekday + 1,
        session: 'CHIỀU',
        startTime: now,
        duration: 45,
      );

      final box = await Hive.openBox<ClassSchedule>('class_schedules');
      await box.add(testSchedule);

      // Show notification immediately for testing
      await showNotification(
        title: 'Sắp đến giờ học!',
        body: '''
${testSchedule.subject}
Phòng: ${testSchedule.room}
Thời gian bắt đầu: ${testSchedule.startTime.hour}:${testSchedule.startTime.minute.toString().padLeft(2, '0')}''',
        payload: json.encode({
          'type': 'timetable',
          'classId': testSchedule.id,
        }),
        channel: scheduleChannel,
      );
    } catch (e) {
      print('Error testing schedule notification: $e');
    }
  }

  // Add background message handler
  @pragma('vm:entry-point')
  Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    print(
        '[NotificationService] Handling background message: ${message.messageId}');
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Data: ${message.data}');

    // Handle background message
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
      print('[NotificationService] Error handling background message: $e');
    }
  }
}
