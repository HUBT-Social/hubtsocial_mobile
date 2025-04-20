import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/extensions/string.dart';
import 'package:hubtsocial_mobile/src/features/quiz/data/models/quiz_response_model.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';

class QuizCard extends StatefulWidget {
  const QuizCard({
    super.key,
    required this.item,
  });
  final QuizResponseModel item;

  @override
  State<QuizCard> createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
      child: Card(
        elevation: 2,
        color: context.colorScheme.surfaceContainerLow,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => AppRoute.quizInfo.push(context, queryParameters: {
            'id': widget.item.id,
            'title': widget.item.title
          }),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 12.w,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: context.colorScheme.secondary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.r),
                      bottomLeft: Radius.circular(12.r),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 12.h, bottom: 12.h, left: 6.w, right: 12.w),
                    child: Column(
                      spacing: 12.h,
                      children: [
                        Row(
                          spacing: 12,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                width: 38.r,
                                height: 38.r,
                                decoration: BoxDecoration(
                                  color: context
                                      .colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Icon(
                                  Icons.quiz_rounded,
                                  color: context.colorScheme.secondary,
                                  size: 28.r,
                                )),
                            Expanded(
                              child: Text(
                                widget.item.title == null
                                    ? widget.item.id.toString()
                                    : widget.item.title!.capitalizeFirst(),
                                style: context.textTheme.bodyLarge,
                              ),
                            ),
                            if (widget.item.credits != null)
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: context.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  context.loc.credits(
                                    widget.item.credits ?? 0,
                                  ),
                                  style: context.textTheme.labelLarge?.copyWith(
                                      color: context.colorScheme.onPrimary),
                                ),
                              )
                          ],
                        ),
                        Row(
                          spacing: 12.w,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              spacing: 6.w,
                              children: [
                                Icon(
                                  Icons.question_mark_rounded,
                                  color: context.colorScheme.secondary,
                                ),
                                Text(
                                  context.loc.question_count(
                                      widget.item.questionCount ?? 0),
                                  style: context.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            Row(
                              spacing: 6.w,
                              children: [
                                Icon(
                                  Icons.school_rounded,
                                  color: context.colorScheme.secondary,
                                ),
                                Text(
                                  widget.item.major!.capitalizeFirst(),
                                  style: context.textTheme.bodyMedium,
                                ),
                              ],
                            )
                          ],
                        ),
                        if (widget.item.durationMinutes != null)
                          Row(
                            spacing: 12.w,
                            children: [
                              Expanded(
                                child: Row(
                                  spacing: 6.w,
                                  children: [
                                    Icon(
                                      Icons.timer_rounded,
                                      color: context.colorScheme.secondary,
                                    ),
                                    Text(
                                      context.loc.duration_minutes(
                                        widget.item.durationMinutes ?? 0,
                                      ),
                                      style: context.textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
