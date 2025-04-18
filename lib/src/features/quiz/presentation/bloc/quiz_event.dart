part of 'quiz_bloc.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();
}

class FetchQuizEvent extends QuizEvent {
  const FetchQuizEvent({
    required this.page,
  });

  final int page;

  @override
  List<String> get props => [page.toString()];
}
