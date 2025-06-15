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
      // Initialize local notifications
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

      if (timetableData != null) {
        await _scheduleTimetableNotifications(timetableData, notificationsBox);
        logger.i('Đã lên lịch thông báo từ dữ liệu Hive');
      } else {
        logger.w('Không tìm thấy dữ liệu thời khóa biểu trong Hive');
      }
    } catch (e, s) {
      logger.e('Lỗi khi lên lịch thông báo từ Hive: $e');
      logger.d(s.toString());
    }
  }

  Future<void> _scheduleTimetableNotifications(
    TimetableResponseModel timetableData,
    Box<NotificationModel> notificationsBox,
  ) async {
    try {
      // Cancel all existing timetable notifications
      await _localMessage.cancelAllNotifications();

      final now = DateTime.now();
      logger.i('Current local time: $now (isUtc: ${now.isUtc})');

      final startTime = timetableData.starttime.toLocal();
      final endTime = timetableData.endtime.toLocal();
      // final localTimetableStartTime = timetable.startTime!.toLocal();
      //final localTimetableEndTime = timetable.endTime!.toLocal();
      logger.i('Timetable period: Start $startTime, End $endTime');

      // Only schedule notifications if we're within the timetable period
      if (now.isAfter(startTime) && now.isBefore(endTime)) {
        logger.i('Currently within timetable period. Proceeding to schedule.');
        for (var timetable in timetableData.reformTimetables) {
          if (timetable.startTime == null || timetable.endTime == null) {
            logger.w(
                'Skipping timetable entry due to null start/end time: ${timetable.subject}');
            continue;
          }

          // Convert timetable start and end times to local timezone
          final localTimetableStartTime = timetable.startTime!.toLocal();
          final localTimetableEndTime = timetable.endTime!.toLocal();
          // final localTimetableStartTime = timetable.startTime!;
          // final localTimetableEndTime = timetable.endTime!;
          logger.i('  Subject: ${timetable.subject}');
          logger.i(
              '    Raw Timetable Start: ${timetable.startTime} (isUtc: ${timetable.startTime!.isUtc})');
          logger.i(
              '    Local Timetable Start: $localTimetableStartTime (isUtc: ${localTimetableStartTime.isUtc})');
          logger.i(
              '    Raw Timetable End: ${timetable.endTime} (isUtc: ${timetable.endTime!.isUtc})');
          logger.i(
              '    Local Timetable End: $localTimetableEndTime (isUtc: ${localTimetableEndTime.isUtc})');

          // Schedule notification 30 minutes before class starts
          final startNotificationTime =
              localTimetableStartTime.subtract(const Duration(minutes: 30));

          // Schedule notification 30 minutes before class ends
          final endNotificationTime =
              localTimetableEndTime.subtract(const Duration(minutes: 30));

          logger.i(
              '    Start Notification Time: $startNotificationTime (isUtc: ${startNotificationTime.isUtc})');
          logger.i(
              '    End Notification Time: $endNotificationTime (isUtc: ${endNotificationTime.isUtc})');

          // Only schedule if the notification times are in the future
          if (startNotificationTime.isAfter(now)) {
            logger.i(
                '    Scheduling start notification for ${timetable.subject}');
            final startNotificationId = timetable.hashCode;

            // Create start notification payload
            final startPayload = jsonEncode({
              'type': LocalStorageKey.schedule,
              'timetableId': timetable.id,
              'startTime': localTimetableStartTime.toIso8601String(),
              'endTime': localTimetableEndTime.toIso8601String(),
            });

            // Schedule the start notification
            await _localMessage.scheduleNotification(
              id: startNotificationId,
              title: 'Sắp đến giờ học',
              body:
                  'Môn ${timetable.subject ?? "Không có tên môn"} sẽ bắt đầu trong 30 phút nữa tại ${timetable.room ?? "Chưa có phòng"}',
              scheduledDate: startNotificationTime,
              payload: startPayload,
              isAlarmLike: true,
            );

            // Create and save start notification model
            final startNotification = NotificationModel(
              id: startNotificationId.toString(),
              title: 'Sắp đến giờ học',
              body:
                  'Môn ${timetable.subject ?? "Không có tên môn"} sẽ bắt đầu trong 30 phút nữa tại ${timetable.room ?? "Chưa có phòng"}',
              time: DateTime.now().toIso8601String(),
              isRead: false,
              type: LocalStorageKey.schedule,
              data: {
                'type': LocalStorageKey.schedule,
                'timetableId': timetable.id,
                'startTime': localTimetableStartTime.toIso8601String(),
                'endTime': localTimetableEndTime.toIso8601String(),
                'subject': timetable.subject,
                'room': timetable.room,
              },
            );

            await notificationsBox.put(
                startNotificationId.toString(), startNotification);
            logger.i(
                'Đã lên lịch thông báo bắt đầu cho môn ${timetable.subject ?? "Không có tên môn"}');
          } else {
            logger.i(
                '    Start notification time is in the past for ${timetable.subject}. Skipping.');
          }

          if (endNotificationTime.isAfter(now)) {
            logger
                .i('    Scheduling end notification for ${timetable.subject}');
            final endNotificationId =
                timetable.hashCode + 1; // Different ID for end notification

            // Create end notification payload
            final endPayload = jsonEncode({
              'type': LocalStorageKey.schedule,
              'timetableId': timetable.id,
              'startTime': localTimetableStartTime.toIso8601String(),
              'endTime': localTimetableEndTime.toIso8601String(),
            });

            // Schedule the end notification
            await _localMessage.scheduleNotification(
              id: endNotificationId,
              title: 'Sắp hết giờ học',
              body:
                  'Môn ${timetable.subject ?? "Không có tên môn"} sẽ kết thúc trong 30 phút nữa',
              scheduledDate: endNotificationTime,
              payload: endPayload,
              isAlarmLike: true,
            );

            // Create and save end notification model
            final endNotification = NotificationModel(
              id: endNotificationId.toString(),
              title: 'Sắp hết giờ học',
              body:
                  'Môn ${timetable.subject ?? "Không có tên môn"} sẽ kết thúc trong 30 phút nữa',
              time: DateTime.now().toIso8601String(),
              isRead: false,
              type: LocalStorageKey.schedule,
              data: {
                'type': LocalStorageKey.schedule,
                'timetableId': timetable.id,
                'startTime': localTimetableStartTime.toIso8601String(),
                'endTime': localTimetableEndTime.toIso8601String(),
                'subject': timetable.subject,
                'room': timetable.room,
              },
            );

            await notificationsBox.put(
                endNotificationId.toString(), endNotification);
            logger.i(
                'Đã lên lịch thông báo kết thúc cho môn ${timetable.subject ?? "Không có tên môn"}');
          } else {
            logger.i(
                '    End notification time is in the past for ${timetable.subject}. Skipping.');
          }
        }
      } else {
        logger.w('Outside timetable period. Not scheduling notifications.');
      }
    } catch (e, s) {
      logger.e('Lỗi khi lên lịch thông báo thời khóa biểu: $e');
      logger.d(s.toString());
    }
  }
}
