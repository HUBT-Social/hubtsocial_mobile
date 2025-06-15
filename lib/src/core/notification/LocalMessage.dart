import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
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
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
    logger.d('Local timezone set to: ${tz.local.name}');

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
        // Handle notification tap
        print('Notification tapped: ${response.payload}');
      },
    );

    // Create the notification channel
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    bool isAlarmLike = false,
  }) async {
    logger.d('Scheduling notification: $title');
    logger.d(
        '  Raw scheduledDate: $scheduledDate (isUtc: ${scheduledDate.isUtc})');
    final tz.TZDateTime scheduledTZDate =
        tz.TZDateTime.from(scheduledDate, tz.local);
    logger.d(
        '  TZDateTime for scheduling: $scheduledTZDate (isUtc: ${scheduledTZDate.isUtc})');

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTZDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: isAlarmLike ? Importance.max : Importance.high,
          priority: isAlarmLike ? Priority.high : Priority.low,
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
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
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
          importance: isAlarmLike ? Importance.max : Importance.high,
          priority: isAlarmLike ? Priority.high : Priority.low,
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
    await flutterLocalNotificationsPlugin.cancel(id);
    logger.i('Notification with ID $id cancelled.');
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    logger.i('All notifications cancelled.');
  }
}
