import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/core/data/domain/usecases/usecases.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/data/models/subject_score_model.dart';
import 'package:injectable/injectable.dart';

import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/domain/repos/academic_result_repo.dart';

@LazySingleton()
class GetAcademicResultUseCase
    extends UseCaseWithParams<void, GetAcademicResultParams> {
  const GetAcademicResultUseCase(this._repo);
  final AcademicResultRepo _repo;

  @override
  ResultFuture<List<SubjectScoreModel>> call(GetAcademicResultParams param) =>
      _repo.getAcademicResult();
}

class GetAcademicResultParams extends Equatable {
  const GetAcademicResultParams();

  @override
  List<String> get props => [];
}
