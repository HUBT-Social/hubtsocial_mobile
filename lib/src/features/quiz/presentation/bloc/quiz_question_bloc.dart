import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/features/quiz/data/models/question_model.dart';

part 'quiz_question_event.dart';
part 'quiz_question_state.dart';

@Injectable()
class QuizQuestionBloc extends Bloc<QuizQuestionEvent, QuizQuestionState> {
  QuizQuestionBloc() : super(const QuizQuestionState()) {
    on<LoadQuizQuestions>(_onLoadQuestions);
    on<AnswerQuestion>(_onAnswerSelected);
    on<NextQuestion>(_onNextQuestion);
    on<JumpToQuestion>(_onJumpToQuestion);
    on<TimerTicked>(_onTimerTicked);
  }

  Timer? _timer;

  void _onLoadQuestions(
      LoadQuizQuestions event, Emitter<QuizQuestionState> emit) {
    _timer?.cancel();
    _startTimer();

    emit(QuizQuestionState(
      questions: event.questions,
      currentIndex: 0,
      selectedAnswer: null,
      answered: false,
      score: 0,
      elapsedSeconds: 0,
      isFinished: false,
      history: List<int?>.filled(event.questions.length, null),
    ));
  }

  void _onAnswerSelected(
      AnswerQuestion event, Emitter<QuizQuestionState> emit) {
    if (state.answered) return;

    final question = state.questions[state.currentIndex];
    final isCorrect = question.correctAnswer == event.selectedIndex;
    final newScore = isCorrect ? state.score + 1 : state.score;

    final updatedHistory = List<int?>.from(state.history);
    updatedHistory[state.currentIndex] = event.selectedIndex;

    emit(state.copyWith(
      selectedAnswer: event.selectedIndex,
      answered: true,
      score: newScore,
      history: updatedHistory,
    ));

    Future.delayed(const Duration(seconds: 1), () {
      add(const NextQuestion());
    });
  }

  void _onNextQuestion(NextQuestion event, Emitter<QuizQuestionState> emit) {
    final nextIndex = state.currentIndex + 1;
    if (nextIndex < state.questions.length) {
      emit(state.copyWith(
        currentIndex: nextIndex,
        selectedAnswer: state.history[nextIndex],
        answered: state.history[nextIndex] != null,
      ));
    } else {
      _timer?.cancel();
      emit(state.copyWith(isFinished: true));
    }
  }

  void _onJumpToQuestion(
      JumpToQuestion event, Emitter<QuizQuestionState> emit) {
    if (event.index >= 0 && event.index < state.questions.length) {
      emit(state.copyWith(
        currentIndex: event.index,
        selectedAnswer: state.history[event.index],
        answered: state.history[event.index] != null,
      ));
    }
  }

  void _startTimer() {
    int seconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      seconds++;
      add(TimerTicked(seconds));
    });
  }

  void _onTimerTicked(TimerTicked event, Emitter<QuizQuestionState> emit) {
    emit(state.copyWith(elapsedSeconds: event.elapsedSeconds));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
