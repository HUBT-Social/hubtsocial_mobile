import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:hubtsocial_mobile/src/core/local_storage/local_storage_key.dart';
import 'package:hubtsocial_mobile/src/features/timetable/data/models/reform_timetable_model.dart';
import 'package:hubtsocial_mobile/src/features/timetable/data/models/timetable_response_model.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimetableNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _timetableChannel =
      AndroidNotificationChannel(
    'timetable_channel',
    'Thông báo lịch học',
    description: 'Kênh thông báo cho lịch học',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
    showBadge: true,
    enableLights: true,
  );

  /// Gọi hàm này ở main hoặc khi app khởi động
  static Future<void> initNotification() async {
    tz.initializeTimeZones();
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {},
    );
    final androidPlugin =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_timetableChannel);
  }

  /// Lên lịch thông báo trước 30 phút cho tất cả tiết học còn lại trong ngày (hoặc tương lai)
  static Future<void> scheduleAllTimetableNotifications() async {
    if (!Hive.isBoxOpen(LocalStorageKey.timeTable)) {
      await Hive.openBox<TimetableResponseModel>(LocalStorageKey.timeTable);
    }
    final timetableBox =
        Hive.box<TimetableResponseModel>(LocalStorageKey.timeTable);
    final timetableData = timetableBox.get(LocalStorageKey.timeTable);
    if (timetableData == null) return;

    final location = tz.getLocation('Asia/Ho_Chi_Minh');
    final now = tz.TZDateTime.now(location);

    for (final lesson in timetableData.reformTimetables) {
      if (lesson.startTime == null) continue;
      final lessonStart = tz.TZDateTime.from(lesson.startTime!, location);
      final notifyTime = lessonStart.subtract(const Duration(minutes: 30));
      if (notifyTime.isAfter(now)) {
        // Thông báo trước 30 phút
        final id30m = (lesson.id ?? '').hashCode ^ '30m'.hashCode;
        final title30m = 'Sắp đến giờ học: ${lesson.subject ?? ''}';
        final body30m =
            'Lớp: ${lesson.className ?? ''} - Phòng: ${lesson.room ?? ''}\\nBắt đầu lúc: ${lessonStart.hour}:${lessonStart.minute.toString().padLeft(2, '0')}';
        await _notificationsPlugin.zonedSchedule(
          id30m,
          title30m,
          body30m,
          notifyTime,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _timetableChannel.id,
              _timetableChannel.name,
              channelDescription: _timetableChannel.description,
              importance: Importance.max,
              priority: Priority.high,
              playSound: true,
              enableVibration: true,
              enableLights: true,
              icon: '@mipmap/ic_launcher',
              styleInformation: BigTextStyleInformation(body30m),
            ),
            iOS: DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.dateAndTime,
        );
      }
      if (lessonStart.isAfter(now)) {
        // Thông báo đúng giờ học
        final idStart = (lesson.id ?? '').hashCode ^ 'start'.hashCode;
        final titleStart = 'Bắt đầu học: ${lesson.subject ?? ''}';
        final bodyStart =
            'Lớp: ${lesson.className ?? ''} - Phòng: ${lesson.room ?? ''}\\nGiờ học bắt đầu!';
        await _notificationsPlugin.zonedSchedule(
          idStart,
          titleStart,
          bodyStart,
          lessonStart,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _timetableChannel.id,
              _timetableChannel.name,
              channelDescription: _timetableChannel.description,
              importance: Importance.max,
              priority: Priority.high,
              playSound: true,
              enableVibration: true,
              enableLights: true,
              icon: '@mipmap/ic_launcher',
              styleInformation: BigTextStyleInformation(bodyStart),
            ),
            iOS: DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.dateAndTime,
        );
      }
    }
  }
}
