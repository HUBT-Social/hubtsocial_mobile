import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/features/chat/data/models/chat_response_model.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usercases/fetch_chat_usercase.dart';

part 'chat_event.dart';
part 'chat_state.dart';

@Injectable()
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({
    required FetchChatUserCase fetchChat,
  })  : _fetchChat = fetchChat,
        super(const ChatInitial()) {
    on<ChatEvent>((event, emit) {
      emit(const ChatLoading());
    });
    on<FetchChatEvent>(_fetchChatHandler);
  }
  final FetchChatUserCase _fetchChat;

  Future<void> _fetchChatHandler(
    FetchChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _fetchChat(
      FetchChatParams(
        page: event.page,
        limit: event.limit,
      ),
    );
    result.fold(
      (failure) {
        switch (int.parse(failure.statusCode)) {
          case 401:
            emit(ChatError(failure.message));
            break;
          default:
            emit(ChatError(failure.message));
            break;
        }
      },
      (response) {
        emit(FetchChatSuccess(response));
      },
    );
  }
}
