import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hubtsocial_mobile/src/core/navigation/router.dart';

enum AppRoute {
  // none(''),
  splash('splash'),
  getStarted('getStarted'),
  staging('staging'),
  signIn('sign-in'),
  signUp('sign-up'),
  information('information'),
  home('home'),
  settings('settings'),
  notifications('notifications'),
  profile('profile'),
  error('error'),
  ;

  const AppRoute(this.path);

  final String path;
}

extension AppRouteNavigation on AppRoute {
  void go(BuildContext context) {
    context.go(
      parseRoute(
        route: '/$path',
      ),
    );
  }

  void push(BuildContext context) {
    context.push(
      parseRoute(
        route: '/$path',
      ),
    );
  }
}
