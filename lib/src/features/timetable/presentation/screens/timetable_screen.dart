import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';

import '../../../main_wrapper/ui/widgets/main_app_bar.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        MainAppBar(
          title: context.loc.timetable,
        )
      ],
      body: CustomScrollView(
        // controller: scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [],
      ),
    );
  }
}
