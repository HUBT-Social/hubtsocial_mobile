import 'dart:convert';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/core/notification/LocalMessage.dart';
import 'package:hubtsocial_mobile/src/core/local_storage/local_storage_key.dart';
import 'package:hubtsocial_mobile/src/features/timetable/data/models/reform_timetable_model.dart';
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
      final startTime = timetableData.starttime;
      final endTime = timetableData.endtime;

      // Only schedule notifications if we're within the timetable period
      if (now.isAfter(startTime) && now.isBefore(endTime)) {
        for (var timetable in timetableData.reformTimetables) {
          if (timetable.startTime == null || timetable.endTime == null)
            continue;

          // Schedule notification 15 minutes before class starts
          final startNotificationTime =
              timetable.startTime!.subtract(const Duration(minutes: 15));

          // Schedule notification 5 minutes before class ends
          final endNotificationTime =
              timetable.endTime!.subtract(const Duration(minutes: 5));

          // Only schedule if the notification times are in the future
          if (startNotificationTime.isAfter(now)) {
            final startNotificationId = timetable.hashCode;

            // Create start notification payload
            final startPayload = jsonEncode({
              'type': LocalStorageKey.schedule,
              'timetableId': timetable.id,
              'startTime': timetable.startTime!.toIso8601String(),
              'endTime': timetable.endTime!.toIso8601String(),
            });

            // Schedule the start notification
            await _localMessage.scheduleNotification(
              id: startNotificationId,
              title: 'Sắp đến giờ học',
              body:
                  'Môn ${timetable.subject ?? "Không có tên môn"} sẽ bắt đầu trong 15 phút nữa tại ${timetable.room ?? "Chưa có phòng"}',
              scheduledDate: startNotificationTime,
              payload: startPayload,
              isAlarmLike: true,
            );

            // Create and save start notification model
            final startNotification = NotificationModel(
              id: startNotificationId.toString(),
              title: 'Sắp đến giờ học',
              body:
                  'Môn ${timetable.subject ?? "Không có tên môn"} sẽ bắt đầu trong 15 phút nữa tại ${timetable.room ?? "Chưa có phòng"}',
              time: DateTime.now().toIso8601String(),
              isRead: false,
              type: LocalStorageKey.schedule,
              data: {
                'type': LocalStorageKey.schedule,
                'timetableId': timetable.id,
                'startTime': timetable.startTime!.toIso8601String(),
                'endTime': timetable.endTime!.toIso8601String(),
                'subject': timetable.subject,
                'room': timetable.room,
              },
            );

            await notificationsBox.put(
                startNotificationId.toString(), startNotification);
            logger.i(
                'Đã lên lịch thông báo bắt đầu cho môn ${timetable.subject ?? "Không có tên môn"}');
          }

          if (endNotificationTime.isAfter(now)) {
            final endNotificationId =
                timetable.hashCode + 1; // Different ID for end notification

            // Create end notification payload
            final endPayload = jsonEncode({
              'type': LocalStorageKey.schedule,
              'timetableId': timetable.id,
              'startTime': timetable.startTime!.toIso8601String(),
              'endTime': timetable.endTime!.toIso8601String(),
            });

            // Schedule the end notification
            await _localMessage.scheduleNotification(
              id: endNotificationId,
              title: 'Sắp hết giờ học',
              body:
                  'Môn ${timetable.subject ?? "Không có tên môn"} sẽ kết thúc trong 5 phút nữa',
              scheduledDate: endNotificationTime,
              payload: endPayload,
              isAlarmLike: true,
            );

            // Create and save end notification model
            final endNotification = NotificationModel(
              id: endNotificationId.toString(),
              title: 'Sắp hết giờ học',
              body:
                  'Môn ${timetable.subject ?? "Không có tên môn"} sẽ kết thúc trong 5 phút nữa',
              time: DateTime.now().toIso8601String(),
              isRead: false,
              type: LocalStorageKey.schedule,
              data: {
                'type': LocalStorageKey.schedule,
                'timetableId': timetable.id,
                'startTime': timetable.startTime!.toIso8601String(),
                'endTime': timetable.endTime!.toIso8601String(),
                'subject': timetable.subject,
                'room': timetable.room,
              },
            );

            await notificationsBox.put(
                endNotificationId.toString(), endNotification);
            logger.i(
                'Đã lên lịch thông báo kết thúc cho môn ${timetable.subject ?? "Không có tên môn"}');
          }
        }
      } else {
        logger.w('Ngoài thời gian của thời khóa biểu');
      }
    } catch (e, s) {
      logger.e('Lỗi khi lên lịch thông báo thời khóa biểu: $e');
      logger.d(s.toString());
    }
  }
}
