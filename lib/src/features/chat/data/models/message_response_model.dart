import 'package:chatview/chatview.dart';
import 'package:equatable/equatable.dart';

class MessageResponseModel extends Equatable {
  MessageResponseModel({
    required this.groupId,
    required this.message,
  });

  final String? groupId;
  final Message message;

  MessageResponseModel copyWith({
    String? groupId,
    required Message message,
  }) {
    return MessageResponseModel(
      groupId: groupId ?? this.groupId,
      message: message,
    );
  }

  factory MessageResponseModel.fromJson(Map<String, dynamic> json) {
    return MessageResponseModel(
      groupId: json["groupId"],
      message: Message.fromJson(json["message"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "groupId": groupId,
        "message": message.toJson(),
      };

  @override
  String toString() {
    return "$groupId, $message, ";
  }

  @override
  List<Object?> get props => [
        groupId,
        message,
      ];
}
