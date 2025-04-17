import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';

class TimetableInfoScreen extends StatefulWidget {
  const TimetableInfoScreen({super.key});

  @override
  State<TimetableInfoScreen> createState() => _TimetableInfoScreenState();
}

class _TimetableInfoScreenState extends State<TimetableInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: context.colorScheme.surface,
        title: Text(
          "thôgn tin thời khóa biểubiểu",
          textAlign: TextAlign.center,
          style: context.textTheme.headlineSmall?.copyWith(
            color: context.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [],
      ),
    );
  }
}
