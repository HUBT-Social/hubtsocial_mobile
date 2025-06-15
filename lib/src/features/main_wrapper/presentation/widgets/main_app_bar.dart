import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';

class MainAppBar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;

  const MainAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: 52.h,
      floating: true,
      snap: true,
      expandedHeight: 0,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(20.w, 50.h, 20.w, 100.h),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff52C755),
              Color(0xff43B446),
              Color(0xff33A036),
              Color(0xff248D27),
            ],
            // begin: Alignment.topLeft,
            // end: Alignment.bottomRight,
          ),
        ),
      ),
      title: Text(
        title,
        style: context.textTheme.headlineSmall?.copyWith(
            color: context.colorScheme.onPrimary, fontWeight: FontWeight.w600),
      ),
      actions: actions,
    );
  }
}
