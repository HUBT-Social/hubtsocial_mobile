part of 'room_chat_bloc.dart';

sealed class GetRoomChatState extends Equatable {
  const GetRoomChatState();

  @override
  List<Object> get props => [];
}

final class RoomChatProfileInitial extends GetRoomChatState {}

class RoomChatProfileLoading extends GetRoomChatState {}

class RoomChatProfileLoaded extends GetRoomChatState {
  const RoomChatProfileLoaded(this.listMessage);
  final List<Message> listMessage;

  @override
  List<Object> get props => [];
}

class UpdatedRoomChatProfile extends GetRoomChatState {}

class RoomChaLoadedError extends GetRoomChatState {
  const RoomChaLoadedError(this.message);

  final String message;

  @override
  List<String> get props => [message];
}
