import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:hubtsocial_mobile/src/features/academic_result/data/models/subject_score_model.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/domain/usecases/get_academic_result_usecase.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/presentation/bloc/academic_result_event.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/presentation/bloc/academic_result_state.dart';

@injectable
class AcademicResultBloc
    extends Bloc<AcademicResultEvent, AcademicResultState> {
  AcademicResultBloc({
    required GetAcademicResultUseCase getAcademicResult,
  })  : _getAcademicResult = getAcademicResult,
        super(AcademicResultInitial()) {
    on<GetAcademicResult>(_onGetAcademicResult);
  }

  final GetAcademicResultUseCase _getAcademicResult;

  Future<void> _onGetAcademicResult(
    GetAcademicResult event,
    Emitter<AcademicResultState> emit,
  ) async {
    emit(AcademicResultLoading());

    final result = await _getAcademicResult();

    result.fold(
      (failure) => emit(AcademicResultError(failure)),
      (subjectScores) {
        if (subjectScores.isEmpty) {
          emit(const AcademicResultLoaded(
            totalAverageScore10: 0,
            totalCreditsAchieved: 0,
            pendingSubjects: 0,
            retakeSubjects: 0,
            failedSubjects: 0,
            grade: 'N/A',
            subjectScores: [],
          ));
          return;
        }

        double totalScore10 = 0;
        int totalCredits = 0;
        int pending = 0;
        int retake = 0;
        int failed = 0;

        for (var subject in subjectScores) {
          totalScore10 += subject.score10;
          // Assuming each subject contributes 1 credit for now, adjust if needed
          totalCredits += 1;

          // Example logic for categorization
          if (subject.grade == 'Pending') {
            pending++;
          } else if (subject.grade == 'Retake') {
            retake++;
          } else if (subject.grade == 'F') {
            failed++;
          }
        }

        final averageScore10 =
            totalCredits > 0 ? totalScore10 / totalCredits : 0.0;

        String grade;
        if (averageScore10 >= 8.5) {
          grade = 'Xuất sắc';
        } else if (averageScore10 >= 7.0) {
          grade = 'Giỏi';
        } else if (averageScore10 >= 5.5) {
          grade = 'Khá';
        } else if (averageScore10 >= 4.0) {
          grade = 'Trung bình';
        } else {
          grade = 'Yếu/Kém';
        }

        emit(AcademicResultLoaded(
          totalAverageScore10: averageScore10,
          totalCreditsAchieved: totalCredits,
          pendingSubjects: pending,
          retakeSubjects: retake,
          failedSubjects: failed,
          grade: grade,
          subjectScores: subjectScores,
        ));
      },
    );
  }
}
