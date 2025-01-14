part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
}

class FetchChatEvent extends ChatEvent {
  const FetchChatEvent({
    required this.page,
  });

  final int page;

  @override
  List<String> get props => [page.toString()];
}
