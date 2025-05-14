/*import 'package:workmanager/workmanager.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hubtsocial_mobile/src/core/notification/LocalMessage.dart';
import 'package:hubtsocial_mobile/src/core/local_storage/local_storage_key.dart';
import 'package:hubtsocial_mobile/src/features/timetable/data/models/timetable_response_model.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // init Hive
      await Hive.initFlutter();

      // init LocalMessage
      final localMessage = LocalMessage();
      await localMessage.initLocalNotifications();

      // get liệu từ Hive
      if (!Hive.isBoxOpen(LocalStorageKey.timeTable)) {
        await Hive.openBox<TimetableResponseModel>(LocalStorageKey.timeTable);
      }
      final timetableBox =
          Hive.box<TimetableResponseModel>(LocalStorageKey.timeTable);
      final timetableData = timetableBox.get(LocalStorageKey.timeTable);

      if (timetableData != null) {
        // dele thông báo cũ
        await localMessage.cancelAllNotifications();

        // Lên lịch thông báo mới
        for (var reformTimetable in timetableData.reformTimetables) {
          if (reformTimetable.startTime != null &&
              reformTimetable.endTime != null) {
            // Thông báo trước khi bắt đầu 10 phút
            final notificationStartTime = reformTimetable.startTime!
                .subtract(const Duration(minutes: 10));
            if (notificationStartTime.isAfter(DateTime.now())) {
              await localMessage.scheduleNotification(
                id: int.parse('${reformTimetable.id}1'),
                title: 'Sắp đến giờ học',
                body:
                    'Lớp ${reformTimetable.className} - ${reformTimetable.subject} sẽ bắt đầu trong 10 phút nữa\nPhòng: ${reformTimetable.room ?? "Chưa cập nhật"}\nZoom ID: ${reformTimetable.zoomId ?? "Chưa cập nhật"}',
                scheduledDate: notificationStartTime,
                payload: 'timetable_${reformTimetable.id}',
              );
            }

            // Thông báo khi kết thúc
            if (reformTimetable.endTime!.isAfter(DateTime.now())) {
              await localMessage.scheduleNotification(
                id: int.parse('${reformTimetable.id}2'),
                title: 'Kết thúc buổi học',
                body:
                    'Lớp ${reformTimetable.className} - ${reformTimetable.subject} đã kết thúc',
                scheduledDate: reformTimetable.endTime!,
                payload: 'timetable_end_${reformTimetable.id}',
              );
            }
          }
        }
        logger.i('Đã lên lịch thông báo từ background service');
      }
      return true;
    } catch (e, s) {
      logger.e('Lỗi trong background service: $e');
      logger.d(s.toString());
      return false;
    }
  });
}

class TimetableBackgroundService {
  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);
  }

  static Future<void> schedulePeriodicTask() async {
    await Workmanager().registerPeriodicTask(
      'timetable_notification_task',
      'scheduleTimetableNotifications',
      frequency: const Duration(hours: 1),
      constraints: Constraints(
        networkType: NetworkType.not_required,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
    );
  }
}
*/
