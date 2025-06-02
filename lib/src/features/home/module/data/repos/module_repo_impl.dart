import 'package:chatview/chatview.dart';
import 'package:dartz/dartz.dart';
import 'package:hubtsocial_mobile/src/core/api/errors/exceptions.dart';
import 'package:hubtsocial_mobile/src/core/api/errors/failure.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/home/module/data/datasources/module_remote_data_source.dart';
import 'package:hubtsocial_mobile/src/features/home/module/domain/repos/module_repo.dart';
import 'package:hubtsocial_mobile/src/features/room_chat/data/models/room_info_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(
  as: ModuleRepo,
)
class ModuleRepoImpl implements ModuleRepo {
  const ModuleRepoImpl(this._remoteDataSource);

  final ModuleRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<List<Message>> fetchModule({required String roomId}) async {
    try {
      final result = await _remoteDataSource.fetchModule(
        roomId: roomId,
      );

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<RoomInfoModel> getRoomMember({required String roomId}) async {
    try {
      final result = await _remoteDataSource.getRoomMember(
        roomId: roomId,
      );

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
