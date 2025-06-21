import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'timetable_channel',
  'Thông báo lịch học',
  description: 'Kênh thông báo cho lịch học',
  importance: Importance.max,
  playSound: true,
  enableVibration: true,
  showBadge: true,
  enableLights: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class LocalMessage {
  Future<void> initLocalNotifications() async {
    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          final now = DateTime.now();
          logger.i('Người dùng đã nhấn vào thông báo: ${response.payload}');
          logger.i('Thời gian thực tế khi nhận notification: $now');
        },
      );

      // Tạo kênh thông báo
      final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.createNotificationChannel(channel);
      logger.i('Đã tạo kênh thông báo thành công');

      final status = await Permission.notification.status;
      if (!status.isGranted) {
        await Permission.notification.request();
      }
    } catch (e) {
      logger.e('Lỗi khi khởi tạo thông báo: $e');
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    final location = tz.getLocation('Asia/Ho_Chi_Minh');
    final now = tz.TZDateTime.now(location);

    // Convert sang tz.TZDateTime
    final tzScheduledDate = scheduledDate is tz.TZDateTime
        ? scheduledDate
        : tz.TZDateTime.from(scheduledDate, location);

    if (tzScheduledDate.isBefore(now)) {
      logger.i('Bỏ qua thông báo ... vì thời gian đã qua: $tzScheduledDate');
      return;
    }

    logger.i('Đang lên lịch thông báo: $title');
    logger.i('Thời gian lên lịch: $scheduledDate');

    logger.i('Thời gian đã chuyển đổi timezone: $tzScheduledDate');
    logger.i(
        'now: $now, scheduledDate: $scheduledDate, tzScheduledDate: $tzScheduledDate');

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzScheduledDate,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true,
            enableVibration: true,
            playSound: true,
            enableLights: true,
            icon: '@mipmap/ic_launcher',
            color: Colors.red,
            fullScreenIntent: false,
            category: null,
            styleInformation: BigTextStyleInformation(body),
          ),
          iOS: DarwinNotificationDetails(
            interruptionLevel: InterruptionLevel.timeSensitive,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );
    } on PlatformException catch (e) {
      if (e.code == 'exact_alarms_not_permitted') {
        // Fallback: dùng inexactAllowWhileIdle
        await flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          tzScheduledDate,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              importance: Importance.max,
              priority: Priority.high,
              showWhen: true,
              enableVibration: true,
              playSound: true,
              enableLights: true,
              icon: '@mipmap/ic_launcher',
              color: Colors.red,
              fullScreenIntent: false,
              category: null,
              styleInformation: BigTextStyleInformation(body),
            ),
            iOS: DarwinNotificationDetails(
              interruptionLevel: InterruptionLevel.timeSensitive,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          payload: payload,
          matchDateTimeComponents: DateTimeComponents.dateAndTime,
        );
      }
    }
    logger.i('Đã lên lịch thông báo thành công');
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
    bool isAlarmLike = false,
  }) async {
    logger.d('Showing instant notification: $title');
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
          enableVibration: true,
          playSound: true,
          enableLights: true,
          icon: '@mipmap/ic_launcher',
          color: Colors.red,
          fullScreenIntent: isAlarmLike,
          category: isAlarmLike ? AndroidNotificationCategory.alarm : null,
          styleInformation: BigTextStyleInformation(body),
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          interruptionLevel: isAlarmLike
              ? InterruptionLevel.timeSensitive
              : InterruptionLevel.active,
        ),
      ),
      payload: payload,
    );
  }

  Future<void> cancelNotification(int id) async {
    try {
      await flutterLocalNotificationsPlugin.cancel(id);
      logger.i('Đã hủy thông báo với ID: $id');
    } catch (e) {
      logger.e('Lỗi khi hủy thông báo: $e');
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await flutterLocalNotificationsPlugin.cancelAll();
      logger.i('Đã hủy tất cả thông báo');
    } catch (e) {
      logger.e('Lỗi khi hủy tất cả thông báo: $e');
    }
  }
}
