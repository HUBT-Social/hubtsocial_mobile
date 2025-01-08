import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:lottie/lottie.dart';

import '../../../../constants/assets.dart';
import '../../../../router/route.dart';

class PasswordSuccessfulScreen extends StatefulWidget {
  const PasswordSuccessfulScreen({super.key});

  @override
  State<PasswordSuccessfulScreen> createState() =>
      _PasswordSuccessfulScreenState();
}

class _PasswordSuccessfulScreenState extends State<PasswordSuccessfulScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colorScheme.surface,
      padding: EdgeInsets.symmetric(horizontal: 20.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 347.h,
            width: 360.w,
            child: Lottie.asset(AppLotties.passwordSuccessful),
          ),
          SizedBox(height: 30.h),
          Text(
            context.loc.password_change_successful,
            style: context.textTheme.headlineMedium?.copyWith(
              color: context.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 38.h),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                AppRoute.signIn.go(context);
              },
              child: Text(
                context.loc.sign_in,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.onPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
