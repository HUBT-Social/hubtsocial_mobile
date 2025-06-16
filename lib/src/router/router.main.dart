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
            routes: [
              GoRoute(
                  path: 'quiz',
                  pageBuilder: (context, state) => CustomTransitionPage(
                        key: state.pageKey,
                        child: MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (_) => getIt<QuizBloc>(),
                            ),
                          ],
                          child: const QuizScreen(),
                        ),
                        transitionsBuilder: (context, animation,
                                secondaryAnimation, child) =>
                            FadeTransition(opacity: animation, child: child),
                      ),
                  routes: [
                    GoRoute(
                      path: 'info',
                      pageBuilder: (context, state) => CustomTransitionPage(
                        key: state.pageKey,
                        child: MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (_) => getIt<QuizInfoBloc>(),
                            ),
                          ],
                          child: QuizInfoScreen(
                            id: state.uri.queryParameters['id'].toString(),
                          ),
                        ),
                        transitionsBuilder: (context, animation,
                                secondaryAnimation, child) =>
                            FadeTransition(opacity: animation, child: child),
                      ),
                      routes: [
                        GoRoute(
                          path: 'question',
                          pageBuilder: (context, state) {
                            final questions =
                                state.extra as List<QuestionModel>;
                            return CustomTransitionPage(
                              key: state.pageKey,
                              child: MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                    create: (context) =>
                                        getIt<QuizQuestionBloc>()
                                          ..add(LoadQuizQuestions(questions)),
                                    // create: (_) => getIt<QuizQuestionBloc>(),
                                  ),
                                ],
                                child: const QuizQuestionScreen(),
                              ),
                              transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) =>
                                  FadeTransition(
                                      opacity: animation, child: child),
                            );
                          },
                        ),
                        GoRoute(
                          path: 'result',
                          pageBuilder: (context, state) {
                            final extra = state.extra as Map;
                            return CustomTransitionPage(
                              key: state.pageKey,
                              child: QuizResultScreen(
                                score: extra["score"],
                                total: extra["total"],
                                time: extra["time"],
                              ),
                              transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) =>
                                  FadeTransition(
                                      opacity: animation, child: child),
                            );
                          },
                        ),
                      ],
                    ),
                  ]),
              GoRoute(
                path: 'module',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (_) => getIt<ModuleBloc>(),
                      ),
                    ],
                    child: const ModuleScreen(),
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeTransition(opacity: animation, child: child),
                ),
              ),
              GoRoute(
                path: AppRoute.academicResult.path,
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: BlocProvider(
                    create: (_) => getIt<AcademicResultBloc>(),
                    child: const AcademicResultScreen(),
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeTransition(opacity: animation, child: child),
                ),
              ),
              GoRoute(
                path: AppRoute.tuitionPayment.path,
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const TuitionPaymentScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeTransition(opacity: animation, child: child),
                ),
              ),
            ],
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
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: BlocProvider(
                    create: (context) => getIt<TimetableInfoBloc>(),
                    child: TimetableInfoScreen(
                      id: state.uri.queryParameters['id'].toString(),
                    ),
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeTransition(opacity: animation, child: child),
                ),
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
              child: const MenuScreen(),
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
                    path: 'user-profile-details',
                    pageBuilder: (context, state) {
                      final userName =
                          state.uri.queryParameters['userName'] as String;
                      return CustomTransitionPage(
                        key: state.pageKey,
                        child: OtherUserProfileScreen(userName: userName),
                        transitionsBuilder: (context, animation,
                                secondaryAnimation, child) =>
                            FadeTransition(opacity: animation, child: child),
                      );
                    },
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
              GoRoute(
                path: 'notification-settings',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const NotificationSettingsScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeTransition(opacity: animation, child: child),
                ),
              ),
            ],
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: AppRoute.teacherevalua.path,
            builder: (context, state) {
              final teacher = state.extra as Teacher;
              return TeacherEvaluationScreen(teacher: teacher);
            },
          ),
        ],
      ),

      /// Brach Teacher Evaluation
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: AppRoute.teacherCode.path,
            builder: (context, state) => TeacherCodeInputScreen(),
          ),
        ],
      ),
    ],
  );
}
