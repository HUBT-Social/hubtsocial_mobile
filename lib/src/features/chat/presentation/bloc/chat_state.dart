part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

// class EmailUpdatedState extends ChatState {
//   final String email;

//   const EmailUpdatedState(this.email);
// }

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatLoading extends ChatState {
  const ChatLoading();
}

class ChatFailure extends ChatState {
  const ChatFailure();
}

class ChatSuccess extends ChatState {
  const ChatSuccess();
}

class ChatError extends ChatState {
  const ChatError(this.message);

  final String message;

  @override
  List<String> get props => [message];
}

class FetchChat extends ChatState {
  const FetchChat(this.page);

  final int page;

  @override
  List<String> get props => [page.toString()];
}

class FetchChatSuccess extends ChatState {
  const FetchChatSuccess(this.listChat);

  final List<ChatResponseModel> listChat;

  @override
  List<String> get props => [listChat.toString()];
}
