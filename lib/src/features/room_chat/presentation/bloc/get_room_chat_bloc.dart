import 'package:chatview/chatview.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usercases/fetch_room_chat_usercase.dart';

part 'get_room_chat_event.dart';
part 'get_room_chat_state.dart';

@Injectable()
class GetRoomChatBloc extends Bloc<GetRoomChatEvent, GetRoomChatState> {
  GetRoomChatBloc({
    required FetchRoomChatUserCase fetchRoomChat,
  })  : _fetchRoomChat = fetchRoomChat,
        super(RoomChatProfileInitial()) {
    on<GetRoomChatEvent>((event, emit) {
      emit(RoomChatProfileLoading());
    });
    on<FetchRoomChatEvent>(_fetchRoomChatHandler);
  }

  final FetchRoomChatUserCase _fetchRoomChat;

  Future<void> _fetchRoomChatHandler(
    FetchRoomChatEvent event,
    Emitter<GetRoomChatState> emit,
  ) async {
    final result =
        await _fetchRoomChat(FetchRoomChatParams(roomId: event.roomId));
    result.fold((failure) => emit(RoomChaLoadedError("serverError")),
        (response) => emit(RoomChatProfileLoaded(response)));
  }
}
