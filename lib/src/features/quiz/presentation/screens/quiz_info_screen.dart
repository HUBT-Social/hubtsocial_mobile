import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
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
                    margin: EdgeInsets.symmetric(horizontal: 12.w),
                    width: double.infinity,
                    height: 200.h,
                    decoration: BoxDecoration(
                      color: context.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Text(
                            state.quizInfo.title ?? widget.id,
                            style: context.textTheme.headlineSmall?.copyWith(
                              color: context.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Text(
                            state.quizInfo.description ?? "",
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.h, horizontal: 12.w),
                    child: FilledButton(
                      onPressed: () {},
                      child: Text("Bắt đầu"),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                    child: Container(
                  color: Colors.amber,
                  height: 100000,
                  width: 300,
                )),
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
