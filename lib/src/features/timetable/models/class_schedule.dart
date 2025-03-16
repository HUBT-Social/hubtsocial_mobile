import 'package:hive_ce/hive.dart';

class ClassSchedule extends HiveObject {
  final String id;

  final String subject;

  final String room;

  final int weekDay; // 2-8 (2: Thứ 2, ..., 8: CN)

  final String session; // SÁNG, CHIỀU, TỐI

  final DateTime startTime;

  final int duration; // in minutes

  final String? zoomId;

  bool notified;

  ClassSchedule({
    required this.id,
    required this.subject,
    required this.room,
    required this.weekDay,
    required this.session,
    required this.startTime,
    required this.duration,
    this.zoomId,
    this.notified = false,
  });

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
