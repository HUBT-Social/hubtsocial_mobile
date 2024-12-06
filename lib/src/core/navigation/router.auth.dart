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
      return AuthScreen(child: child);
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
      GoRoute(
        path: AppRoute.signUpInformation.path,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<AuthBloc>(),
          child: SignUpInformationScreen(),
        ),
      ),
    ],
  );
}
