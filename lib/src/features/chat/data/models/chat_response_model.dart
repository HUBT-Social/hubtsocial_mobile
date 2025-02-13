import 'package:equatable/equatable.dart';

class ChatResponseModel extends Equatable {
  const ChatResponseModel({
    required this.totalNumber,
    required this.id,
    required this.avatarUrl,
    required this.groupName,
  });

  final int? totalNumber;
  final String? id;
  final String? avatarUrl;
  final String? groupName;

  ChatResponseModel copyWith({
    int? totalNumber,
    String? id,
    String? avatarUrl,
    String? groupName,
  }) {
    return ChatResponseModel(
      totalNumber: totalNumber ?? this.totalNumber,
      id: id ?? this.id,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      groupName: groupName ?? this.groupName,
    );
  }

  String? get bodyNoEscapeSequence => groupName?.replaceAll('\n', ' ');

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatResponseModel(
      totalNumber: json["totalNumber"],
      id: json["id"],
      avatarUrl: json["avatarUrl"],
      groupName: json["body"],
    );
  }

  Map<String, dynamic> toJson() => {
        "totalNumber": totalNumber,
        "id": id,
        "avatarUrl": avatarUrl,
        "groupName": groupName,
      };

  @override
  String toString() {
    return "$totalNumber, $id, $avatarUrl, $groupName, ";
  }

  @override
  List<Object?> get props => [
        totalNumber,
        id,
        avatarUrl,
        groupName,
      ];
}
