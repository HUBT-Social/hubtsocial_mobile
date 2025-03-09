import 'package:hive_ce/hive.dart';

part 'class_schedule.g.dart';

@HiveType(typeId: 5)
class ClassSchedule extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String subject;

  @HiveField(2)
  final String room;

  @HiveField(3)
  final int weekDay; // 2-8 (2: Thứ 2, ..., 8: CN)

  @HiveField(4)
  final String session; // SÁNG, CHIỀU, TỐI

  @HiveField(5)
  final int startHour; // 7, 13, 18

  @HiveField(6)
  final int startMinute; // 0-59

  @HiveField(7)
  final int duration; // in minutes

  @HiveField(8)
  final String? zoomId;

  @HiveField(9)
  bool notified;

  ClassSchedule({
    required this.id,
    required this.subject,
    required this.room,
    required this.weekDay,
    required this.session,
    required this.startHour,
    required this.startMinute,
    required this.duration,
    this.zoomId,
    this.notified = false,
  });

  DateTime get startTime {
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      startHour,
      startMinute,
    );
  }

  DateTime get endTime => startTime.add(Duration(minutes: duration));

  bool get isOngoing {
    final now = DateTime.now();
    final start = startTime;
    final end = endTime;
    return now.hour == start.hour && now.minute >= start.minute ||
        now.hour == end.hour && now.minute <= end.minute ||
        now.hour > start.hour && now.hour < end.hour;
  }

  bool get isUpcoming {
    final now = DateTime.now();
    final start = startTime;
    final thirtyMinsBefore = start.subtract(const Duration(minutes: 30));
    return now.isAfter(thirtyMinsBefore) && now.isBefore(start);
  }

  bool get isPast {
    return DateTime.now().isAfter(endTime);
  }
}
