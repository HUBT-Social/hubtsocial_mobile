import 'dart:convert';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/core/notification/LocalMessage.dart';
import 'package:hubtsocial_mobile/src/core/local_storage/local_storage_key.dart';
import 'package:hubtsocial_mobile/src/features/timetable/data/models/reform_timetable_model.dart';
import 'package:hubtsocial_mobile/src/features/timetable/data/models/timetable_response_model.dart';

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

      final timetableBox =
          Hive.box<TimetableResponseModel>(LocalStorageKey.timeTable);
      final timetableData = timetableBox.get(LocalStorageKey.timeTable);

      if (timetableData != null) {
        await _scheduleTimetableNotifications(timetableData);
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
      TimetableResponseModel timetable) async {
    try {
      // Cancel all existing notifications before scheduling new ones
      await _localMessage.cancelAllNotifications();

      for (var reformTimetable in timetable.reformTimetables) {
        if (reformTimetable.startTime != null &&
            reformTimetable.endTime != null) {
          // Schedule notification 10 minutes before class starts
          final notificationStartTime =
              reformTimetable.startTime!.subtract(const Duration(minutes: 10));
          if (notificationStartTime.isAfter(DateTime.now())) {
            await _localMessage.scheduleNotification(
              id: reformTimetable.id.hashCode +
                  1, // Unique ID for start notification
              title: 'Sắp đến giờ học',
              body:
                  'Lớp ${reformTimetable.className} - ${reformTimetable.subject} sẽ bắt đầu trong 10 phút nữa\nPhòng: ${reformTimetable.room ?? "Chưa cập nhật"}\nZoom ID: ${reformTimetable.zoomId ?? "Chưa cập nhật"}',
              scheduledDate: notificationStartTime,
              payload: jsonEncode({
                'timetableId': reformTimetable.id,
                'type': 'start_notification',
                'className': reformTimetable.className,
                'subject': reformTimetable.subject,
                'room': reformTimetable.room,
                'zoomId': reformTimetable.zoomId
              }),
            );
            logger.i(
                'Đã lên lịch thông báo bắt đầu cho môn ${reformTimetable.subject}');
          }

          // Schedule notification when class ends
          if (reformTimetable.endTime!.isAfter(DateTime.now())) {
            await _localMessage.scheduleNotification(
              id: reformTimetable.id.hashCode +
                  2, // Unique ID for end notification
              title: 'Kết thúc buổi học',
              body:
                  'Lớp ${reformTimetable.className} - ${reformTimetable.subject} đã kết thúc',
              scheduledDate: reformTimetable.endTime!,
              payload: jsonEncode({
                'timetableId': reformTimetable.id,
                'type': 'end_notification',
                'className': reformTimetable.className,
                'subject': reformTimetable.subject
              }),
            );
            logger.i(
                'Đã lên lịch thông báo kết thúc cho môn ${reformTimetable.subject}');
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
    await _localMessage.showNotification(
      title: 'Test Notification',
      body: 'Lớp ${timetable.className} - ${timetable.subject} thông báo !',
      payload: jsonEncode({
        'timetableId': timetable.id,
        'type': 'start_notification',
        'className': timetable.className,
        'subject': timetable.subject,
        'room': timetable.room,
        'zoomId': timetable.zoomId
      }),
    );
  }
}
