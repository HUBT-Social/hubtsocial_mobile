part of 'room_chat_bloc.dart';

sealed class RoomChatEvent extends Equatable {
  const RoomChatEvent();

  @override
  List<Object> get props => [];
}

class FetchRoomChatEvent extends RoomChatEvent {
  const FetchRoomChatEvent({
    required this.roomId,
    required this.page,
  });

  final String roomId;
  final int page;

  @override
  List<String> get props => [roomId];
}

class GetRoomMemberEvent extends RoomChatEvent {
  const GetRoomMemberEvent({
    required this.groupId,
  });

  final String groupId;

  @override
  List<String> get props => [groupId];
}
