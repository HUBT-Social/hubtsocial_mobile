part of 'router.import.dart';

// final _shellNavigatorHome = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
// final _shellNavigatorChat = GlobalKey<NavigatorState>(debugLabel: 'shellChat');
// final _shellNavigatorTimetable =
//     GlobalKey<NavigatorState>(debugLabel: 'shellTimetable');
// final _shellNavigatorNotifications =
//     GlobalKey<NavigatorState>(debugLabel: 'shellNotifications');
// final _shellNavigatorMenu = GlobalKey<NavigatorState>(debugLabel: 'shellMenu');

ShellRoute _authRoute() {
  return ShellRoute(
    builder: (context, state, child) {
      return BlocProvider(
        create: (context) => getIt<AuthBloc>(),
        child: AuthScreen(child: child),
      );
    },
    routes: [
      GoRoute(
        path: AppRoute.getStarted.path,
        builder: (context, state) => GetStartedScreen(),
      ),
      GoRoute(
        path: AppRoute.signIn.path,
        builder: (context, state) => SignInScreen(),
      ),
      GoRoute(
        path: AppRoute.twoFactor.path,
        builder: (context, state) => TwoFactorPage(),
      ),
      GoRoute(
        path: AppRoute.forgotPassword.path,
        builder: (context, state) => ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoute.signUp.path,
        builder: (context, state) => SignUpScreen(),
      ),
      GoRoute(
        path: AppRoute.emailVerify.path,
        builder: (context, state) => EmailVerifyScreen(),
      ),
      GoRoute(
        path: AppRoute.passwordVerify.path,
        builder: (context, state) => PasswordVerifiCationScreen(
            maskMail: state.uri.queryParameters['maskMail'].toString()),
      ),
      GoRoute(
        path: AppRoute.setNewPassword.path,
        builder: (context, state) => SetNewPasswordScreen(),
      ),
      GoRoute(
        path: AppRoute.passwordSuccessful.path,
        builder: (context, state) => PasswordSuccessfulScreen(),
      ),
      GoRoute(
        path: AppRoute.signUpInformation.path,
        builder: (context, state) => SignUpInformationScreen(),
      ),
    ],
  );
}
