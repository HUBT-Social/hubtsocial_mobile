part of 'router.import.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

String joinRoute(List<String> routes) {
  var route = routes.join('');
  return route;
}

final GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  errorBuilder: (context, state) {
    logger.e(state.uri.path);
    return NotFoundScreen(url: state.uri.path);
  },
  debugLogDiagnostics: true,
  initialLocation: AppRoute.home.path,
  redirect: (context, state) {
    if (state.fullPath!.contains(AppRoute.auth.path)) {
      return null;
    }
    // LocalUser? user = context.read<UserProvider>().user;
    var tokenBox = Hive.box(LocalStorageKey.token);
    if (tokenBox.isEmpty || !tokenBox.containsKey(LocalStorageKey.userToken)) {
      return joinRoute(['', AppRoute.getStarted.path]);
    } else if (tokenBox.isNotEmpty &&
        tokenBox.containsKey(LocalStorageKey.userToken)) {
      UserToken token = tokenBox.get(LocalStorageKey.userToken);
      var payload = jwtDecode(token.refreshToken).payload;

      // Check if token is expired
      var currentTimestamp = DateTime.now().millisecondsSinceEpoch;
      if (currentTimestamp ~/ 1000 < payload['exp']) {
        return null;
      }
      // Move to sign in screen if no token found
      return joinRoute(['', AppRoute.getStarted.path]);
    }

    return null;
  },
  routes: [
    // MainWrapper
    _mainRoute(),
    // auth
    _authRoute(),

    GoRoute(
        path: AppRoute.roomChat.path,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) =>
                FadeTransition(opacity: animation, child: child),
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => getIt<GetRoomChatBloc>(),
                ),
                BlocProvider(
                  create: (_) => getIt<ReceiveChatCubit>(),
                ),
              ],
              child: RoomChatScreen(
                id: state.uri.queryParameters['id'].toString(),
                title: state.uri.queryParameters['title'].toString(),
                avatarUrl: state.uri.queryParameters['avatarUrl'].toString(),
              ),
            ),
          );
        },
        routes: [
          GoRoute(
              path: 'info',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  key: state.pageKey,
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) =>
                      FadeTransition(opacity: animation, child: child),
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (_) => getIt<GetRoomChatBloc>(),
                      ),
                      BlocProvider(
                        create: (_) => getIt<ReceiveChatCubit>(),
                      ),
                    ],
                    child: RoomChatInfoScreen(
                      id: state.uri.queryParameters['id'].toString(),
                      title: state.uri.queryParameters['title'].toString(),
                      avatarUrl:
                          state.uri.queryParameters['avatarUrl'].toString(),
                    ),
                  ),
                );
              },
              routes: []),
        ]),
  ],
);
