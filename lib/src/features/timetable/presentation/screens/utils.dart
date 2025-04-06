// import 'dart:collection';

// import 'package:table_calendar/table_calendar.dart';

// import '../../data/models/reform_timetable_model.dart';
// import '../../models/class_schedule.dart';

// /// Example events.
// ///
// /// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
// final kEvents = LinkedHashMap<DateTime, List<ReformTimetable>>(
//   equals: isSameDay,
//   hashCode: getHashCode,
// )..addAll(_kEventSource);

// final _kEventSource = {
//   for (var item in List.generate(50, (index) => index))
//     DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5): List.generate(
//       item % 4 + 1,
//       // (index) => ClassSchedule('Event $item | ${index + 1}'),
//       (index) => ReformTimetable(
//         id: '5',
//         subject: 'TIN CHUYÊN NGÀNH',
//         room: 'D608',
//         weekDay: 8,
//         session: 'CHIỀU',
//         startTime: DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
//         duration: 180,
//       ),
//     ),
// }..addAll({
//     kToday: [
//       // ClassSchedule("Today's Event 1"),
//       // ClassSchedule("Today's Event 2"),
//       ReformTimetable(
//         id: '5',
//         subject: 'TIN CHUYÊN NGÀNH',
//         room: 'D608',
//         weekDay: 8,
//         session: 'CHIỀU',
//         startTime: DateTime.now(),
//         duration: 180,
//       ),
//       ReformTimetable(
//         id: '5',
//         subject: 'TIN CHUYÊN NGÀNH',
//         room: 'D608',
//         weekDay: 8,
//         session: 'CHIỀU',
//         startTime: DateTime.now(),
//         duration: 180,
//       ),
//     ],
//   });

// int getHashCode(DateTime key) {
//   return key.day * 1000000 + key.month * 10000 + key.year;
// }

// /// Returns a list of [DateTime] objects from [first] to [last], inclusive.
// List<DateTime> daysInRange(DateTime first, DateTime last) {
//   final dayCount = last.difference(first).inDays + 1;
//   return List.generate(
//     dayCount,
//     (index) => DateTime.utc(first.year, first.month, first.day + index),
//   );
// }

// final kToday = DateTime.now();
// final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
// final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
