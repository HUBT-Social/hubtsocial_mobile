import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/utils/extensions/theme_extension.dart';

class MainAppBar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;

  const MainAppBar({
    super.key,
    required this.title,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: 42.h,
      backgroundColor: Theme.of(context).colorScheme.surface.withAlpha(192),
      floating: true,
      snap: true,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          blendMode: BlendMode.srcOver,
          child: Container(
            color: Colors.transparent,
          ),
        ),
      ),
      title: Text(
        title,
        style: context.textTheme.headlineSmall?.copyWith(
            color: context.colorScheme.onSurface, fontWeight: FontWeight.w600),
      ),
      actions: actions,
    );
  }
}
