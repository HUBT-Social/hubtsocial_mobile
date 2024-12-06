import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  // none(''),
  auth('/auth'),
  getStarted('/auth/getStarted'),
  signIn('/auth/sign-in'),
  twoFactor('/auth/two-factor'),
  forgotPassword('/auth/forgot-password'),
  emailVerify('/auth/email-verify'),
  signUp('/auth/sign-up'),
  information('/auth/information'),
  signUpInformation('/auth/sign-up-information'),
  passwordVerify('/auth/password-verify'),
  setNewPassword('/auth/set-new-password'),
  home('/'),
  chat('/chat'),
  timetable('/timetable'),
  notifications('/notifications'),
  menu('/menu'),
  profile('/menu/profile'),
  error('/error'),
  passwordSuccessful('/password-successful'),
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
