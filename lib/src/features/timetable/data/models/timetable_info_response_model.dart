import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/features/timetable/data/models/timetable_info_member_model.dart';

import '../timetable_type.dart';

class TimetableInfoResponseModel extends Equatable {
  const TimetableInfoResponseModel({
    required this.creditNum,
    required this.chatRoomId,
    required this.studentMembers,
    required this.teacherleMembers,
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

  final int? creditNum;
  final String? chatRoomId;
  final List<TimetableInfoMemberModel> studentMembers;
  final List<TimetableInfoMemberModel> teacherleMembers;
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
    int? creditNum,
    String? chatRoomId,
    List<TimetableInfoMemberModel>? studentMembers,
    List<TimetableInfoMemberModel>? teacherleMembers,
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
      creditNum: creditNum ?? this.creditNum,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      studentMembers: studentMembers ?? this.studentMembers,
      teacherleMembers: teacherleMembers ?? this.teacherleMembers,
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
      creditNum: json["creditNum"],
      chatRoomId: json["chatRoomId"],
      studentMembers: json["studentMembers"] == null
          ? []
          : List<TimetableInfoMemberModel>.from(json["studentMembers"]!
              .map((x) => TimetableInfoMemberModel.fromJson(x))),
      teacherleMembers: json["teacherleMembers"] == null
          ? []
          : List<TimetableInfoMemberModel>.from(json["teacherleMembers"]!
              .map((x) => TimetableInfoMemberModel.fromJson(x))),
      id: json["id"],
      className: json["className"],
      startTime: DateTime.tryParse(json["startTime"]),
      endTime: DateTime.tryParse(json["endTime"]),
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
        "creditNum": creditNum,
        "chatRoomId": chatRoomId,
        "studentMembers": studentMembers.map((x) => x.toJson()).toList(),
        "teacherleMembers": teacherleMembers.map((x) => x.toJson()).toList(),
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
    return "$creditNum, $chatRoomId, $studentMembers, $teacherleMembers, $id, $className, $startTime, $endTime, $subject, $room, $zoomId, $courseId, $type, ";
  }

  @override
  List<Object?> get props => [
        creditNum,
        chatRoomId,
        studentMembers,
        teacherleMembers,
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
