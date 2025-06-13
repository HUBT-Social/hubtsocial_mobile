import 'package:equatable/equatable.dart';

import 'package:hubtsocial_mobile/src/core/api/errors/failure.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/data/models/subject_score_model.dart';

abstract class AcademicResultState extends Equatable {
  const AcademicResultState();

  @override
  List<Object> get props => [];
}

class AcademicResultInitial extends AcademicResultState {}

class AcademicResultLoading extends AcademicResultState {}

class AcademicResultLoaded extends AcademicResultState {
  const AcademicResultLoaded({
    required this.totalAverageScore10,
    required this.totalCreditsAchieved,
    required this.pendingSubjects,
    required this.retakeSubjects,
    required this.failedSubjects,
    required this.grade,
    required this.subjectScores,
  });

  final double totalAverageScore10;
  final int totalCreditsAchieved;
  final int pendingSubjects;
  final int retakeSubjects;
  final int failedSubjects;
  final String grade;
  final List<SubjectScoreModel> subjectScores;

  @override
  List<Object> get props => [
        totalAverageScore10,
        totalCreditsAchieved,
        pendingSubjects,
        retakeSubjects,
        failedSubjects,
        grade,
        subjectScores,
      ];
}

class AcademicResultError extends AcademicResultState {
  const AcademicResultError(this.failure);

  final Failure failure;

  @override
  List<Object> get props => [failure];
}
