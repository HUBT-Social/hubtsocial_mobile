import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/quiz/data/models/question_model.dart';

import '../../../menu/presentation/widgets/line_in_menu.dart';

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
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LineInMenu(),
          Text(
            "${context.loc.question_value(widget.index + 1)}: ${widget.item.title}",
            style: context.textTheme.bodyLarge,
          ),
          SizedBox(height: 4.h),
          ...widget.item.answers.map(
            (answer) {
              return Row(
                spacing: 6.w,
                children: [
                  Icon(
                    Icons.circle,
                    size: 8.r,
                    color: context.colorScheme.secondary,
                  ),
                  Text(
                    answer.content.toString(),
                    style: context.textTheme.bodyMedium,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
