part of 'router.import.dart';

// final _shellNavigatorHome = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
// final _shellNavigatorSettings =
//     GlobalKey<NavigatorState>(debugLabel: 'shellSettings');
// final _shellNavigatorNotifications =
//     GlobalKey<NavigatorState>(debugLabel: 'shellNotifications');
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

String joinRoute(List<String> routes) {
  var route = routes.join('');
  return route;
}

final GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  errorBuilder: (context, state) {
    logError(state.uri.path);
    return NotFoundScreen(url: state.uri.path);
  },
  debugLogDiagnostics: true,
  initialLocation: AppRoute.home.path,
  redirect: (context, state) {
    if (state.fullPath!.contains(AppRoute.getStarted.path) ||
        state.fullPath!.contains(AppRoute.signIn.path) ||
        state.fullPath!.contains(AppRoute.twoFactor.path) ||
        state.fullPath!.contains(AppRoute.signUp.path) ||
        state.fullPath!.contains(AppRoute.emailVerify.path)) {
      return null;
    }
    // LocalUser? user = context.read<UserProvider>().user;
    var tokenBox = Hive.box('token');
    if (tokenBox.isEmpty || !tokenBox.containsKey('userToken')) {
      return joinRoute(['', AppRoute.getStarted.path]);
    } else if (tokenBox.isNotEmpty && tokenBox.containsKey('userToken')) {
      UserToken token = tokenBox.get('userToken');
      var payload = jwtDecode(token.refreshToken).payload;
      // Check if token is expired
      var currentTimestamp = DateTime.now().millisecondsSinceEpoch;
      if (currentTimestamp ~/ 1000 < payload['exp']) {
        return null;
      }
      // Move to sign in screen if no token found
      return joinRoute(['', AppRoute.signIn.path]);
    }
    // if (user == null) {
    // if (state.fullPath != null) {
    //   var param = Map<String, String>.from(state.uri.queryParameters);
    //   logInfo('Param $param');
    //   param.putIfAbsent(
    //       'forwardRoute', () => state.fullPath!.replaceAll('/', ''));
    //   return parseRoute(
    //       route: '/${AppRoute.home.path}', queryParameters: param);
    // }
    // return '/';
    // }

    return null;
  },
  routes: [
    GoRoute(
      path: AppRoute.getStarted.path,
      builder: (context, state) => const GetStartedScreen(),
    ),

    GoRoute(
      path: AppRoute.signIn.path,
      builder: (context, state) => BlocProvider(
        create: (context) => getIt<AuthBloc>(),
        child: SignInScreen(),
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
      builder: (context, state) => BlocProvider(
        create: (context) => getIt<AuthBloc>(),
        child: const SignUpScreen(),
      ),
    ),
    GoRoute(
      path: AppRoute.emailVerify.path,
      builder: (context, state) => BlocProvider(
        create: (context) => getIt<AuthBloc>(),
        child: EmailVerifyScreen(),
      ),
    ),
    GoRoute(
      path: AppRoute.information.path,
      builder: (context, state) => const InformationScreen(),
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
          // navigatorKey: _shellNavigatorHome,
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
          // navigatorKey: _shellNavigatorNotifications,
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
          // navigatorKey: _shellNavigatorSettings,
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
