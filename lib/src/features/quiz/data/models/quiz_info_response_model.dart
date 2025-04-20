import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/features/quiz/data/models/question_model.dart';

class QuizInfoResponseModel extends Equatable {
  QuizInfoResponseModel({
    required this.title,
    required this.description,
    required this.image,
    required this.questionCount,
    required this.durationMinutes,
    required this.major,
    required this.credits,
    required this.questions,
  });

  final String? title;
  final String? description;
  final String? image;
  final int? questionCount;
  final int? durationMinutes;
  final String? major;
  final int? credits;
  final List<QuestionModel> questions;

  QuizInfoResponseModel copyWith({
    String? title,
    String? description,
    String? image,
    int? questionCount,
    int? durationMinutes,
    String? major,
    int? credits,
    List<QuestionModel>? questions,
  }) {
    return QuizInfoResponseModel(
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      questionCount: questionCount ?? this.questionCount,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      major: major ?? this.major,
      credits: credits ?? this.credits,
      questions: questions ?? this.questions,
    );
  }

  factory QuizInfoResponseModel.fromJson(Map<String, dynamic> json) {
    return QuizInfoResponseModel(
      title: json["title"],
      description: json["description"],
      image: json["image"],
      questionCount: json["questionCount"],
      durationMinutes: json["durationMinutes"],
      major: json["major"],
      credits: json["credits"],
      questions: json["questions"] == null
          ? []
          : List<QuestionModel>.from(
              json["questions"]!.map((x) => QuestionModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "image": image,
        "questionCount": questionCount,
        "durationMinutes": durationMinutes,
        "major": major,
        "credits": credits,
        "questions": questions.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$title, $description, $image, $questionCount, $durationMinutes, $major, $credits, $questions, ";
  }

  @override
  List<Object?> get props => [
        title,
        description,
        image,
        questionCount,
        durationMinutes,
        major,
        credits,
        questions,
      ];
}
