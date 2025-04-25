import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/constants/assets.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/quiz/data/models/question_model.dart';
import 'package:hubtsocial_mobile/src/features/quiz/presentation/widgets/quiz_info_question.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';

import '../../data/models/answer_model.dart';
import '../bloc/quiz_info_bloc.dart';

class QuizInfoScreen extends StatefulWidget {
  const QuizInfoScreen({
    super.key,
    required this.id,
  });
  final String id;

  @override
  State<QuizInfoScreen> createState() => _QuizInfoScreenState();
}

class _QuizInfoScreenState extends State<QuizInfoScreen> {
  final Random _random = Random();
  bool _shuffleQuestions = false;
  bool _shuffleAnswers = false;

  @override
  void initState() {
    super.initState();
    context.read<QuizInfoBloc>().add(GetQuizInfoEvent(id: widget.id));
  }

  List<QuestionModel> prepareQuestions(List<QuestionModel> originalQuestions) {
    List<QuestionModel> questions = List.from(originalQuestions);

    if (_shuffleQuestions) {
      questions.shuffle(_random);
    }

    return questions.map((q) {
      List<AnswerModel> answers = q.answers;
      var correctAnswer = q.answers[q.correctAnswer ?? 0];

      if (correctAnswer.content == null) {
        correctAnswer = q.answers[0];
      }

      if (_shuffleAnswers) {
        answers.shuffle(_random);
      }

      final newCorrectIndex = answers.indexWhere(
        (a) => a.content?.trim() == correctAnswer.content?.trim(),
      );

      return q.copyWith(
        answers: answers,
        correctAnswer: newCorrectIndex,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colorScheme.surface,
        title: Text(
          context.loc.quizDetailTitle,
          style: context.textTheme.headlineSmall?.copyWith(
            color: context.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocConsumer<QuizInfoBloc, QuizInfoState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is GetQuizInfoSuccess) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    margin: EdgeInsets.symmetric(horizontal: 6.w),
                    decoration: BoxDecoration(
                      color: context.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.r),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: Image.asset(
                                Assets.startedBg,
                                height: 200.h,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          state.quizInfo.title ?? widget.id,
                          style: context.textTheme.headlineSmall?.copyWith(
                            color: context.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (state.quizInfo.description != null)
                          Text(
                            state.quizInfo.description!,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Checkbox(
                              value: _shuffleQuestions,
                              onChanged: (value) {
                                setState(() => _shuffleQuestions = value!);
                              },
                            ),
                            Text(context.loc.shuffleQuestions),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _shuffleAnswers,
                              onChanged: (value) {
                                setState(() => _shuffleAnswers = value!);
                              },
                            ),
                            Text(context.loc.shuffleAnswers),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 12.h,
                            horizontal: 12.w,
                          ),
                          child: FilledButton(
                            onPressed: () {
                              final prepared =
                                  prepareQuestions(state.quizInfo.questions);
                              AppRoute.quizQuestion.push(
                                context,
                                extra: prepared,
                              );
                            },
                            child: Text(context.loc.startQuiz),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList.builder(
                  itemCount: state.quizInfo.questions.length,
                  itemBuilder: (context, index) {
                    return QuizInfoQuestion(
                      index: index,
                      item: state.quizInfo.questions[index],
                    );
                  },
                ),
                SliverToBoxAdapter(child: SizedBox(height: 100.h)),
              ],
            );
          }

          if (state is QuizInfoLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is QuizInfoError) {
            return Center(
              child: Text(
                state.message,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.error,
                ),
              ),
            );
          }

          return const Center();
        },
      ),
    );
  }
}
