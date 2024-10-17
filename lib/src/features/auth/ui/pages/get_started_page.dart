import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/configs/assets.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/navigation/route.dart';

import '../../../../core/localization/ui/widget/button_change_localization.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({super.key});

  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Image.asset(
            Assets.startedBg,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 60.w),
                child: Text(
                  context.loc.app_name,
                  textAlign: TextAlign.center,
                  style: context.textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: context.colorScheme.tertiary,
                    shadows: [
                      Shadow(
                        color: context.colorScheme.shadow.withAlpha(92),
                        offset: Offset(0, 4),
                        blurRadius: 24,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 220.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: context.colorScheme.surface,
                  borderRadius: BorderRadiusDirectional.only(
                    topStart: Radius.circular(24),
                    topEnd: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: context.colorScheme.shadow.withAlpha(192),
                      blurRadius: 24,
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 36.h, vertical: 24.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.loc.welcome,
                            style: context.textTheme.displayMedium?.copyWith(
                                color: context.colorScheme.tertiary,
                                fontWeight: FontWeight.w800),
                          ),
                          Text(
                            context.loc.welcome_info,
                            style: context.textTheme.labelLarge
                                ?.copyWith(color: context.colorScheme.tertiary),
                          ),
                        ],
                      ),
                      FilledButton(
                          onPressed: () {
                            AppRoute.signIn.push(context);
                          },
                          child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                context.loc.sign_in,
                                style: context.textTheme.bodyLarge?.copyWith(
                                  color: context.colorScheme.onPrimary,
                                ),
                                textAlign: TextAlign.center,
                              ))),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Column(
                children: [
                  ButtonChangeLocalization(),
                ],
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
