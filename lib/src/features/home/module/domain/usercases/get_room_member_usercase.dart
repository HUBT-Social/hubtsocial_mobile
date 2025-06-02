import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/core/data/domain/usecases/usecases.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/home/module/domain/repos/module_repo.dart';
import 'package:hubtsocial_mobile/src/features/room_chat/data/models/room_info_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class GetRoomMemberUserCase extends UseCaseWithParams<void, GetModuleParams> {
  const GetRoomMemberUserCase(this._repo);
  final ModuleRepo _repo;
  @override
  ResultFuture<RoomInfoModel> call(GetModuleParams param) =>
      _repo.getRoomMember(roomId: param.roomId);
}

class GetModuleParams extends Equatable {
  const GetModuleParams({
    required this.roomId,
  });
  const GetModuleParams.empty() : roomId = "";
  final String roomId;

  @override
  List<String> get props => [roomId];
}
