import 'package:dartz/dartz.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/errors/exceptions.dart';
import '../../../../core/api/errors/failure.dart';
import '../../domain/repos/quiz_repo.dart';
import '../datasources/quiz_remote_data_source.dart';
import '../models/quiz_response_model.dart';

@LazySingleton(
  as: QuizRepo,
)
class QuizRepoImpl implements QuizRepo {
  const QuizRepoImpl(this._remoteDataSource);

  final QuizRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<List<QuizResponseModel>> fetchQuiz({required int page}) async {
    try {
      final result = await _remoteDataSource.fetchQuiz(
        page: page,
      );

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
