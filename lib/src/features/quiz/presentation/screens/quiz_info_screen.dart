import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/constants/assets.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/menu/presentation/widgets/line_in_menu.dart';
import 'package:hubtsocial_mobile/src/features/quiz/data/models/question_model.dart';
import 'package:hubtsocial_mobile/src/features/quiz/data/models/quiz_response_model.dart';
import 'package:hubtsocial_mobile/src/features/quiz/presentation/widgets/quiz_info_question.dart';

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
    super.initState();
    context.read<QuizInfoBloc>().add(GetQuizInfoEvent(id: widget.id));
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
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    margin: EdgeInsets.symmetric(horizontal: 6.w),
                    width: double.infinity,
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
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.r),
                                topRight: Radius.circular(16.r),
                              ),
                              child: Image.asset(
                                Assets.startedBg,
                                fit: BoxFit.cover,
                                height: 200.h,
                                width: double.infinity,
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
                            state.quizInfo.description ?? "",
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Checkbox(
                              value: true,
                              onChanged: (value) {},
                            ),
                            Text("Đảo câu hỏi"),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: true,
                              onChanged: (value) {},
                            ),
                            Text("Đảo câu trả lời"),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 12.h,
                            horizontal: 12.w,
                          ),
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
