import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';
import '../bloc/quiz_question_bloc.dart';
import '../widgets/answer_option_widget.dart';
import '../widgets/timer_display_widget.dart';

class QuizQuestionScreen extends StatefulWidget {
  const QuizQuestionScreen({super.key});

  @override
  State<QuizQuestionScreen> createState() => _QuizQuestionScreenState();
}

class _QuizQuestionScreenState extends State<QuizQuestionScreen> {
  final _timerController = TimerController();

  @override
  void initState() {
    _timerController.start();
    super.initState();
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuizQuestionBloc, QuizQuestionState>(
      listener: (context, state) {
        if (state.isFinished) {
          Future.delayed(const Duration(milliseconds: 800), () {
            AppRoute.quizResult.pushReplacement(context, extra: {
              "score": state.score,
              "total": state.questions.length,
              "time": _timerController.elapsedSeconds,
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
            title: Text(
              context.loc.question_value('${index + 1}/${questions.length}'),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: TimerDisplayWidget(
                  controller: _timerController,
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(12.h),
                      child: Text(question.title ?? '',
                          style: Theme.of(context).textTheme.titleLarge),
                    ),
                  ),
                  SliverList.builder(
                    itemCount: question.answers.length,
                    itemBuilder: (BuildContext context, int index) {
                      final answer = question.answers[index];

                      return AnswerOptionWidget(
                        text: answer.content ?? '',
                        index: index,
                        selectedIndex: selected,
                        correctIndex: state.answered ? correctIndex : null,
                        onTap: () {
                          if (!state.answered) {
                            context
                                .read<QuizQuestionBloc>()
                                .add(AnswerQuestion(index));
                          }
                        },
                      );
                    },
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 120.h,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 80.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
              )
            ],
          ),
        );
      },
    );
  }
}
