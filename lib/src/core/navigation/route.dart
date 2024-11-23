import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'router.import.dart';

enum AppRoute {
  // none(''),
  getStarted('/getStarted'),
  staging('/staging'),
  signIn('/sign-in'),
  twoFactor('/two-factor'),
  emailVerify('/email-verify'),
  signUp('/sign-up'),
  information('/information'),
  home('/'),
  settings('/settings'),
  notifications('/notifications'),
  profile('/profile'),
  error('/error'),
  ;

  const AppRoute(this.path);

  final String path;
}

extension AppRouteNavigation on AppRoute {
  void go(BuildContext context) {
    context.go(path);
  }

  void push(BuildContext context) {
    context.push(path);
  }

  void pushReplacement(BuildContext context) {
    context.pushReplacement(path);
  }
}
