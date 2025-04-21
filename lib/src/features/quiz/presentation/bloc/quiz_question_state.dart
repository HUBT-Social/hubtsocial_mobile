part of 'quiz_question_bloc.dart';

class QuizQuestionState extends Equatable {
  final List<QuestionModel> questions;
  final int currentIndex;
  final int? selectedAnswer;
  final bool answered;
  final int score;
  final int elapsedSeconds;
  final bool isFinished;
  final List<int?> history; // lưu đáp án đã chọn theo index câu hỏi

  const QuizQuestionState({
    this.questions = const [],
    this.currentIndex = 0,
    this.selectedAnswer,
    this.answered = false,
    this.score = 0,
    this.elapsedSeconds = 0,
    this.isFinished = false,
    this.history = const [],
  });

  QuizQuestionState copyWith({
    List<QuestionModel>? questions,
    int? currentIndex,
    int? selectedAnswer,
    bool? answered,
    int? score,
    int? elapsedSeconds,
    bool? isFinished,
    List<int?>? history,
  }) {
    return QuizQuestionState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedAnswer: selectedAnswer,
      answered: answered ?? this.answered,
      score: score ?? this.score,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      isFinished: isFinished ?? this.isFinished,
      history: history ?? this.history,
    );
  }

  @override
  List<Object?> get props => [
        questions,
        currentIndex,
        selectedAnswer,
        answered,
        score,
        elapsedSeconds,
        isFinished,
      ];
}
