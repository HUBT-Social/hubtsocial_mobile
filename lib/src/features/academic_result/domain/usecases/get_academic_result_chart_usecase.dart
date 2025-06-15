import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/core/data/domain/usecases/usecases.dart';
import 'package:injectable/injectable.dart';

import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/domain/repos/academic_result_repo.dart';

import '../../data/models/score_distribution_model.dart';

@LazySingleton()
class GetAcademicResultChartUseCase
    extends UseCaseWithParams<void, GetAcademicResultChartParams> {
  const GetAcademicResultChartUseCase(this._repo);
  final AcademicResultRepo _repo;
  @override
  ResultFuture<ScoreDistributionModel> call(
          GetAcademicResultChartParams param) =>
      _repo.getAcademicResultChart();
}

class GetAcademicResultChartParams extends Equatable {
  const GetAcademicResultChartParams();

  @override
  List<String> get props => [];
}
