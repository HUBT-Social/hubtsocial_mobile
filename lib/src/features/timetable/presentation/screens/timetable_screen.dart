import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/configs/assets.dart';
import '../../../../core/theme/presentation/widget/button_change_theme.dart';
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
      body: ListView(
        // controller: scrollController,
        physics: const BouncingScrollPhysics(),
        children: [],
      ),
    );
  }
}
