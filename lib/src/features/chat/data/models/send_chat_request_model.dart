import 'package:equatable/equatable.dart';

class SendChatRequestModel extends Equatable {
  SendChatRequestModel({
    required this.requestId,
    required this.groupId,
    required this.content,
    required this.medias,
    required this.files,
    required this.replyToMessageId,
  });

  final String? requestId;
  final String? groupId;
  final String? content;
  final String? medias;
  final String? files;
  final String? replyToMessageId;

  SendChatRequestModel copyWith({
    String? requestId,
    String? groupId,
    String? content,
    String? medias,
    String? files,
    String? replyToMessageId,
  }) {
    return SendChatRequestModel(
      requestId: requestId ?? this.requestId,
      groupId: groupId ?? this.groupId,
      content: content ?? this.content,
      medias: medias ?? this.medias,
      files: files ?? this.files,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
    );
  }

  factory SendChatRequestModel.fromJson(Map<String, dynamic> json) {
    return SendChatRequestModel(
      requestId: json["requestId"],
      groupId: json["groupId"],
      content: json["content"],
      medias: json["medias"],
      files: json["files"],
      replyToMessageId: json["replyToMessageId"],
    );
  }

  Map<String, dynamic> toJson() => {
        "requestId": requestId,
        "groupId": groupId,
        "content": content,
        "medias": medias,
        "files": files,
        "replyToMessageId": replyToMessageId,
      };

  @override
  String toString() {
    return "$requestId, $groupId, $content, $medias, $files, $replyToMessageId, ";
  }

  @override
  List<Object?> get props => [
        requestId,
        groupId,
        content,
        medias,
        files,
        replyToMessageId,
      ];
}
