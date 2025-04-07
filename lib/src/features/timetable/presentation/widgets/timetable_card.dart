import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/timetable/data/models/reform_timetable_model.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Card(
        elevation: 2,
        color: context.colorScheme.surfaceContainerHighest,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => {},
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.reformTimetable.subject ??
                                    widget.reformTimetable.type.toString(),
                                style: context.textTheme.titleLarge,
                              ),
                            ),
                            if (widget.reformTimetable.type != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: context.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text(
                                  widget.reformTimetable.type!.name,
                                  style: context.textTheme.titleSmall,
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
                                Icon(Icons.location_on_sharp),
                                Text(
                                  widget.reformTimetable.room ?? "",
                                  style: context.textTheme.titleMedium,
                                ),
                              ],
                            ),
                            Text(
                              widget.reformTimetable.className ?? '',
                              style: context.textTheme.titleMedium,
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
                                  Icon(Icons.voice_chat_rounded),
                                  Text(
                                    widget.reformTimetable.zoomId ?? "",
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
                                    Icon(Icons.timer_rounded),
                                    Text(
                                      DateFormat.jm().format(
                                          widget.reformTimetable.startTime ??
                                              DateTime.now()),
                                      style: context.textTheme.titleMedium,
                                    ),
                                    if (widget.reformTimetable.endTime != null)
                                      Text(
                                        "->",
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
