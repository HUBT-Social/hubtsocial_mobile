part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
}

class FetchChatEvent extends ChatEvent {
  const FetchChatEvent({
    required this.page,
    required this.limit,
  });

  final int page;
  final int limit;

  @override
  List<String> get props => [page.toString(), limit.toString()];
}
