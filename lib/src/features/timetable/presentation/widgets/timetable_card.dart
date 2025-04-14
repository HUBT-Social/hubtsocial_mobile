import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Card(
        elevation: 2,
        color: context.colorScheme.surfaceContainerLow,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => AppRoute.timetableInfo.push(context),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 12,
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      spacing: 12,
                      children: [
                        Row(
                          spacing: 12,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: context
                                      .colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(4),
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
                                style: context.textTheme.titleLarge,
                              ),
                            ),
                            if (widget.reformTimetable.type != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 2),
                                decoration: BoxDecoration(
                                  color: context.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(8),
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
                          spacing: 12,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              spacing: 6,
                              children: [
                                Icon(
                                  Icons.room,
                                  color: context.colorScheme.secondary,
                                ),
                                Text(
                                  widget.reformTimetable.room!
                                      .capitalizeFirst(),
                                  style: context.textTheme.titleMedium,
                                ),
                              ],
                            ),
                            Row(
                              spacing: 6,
                              children: [
                                Icon(
                                  Icons.school_rounded,
                                  color: context.colorScheme.secondary,
                                ),
                                Text(
                                  widget.reformTimetable.className!
                                      .capitalizeFirst(),
                                  style: context.textTheme.titleMedium,
                                ),
                              ],
                            )
                          ],
                        ),
                        if (widget.reformTimetable.zoomId!.isNotEmpty)
                          Row(
                            spacing: 12,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                spacing: 6,
                                children: [
                                  Icon(
                                    Icons.voice_chat_rounded,
                                    color: context.colorScheme.secondary,
                                  ),
                                  Text(
                                    widget.reformTimetable.zoomId!
                                        .capitalizeFirst(),
                                    style: context.textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        if (widget.reformTimetable.startTime != null)
                          Row(
                            spacing: 12,
                            children: [
                              Expanded(
                                child: Row(
                                  spacing: 6,
                                  children: [
                                    Icon(
                                      Icons.timer_rounded,
                                      color: context.colorScheme.secondary,
                                    ),
                                    Text(
                                      DateFormat.jm().format(
                                          widget.reformTimetable.startTime ??
                                              DateTime.now()),
                                      style: context.textTheme.titleMedium,
                                    ),
                                    if (widget.reformTimetable.endTime != null)
                                      Text(
                                        "-",
                                        style: context.textTheme.titleMedium,
                                      ),
                                    if (widget.reformTimetable.endTime != null)
                                      Text(
                                        DateFormat.jm().format(
                                            widget.reformTimetable.endTime ??
                                                DateTime.now()),
                                        style: context.textTheme.titleMedium,
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
