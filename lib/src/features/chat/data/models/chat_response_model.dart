import 'package:equatable/equatable.dart';

class ChatResponseModel extends Equatable {
  const ChatResponseModel({
    required this.lastMessage,
    required this.lassSender,
    required this.lastInteractionTime,
    required this.id,
    required this.avatarUrl,
    required this.groupName,
  });

  final String? lastMessage;
  final String? lassSender;
  final String? lastInteractionTime;
  final String id;
  final String avatarUrl;
  final String groupName;

  ChatResponseModel copyWith({
    String? lastMessage,
    String? lassSender,
    String? lastInteractionTime,
    String? id,
    String? avatarUrl,
    String? groupName,
  }) {
    return ChatResponseModel(
      lastMessage: lastMessage ?? this.lastMessage,
      lassSender: lassSender ?? this.lassSender,
      lastInteractionTime: lastInteractionTime ?? this.lastInteractionTime,
      id: id ?? this.id,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      groupName: groupName ?? this.groupName,
    );
  }

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatResponseModel(
      lastMessage: json["lastMessage"],
      lassSender: json["lassSender"],
      lastInteractionTime: json["lastInteractionTime"],
      id: json["id"],
      avatarUrl: json["avatarUrl"],
      groupName: json["groupName"],
    );
  }

  Map<String, dynamic> toJson() => {
        "lastMessage": lastMessage,
        "lassSender": lassSender,
        "lastInteractionTime": lastInteractionTime,
        "id": id,
        "avatarUrl": avatarUrl,
        "groupName": groupName,
      };

  @override
  String toString() {
    return "$lastMessage,$lassSender, $lastInteractionTime, $id, $avatarUrl, $groupName, ";
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
