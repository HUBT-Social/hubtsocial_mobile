import 'package:chatview/chatview.dart';
import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/data/domain/usecases/usecases.dart';

import '../repos/room_chat_repo.dart';

@LazySingleton()
class FetchRoomChatUserCase
    extends UseCaseWithParams<void, FetchRoomChatParams> {
  const FetchRoomChatUserCase(this._repo);
  final RoomChatRepo _repo;
  @override
  ResultFuture<List<Message>> call(FetchRoomChatParams param) =>
      _repo.fetchRoomChat(roomId: param.roomId);
}

class FetchRoomChatParams extends Equatable {
  const FetchRoomChatParams({
    required this.roomId,
  });
  const FetchRoomChatParams.empty() : roomId = "";
  final String roomId;

  @override
  List<String> get props => [roomId];
}
