import 'package:dartz/dartz.dart';
import 'package:hubtsocial_mobile/src/core/api/errors/exceptions.dart';
import 'package:hubtsocial_mobile/src/core/api/errors/failure.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/home/module/data/datasources/module_remote_data_source.dart';
import 'package:hubtsocial_mobile/src/features/home/module/data/models/module_response_model.dart';
import 'package:hubtsocial_mobile/src/features/home/module/domain/repos/module_repo.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(
  as: ModuleRepo,
)
class ModuleRepoImpl implements ModuleRepo {
  const ModuleRepoImpl(this._remoteDataSource);

  final ModuleRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<List<ModuleResponseModel>> getModule() async {
    try {
      final result = await _remoteDataSource.getModule();

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
