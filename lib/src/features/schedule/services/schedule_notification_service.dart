import '../models/class_schedule.dart';

import '../../../core/notification/local_message.dart';
import 'dart:convert';

class ScheduleNotificationService {
  final LocalMessage _localMessage = LocalMessage();

  Future<void> scheduleClassNotifications(List<ClassSchedule> schedules) async {
    // Hủy tất cả thông báo cũ
    await _localMessage.cancelAllNotifications();

    // Lên lịch thông báo mới cho từng lớp học
    for (var schedule in schedules) {
      if (schedule.startTime.isAfter(DateTime.now())) {
        await _localMessage.showNotification(
          title: 'Lịch học ${schedule.name}',
          body:
              'Bạn có lớp ${schedule.name} lúc ${schedule.startTime.hour}:${schedule.startTime.minute}',
          payload: jsonEncode({
            'type': 'class_schedule',
            'classId': schedule.id,
            'className': schedule.name,
          }),
        );
      }
    }
  }
}
