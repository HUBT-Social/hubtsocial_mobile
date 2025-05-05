import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/extensions/string.dart';
import 'package:hubtsocial_mobile/src/features/timetable/data/models/reform_timetable_model.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';
import 'package:intl/intl.dart';

class TimetableCard extends StatefulWidget {
  const TimetableCard({
    super.key,
    required this.reformTimetable,
  });
  final ReformTimetable reformTimetable;

  @override
  State<TimetableCard> createState() => _TimetableCardState();
}

class _TimetableCardState extends State<TimetableCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
      child: Card(
        elevation: 2,
        color: context.colorScheme.surfaceContainerLow,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => AppRoute.timetableInfo.push(context,
              queryParameters: {"id": widget.reformTimetable.id}),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 12.w,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: widget.reformTimetable.color,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.r),
                      bottomLeft: Radius.circular(12.r),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 12.h, bottom: 12.h, left: 12.w, right: 12.w),
                    child: Column(
                      spacing: 12.h,
                      children: [
                        Row(
                          spacing: 12.w,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                width: 48.r,
                                height: 48.r,
                                decoration: BoxDecoration(
                                  color: context
                                      .colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Icon(
                                  Icons.book_rounded,
                                  color: context.colorScheme.secondary,
                                )),
                            Expanded(
                              child: Text(
                                widget.reformTimetable.subject == null
                                    ? widget.reformTimetable.type.toString()
                                    : widget.reformTimetable.subject!
                                        .capitalizeFirst(),
                                style: context.textTheme.bodyLarge,
                              ),
                            ),
                            if (widget.reformTimetable.type != null)
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: widget.reformTimetable.color,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  widget.reformTimetable.type!.name,
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
                                  Icons.room,
                                  color: context.colorScheme.secondary,
                                ),
                                Text(
                                  widget.reformTimetable.room!
                                      .capitalizeFirst(),
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
                                  widget.reformTimetable.className!
                                      .capitalizeFirst(),
                                  style: context.textTheme.bodyMedium,
                                ),
                              ],
                            )
                          ],
                        ),
                        if (widget.reformTimetable.zoomId!.isNotEmpty)
                          Row(
                            spacing: 12.w,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                spacing: 6.w,
                                children: [
                                  Icon(
                                    Icons.voice_chat_rounded,
                                    color: context.colorScheme.secondary,
                                  ),
                                  Text(
                                    widget.reformTimetable.zoomId!
                                        .capitalizeFirst(),
                                    style: context.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        if (widget.reformTimetable.startTime != null)
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
                                      DateFormat.jm().format(
                                          widget.reformTimetable.startTime ??
                                              DateTime.now()),
                                      style: context.textTheme.bodyMedium,
                                    ),
                                    if (widget.reformTimetable.endTime != null)
                                      Text(
                                        "-",
                                        style: context.textTheme.bodyMedium,
                                      ),
                                    if (widget.reformTimetable.endTime != null)
                                      Text(
                                        DateFormat.jm().format(
                                            widget.reformTimetable.endTime ??
                                                DateTime.now()),
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
