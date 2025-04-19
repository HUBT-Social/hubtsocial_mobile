import 'package:equatable/equatable.dart';

class QuizResponseModel extends Equatable {
  const QuizResponseModel({
    required this.id,
    required this.title,
    required this.questionCount,
    required this.durationMinutes,
    required this.major,
    required this.credits,
  });

  final String id;
  final String? title;
  final int? questionCount;
  final int? durationMinutes;
  final String? major;
  final int? credits;

  QuizResponseModel copyWith({
    required String id,
    String? title,
    int? questionCount,
    int? durationMinutes,
    String? major,
    int? credits,
  }) {
    return QuizResponseModel(
      id: id,
      title: title ?? this.title,
      questionCount: questionCount ?? this.questionCount,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      major: major ?? this.major,
      credits: credits ?? this.credits,
    );
  }

  factory QuizResponseModel.fromJson(Map<String, dynamic> json) {
    return QuizResponseModel(
      id: json["id"],
      title: json["title"],
      questionCount: json["questionCount"],
      durationMinutes: json["durationMinutes"],
      major: json["major"],
      credits: json["credits"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "questionCount": questionCount,
        "durationMinutes": durationMinutes,
        "major": major,
        "credits": credits,
      };

  @override
  String toString() {
    return "$id, $title, $questionCount, $durationMinutes, $major, $credits ";
  }

  @override
  List<Object?> get props => [
        id,
        title,
        questionCount,
        durationMinutes,
        major,
        credits,
      ];
}
