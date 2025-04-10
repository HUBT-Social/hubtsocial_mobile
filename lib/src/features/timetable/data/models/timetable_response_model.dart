import 'dart:convert';
import 'package:hive_ce/hive.dart';
import 'reform_timetable_model.dart';

class TimetableResponseModel extends HiveObject {
  TimetableResponseModel({
    required this.versionKey,
    required this.starttime,
    required this.endtime,
    required this.reformTimetables,
  });

  final String versionKey;
  final DateTime starttime;
  final DateTime endtime;
  final List<ReformTimetable> reformTimetables;

  TimetableResponseModel copyWith({
    required String versionKey,
    required DateTime starttime,
    required DateTime endtime,
    List<ReformTimetable>? reformTimetables,
  }) {
    return TimetableResponseModel(
      versionKey: versionKey,
      starttime: starttime,
      endtime: endtime,
      reformTimetables: reformTimetables ?? this.reformTimetables,
    );
  }

  factory TimetableResponseModel.fromMap(Map<String, dynamic> json) {
    return TimetableResponseModel(
      versionKey: json["versionKey"],
      starttime: DateTime.parse(json["starttime"]),
      endtime: DateTime.parse(json["endtime"]),
      reformTimetables: json["reformTimetables"] == null
          ? []
          : List<ReformTimetable>.from(json["reformTimetables"]!
              .map((x) => ReformTimetable.fromJson(x))),
    );
  }

  factory TimetableResponseModel.fromJson(String source) =>
      TimetableResponseModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => {
        "versionKey": versionKey,
        "starttime": starttime.toIso8601String(),
        "endtime": endtime.toIso8601String(),
        "reformTimetables": reformTimetables.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$versionKey, $starttime, $endtime, $reformTimetables, ";
  }
}
