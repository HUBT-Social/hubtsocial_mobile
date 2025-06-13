import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:hubtsocial_mobile/src/core/api/errors/failure.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/data/models/subject_score_model.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/domain/repos/academic_result_repo.dart';

@LazySingleton()
class GetAcademicResultUseCase {
  const GetAcademicResultUseCase(this._repo);

  final AcademicResultRepo _repo;

  ResultFuture<List<SubjectScoreModel>> call() async {
    return _repo.getAcademicResult();
  }
}
