import 'package:equatable/equatable.dart';

class ChatResponseModel extends Equatable {
  const ChatResponseModel({
    required this.lastMessage,
    required this.lastInteractionTime,
    required this.id,
    required this.avatarUrl,
    required this.groupName,
  });

  final String? lastMessage;
  final String? lastInteractionTime;
  final String id;
  final String avatarUrl;
  final String groupName;

  ChatResponseModel copyWith({
    String? lastMessage,
    String? lastInteractionTime,
    String? id,
    String? avatarUrl,
    String? groupName,
  }) {
    return ChatResponseModel(
      lastMessage: lastMessage ?? this.lastMessage,
      lastInteractionTime: lastInteractionTime ?? this.lastInteractionTime,
      id: id ?? this.id,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      groupName: groupName ?? this.groupName,
    );
  }

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatResponseModel(
      lastMessage: json["lastMessage"],
      lastInteractionTime: json["lastInteractionTime"],
      id: json["id"],
      avatarUrl: json["avatarUrl"],
      groupName: json["groupName"],
    );
  }

  Map<String, dynamic> toJson() => {
        "lastMessage": lastMessage,
        "lastInteractionTime": lastInteractionTime,
        "id": id,
        "avatarUrl": avatarUrl,
        "groupName": groupName,
      };

  @override
  String toString() {
    return "$lastMessage, $lastInteractionTime, $id, $avatarUrl, $groupName, ";
  }

  @override
  List<Object?> get props => [
        lastMessage,
        lastInteractionTime,
        id,
        avatarUrl,
        groupName,
      ];
}
