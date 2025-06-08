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

      if (!Hive.isBoxOpen('notifications')) {
        await Hive.openBox<NotificationModel>('notifications');
      }

      final timetableBox =
          Hive.box<TimetableResponseModel>(LocalStorageKey.timeTable);
      final notificationsBox = Hive.box<NotificationModel>('notifications');
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

  Future<void> _scheduleTimetableNotifications(TimetableResponseModel timetable,
      Box<NotificationModel> notificationsBox) async {
    try {
      // Cancel all existing notifications before scheduling new ones
      await _localMessage.cancelAllNotifications();

      for (var reformTimetable in timetable.reformTimetables) {
        if (reformTimetable.startTime != null &&
            reformTimetable.endTime != null) {
          // Schedule notification 1 hour before class starts
          final notificationStartTime =
              reformTimetable.startTime!.subtract(const Duration(hours: 1));

          if (notificationStartTime.isAfter(DateTime.now())) {
            // Create notification model for 1 hour before
            final String bodyText =
                'Lớp ${reformTimetable.className ?? ""} - ${reformTimetable.subject ?? ""} sẽ bắt đầu trong 1 giờ nữa. Phòng: ${reformTimetable.room ?? "Chưa cập nhật"}. Zoom ID: ${reformTimetable.zoomId ?? "Chưa cập nhật"}';
            final notificationModel = NotificationModel(
              id: 'timetable_${reformTimetable.id ?? DateTime.now().millisecondsSinceEpoch}_1h',
              title: 'Sắp đến giờ học',
              body: _truncateWithEllipsis(bodyText, 90),
              time: notificationStartTime.toIso8601String(),
              type: 'timetable',
              data: {
                'timetableId':
                    reformTimetable.id ?? DateTime.now().millisecondsSinceEpoch,
                'type': 'start_notification',
                'className': reformTimetable.className ?? "",
                'subject': reformTimetable.subject ?? "",
                'room': reformTimetable.room ?? "",
                'zoomId': reformTimetable.zoomId ?? "",
                'startTime': reformTimetable.startTime?.toIso8601String(),
                'endTime': reformTimetable.endTime?.toIso8601String(),
              },
            );

            // Save notification to Hive
            await notificationsBox.add(notificationModel);

            // Schedule local notification with high importance
            await _localMessage.scheduleNotification(
              id: reformTimetable.id.hashCode + 1,
              title: notificationModel.title ?? '',
              body: notificationModel.body ?? '',
              scheduledDate: notificationStartTime,
              payload: jsonEncode(notificationModel.data),
            );
            logger.i(
                'Đã lên lịch thông báo bắt đầu cho môn ${reformTimetable.subject} tại $notificationStartTime');
          }

          // Schedule notification 15 minutes before class starts
          final notificationReminderTime =
              reformTimetable.startTime!.subtract(const Duration(minutes: 15));

          if (notificationReminderTime.isAfter(DateTime.now())) {
            // Create notification model for 15 minutes before
            final String reminderBodyText =
                'Lớp ${reformTimetable.className ?? ""} - ${reformTimetable.subject ?? ""} sẽ bắt đầu trong 15 phút nữa. Phòng: ${reformTimetable.room ?? "Chưa cập nhật"}. Zoom ID: ${reformTimetable.zoomId ?? "Chưa cập nhật"}';
            final reminderModel = NotificationModel(
              id: 'timetable_${reformTimetable.id ?? DateTime.now().millisecondsSinceEpoch}_15m',
              title: 'Nhắc nhở: Sắp đến giờ học',
              body: _truncateWithEllipsis(reminderBodyText, 50),
              time: notificationReminderTime.toIso8601String(),
              type: 'timetable',
              data: {
                'timetableId':
                    reformTimetable.id ?? DateTime.now().millisecondsSinceEpoch,
                'type': 'reminder_notification',
                'className': reformTimetable.className ?? "",
                'subject': reformTimetable.subject ?? "",
                'room': reformTimetable.room ?? "",
                'zoomId': reformTimetable.zoomId ?? "",
                'startTime': reformTimetable.startTime?.toIso8601String(),
                'endTime': reformTimetable.endTime?.toIso8601String(),
              },
            );

            // Save reminder to Hive
            await notificationsBox.add(reminderModel);

            // Schedule local notification with high importance
            await _localMessage.scheduleNotification(
              id: reformTimetable.id.hashCode + 2,
              title: reminderModel.title ?? '',
              body: reminderModel.body ?? '',
              scheduledDate: notificationReminderTime,
              payload: jsonEncode(reminderModel.data),
            );
            logger.i(
                'Đã lên lịch thông báo nhắc nhở cho môn ${reformTimetable.subject} tại $notificationReminderTime');
          }
        }
      }
      logger.i('Đã lên lịch tất cả thông báo cho thời khóa biểu');
    } catch (e, s) {
      logger.e('Lỗi khi lên lịch thông báo: $e');
      logger.d(s.toString());
    }
  }

  Future<void> showInstantNotification(ReformTimetable timetable) async {
    await _localMessage.initLocalNotifications();

    // Create notification model for instant notification
    final String testBodyText =
        'Lớp ${timetable.className ?? ""} - ${timetable.subject ?? ""} thông báo !';
    final notificationModel = NotificationModel(
      id: 'timetable_test_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Test Notification',
      body: _truncateWithEllipsis(testBodyText, 90),
      time: DateTime.now().toIso8601String(),
      type: 'timetable',
      data: {
        'timetableId': timetable.id ?? DateTime.now().millisecondsSinceEpoch,
        'type': 'test_notification',
        'className': timetable.className ?? "",
        'subject': timetable.subject ?? "",
        'room': timetable.room ?? "",
        'zoomId': timetable.zoomId ?? "",
        'startTime': timetable.startTime?.toIso8601String(),
        'endTime': timetable.endTime?.toIso8601String(),
      },
    );

    // Save test notification to Hive
    final notificationsBox =
        await Hive.openBox<NotificationModel>('notifications');
    await notificationsBox.add(notificationModel);

    // Show local notification
    await _localMessage.showNotification(
      title: notificationModel.title ?? '',
      body: notificationModel.body ?? '',
      payload: jsonEncode(notificationModel.data),
    );
  }

  String _truncateWithEllipsis(String text, int maxLength) {
    return (text.length <= maxLength)
        ? text
        : '${text.substring(0, maxLength - 3)}...';
  }
}
