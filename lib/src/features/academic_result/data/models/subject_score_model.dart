import 'package:equatable/equatable.dart';

class SubjectScoreModel extends Equatable {
  final String subject;
  final double score10;
  final double score4;
  final String grade;

  const SubjectScoreModel({
    required this.subject,
    required this.score10,
    required this.score4,
    required this.grade,
  });

  factory SubjectScoreModel.fromJson(Map<String, dynamic> map) {
    return SubjectScoreModel(
      subject: map['subject'] as String,
      score10: (map['score10'] as num).toDouble(),
      score4: (map['score4'] as num).toDouble(),
      grade: map['grade'] as String,
    );
  }

  @override
  List<Object> get props => [subject, score10, score4, grade];
}
