part of 'router.import.dart';

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
        state.fullPath!.contains(AppRoute.forgotPassword.path) ||
        state.fullPath!.contains(AppRoute.signUp.path) ||
        state.fullPath!.contains(AppRoute.passwordVerify.path) ||
        state.fullPath!.contains(AppRoute.setNewPassword.path) ||
        state.fullPath!.contains(AppRoute.passwordSuccessful.path) ||
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

      logDebug("token.refreshToken:" + token.refreshToken);
      logDebug("token.accessToken:" + token.accessToken);
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
      path: AppRoute.forgotPassword.path,
      builder: (context, state) => BlocProvider(
        create: (context) => getIt<AuthBloc>(),
        child: ForgotPasswordScreen(),
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
    GoRoute(
      path: AppRoute.passwordVerify.path,
      builder: (context, state) => BlocProvider(
        create: (context) => getIt<AuthBloc>(),
        child: PasswordVerifiCationScreen(),
      ),
    ),
    GoRoute(
      path: AppRoute.setNewPassword.path,
      builder: (context, state) => BlocProvider(
        create: (context) => getIt<AuthBloc>(),
        child: SetNewPasswordScreen(),
      ),
    ),
    GoRoute(
      path: AppRoute.passwordSuccessful.path,
      builder: (context, state) => BlocProvider(
        create: (context) => getIt<AuthBloc>(),
        child: PasswordSuccessfulScreen(),
      ),
    ),
    // MainWrapper
    _mainRoute(),
  ],
);
