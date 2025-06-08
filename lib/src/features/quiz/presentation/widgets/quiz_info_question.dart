import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/quiz/data/models/question_model.dart';

import '../../../menu/presentation/widgets/line_in_menu.dart';

class QuizInfoQuestion extends StatelessWidget {
  const QuizInfoQuestion({
    super.key,
    required this.index,
    required this.item,
  });
  final int index;
  final QuestionModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LineInMenu(),
          Text(
            "${context.loc.question_value((index + 1).toString())}: ${item.title}",
            style: context.textTheme.bodyLarge,
          ),
          SizedBox(height: 4.h),
          ...item.answers.map(
            (answer) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Row(
                  spacing: 6.w,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 8.r,
                      color: context.colorScheme.secondary,
                    ),
                    Expanded(
                      child: Text(
                        answer.content.toString(),
                        style: context.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
