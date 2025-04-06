import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/timetable/data/models/reform_timetable_model.dart';

import '../../../../core/presentation/widget/url_image.dart';
import '../../../../router/route.dart';
import '../../../../router/router.import.dart';

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
      padding: const EdgeInsets.all(12),
      child: Card(
        elevation: 2,
        color: context.colorScheme.surfaceContainerHighest,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => {},
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.reformTimetable.subject ??
                              widget.reformTimetable.type.toString(),
                          style: context.textTheme.titleMedium,
                          // overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                      ],
                    ),
                  ),
                  Text(
                    widget.reformTimetable.className ?? "",
                    style: context.textTheme.titleMedium,
                    // overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
