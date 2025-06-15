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
        builder: (context, state) => const GetStartedScreen(),
      ),
      GoRoute(
        path: AppRoute.signIn.path,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: AppRoute.twoFactor.path,
        builder: (context, state) => TwoFactorPage(
            maskEmail: state.uri.queryParameters['maskEmail'].toString()),
      ),
      GoRoute(
        path: AppRoute.forgotPassword.path,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoute.signUp.path,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoute.emailVerify.path,
        builder: (context, state) => EmailVerifyScreen(
            email: state.uri.queryParameters['email'].toString()),
      ),
      GoRoute(
        path: AppRoute.passwordVerify.path,
        builder: (context, state) => PasswordVerifiCationScreen(
            maskEmail: state.uri.queryParameters['maskEmail'].toString()),
      ),
      GoRoute(
        path: AppRoute.setNewPassword.path,
        builder: (context, state) => const SetNewPasswordScreen(),
      ),
      GoRoute(
        path: AppRoute.passwordSuccessful.path,
        builder: (context, state) => const PasswordSuccessfulScreen(),
      ),
      GoRoute(
        path: AppRoute.signUpInformation.path,
        builder: (context, state) => const SignUpInformationScreen(),
      ),
    ],
  );
}
