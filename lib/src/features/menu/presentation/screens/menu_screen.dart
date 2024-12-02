import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/localization/ui/widget/button_change_localization.dart';
import 'package:hubtsocial_mobile/src/core/navigation/route.dart';
import 'package:hubtsocial_mobile/src/features/menu/presentation/widgets/user_card_in_menu.dart';

import '../../../../core/app/providers/hive_provider.dart';
import '../../../../core/navigation/router.import.dart';
import '../../../../core/theme/bloc/theme_bloc.dart';
import '../../../../core/theme/utils/change_theme_bottom_sheet.dart';
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
          Card(
            elevation: 2,
            color: context.colorScheme.surfaceContainerHighest,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => ThemeUtils.showThemeBottomSheet(
                  navigatorKey.currentContext ?? context),
              child: Container(
                height: 48,
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        BlocBuilder<ThemeBloc, AppThemeState>(
                          builder: (context, state) {
                            return SvgPicture.asset(
                              colorFilter: ColorFilter.mode(
                                  context.colorScheme.onSurface,
                                  BlendMode.srcIn),
                              state.selectedTheme.image,
                              fit: BoxFit.fitHeight,
                              height: 32,
                            );
                          },
                        ),
                        SizedBox(width: 12),
                        Text(
                          "Đổi ngôn ngữ",
                          style: context.textTheme.titleMedium,
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_drop_down_rounded,
                      color: context.colorScheme.onSurface,
                    ),
                  ],
                ),
              ),
            ),
          ),
          ButtonChangeLocalization(),
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
