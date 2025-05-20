import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/quiz_response_model.dart';
import '../../domain/usercases/fetch_quiz_usercase.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

@Injectable()
class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc({
    required FetchQuizUserCase fetchQuiz,
  })  : _fetchQuiz = fetchQuiz,
        super(const QuizInitial()) {
    on<QuizEvent>((event, emit) {
      emit(const QuizLoading());
    });
    on<FetchQuizEvent>(_fetchQuizHandler);
  }
  final FetchQuizUserCase _fetchQuiz;

  Future<void> _fetchQuizHandler(
    FetchQuizEvent event,
    Emitter<QuizState> emit,
  ) async {
    final result = await _fetchQuiz(
      FetchQuizParams(
        page: event.page,
      ),
    );
    result.fold(
      (failure) {
        switch (failure.statusCode) {
          case '401':
            emit(QuizError(failure.message));
            break;
          default:
            emit(QuizError(failure.message));
            break;
        }
      },
      (response) {
        emit(FetchQuizSuccess(response));
      },
    );
  }
}
