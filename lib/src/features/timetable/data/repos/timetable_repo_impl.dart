import 'package:dartz/dartz.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/errors/exceptions.dart';
import '../../../../core/api/errors/failure.dart';
import '../../domain/repos/timetable_repo.dart';
import '../datasources/timetable_remote_data_source.dart';
import '../models/timetable_response_model.dart';

@LazySingleton(
  as: TimetableRepo,
)
class TimetableRepoImpl implements TimetableRepo {
  const TimetableRepoImpl(this._remoteDataSource);

  final TimetableRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<TimetableResponseModel> initTimetable() async {
    try {
      final result = await _remoteDataSource.initTimetable();

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
