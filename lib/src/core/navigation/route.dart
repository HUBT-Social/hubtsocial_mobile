import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  // none(''),
  auth('/auth'),
  getStarted('/getStarted'),
  staging('/staging'),
  signIn('/sign-in'),
  twoFactor('/two-factor'),
  emailVerify('/email-verify'),
  signUp('/sign-up'),
  information('/information'),

  home('/'),
  chat('/chat'),
  timetable('/timetable'),
  notifications('/notifications'),
  menu('/menu'),
  profile('/menu/profile'),
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

  // void goNamed(BuildContext context) {
  //   context.goNamed(path);
  // }
}
