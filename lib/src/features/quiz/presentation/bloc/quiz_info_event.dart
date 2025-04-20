part of 'quiz_info_bloc.dart';

abstract class QuizInfoEvent extends Equatable {
  const QuizInfoEvent();
}

class GetQuizInfoEvent extends QuizInfoEvent {
  const GetQuizInfoEvent({
    required this.id,
  });

  final String id;

  @override
  List<String> get props => [id];
}
