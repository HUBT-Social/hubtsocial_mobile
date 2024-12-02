import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/localization/ui/widget/button_change_localization.dart';
import 'package:hubtsocial_mobile/src/core/navigation/route.dart';
import 'package:hubtsocial_mobile/src/features/menu/presentation/widgets/user_card_in_menu.dart';

import '../../../../core/app/providers/hive_provider.dart';
import '../../../../core/theme/presentation/widget/button_change_theme.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
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
          UserCardInMenu(),
          ButtonChangeTheme(),
          ButtonChangeLocalization(),
          FilledButton(
            onPressed: () {
              AppRoute.profile.push(context);
            },
            child: Text("data"),
          ),
          FilledButton(
            onPressed: () {
              context.read<AuthBloc>().add(const SignOutEvent());
              HiveProvider.clearToken(() => AppRoute.getStarted.go(context));
            },
            child: Text("Sign out"),
          ),
        ],
      ),
    );
  }
}
