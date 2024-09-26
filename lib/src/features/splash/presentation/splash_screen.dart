// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hubtsocial_mobile/src/utils/extensions/localization_extension.dart';
import 'package:hubtsocial_mobile/src/utils/extensions/theme_extension.dart';

import '../../../constants/assets.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startApplication();
  }

  startApplication() async {
    // final applicationManager = ApplicationManager();
    // await applicationManager.startApplication();
    // context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    .animate(delay: const Duration(seconds: 2))
                    .scale(
                        duration: const Duration(milliseconds: 500),
                        begin: const Offset(10, 10),
                        end: const Offset(1, 1))
                    .fadeIn(duration: const Duration(milliseconds: 500))
                    .callback(
                      delay: const Duration(seconds: 2),
                      callback: (value) => context.go('/home'),
                    ),
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
    );
  }
}
