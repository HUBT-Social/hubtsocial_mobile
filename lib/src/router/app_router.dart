import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hubtsocial_mobile/src/features/home/presentation/home_screen.dart';
import 'package:hubtsocial_mobile/src/features/notifications/presentation/notifications_screen.dart';
import 'package:hubtsocial_mobile/src/features/profile/presentation/profile_screen.dart';
import 'package:hubtsocial_mobile/src/features/splash/presentation/splash_screen.dart';

import '../features/wrapper/presentation/main_wrapper.dart';
import 'router_config.dart';

class AppRouter {
  AppRouter._();

  static String initial = "/";

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorHome =
      GlobalKey<NavigatorState>(debugLabel: 'shellHome');
  static final _shellNavigatorSettings =
      GlobalKey<NavigatorState>(debugLabel: 'shellSettings');
  static final _shellNavigatorNotifications =
      GlobalKey<NavigatorState>(debugLabel: 'shellNotifications');
  // GoRouter configuration
  static final GoRouter router = GoRouter(
    initialLocation: initial,
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: Screen.splash.screenPath,
        builder: (context, state) {
          return const SplashScreen();
        },
      ),

      /// MainWrapper
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapper(
            navigationShell: navigationShell,
          );
        },
        branches: <StatefulShellBranch>[
          /// Brach Home
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHome,
            routes: <RouteBase>[
              GoRoute(
                path: Screen.home.screenPath,
                builder: (BuildContext context, GoRouterState state) =>
                    const HomeScreen(),
                routes: [
                  GoRoute(
                    path: 'subHome',
                    pageBuilder: (context, state) => CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: const HomeScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              FadeTransition(opacity: animation, child: child),
                    ),
                  ),
                ],
              ),
            ],
          ),

          /// Brach Profile
          StatefulShellBranch(
            navigatorKey: _shellNavigatorNotifications,
            routes: <RouteBase>[
              GoRoute(
                path: Screen.notifications.screenPath,
                builder: (BuildContext context, GoRouterState state) =>
                    const NotificationsScreen(),
              ),
            ],
          ),

          /// Brach Profile
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSettings,
            routes: <RouteBase>[
              GoRoute(
                path: Screen.profile.screenPath,
                builder: (BuildContext context, GoRouterState state) =>
                    const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: "subSetting",
                    pageBuilder: (context, state) {
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: const ProfileScreen(),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) =>
                            FadeTransition(opacity: animation, child: child),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
