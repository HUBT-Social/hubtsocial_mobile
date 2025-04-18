part of 'quiz_bloc.dart';

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object> get props => [];
}

// class EmailUpdatedState extends QuizState {
//   final String email;

//   const EmailUpdatedState(this.email);
// }

class QuizInitial extends QuizState {
  const QuizInitial();
}

class QuizLoading extends QuizState {
  const QuizLoading();
}

class QuizFailure extends QuizState {
  const QuizFailure();
}

class QuizSuccess extends QuizState {
  const QuizSuccess();
}

class QuizError extends QuizState {
  const QuizError(this.message);

  final String message;

  @override
  List<String> get props => [message];
}

class FetchQuiz extends QuizState {
  const FetchQuiz(this.page);

  final int page;

  @override
  List<String> get props => [page.toString()];
}

class FetchQuizSuccess extends QuizState {
  const FetchQuizSuccess(this.listQuiz);

  final List<QuizResponseModel> listQuiz;

  @override
  List<String> get props => [listQuiz.toString()];
}
