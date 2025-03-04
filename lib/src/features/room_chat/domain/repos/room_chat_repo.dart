import 'package:chatview/chatview.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';

import '../../data/models/room_member_model.dart';

abstract class RoomChatRepo {
  const RoomChatRepo();
  ResultFuture<List<Message>> fetchRoomChat({
    required String roomId,
  });
  ResultFuture<RoomMemberModel> getRoomMember({
    required String roomId,
  });
}
