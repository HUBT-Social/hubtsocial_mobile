import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce/hive.dart';
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

      // Check notification permission status first
      final NotificationSettings settings =
          await _firebaseMessaging.getNotificationSettings();
      print(
          '[NotificationService] Current permission status: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        print('[NotificationService] Notifications are denied by user');
        // Request permission again
        final NotificationSettings newSettings =
            await _firebaseMessaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
          provisional: false,
        );
        print(
            '[NotificationService] New permission status: ${newSettings.authorizationStatus}');

        if (newSettings.authorizationStatus == AuthorizationStatus.denied) {
          print('[NotificationService] User denied notifications permission');
          return;
        }
      }

      // Get and verify FCM token
      final token = await _firebaseMessaging.getToken();
      if (token == null) {
        print('[NotificationService] Failed to get FCM token');
        return;
      }
      print('[NotificationService] FCM Token: $token');

      // Set up handlers
      FirebaseMessaging.onMessage.listen((message) {
        print('[NotificationService] Received foreground message:');
        print('Title: ${message.notification?.title}');
        print('Body: ${message.notification?.body}');
        print('Data: ${message.data}');
        _handleMessage(message, context);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        print('[NotificationService] App opened from background message:');
        print('Data: ${message.data}');
        _handleMessage(message, context);
      });

      // 1. Setup time zones
      await _setupTimeZones();

      // 2. Setup notifications
      await _setupNotifications();

      // 3. Start schedule checker
      _startScheduleChecker();

      logger.i('NotificationService initialized successfully');
    } catch (e, stackTrace) {
      print('[NotificationService] Initialization error: $e');
      print(stackTrace);
      logger.e('Error initializing NotificationService: $e');
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
      final targetUsers = message.data['targetUsers'];
      final groupId = message.data['groupId'];

      // Kiểm tra xem người dùng hiện tại có trong danh sách nhận không
      if (targetUsers != null) {
        final userList = List<String>.from(json.decode(targetUsers));
        final currentUserId =
            'GET_CURRENT_USER_ID'; // Thay bằng cách lấy ID người dùng hiện tại
        if (!userList.contains(currentUserId)) {
          return; // Không hiển thị nếu không phải người nhận
        }
      }

      // Save to storage with additional metadata
      await _saveNotification(
        message,
        additionalData: {
          'groupId': groupId,
          'isGroupMessage': groupId != null,
          'isBroadcast': notificationType == 'broadcast',
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
          'isBroadcast': notificationType == 'broadcast',
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
      await box.add(notification);
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
        case 'timetable':
          final classId = data['classId']?.toString();
          _context!.go(classId != null
              ? '${AppRoute.timetable.path}?classId=$classId'
              : AppRoute.timetable.path);
          break;

        case 'chat':
          if (isGroupMessage) {
            final groupId = data['groupId']?.toString();
            if (groupId != null) {
              _context!.go('/chat/group/$groupId');
            } else {
              _context!.go(AppRoute.chat.path);
            }
          } else {
            final chatId = data['chatId']?.toString();
            _context!.go(chatId != null ? '/chat/$chatId' : AppRoute.chat.path);
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
}
