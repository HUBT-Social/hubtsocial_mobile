import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hubtsocial_mobile/src/core/navigation/route.dart';
import 'package:hubtsocial_mobile/src/features/home/ui/page/home_page.dart';

import '../../features/auth/bloc/auth_cubit.dart';
import '../../features/auth/repository/auth_repository.dart';
import '../../features/auth/ui/page/auth_page.dart';
import '../../features/auth/ui/page/splash_page.dart';
import '../../features/user/repository/user_repository.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: AppRoute.splash.path,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoute.home.path,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoute.settings.path,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoute.auth.path,
      builder: (context, state) {
        return BlocProvider(
          create: (context) => AuthCubit(
            userRepository: context.read<UserRepository>(),
            authRepository: context.read<AuthRepository>(),
          ),
          child: const AuthPage(),
        );
      },
    ),
  ],
);
