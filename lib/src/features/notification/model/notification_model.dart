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

  NotificationModel({
    required this.id,
    this.title,
    this.body,
    required this.time,
    this.isRead = false,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      time: json['time'],
      isRead: json['isRead'] ?? false,
      data: json['data'],
    );
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    Map<String, dynamic>? data,
    String? time,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
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
