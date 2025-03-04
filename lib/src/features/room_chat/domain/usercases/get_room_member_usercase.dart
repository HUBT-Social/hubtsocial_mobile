import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/data/domain/usecases/usecases.dart';

import '../../data/models/room_member_model.dart';
import '../repos/room_chat_repo.dart';

@LazySingleton()
class GetRoomMemberUserCase extends UseCaseWithParams<void, GetRoomChatParams> {
  const GetRoomMemberUserCase(this._repo);
  final RoomChatRepo _repo;
  @override
  ResultFuture<RoomMemberModel> call(GetRoomChatParams param) =>
      _repo.getRoomMember(roomId: param.roomId);
}

class GetRoomChatParams extends Equatable {
  const GetRoomChatParams({
    required this.roomId,
  });
  const GetRoomChatParams.empty() : roomId = "";
  final String roomId;

  @override
  List<String> get props => [roomId];
}
