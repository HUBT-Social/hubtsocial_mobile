import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/repository/auth_repository.dart';
import '../../features/user/bloc/user_cubit.dart';
import '../../features/user/provider/user_mock_provider.dart';
import '../../features/user/repository/user_repository.dart';
import '../services/firebase_notifications/NotificationService/NotificationService.dart';
import '../services/firebase_notifications/firebase/firebase_messaging_service.dart';
import '../services/firebase_notifications/local/awesome_notification_service.dart';

class DI extends StatelessWidget {
  const DI({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _ProviderDI(
      child: _RepositoryDI(
        child: _BlocDI(
          child: child,
        ),
      ),
    );
  }
}

class _ProviderDI extends StatelessWidget {
  const _ProviderDI({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserMockProvider>(
          create: (context) => UserMockProvider(),
        ),
      ],
      child: child,
    );
  }
}

class _RepositoryDI extends StatelessWidget {
  const _RepositoryDI({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>(
          create: (context) => UserRepository(
            userProvider: context.read<UserMockProvider>(),
          ),
        ),
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(
            userProvider: context.read<UserMockProvider>(),
          ),
        ),
      ],
      child: child,
    );
  }
}

class _BlocDI extends StatelessWidget {
  const _BlocDI({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserCubit>(
          create: (context) => UserCubit(
            userRepository: context.read<UserRepository>(),
          ),
        ),
      ],
      child: child,
    );
  }
}

void DinotificationServices() {
  //FirebaseMessagingService().initialize();
  // AwesomeNotificationService.initialize();
  NotificationService.initialize();
}
=======
>>>>>>> fb0d315c4d8f8d2bb2be58af52a5112a80e394ef
