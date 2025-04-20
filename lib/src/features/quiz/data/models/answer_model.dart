import 'package:equatable/equatable.dart';

class AnswerModel extends Equatable {
  const AnswerModel({
    required this.content,
  });

  final String? content;

  AnswerModel copyWith({
    String? content,
  }) {
    return AnswerModel(
      content: content ?? this.content,
    );
  }

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      content: json["content"],
    );
  }

  Map<String, dynamic> toJson() => {
        "content": content,
      };

  @override
  String toString() {
    return "$content, ";
  }

  @override
  List<Object?> get props => [
        content,
      ];
}
