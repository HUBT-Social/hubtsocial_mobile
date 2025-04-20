import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/features/quiz/data/models/answer_model.dart';

class QuestionModel extends Equatable {
  const QuestionModel({
    required this.title,
    required this.answers,
    required this.correctAnswer,
  });

  final String? title;
  final List<AnswerModel> answers;
  final int? correctAnswer;

  QuestionModel copyWith({
    String? title,
    List<AnswerModel>? answers,
    int? correctAnswer,
  }) {
    return QuestionModel(
      title: title ?? this.title,
      answers: answers ?? this.answers,
      correctAnswer: correctAnswer ?? this.correctAnswer,
    );
  }

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      title: json["title"],
      answers: json["answers"] == null
          ? []
          : List<AnswerModel>.from(
              json["answers"]!.map((x) => AnswerModel.fromJson(x))),
      correctAnswer: json["correctAnswer"],
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "answers": answers.map((x) => x?.toJson()).toList(),
        "correctAnswer": correctAnswer,
      };

  @override
  String toString() {
    return "$title, $answers, $correctAnswer, ";
  }

  @override
  List<Object?> get props => [
        title,
        answers,
        correctAnswer,
      ];
}
