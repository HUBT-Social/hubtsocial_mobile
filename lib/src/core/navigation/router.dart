import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hubtsocial_mobile/src/core/navigation/route.dart';
import 'package:hubtsocial_mobile/src/features/auth/ui/pages/get_started_page.dart';
import 'package:hubtsocial_mobile/src/features/auth/ui/pages/sign_in_page.dart';
import 'package:hubtsocial_mobile/src/features/home/ui/pages/home_page.dart';
import '../../features/auth/ui/pages/splash_page.dart';
import '../../features/main_wrapper/ui/main_wrapper.dart';
import '../../features/notifications/ui/pages/notifications_page.dart';
import '../../features/profile/ui/pages/profile_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHome = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorSettings =
    GlobalKey<NavigatorState>(debugLabel: 'shellSettings');
final _shellNavigatorNotifications =
    GlobalKey<NavigatorState>(debugLabel: 'shellNotifications');

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: AppRoute.splash.path,
      builder: (context, state) => const SplashPage(),
    ),

    GoRoute(
      path: AppRoute.getStarted.path,
      builder: (context, state) => const GetStartedPage(),
    ),

    GoRoute(
      path: AppRoute.signIn.path,
      builder: (context, state) => const SignInPage(),
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
              path: AppRoute.home.path,
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
              path: AppRoute.notifications.path,
              builder: (BuildContext context, GoRouterState state) =>
                  const NotificationsPage(),
            ),
          ],
        ),

        /// Brach Profile
        StatefulShellBranch(
          navigatorKey: _shellNavigatorSettings,
          routes: <RouteBase>[
            GoRoute(
              path: AppRoute.profile.path,
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
