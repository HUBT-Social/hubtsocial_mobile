import 'package:dartz/dartz.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/domain/repos/academic_result_repo.dart';
import 'package:injectable/injectable.dart';

import 'package:hubtsocial_mobile/src/core/api/errors/exceptions.dart';
import 'package:hubtsocial_mobile/src/core/api/errors/failure.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/data/datasources/academic_result_remote_data_source.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/data/models/subject_score_model.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/data/models/score_distribution_model.dart';

@LazySingleton(
  as: AcademicResultRepo,
)
class AcademicResultRepoImpl implements AcademicResultRepo {
  const AcademicResultRepoImpl(this._remoteDataSource);

  final AcademicResultRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<List<SubjectScoreModel>> getAcademicResult() async {
    try {
      final result = await _remoteDataSource.getAcademicResult();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<ScoreDistributionModel> getAcademicResultChart() async {
    try {
      final result = await _remoteDataSource.getAcademicResultChart();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
