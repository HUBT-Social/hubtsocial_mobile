import 'package:equatable/equatable.dart';

class SubjectScoreModel extends Equatable {
  const SubjectScoreModel({
    required this.subject,
    required this.score10,
    required this.score4,
    required this.grade,
  });

  final String subject;
  final double score10;
  final double score4;
  final String grade;

  SubjectScoreModel copyWith({
    String? subject,
    double? score10,
    double? score4,
    String? grade,
  }) {
    return SubjectScoreModel(
      subject: subject ?? this.subject,
      score10: score10 ?? this.score10,
      score4: score4 ?? this.score4,
      grade: grade ?? this.grade,
    );
  }

  factory SubjectScoreModel.fromJson(Map<String, dynamic> json) {
    return SubjectScoreModel(
      subject: json["subject"],
      score10: (json['score10'] as num).toDouble(),
      score4: (json['score4'] as num).toDouble(),
      grade: json["grade"],
    );
  }

  Map<String, dynamic> toJson() => {
        "subject": subject,
        "score10": score10,
        "score4": score4,
        "grade": grade,
      };

  @override
  String toString() {
    return "$subject, $score10, $score4, $grade, ";
  }

  @override
  List<Object?> get props => [
        subject,
        score10,
        score4,
        grade,
      ];
}
