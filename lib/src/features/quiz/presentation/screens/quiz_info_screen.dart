import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/constants/assets.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/quiz/data/models/question_model.dart';
import 'package:hubtsocial_mobile/src/features/quiz/data/models/quiz_response_model.dart';

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
  @override
  void initState() {
    context.read<QuizInfoBloc>().add(GetQuizInfoEvent(id: widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colorScheme.surface,
        title: Text(
          "Chi tiết đề",
          textAlign: TextAlign.center,
          style: context.textTheme.headlineSmall?.copyWith(
            color: context.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [],
      ),
      body: BlocConsumer<QuizInfoBloc, QuizInfoState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is GetQuizInfoSuccess) {
            return CustomScrollView(
              // controller: scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    margin: EdgeInsets.symmetric(horizontal: 6.w),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: context.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 12.h),
                            height: 200.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12.r),
                                topRight: Radius.circular(12.r),
                              ),
                            ),
                            child: Image.asset(
                              Assets.startedBg,
                              fit: BoxFit.cover,
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
                        Text(
                          state.quizInfo.description ?? "",
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: true,
                              onChanged: (value) {},
                            ),
                            Text("data"),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 20.h, horizontal: 12.w),
                          child: FilledButton(
                            onPressed: () {},
                            child: Text("Bắt đầu"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList.builder(
                  itemCount: state.quizInfo.questions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return QuizInfoQuestion(
                      index: index,
                      item: state.quizInfo.questions[index],
                    );
                  },
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 100.h,
                  ),
                )
              ],
            );
          } else if (state is QuizInfoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is QuizInfoError) {
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

class QuizInfoQuestion extends StatefulWidget {
  const QuizInfoQuestion({
    super.key,
    required this.index,
    required this.item,
  });
  final int index;
  final QuestionModel item;

  @override
  State<QuizInfoQuestion> createState() => _QuizInfoQuestionState();
}

class _QuizInfoQuestionState extends State<QuizInfoQuestion> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12.r),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "${context.loc.question_value(widget.index + 1)}: ${widget.item.title}",
              style: context.textTheme.bodyMedium,
            ),
          ),
          // widget.item.answers.map(
          //   (e) {
          //     return Text("data");
          //   },
          // ),

          // SizedBox(
          //   height: 300,
          //   child: ListView.builder(
          //     itemCount: widget.item.answers.length,
          //     itemBuilder: (context, index) =>
          //         Text(widget.item.answers[index].content.toString()),
          //   ),
          // ),

          // Container()..

          IntrinsicHeight(
            child: ListView.builder(
              itemCount: widget.item.answers.length,
              itemBuilder: (context, index) =>
                  Text(widget.item.answers[index].content.toString()),
            ),
          )
        ],
      ),
    );
  }
}
