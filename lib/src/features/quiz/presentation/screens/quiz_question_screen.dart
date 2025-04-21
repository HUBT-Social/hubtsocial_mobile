import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/quiz_question_bloc.dart';
import '../widgets/answer_option_widget.dart';
import '../widgets/timer_display_widget.dart';

class QuizQuestionScreen extends StatelessWidget {
  const QuizQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuizQuestionBloc, QuizQuestionState>(
      listener: (context, state) {
        if (state.isFinished) {
          Future.delayed(const Duration(milliseconds: 800), () {
            context.go('/quiz/result', extra: {
              "score": state.score,
              "total": state.questions.length,
              "time": state.elapsedSeconds,
            });
          });
        }
      },
      builder: (context, state) {
        final questions = state.questions;
        final index = state.currentIndex;

        if (questions.isEmpty || index < 0 || index >= questions.length) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final question = questions[index];
        final selected = state.selectedAnswer;
        final correctIndex = question.correctAnswer;

        return Scaffold(
          appBar: AppBar(
            title: Text('Câu ${index + 1}/${questions.length}'),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TimerDisplayWidget(seconds: state.elapsedSeconds),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(question.title ?? '',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 20),
                  ...List.generate(question.answers.length, (i) {
                    final answer = question.answers[i];
                    return AnswerOptionWidget(
                      text: answer.content ?? '',
                      index: i,
                      selectedIndex: selected,
                      correctIndex: state.answered ? correctIndex : null,
                      onTap: () {
                        if (!state.answered) {
                          context
                              .read<QuizQuestionBloc>()
                              .add(AnswerQuestion(i));
                        }
                      },
                    );
                  }),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: index > 0
                            ? () => context
                                .read<QuizQuestionBloc>()
                                .add(JumpToQuestion(index - 1))
                            : null,
                        icon: const Icon(Icons.arrow_back),
                      ),
                      IconButton(
                        onPressed: index < questions.length - 1
                            ? () => context
                                .read<QuizQuestionBloc>()
                                .add(JumpToQuestion(index + 1))
                            : null,
                        icon: const Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
