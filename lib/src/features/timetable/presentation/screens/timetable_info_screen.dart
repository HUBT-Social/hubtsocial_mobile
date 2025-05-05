import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/timetable/presentation/bloc/timetable_info_bloc.dart';

class TimetableInfoScreen extends StatefulWidget {
  const TimetableInfoScreen({required this.id, super.key});
  final String id;

  @override
  State<TimetableInfoScreen> createState() => _TimetableInfoScreenState();
}

class _TimetableInfoScreenState extends State<TimetableInfoScreen> {
  @override
  void initState() {
    context
        .read<TimetableInfoBloc>()
        .add(InitTimetableInfoEvent(timetableId: widget.id));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: context.colorScheme.surface,
        title: Text(
          "Thông tin thời khóa biểu",
          textAlign: TextAlign.center,
          style: context.textTheme.headlineSmall?.copyWith(
            color: context.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [],
      ),
      body: Center(),
    );
  }
}
