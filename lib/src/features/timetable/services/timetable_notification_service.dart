import 'dart:convert';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/core/notification/LocalMessage.dart';
import 'package:hubtsocial_mobile/src/core/local_storage/local_storage_key.dart';
import 'package:hubtsocial_mobile/src/features/timetable/data/models/reform_timetable_model.dart';
import 'package:hubtsocial_mobile/src/features/timetable/data/models/timetable_response_model.dart';
import 'package:hubtsocial_mobile/src/features/notification/model/notification_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

class TimetableNotificationService {
  final LocalMessage _localMessage = LocalMessage();

  Future<void> requestNotificationPermission() async {
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }

  Future<void> scheduleTodayAndFutureNotificationsFromHive() async {
    await requestNotificationPermission();
    await _localMessage.initLocalNotifications();
    await _localMessage.cancelAllNotifications();

    if (!Hive.isBoxOpen(LocalStorageKey.timeTable)) {
      await Hive.openBox<TimetableResponseModel>(LocalStorageKey.timeTable);
    }
    if (!Hive.isBoxOpen(LocalStorageKey.notification)) {
      await Hive.openBox<NotificationModel>(LocalStorageKey.notification);
    }

    final timetableBox =
        Hive.box<TimetableResponseModel>(LocalStorageKey.timeTable);
    final notificationsBox =
        Hive.box<NotificationModel>(LocalStorageKey.notification);
    final timetableData = timetableBox.get(LocalStorageKey.timeTable);

    if (timetableData == null) return;

    final location = tz.getLocation('Asia/Ho_Chi_Minh');
    final now = tz.TZDateTime.now(location);

    final today = tz.TZDateTime(location, now.year, now.month, now.day);

    final todayTimetables = timetableData.reformTimetables.where((lesson) {
      if (lesson.startTime == null) return false;
      final startTime = tz.TZDateTime.from(lesson.startTime!, location);
      return startTime.year == today.year &&
          startTime.month == today.month &&
          startTime.day == today.day;
    }).toList();

    for (final lesson in todayTimetables) {
      await _scheduleLessonNotification(
        lesson: lesson,
        location: location,
        now: now,
        notificationsBox: notificationsBox,
      );
    }
  }

  Future<int> _scheduleLessonNotification({
    required ReformTimetable lesson,
    required tz.Location location,
    required tz.TZDateTime now,
    required Box<NotificationModel> notificationsBox,
  }) async {
    int count = 0;

    try {
      final tzScheduledDate = tz.TZDateTime.from(lesson.startTime!, location);
      final notifyTime = tzScheduledDate.subtract(const Duration(minutes: 30));
      final id30m = lesson.id.hashCode;
      final idStart = '${lesson.id}_start'.hashCode;

      if (notifyTime.isBefore(now)) {
        logger.w(
            'Bỏ qua thông báo trước 30p của môn: ${lesson.subject} vì thời gian đã qua: $notifyTime');
        return count;
      }

      final payload = jsonEncode({
        'type': LocalStorageKey.schedule,
        'timetableId': lesson.id,
        'startTime': tzScheduledDate.toIso8601String(),
        'endTime': lesson.endTime?.toIso8601String(),
      });

      if (!notificationsBox.containsKey(id30m.toString()) &&
          notifyTime.isAfter(now)) {
        await _localMessage.scheduleNotification(
          id: id30m,
          title: 'Sắp đến giờ học: ${lesson.subject ?? ''}',
          body:
              'Lớp: ${lesson.className ?? ''} - Phòng: ${lesson.room ?? ''}\nBắt đầu lúc: ${tzScheduledDate.hour}:${tzScheduledDate.minute.toString().padLeft(2, '0')}',
          scheduledDate: notifyTime,
          payload: payload,
        );

        await notificationsBox.put(
          id30m.toString(),
          NotificationModel(
            id: id30m.toString(),
            title: 'Sắp đến giờ học',
            body:
                'Môn ${lesson.subject ?? "Không rõ"} sẽ bắt đầu trong 30 phút tại ${lesson.room ?? "Chưa rõ"}',
            time: notifyTime.toIso8601String(),
            isRead: false,
            type: LocalStorageKey.schedule,
            data: {
              'timetableId': lesson.id,
              'subject': lesson.subject,
              'room': lesson.room,
              'startTime': tzScheduledDate.toIso8601String(),
              'endTime': lesson.endTime?.toIso8601String(),
            },
          ),
        );
        logger.i(' Đã lên lịch trước 30p: ${lesson.subject}');
        count++;
      } else if (notifyTime.isBefore(now)) {
        logger.w('Bỏ qua thông báo trước 30p vì đã qua: $notifyTime');
      }

      // 🕒 Đúng giờ học
      if (!notificationsBox.containsKey(idStart.toString()) &&
          tzScheduledDate.isAfter(now)) {
        await _localMessage.scheduleNotification(
          id: idStart,
          title: 'Bắt đầu học: ${lesson.subject ?? ''}',
          body:
              'Lớp: ${lesson.className ?? ''} - Phòng: ${lesson.room ?? ''}\nGiờ học bắt đầu!',
          scheduledDate: tzScheduledDate,
          payload: payload,
        );

        await notificationsBox.put(
          idStart.toString(),
          NotificationModel(
            id: idStart.toString(),
            title: 'Giờ học bắt đầu',
            body:
                'Môn ${lesson.subject ?? "Không rõ"} đang bắt đầu tại ${lesson.room ?? "Chưa rõ"}',
            time: tzScheduledDate.toIso8601String(),
            isRead: false,
            type: LocalStorageKey.schedule,
            data: {
              'timetableId': lesson.id,
              'subject': lesson.subject,
              'room': lesson.room,
              'startTime': tzScheduledDate.toIso8601String(),
              'endTime': lesson.endTime?.toIso8601String(),
            },
          ),
        );
        logger.i(' Đã lên lịch đúng giờ: ${lesson.subject}');
        count++;
      } else if (tzScheduledDate.isBefore(now)) {
        logger.w('Bỏ qua thông báo đúng giờ vì đã qua: $tzScheduledDate');
      }

      logger.i(
          'now: $now, testStartTime: $tzScheduledDate, tzScheduledDate: $tzScheduledDate');
    } catch (e) {
      logger.e(' Lỗi khi xử lý môn ${lesson.subject}: $e');
    }

    return count;
  }
}
