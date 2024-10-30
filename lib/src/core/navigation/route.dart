import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  splash('/'),
  getStarted('/getStarted'),
  signIn('/signIn'),
  signUp('/signUp'),
  information('/information'),
  home('/home'),
  settings('/settings'),
  notifications('/notifications'),
  profile('/profile'),
  error('/error'),
  ;

  const AppRoute(this.path);

  final String path;
}

extension AppRouteNavigation on AppRoute {
  void go(BuildContext context) => context.go(path);

  void push(BuildContext context) => context.push(path);
}
