import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/navigation/route.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/configs/assets.dart';
import '../../../../core/theme/presentation/widget/button_change_theme.dart';
import '../../../main_wrapper/ui/widgets/main_app_bar.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        MainAppBar(
          title: context.loc.menu,
        )
      ],
      body: ListView(
        // controller: scrollController,
        physics: const BouncingScrollPhysics(),
        children: [
          FilledButton(
              onPressed: () {
                AppRoute.profile.push(context);
              },
              child: Text("data"))
        ],
      ),
    );
  }
}
