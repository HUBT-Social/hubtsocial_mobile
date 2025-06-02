import 'package:chatview/chatview.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/room_chat/data/models/room_info_model.dart';

abstract class ModuleRepo {
  const ModuleRepo();
  ResultFuture<List<Message>> fetchModule({
    required String roomId,
  });
  ResultFuture<RoomInfoModel> getRoomMember({
    required String roomId,
  });
}
