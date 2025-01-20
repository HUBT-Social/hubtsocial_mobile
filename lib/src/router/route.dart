import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  // none(''),
  error('/error'),

  // auth
  auth('/auth'),
  getStarted('/auth'),

  signIn('/auth/sign-in'),
  twoFactor('/auth/sign-in/two-factor'),

  signUp('/auth/sign-up'),
  emailVerify('/auth/sign-up/email-verify'),
  signUpInformation('/auth/sign-up/sign-up-information'),

  forgotPassword('/auth/forgot-password'),
  passwordVerify('/auth/forgot-password/password-verify'),
  setNewPassword('/auth/forgot-password/set-new-password'),
  passwordSuccessful('/auth/forgot-password/password-successful'),
  // auth

  // home
  home('/'),
  // home

  // chat
  chat('/chat'),
  roomChat('/room'),
  // chat

  // timetable
  timetable('/timetable'),
  // timetable

  // notifications
  notifications('/notifications'),
  // notifications

  // menu
  menu('/menu'),
  profile('/menu/profile'),
  profile2('/menu/profile/profile2'),
  aboutprofile('menu/profile/aboutprofile'),
  // menu

  ;

  const AppRoute(this.path);

  final String path;
}

extension AppRouteNavigation on AppRoute {
  String parseRoute({
    // Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic>? queryParameters,
  }) {
    var uri = Uri(path: path, queryParameters: queryParameters);
    return uri.toString();
  }

  void go(
    BuildContext context, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    context.go(
      parseRoute(queryParameters: queryParameters),
      extra: extra,
    );
  }

  void push(
    BuildContext context, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    context.push(
      parseRoute(queryParameters: queryParameters),
      extra: extra,
    );
  }

  void pushReplacement(
    BuildContext context, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    context.pushReplacement(
      parseRoute(queryParameters: queryParameters),
      extra: extra,
    );
  }
}
