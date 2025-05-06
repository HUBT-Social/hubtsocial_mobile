import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/features/timetable/data/models/timetable_info_member_model.dart';

import '../timetable_type.dart';

class TimetableInfoResponseModel extends Equatable {
  const TimetableInfoResponseModel({
    required this.countMember,
    required this.creditNum,
    required this.timetableMembers,
    required this.id,
    required this.className,
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.room,
    required this.zoomId,
    required this.courseId,
    required this.type,
  });

  final int? countMember;
  final int? creditNum;
  final List<TimetableInfoMemberModel> timetableMembers;
  final String id;
  final String? className;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? subject;
  final String? room;
  final String? zoomId;
  final String? courseId;
  final TimetableType? type;

  TimetableInfoResponseModel copyWith({
    int? countMember,
    int? creditNum,
    List<TimetableInfoMemberModel>? timetableMembers,
    String? id,
    String? className,
    DateTime? startTime,
    DateTime? endTime,
    String? subject,
    String? room,
    String? zoomId,
    String? courseId,
    TimetableType? type,
  }) {
    return TimetableInfoResponseModel(
      countMember: countMember ?? this.countMember,
      creditNum: creditNum ?? this.creditNum,
      timetableMembers: timetableMembers ?? this.timetableMembers,
      id: id ?? this.id,
      className: className ?? this.className,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      subject: subject ?? this.subject,
      room: room ?? this.room,
      zoomId: zoomId ?? this.zoomId,
      courseId: courseId ?? this.courseId,
      type: type ?? this.type,
    );
  }

  factory TimetableInfoResponseModel.fromJson(Map<String, dynamic> json) {
    return TimetableInfoResponseModel(
      countMember: json["countMenber"],
      creditNum: json["creditNum"],
      timetableMembers: json["timetableMembers"] == null
          ? []
          : List<TimetableInfoMemberModel>.from(json["timetableMembers"]!
              .map((x) => TimetableInfoMemberModel.fromJson(x))),
      id: json["id"],
      className: json["className"],
      startTime: DateTime.tryParse(json["startTime"] ?? ""),
      endTime: DateTime.tryParse(json["endTime"] ?? ""),
      subject: json["subject"],
      room: json["room"],
      zoomId: json["zoomID"],
      courseId: json["courseId"],
      type: TimetableType.values[json["type"]],
    );
  }
  factory TimetableInfoResponseModel.fromMap(String source) =>
      TimetableInfoResponseModel.fromJson(
          json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => {
        "countMenber": countMember,
        "creditNum": creditNum,
        "timetableMembers": timetableMembers.map((x) => x.toJson()).toList(),
        "id": id,
        "className": className,
        "startTime": startTime?.toIso8601String(),
        "endTime": endTime?.toIso8601String(),
        "subject": subject,
        "room": room,
        "zoomID": zoomId,
        "courseId": courseId,
        "type": type,
      };

  @override
  String toString() {
    return "$countMember, $creditNum, $timetableMembers, $id, $className, $startTime, $endTime, $subject, $room, $zoomId, $courseId, $type, ";
  }

  @override
  List<Object?> get props => [
        countMember,
        creditNum,
        timetableMembers,
        id,
        className,
        startTime,
        endTime,
        subject,
        room,
        zoomId,
        courseId,
        type,
      ];
}
