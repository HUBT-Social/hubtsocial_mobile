import 'package:hive_ce/hive.dart';
import 'package:hubtsocial_mobile/src/features/timetable/data/timetable_type.dart';

class ReformTimetable extends HiveObject {
  ReformTimetable({
    required this.id,
    required this.className,
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.room,
    required this.zoomId,
    required this.type,
  });

  final String? id;
  final String? className;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? subject;
  final String? room;
  final String? zoomId;
  final TimetableType? type;

  ReformTimetable copyWith({
    String? id,
    String? className,
    DateTime? startTime,
    DateTime? endTime,
    String? subject,
    String? room,
    String? zoomId,
    TimetableType? type,
  }) {
    return ReformTimetable(
      id: id ?? this.id,
      className: className ?? this.className,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      subject: subject ?? this.subject,
      room: room ?? this.room,
      zoomId: zoomId ?? this.zoomId,
      type: type ?? this.type,
    );
  }

  factory ReformTimetable.fromJson(Map<String, dynamic> json) {
    return ReformTimetable(
      id: json["id"],
      className: json["className"],
      startTime: json["startTime"] != null
          ? DateTime.tryParse(json["startTime"])?.toLocal()
          : null,
      endTime: json["endTime"] != null
          ? DateTime.tryParse(json["endTime"])?.toLocal()
          : null,
      subject: json["subject"],
      room: json["room"],
      zoomId: json["zoomID"],
      type: TimetableType.values[json["type"]],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "className": className,
        "startTime": startTime?.toIso8601String(),
        "endTime": endTime?.toIso8601String(),
        "subject": subject,
        "room": room,
        "zoomID": zoomId,
        "type": type,
      };

  @override
  String toString() {
    return "$id, $className, $startTime, $endTime, $subject, $room, $zoomId, $type, ";
  }
}
