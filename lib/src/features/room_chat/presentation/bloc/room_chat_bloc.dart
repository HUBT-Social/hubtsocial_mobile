import 'package:chatview/chatview.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/room_info_model.dart';
import '../../domain/usercases/fetch_room_chat_usercase.dart';
import '../../domain/usercases/get_room_member_usercase.dart';

part 'room_chat_event.dart';
part 'room_chat_state.dart';

@Injectable()
class GetRoomChatBloc extends Bloc<RoomChatEvent, GetRoomChatState> {
  GetRoomChatBloc({
    required FetchRoomChatUserCase fetchRoomChat,
    required GetRoomMemberUserCase getRoomChat,
  })  : _fetchRoomChat = fetchRoomChat,
        _getRoomChat = getRoomChat,
        super(RoomChatProfileInitial()) {
    on<RoomChatEvent>((event, emit) {
      emit(RoomChatProfileLoading());
    });
    on<FetchRoomChatEvent>(_fetchRoomChatHandler);
    on<GetRoomMemberEvent>(_getRoomMemberHandler);
  }

  final FetchRoomChatUserCase _fetchRoomChat;
  final GetRoomMemberUserCase _getRoomChat;

  Future<void> _fetchRoomChatHandler(
    FetchRoomChatEvent event,
    Emitter<GetRoomChatState> emit,
  ) async {
    final result =
        await _fetchRoomChat(FetchRoomChatParams(roomId: event.roomId));
    result.fold((failure) => emit(RoomChaLoadedError("serverError")),
        (response) => emit(FetchRoomLoaded(response)));
  }

  Future<void> _getRoomMemberHandler(
    GetRoomMemberEvent event,
    Emitter<GetRoomChatState> emit,
  ) async {
    final result = await _getRoomChat(GetRoomChatParams(roomId: event.roomId));
    result.fold((failure) => emit(RoomChaLoadedError("serverError")),
        (response) => emit(RoomMemberLoaded(response)));
  }
}
