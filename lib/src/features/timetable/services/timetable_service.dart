import 'dart:convert';
import 'package:hive_ce/hive.dart';
import 'package:hubtsocial_mobile/src/core/notification/notification_service.dart';
import 'package:hubtsocial_mobile/src/features/timetable/models/class_schedule.dart';

class TimetableService {
  static final TimetableService _instance = TimetableService._internal();
  factory TimetableService() => _instance;
  TimetableService._internal();

  final _notificationService = NotificationService();

  Future<void> initializeDefaultSchedule() async {
    try {
      final box = await Hive.openBox<ClassSchedule>('class_schedules');
      if (box.isEmpty) {
        final schedules = [
          ClassSchedule(
            id: '1',
            subject: 'TIN CHUYÊN NGÀNH',
            room: 'OL100',
            weekDay: 2,
            session: 'CHIỀU',
            startTime: DateTime.now(),
            duration: 180,
            zoomId: '4390658809',
          ),
          ClassSchedule(
            id: '2',
            subject: 'TIN CHUYÊN NGÀNH',
            room: 'D607',
            weekDay: 3,
            session: 'CHIỀU',
            startTime: DateTime.now(),
            duration: 180,
          ),
          ClassSchedule(
            id: '3',
            subject: 'GIÁO DỤC THỂ CHẤT',
            room: 'BAITAP',
            weekDay: 6,
            session: 'CHIỀU',
            startTime: DateTime.now(),
            duration: 180,
          ),
          ClassSchedule(
            id: '4',
            subject: 'TIN CHUYÊN NGÀNH',
            room: 'OL108',
            weekDay: 7,
            session: 'CHIỀU',
            startTime: DateTime.now(),
            duration: 180,
            zoomId: '3555992492',
          ),
          ClassSchedule(
            id: '5',
            subject: 'TIN CHUYÊN NGÀNH',
            room: 'D608',
            weekDay: 8,
            session: 'CHIỀU',
            startTime: DateTime.now(),
            duration: 180,
          ),
        ];
        await box.addAll(schedules);
      }
    } catch (e) {
      print('Error initializing schedules: $e');
    }
  }

  Future<void> checkAndNotifyUpcomingClasses() async {
    try {
      final box = await Hive.openBox<ClassSchedule>('class_schedules');
      final now = DateTime.now();

      for (var schedule in box.values) {
        if (!schedule.notified &&
            schedule.weekDay == now.weekday + 1 &&
            schedule.isUpcoming) {
          await _notificationService.showNotification(
            title: 'Sắp đến giờ học!',
            body: '''
${schedule.subject}
Phòng: ${schedule.room}
${schedule.zoomId != null ? 'ID Zoom: ${schedule.zoomId}\n' : ''}
Thời gian bắt đầu: ${schedule.startTime.hour}:${schedule.startTime.minute.toString().padLeft(2, '0')}''',
            payload: json.encode({
              'type': 'timetable',
              'classId': schedule.id,
            }),
            channel: NotificationService.scheduleChannel,
          );

          schedule.notified = true;
          await schedule.save();
        }
      }
    } catch (e) {
      print('Error checking schedules: $e');
    }
  }

  void startScheduleChecker() {
    Future.delayed(const Duration(minutes: 1), () async {
      await checkAndNotifyUpcomingClasses();
      startScheduleChecker();
    });
  }

  Future<void> testNotification() async {
    try {
      final testSchedule = ClassSchedule(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        subject: 'Test Subject',
        room: 'A101',
        weekDay: DateTime.now().weekday + 1,
        session: 'CHIỀU',
        startTime: DateTime.now().add(Duration(minutes: 100)),
        duration: 45,
      );

      final box = await Hive.openBox<ClassSchedule>('class_schedules');
      await box.add(testSchedule);
      await checkAndNotifyUpcomingClasses();
    } catch (e) {
      print('Error testing notification: $e');
    }
  }
}
