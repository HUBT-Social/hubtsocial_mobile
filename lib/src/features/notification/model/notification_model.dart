import 'package:hive_ce_flutter/adapters.dart';

import '../../../core/local_storage/local_storage_type_id.dart';

part 'notification_model.g.dart';

@HiveType(typeId: LocalStorageTypeId.notification)
class NotificationModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? title;

  @HiveField(2)
  final String? body;

  @HiveField(3)
  final String time;

  @HiveField(4)
  bool isRead;

  @HiveField(5)
  final Map<String, dynamic>? data;

  @HiveField(6) // Thêm trường type vào Hive
  final String? type;

  NotificationModel({
    required this.id,
    this.title,
    this.body,
    required this.time,
    this.isRead = false,
    this.data,
    this.type, // Thêm type vào constructor
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
