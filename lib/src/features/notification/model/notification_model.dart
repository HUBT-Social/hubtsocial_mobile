import 'package:hive_ce_flutter/adapters.dart';

class NotificationModel extends HiveObject {
  final String id;

  final String? title;

  final String? body;

  final String time;

  bool isRead;

  final Map<String, dynamic>? data;

  final String? type;

  NotificationModel({
    required this.id,
    this.title,
    this.body,
    required this.time,
    this.isRead = false,
    this.data,
    this.type,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      time: json['time'],
      isRead: json['isRead'] ?? false,
      data: json['data'],
      type: json['type'], // Thêm type vào fromJson
    );
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    Map<String, dynamic>? data,
    String? time,
    bool? isRead,
    String? type, // Thêm type vào copyWith
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type, // Thêm type vào copyWith
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
