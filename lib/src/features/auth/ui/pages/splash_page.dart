import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/navigation/route.dart';

import '../../../../core/configs/assets.dart';
import '../../../../core/navigation/app_navigator.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    AppNavigator.pauseAndPushNewScreenWithoutBack(
        context: context, routname: AppRoute.home.path, delayTime: 2);
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
                  width: 120,
                  height: 120,
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
                  padding: EdgeInsets.only(top: 82),
                  // child: Text(
                  //   textAlign: TextAlign.center,
                  //   context.loc.department,
                  //   style: context.textTheme.headlineMedium?.copyWith(
                  //     fontWeight: FontWeight.w900,
                  //     color: context.colorScheme.onSurface,
                  //   ),
                  // ),
                  child: SizedBox(),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 24),
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
