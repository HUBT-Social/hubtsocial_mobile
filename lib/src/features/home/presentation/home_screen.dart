import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/features/wrapper/presentation/widgets/main_app_bar.dart';
import 'package:hubtsocial_mobile/src/utils/extensions/localization_extension.dart';

import '../../../configs/assets.dart';

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
        MainAppBar(
          title: context.loc.home,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search_outlined,
                size: 18.sp,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.message_rounded,
                size: 18.sp,
              ),
            ),
          ],
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
            height: 200.h,
            color: Colors.amber,
          ),
          Container(
            height: 500.h,
            color: Colors.red,
          ),
          Container(
            height: 800.h,
            color: Colors.blue,
          ),
          Container(
            height: 400.h,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}
