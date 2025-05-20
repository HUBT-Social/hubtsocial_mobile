import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/data/domain/usecases/usecases.dart';

import '../../data/models/room_info_model.dart';
import '../repos/room_chat_repo.dart';

@LazySingleton()
class GetRoomMemberUserCase extends UseCaseWithParams<void, GetRoomChatParams> {
  const GetRoomMemberUserCase(this._repo);
  final RoomChatRepo _repo;
  @override
  ResultFuture<RoomInfoModel> call(GetRoomChatParams param) =>
      _repo.getRoomMember(groupId: param.groupId);
}

class GetRoomChatParams extends Equatable {
  const GetRoomChatParams({
    required this.groupId,
  });
  const GetRoomChatParams.empty() : groupId = "";
  final String groupId;

  @override
  List<String> get props => [groupId];
}
