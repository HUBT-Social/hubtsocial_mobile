import 'dart:convert';

import 'package:chatview/chatview.dart';
import 'package:equatable/equatable.dart';

class RoomMemberModel extends Equatable {
  RoomMemberModel({
    required this.groupId,
    required this.currentUser,
    required this.otherUsers,
  });

  final String? groupId;
  final ChatUser currentUser;
  final List<ChatUser> otherUsers;

  RoomMemberModel copyWith({
    String? groupId,
    ChatUser? currentUser,
    List<ChatUser>? otherUsers,
  }) {
    return RoomMemberModel(
      groupId: groupId ?? this.groupId,
      currentUser: currentUser ?? this.currentUser,
      otherUsers: otherUsers ?? this.otherUsers,
    );
  }

  factory RoomMemberModel.fromJson(Map<String, dynamic> json) {
    final jsonCurrentUser = json["currentUser"];
    jsonCurrentUser.putIfAbsent("imageType", () => ImageType.network);
    jsonCurrentUser.putIfAbsent(
        "defaultAvatarImage", () => jsonCurrentUser["profilePhoto"]);

    return RoomMemberModel(
      groupId: json["groupId"],
      currentUser: ChatUser.fromJson(jsonCurrentUser),
      otherUsers: json["otherUsers"] == null
          ? []
          : List<ChatUser>.from(json["otherUsers"]!.map((x) {
              final jsonOtherUsers = x;
              jsonOtherUsers.putIfAbsent("imageType", () => ImageType.network);
              jsonOtherUsers.putIfAbsent(
                  "defaultAvatarImage", () => jsonCurrentUser["profilePhoto"]);

              return ChatUser.fromJson(jsonOtherUsers);
            })),
    );
  }

  factory RoomMemberModel.fromMap(String source) =>
      RoomMemberModel.fromJson(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => {
        "groupId": groupId,
        "currentUser": currentUser.toJson(),
        "otherUsers": otherUsers.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$groupId, $currentUser, $otherUsers, ";
  }

  @override
  List<Object?> get props => [
        groupId,
        currentUser,
        otherUsers,
      ];
}
