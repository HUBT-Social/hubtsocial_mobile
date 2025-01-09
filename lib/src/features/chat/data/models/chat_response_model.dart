import 'package:equatable/equatable.dart';

class ChatResponseModel extends Equatable {
  const ChatResponseModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  final int? userId;
  final int? id;
  final String? title;
  final String? body;

  ChatResponseModel copyWith({
    int? userId,
    int? id,
    String? title,
    String? body,
  }) {
    return ChatResponseModel(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  String? get bodyNoEscapeSequence => body?.replaceAll('\n', ' ');

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatResponseModel(
      userId: json["userId"],
      id: json["id"],
      title: json["title"],
      body: json["body"],
    );
  }

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "body": body,
      };

  @override
  String toString() {
    return "$userId, $id, $title, $body, ";
  }

  @override
  List<Object?> get props => [
        userId,
        id,
        title,
        body,
      ];
}
