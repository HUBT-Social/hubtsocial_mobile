part of 'receive_chat_cubit.dart';

sealed class ReceiveChatState extends Equatable {
  const ReceiveChatState(this.messages);
  final MessageResponseModel? messages;

  @override
  List<Object> get props => [];
}

final class ReceiveChatInitial extends ReceiveChatState {
  const ReceiveChatInitial(super.messages);
}

final class ReceiveChatUpdate extends ReceiveChatState {
  const ReceiveChatUpdate(super.messages);
}
