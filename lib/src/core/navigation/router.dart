import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/core/navigation/route.dart';
import 'package:hubtsocial_mobile/src/features/auth/ui/pages/get_started_page.dart';
import 'package:hubtsocial_mobile/src/features/auth/ui/pages/information_page.dart';
import 'package:hubtsocial_mobile/src/features/auth/ui/pages/sign_in_page.dart';
import 'package:hubtsocial_mobile/src/features/auth/ui/pages/two_factor_page.dart';
import 'package:hubtsocial_mobile/src/features/home/ui/pages/home_page.dart';
import 'package:jwt_decode_full/jwt_decode_full.dart';
import '../../features/auth/domain/entities/user_token.dart';
import '../../features/auth/ui/bloc/auth_bloc.dart';
import '../../features/auth/ui/pages/sign_up_page.dart';
import '../../features/auth/ui/pages/splash_page.dart';
import '../../features/main_wrapper/ui/main_wrapper.dart';
import '../../features/notifications/ui/pages/notifications_page.dart';
import '../../features/profile/domain/entities/user.dart';
import '../../features/profile/ui/pages/profile_screen.dart';
import '../app/providers/user_provider.dart';
import '../injections/injections.dart';

final _shellNavigatorHome = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorSettings =
    GlobalKey<NavigatorState>(debugLabel: 'shellSettings');
final _shellNavigatorNotifications =
    GlobalKey<NavigatorState>(debugLabel: 'shellNotifications');

String parseRoute({
  required String route,
  Map<String, dynamic>? queryParameters,
}) {
  var uri = Uri(path: route, queryParameters: queryParameters);
  return uri.toString();
}

String joinRoute(List<String> routes) {
  var route = routes.join('/');
  return route;
}

final GoRouter router = GoRouter(
  // errorBuilder: (context, state) {
  //   logError(state.uri.path);
  //   return const PageUnderConstruction();
  // },
  debugLogDiagnostics: true,
  initialLocation: '/',
  redirect: (context, state) {
    if (state.fullPath != '/') {
      if (state.fullPath!.contains(AppRoute.getStarted.path) ||
          state.fullPath!.contains(AppRoute.signIn.path) ||
          state.fullPath!.contains(AppRoute.twoFactor.path) ||
          state.fullPath!.contains(AppRoute.signUp.path) ||
          state.fullPath!.contains('reset-password') ||
          state.fullPath!.contains('enter-phone')) {
        return null;
      }
      LocalUser? user = context.read<UserProvider>().user;
      var tokenBox = Hive.box('token');
      if (tokenBox.isEmpty || !tokenBox.containsKey('userToken')) {
        return joinRoute(['', AppRoute.getStarted.path]);
      }
      if (user == null) {
        if (state.fullPath != null) {
          var param = Map<String, String>.from(state.uri.queryParameters);
          logInfo('Param $param');
          param.putIfAbsent(
              'forwardRoute', () => state.fullPath!.replaceAll('/', ''));
          return parseRoute(
              route: '/${AppRoute.home.path}', queryParameters: param);
        }
        return '/';
      }
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        var tokenBox = Hive.box('token');
        if (tokenBox.isNotEmpty && tokenBox.containsKey('userToken')) {
          UserToken token = tokenBox.get('userToken');
          var payload = jwtDecode(token.accessToken).payload;
          // Check if token is expired
          var currentTimestamp = DateTime.now().millisecondsSinceEpoch;
          if (currentTimestamp ~/ 1000 < payload['exp']) {
            return const HomeScreen();
          }
        }
        // Move to sign in screen if no token found
        return BlocProvider(
          create: (_) => getIt<AuthBloc>(),
          child: const GetStartedPage(),
        );
      },
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
          builder: (context, state) => BlocProvider(
            create: (context) => getIt<AuthBloc>(),
            child: SignInPage(),
          ),
        ),
        GoRoute(
          path: AppRoute.twoFactor.path,
          builder: (context, state) => BlocProvider(
            create: (context) => getIt<AuthBloc>(),
            child: TwoFactorPage(),
          ),
        ),

        GoRoute(
          path: AppRoute.signUp.path,
          builder: (context, state) => const SignUpPage(),
        ),
        GoRoute(
          path: AppRoute.information.path,
          builder: (context, state) => const InformationPage(),
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
                      pageBuilder: (context, state) =>
                          CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: const HomeScreen(),
                        transitionsBuilder: (context, animation,
                                secondaryAnimation, child) =>
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
    ),
  ],
);
