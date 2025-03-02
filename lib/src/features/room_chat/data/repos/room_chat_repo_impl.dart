import 'package:chatview/chatview.dart';
import 'package:dartz/dartz.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/errors/exceptions.dart';
import '../../../../core/api/errors/failure.dart';
import '../../domain/repos/room_chat_repo.dart';
import '../datasources/room_chat_remote_data_source.dart';
import '../models/room_member_model.dart';

@LazySingleton(
  as: RoomChatRepo,
)
class RoomChatRepoImpl implements RoomChatRepo {
  const RoomChatRepoImpl(this._remoteDataSource);

  final RoomChatRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<List<Message>> fetchRoomChat({required String roomId}) async {
    try {
      final result = await _remoteDataSource.fetchRoomChat(
        roomId: roomId,
      );

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<RoomMemberModel> getRoomMember({required String roomId}) async {
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
