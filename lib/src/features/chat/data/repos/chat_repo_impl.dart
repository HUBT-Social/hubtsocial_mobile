import 'package:dartz/dartz.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/chat/data/models/chat_response_model.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/errors/exceptions.dart';
import '../../../../core/api/errors/failure.dart';
import '../../domain/repos/chat_repo.dart';
import '../datasources/chat_remote_data_source.dart';

@LazySingleton(
  as: ChatRepo,
)
class ChatRepoImpl implements ChatRepo {
  const ChatRepoImpl(this._remoteDataSource);

  final ChatRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<List<ChatResponseModel>> fetchChat({
    required int page,
    required int limit,
  }) async {
    try {
      final result = await _remoteDataSource.fetchChat(
        page: page,
        limit: limit,
      );

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
