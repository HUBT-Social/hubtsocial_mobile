import 'dart:convert';

import 'package:chatview/chatview.dart';
import 'package:equatable/equatable.dart';

class RoomInfoModel extends Equatable {
  const RoomInfoModel({
    required this.groupId,
    required this.title,
    required this.avatarUrl,
    required this.currentUser,
    required this.otherUsers,
  });

  final String? groupId;
  final String? title;
  final String? avatarUrl;
  final ChatUser currentUser;
  final List<ChatUser> otherUsers;

  RoomInfoModel copyWith({
    String? groupId,
    String? title,
    String? avatarUrl,
    ChatUser? currentUser,
    List<ChatUser>? otherUsers,
  }) {
    return RoomInfoModel(
      groupId: groupId ?? this.groupId,
      title: title ?? this.title,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      currentUser: currentUser ?? this.currentUser,
      otherUsers: otherUsers ?? this.otherUsers,
    );
  }

  factory RoomInfoModel.fromJson(Map<String, dynamic> json) {
    final jsonCurrentUser = json["currentUser"];
    jsonCurrentUser.putIfAbsent("imageType", () => ImageType.network);
    jsonCurrentUser.putIfAbsent(
        "defaultAvatarImage", () => jsonCurrentUser["profilePhoto"]);

    return RoomInfoModel(
      groupId: json["groupId"],
      title: json["title"],
      avatarUrl: json["avatarUrl"],
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

  factory RoomInfoModel.fromMap(String source) =>
      RoomInfoModel.fromJson(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => {
        "groupId": groupId,
        "title": title,
        "avatarUrl": avatarUrl,
        "currentUser": currentUser.toJson(),
        "otherUsers": otherUsers.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$groupId,$title,$avatarUrl, $currentUser, $otherUsers, ";
  }

  @override
  List<Object?> get props => [
        groupId,
        title,
        avatarUrl,
        currentUser,
        otherUsers,
      ];
}
