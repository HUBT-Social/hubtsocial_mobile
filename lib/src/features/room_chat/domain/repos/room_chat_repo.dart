import 'package:chatview/chatview.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';

abstract class RoomChatRepo {
  const RoomChatRepo();
  ResultFuture<List<Message>> fetchRoomChat({
    required String roomId,
  });
}
