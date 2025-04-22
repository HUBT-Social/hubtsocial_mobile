part of 'quiz_question_bloc.dart';

abstract class QuizQuestionEvent extends Equatable {
  const QuizQuestionEvent();

  @override
  List<Object?> get props => [];
}

class LoadQuizQuestions extends QuizQuestionEvent {
  final List<QuestionModel> questions;

  const LoadQuizQuestions(this.questions);

  @override
  List<Object?> get props => [questions];
}

class AnswerQuestion extends QuizQuestionEvent {
  final int selectedIndex;

  const AnswerQuestion(this.selectedIndex);

  @override
  List<Object?> get props => [selectedIndex];
}

class NextQuestion extends QuizQuestionEvent {
  const NextQuestion();
}

class JumpToQuestion extends QuizQuestionEvent {
  final int index;

  const JumpToQuestion(this.index);

  @override
  List<Object?> get props => [index];
}
