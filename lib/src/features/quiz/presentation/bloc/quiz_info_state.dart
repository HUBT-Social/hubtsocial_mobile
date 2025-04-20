part of 'quiz_info_bloc.dart';

abstract class QuizInfoState extends Equatable {
  const QuizInfoState();

  @override
  List<Object> get props => [];
}

// class EmailUpdatedState extends QuizInfoState {
//   final String email;

//   const EmailUpdatedState(this.email);
// }

class QuizInfoInitial extends QuizInfoState {
  const QuizInfoInitial();
}

class QuizInfoLoading extends QuizInfoState {
  const QuizInfoLoading();
}

class QuizInfoFailure extends QuizInfoState {
  const QuizInfoFailure();
}

class QuizInfoError extends QuizInfoState {
  const QuizInfoError(this.message);

  final String message;

  @override
  List<String> get props => [message];
}

class GetQuizInfo extends QuizInfoState {
  const GetQuizInfo(this.id);

  final String id;

  @override
  List<String> get props => [id.toString()];
}

class GetQuizInfoSuccess extends QuizInfoState {
  const GetQuizInfoSuccess.getQuizInfoSuccess(this.quizInfo);

  final QuizInfoResponseModel quizInfo;

  @override
  List<String> get props => [quizInfo.toString()];
}
