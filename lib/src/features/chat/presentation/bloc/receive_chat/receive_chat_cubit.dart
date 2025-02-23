import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/features/chat/data/models/message_response_model.dart';

part 'receive_chat_state.dart';

class ReceiveChatCubit extends Cubit<ReceiveChatState> {
  ReceiveChatCubit() : super(ReceiveChatInitial(null));

  void receiveMessage(MessageResponseModel message) {
    emit(ReceiveChatUpdate(message));
  }
}
