import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:hubtsocial_mobile/src/core/api/errors/exceptions.dart';
import 'package:hubtsocial_mobile/src/core/api/errors/failure.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/data/datasources/academic_result_remote_data_source.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/data/models/subject_score_model.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/domain/models/score_distribution_data.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/domain/repos/academic_result_repo.dart';

abstract class AcademicResultRepo {
  const AcademicResultRepo();

  ResultFuture<List<SubjectScoreModel>> getAcademicResult();

  Future<ScoreDistributionData> getAcademicResultChart();
}

@LazySingleton(as: AcademicResultRepo)
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
  Future<ScoreDistributionData> getAcademicResultChart() async {
    try {
      final result = await _remoteDataSource.getAcademicResultChart();
      return result;
    } on ServerException catch (e) {
      throw Exception('Failed to load academic result chart: ${e.message}');
    }
  }
}
