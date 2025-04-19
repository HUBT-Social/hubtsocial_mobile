part of 'router.import.dart';

// final _shellNavigatorHome = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
// final _shellNavigatorChat = GlobalKey<NavigatorState>(debugLabel: 'shellChat');
// final _shellNavigatorTimetable =
//     GlobalKey<NavigatorState>(debugLabel: 'shellTimetable');
// final _shellNavigatorNotifications =
//     GlobalKey<NavigatorState>(debugLabel: 'shellNotifications');
// final _shellNavigatorMenu = GlobalKey<NavigatorState>(debugLabel: 'shellMenu');

StatefulShellRoute _mainRoute() {
  return StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => getIt<UserBloc>(),
          ),
        ],
        child: MainWrapper(
          navigationShell: navigationShell,
        ),
      );
    },
    branches: <StatefulShellBranch>[
      // Brach Home
      StatefulShellBranch(
        // navigatorKey: _shellNavigatorHome,
        routes: [
          GoRoute(
            path: AppRoute.home.path,
            builder: (context, state) => const HomeScreen(),
          ),
        ],
      ),
   
      // Brach Chat
      StatefulShellBranch(
        // navigatorKey: _shellNavigatorChat,
        routes: [
          GoRoute(
            path: AppRoute.chat.path,
            builder: (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => getIt<ChatBloc>(),
                ),
              ],
              child: const ChatScreen(),
            ),
          ),
        ],
      ),

      // Brach Timetable
      StatefulShellBranch(
        // navigatorKey: _shellNavigatorTimetable,
        routes: [
          GoRoute(
            path: AppRoute.timetable.path,
            builder: (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => getIt<TimetableBloc>(),
                ),
              ],
              child: const TimetableScreen(),
            ),
            routes: [
              GoRoute(
                path: 'info',
                builder: (context, state) => TimetableInfoScreen(),
              ),
            ],
          ),
        ],
      ),

      /// Brach Notifications
      StatefulShellBranch(
        // navigatorKey: _shellNavigatorNotifications,
        routes: [
          GoRoute(
            path: AppRoute.notifications.path,
            builder: (context, state) => const NotificationsScreen(),
          ),
        ],
      ),

      /// Brach Menu
      StatefulShellBranch(
        // navigatorKey: _shellNavigatorMenu,
        routes: [
          GoRoute(
            path: AppRoute.menu.path,
            builder: (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => getIt<AuthBloc>(),
                ),
              ],
              child: MenuScreen(),
            ),
            routes: [
              GoRoute(
                path: 'profile',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const ProfileScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeTransition(opacity: animation, child: child),
                ),
                
                routes: [
                  GoRoute(
                    path: 'edit',
                    pageBuilder: (context, state) => CustomTransitionPage(
                      key: state.pageKey,
                      child: const EditProfileScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              FadeTransition(opacity: animation, child: child),
                    ),
                  ),
                  GoRoute(
                    path: 'fullScreen',
                    pageBuilder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>?;
                      final imageUrl = extra?['imageUrl'] as String?;
                      final heroTag = extra?['heroTag'] as String?;

                      return CustomTransitionPage(
                        key: state.pageKey,
                        child: FullScreenImage(
                          imageProvider: NetworkImage(imageUrl ?? ''),
                          heroTag: heroTag ?? 'profile-image',
                        ),
                        transitionsBuilder: (context, animation,
                                secondaryAnimation, child) =>
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

      /// Brach Teacher Evaluation
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: AppRoute.teacherevalua.path,
            builder: (context, state) => TeacherEvaluationScreen(),
          ),
        ],
      ),
        /// Brach Teacher Evaluation
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: AppRoute.teacherCode.path,
            builder: (context, state) =>TeacherCodeInputScreen(),
          ),
        ],
      ),
    ],
  );
}
