import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';

import '../../../../core/configs/assets.dart';
import '../../../../core/navigation/route.dart';
import '../../../user/bloc/user_cubit.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: _onUserState,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.appIcon,
                    width: 120.r,
                    height: 120.r,
                  )
                      .animate()
                      .scale(
                          duration: const Duration(milliseconds: 500),
                          begin: const Offset(10, 10),
                          end: const Offset(1, 1))
                      .fadeIn(duration: const Duration(milliseconds: 500))
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 82.h),
                    child: Text(
                      textAlign: TextAlign.center,
                      context.loc.department,
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 24.h),
                    child: Text(
                      textAlign: TextAlign.center,
                      context.loc.university_name,
                      style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.colorScheme.onSurface),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onUserState(BuildContext context, UserState userState) {
    if (userState is! UserLoaded) {
      // User not loaded yet
      return;
    }

    AppRoute.home.go(context);
  }
}
