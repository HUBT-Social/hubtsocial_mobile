import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/localization/bloc/localization_bloc.dart';
import 'package:hubtsocial_mobile/src/features/menu/presentation/widgets/button_in_menu.dart';
import 'package:hubtsocial_mobile/src/features/menu/presentation/widgets/line_in_menu.dart';

import 'package:hubtsocial_mobile/src/features/menu/presentation/widgets/user_card_in_menu.dart';

import '../../../../core/localization/utils/change_language_bottom_sheet.dart';
import '../../../../router/router.import.dart';
import '../../../../core/theme/bloc/theme_bloc.dart';
import '../../../../core/theme/utils/change_theme_bottom_sheet.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../main_wrapper/presentation/widgets/main_app_bar.dart';

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
          SizedBox(height: 6),
          Container(
            height: 2,
            width: double.infinity,
            color: context.colorScheme.surfaceContainerHighest,
          ),
          SizedBox(height: 6),
          ButtonInMenu(
            borderRadiusTop: 12,
            icon: BlocBuilder<ThemeBloc, AppThemeState>(
              builder: (context, state) {
                return SvgPicture.asset(
                  colorFilter: ColorFilter.mode(
                      context.colorScheme.onSurface, BlendMode.srcIn),
                  state.selectedTheme.image,
                  fit: BoxFit.fitHeight,
                  height: 28,
                );
              },
            ),
            label: context.loc.change_theme,
            iconArrow: Icon(Icons.arrow_drop_down_rounded),
            onTap: () => ThemeUtils.showThemeBottomSheet(
                navigatorKey.currentContext ?? context),
          ),
          SizedBox(height: 6),
          ButtonInMenu(
            borderRadiusBottom: 12,
            icon: BlocBuilder<LocalizationBloc, AppLocalizationState>(
              builder: (context, state) {
                return Image.asset(
                  state.selectedLanguage.image,
                  fit: BoxFit.fitHeight,
                  height: 28,
                  width: 28,
                );
              },
            ),
            label: context.loc.change_language,
            iconArrow: Icon(Icons.arrow_drop_down_rounded),
            onTap: () => LocalizatioUtils.showLanguageBottomSheet(
                navigatorKey.currentContext ?? context),
          ),
          LineInMenu(),
          ButtonInMenu(
            borderRadiusTop: 12,
            icon: Icon(
              Icons.lock_outline_rounded,
              size: 28,
            ),
            label: context.loc.change_password,
            iconArrow: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Tính năng đang phát triển',
                    style: context.textTheme.bodyMedium,
                  ),
                  backgroundColor: context.colorScheme.surfaceDim,
                ),
              );
            },
          ),
          SizedBox(height: 6),
          ButtonInMenu(
            icon: Icon(
              Icons.support_agent_rounded,
              size: 28,
            ),
            label: context.loc.support_center,
            iconArrow: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Tính năng đang phát triển',
                    style: context.textTheme.bodyMedium,
                  ),
                  backgroundColor: context.colorScheme.surfaceDim,
                ),
              );
            },
          ),
          SizedBox(height: 6),
          ButtonInMenu(
            borderRadiusBottom: 12,
            icon: Icon(
              Icons.feedback_rounded,
              size: 28,
            ),
            label: context.loc.feedback_for_developers,
            iconArrow: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Tính năng đang phát triển',
                    style: context.textTheme.bodyMedium,
                  ),
                  backgroundColor: context.colorScheme.surfaceDim,
                ),
              );
            },
          ),
          LineInMenu(),
          InkWell(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Tính năng đang phát triển',
                    style: context.textTheme.bodyMedium,
                  ),
                  backgroundColor: context.colorScheme.surfaceDim,
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Container(
                height: 48,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: context.colorScheme.errorContainer,
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.delete_forever_rounded,
                          size: 28,
                          color: context.colorScheme.error,
                        ),
                        SizedBox(width: 12),
                        Text(
                          context.loc.delete_account,
                          style: context.textTheme.titleSmall?.copyWith(
                            color: context.colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 6),
          InkWell(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
            onTap: () {
              context.read<AuthBloc>().add(const SignOutEvent());
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Container(
                height: 48,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: context.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.output_rounded,
                          size: 28,
                        ),
                        SizedBox(width: 12),
                        Text(
                          context.loc.sign_out,
                          style: context.textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
