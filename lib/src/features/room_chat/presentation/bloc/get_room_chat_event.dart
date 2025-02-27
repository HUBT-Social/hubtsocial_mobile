part of 'get_room_chat_bloc.dart';

sealed class GetRoomChatEvent extends Equatable {
  const GetRoomChatEvent();

  @override
  List<Object> get props => [];
}

class FetchRoomChatEvent extends GetRoomChatEvent {
  const FetchRoomChatEvent({
    required this.roomId,
  });

  final String roomId;

  @override
  List<String> get props => [roomId];
}
