import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/localization/bloc/localization_bloc.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';
import 'package:hubtsocial_mobile/src/features/menu/presentation/widgets/user_card_in_menu.dart';

import '../../../../core/app/providers/hive_provider.dart';
import '../../../../core/localization/utils/change_language_bottom_sheet.dart';
import '../../../../router/router.import.dart';
import '../../../../core/theme/bloc/theme_bloc.dart';
import '../../../../core/theme/utils/change_theme_bottom_sheet.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../main_wrapper/ui/widgets/main_app_bar.dart';
import 'package:flutter/services.dart';

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
          SizedBox(height: 6.h),
          Container(
            height: 2.h,
            width: double.infinity,
            color: context.colorScheme.surfaceContainerHighest,
          ),
          SizedBox(height: 6.h),
          InkWell(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
            ),
            onTap: () => ThemeUtils.showThemeBottomSheet(
                navigatorKey.currentContext ?? context),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.r),
              child: Container(
                height: 48,
                padding: EdgeInsets.symmetric(horizontal: 12.r),
                decoration: BoxDecoration(
                  color: context.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                ),
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
                              height: 28.h,
                            );
                          },
                        ),
                        SizedBox(width: 12.h),
                        Text(
                          "Đổi giao diện",
                          style: context.textTheme.titleSmall,
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
          SizedBox(height: 6.h),
          InkWell(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12.r),
              bottomRight: Radius.circular(12.r),
            ),
            onTap: () => LocalizatioUtils.showLanguageBottomSheet(
                navigatorKey.currentContext ?? context),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.r),
              child: Container(
                height: 48.h,
                padding: EdgeInsets.symmetric(horizontal: 12.r),
                decoration: BoxDecoration(
                  color: context.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12.r),
                    bottomRight: Radius.circular(12.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        BlocBuilder<LocalizationBloc, AppLocalizationState>(
                          builder: (context, state) {
                            return Image.asset(
                              state.selectedLanguage.image,
                              fit: BoxFit.fitHeight,
                              height: 28.r,
                              width: 28.r,
                            );
                          },
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          "Đổi ngôn ngữ",
                          style: context.textTheme.titleSmall,
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
          FilledButton(
            onPressed: () {
              context.read<AuthBloc>().add(const SignOutEvent());
              HiveProvider.clearToken(() => AppRoute.getStarted.go(context));
            },
            child: Text("Sign out"),
          ),
          FilledButton(
            onPressed: () async {
              try {
                final String? textToCopy =
                    await FirebaseMessaging.instance.getToken();
                if (textToCopy != null) {
                  await Clipboard.setData(ClipboardData(text: textToCopy));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Copied to Clipboard!')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to copy to clipboard.')),
                );
              }
            },
            child: Text("FCM"),
          ),
        ],
      ),
    );
  }
}
