import 'package:equatable/equatable.dart';

class QuizResponseModel extends Equatable {
  const QuizResponseModel({
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

  QuizResponseModel copyWith({
    String? lastMessage,
    String? lastInteractionTime,
    String? id,
    String? avatarUrl,
    String? groupName,
  }) {
    return QuizResponseModel(
      lastMessage: lastMessage ?? this.lastMessage,
      lastInteractionTime: lastInteractionTime ?? this.lastInteractionTime,
      id: id ?? this.id,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      groupName: groupName ?? this.groupName,
    );
  }

  factory QuizResponseModel.fromJson(Map<String, dynamic> json) {
    return QuizResponseModel(
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
