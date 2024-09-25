import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/utils/extensions/localization_extension.dart';
import 'package:hubtsocial_mobile/src/utils/extensions/theme_extension.dart';

import '../../../constants/assets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          backgroundColor: Theme.of(context).colorScheme.surface.withAlpha(192),
          floating: true,
          snap: true,
          flexibleSpace: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          title: Text(
            context.loc.home,
            style: context.textTheme.headlineSmall?.copyWith(
                color: context.colorScheme.onSurface,
                fontWeight: FontWeight.w900),
          ),
        )
      ],
      body: ListView(
        // controller: scrollController,
        physics: const BouncingScrollPhysics(),
        children: [
          const Text("aaaaaaa"),
          const Text("aaaaaaa"),
          const Text("aaaaaaa"),
          const Text("aaaaaaa"),
          Image.asset(
            Assets.appIcon,
            width: 120.r,
            height: 120.r,
          ),
          Container(
            height: 500,
            width: 100,
            color: Colors.amber,
          ),
          Container(
            height: 500,
            width: 100,
            color: Colors.red,
          ),
          Container(
            height: 500,
            width: 100,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
