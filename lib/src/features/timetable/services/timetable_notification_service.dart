import 'dart:convert';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/core/notification/LocalMessage.dart';
import 'package:hubtsocial_mobile/src/core/local_storage/local_storage_key.dart';
import 'package:hubtsocial_mobile/src/features/timetable/data/models/timetable_response_model.dart';
import 'package:hubtsocial_mobile/src/features/notification/model/notification_model.dart';

class TimetableNotificationService {
  TimetableNotificationService() : _localMessage = LocalMessage();

  final LocalMessage _localMessage;

  Future<void> scheduleNotificationsFromHive() async {
    try {
      await _localMessage.initLocalNotifications();

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

      if (timetableData == null) {
        logger.w('Không tìm thấy dữ liệu thời khóa biểu trong Hive');
        return;
      }

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      logger.i('Thời gian hiện tại: $now');

      final sortedTimetables = timetableData.reformTimetables
          .where((t) => t.startTime != null)
          .toList()
        ..sort((a, b) => a.startTime!.compareTo(b.startTime!));

      // Lọc các tiết học trong ngày hôm nay
      final todayTimetables = sortedTimetables.where((t) {
        final startTimeLocal = t.startTime!;
        return startTimeLocal.year == today.year &&
            startTimeLocal.month == today.month &&
            startTimeLocal.day == today.day;
      }).toList();

      logger.i(
          'Tổng số tiết học trong hôm nay cần lên lịch: ${todayTimetables.length}');

      int scheduledCount = 0;
      for (final timetable in todayTimetables) {
        try {
          final startTimeUtc =
              DateTime.parse(timetable.startTime!.toIso8601String());
          final startTimeLocal = timetable.startTime!;
          final notifyTime =
              startTimeLocal.subtract(const Duration(minutes: 5));

          final notificationId = timetable.id.hashCode;

          logger.i(
              'now: $now, notifyTime: $notifyTime, notificationId: $notificationId, subject: ${timetable.subject}');

          if (notificationsBox.containsKey(notificationId.toString())) {
            logger.i('Đã có notification cho môn ${timetable.subject}, bỏ qua');
            continue;
          }

          if (notifyTime.isAfter(now)) {
            final payload = jsonEncode({
              'type': LocalStorageKey.schedule,
              'timetableId': timetable.id,
              'startTime': startTimeLocal.toIso8601String(),
              'endTime': timetable.endTime?.toIso8601String(),
            });

            await _localMessage.scheduleNotification(
              id: notificationId,
              title: 'Sắp đến giờ học',
              body:
                  'Môn ${timetable.subject ?? "Không rõ"} sẽ bắt đầu trong 5 phút tại ${timetable.room ?? "Chưa rõ"}',
              scheduledDate: notifyTime,
              payload: payload,
            );

            await notificationsBox.put(
              notificationId.toString(),
              NotificationModel(
                id: notificationId.toString(),
                title: 'Sắp đến giờ học',
                body:
                    'Môn ${timetable.subject ?? "Không rõ"} sẽ bắt đầu trong 5 phút tại ${timetable.room ?? "Chưa rõ"}',
                time: notifyTime.toIso8601String(),
                isRead: false,
                type: LocalStorageKey.schedule,
                data: {
                  'timetableId': timetable.id,
                  'subject': timetable.subject,
                  'room': timetable.room,
                  'startTime': startTimeLocal.toIso8601String(),
                  'endTime': timetable.endTime?.toIso8601String(),
                },
              ),
            );
            scheduledCount++;
            logger.i(
                'Đã lên lịch thông báo cho môn ${timetable.subject} vào lúc $notifyTime');
          } else {
            logger.i(
                'Bỏ qua thông báo cho môn ${timetable.subject} vì thời gian đã qua');
          }
        } catch (e) {
          logger.e('Lỗi khi xử lý tiết học ${timetable.subject}: $e');
        }
      }
      logger.i('Đã lên lịch thành công $scheduledCount thông báo');
    } catch (e, s) {
      logger.e('Lỗi khi lên lịch thông báo từ Hive: $e');
      logger.d(s.toString());
    }
  }
}
