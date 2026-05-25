import 'package:go_router/go_router.dart';
import 'package:linguobyte/core/constants/app_routes.dart';
import 'package:linguobyte/features/auth/presentation/authorization_screen.dart';
import 'package:linguobyte/features/home/presentation/home_screen.dart';
import 'package:linguobyte/features/home/presentation/splash_screen.dart';
import 'package:linguobyte/features/lesson/presentation/additional_screen.dart';
import 'package:linguobyte/features/lesson/presentation/lesson_screen.dart';
import 'package:linguobyte/features/lesson/presentation/practice_screen.dart';
import 'package:linguobyte/features/lesson/presentation/theory_screen.dart';
import 'package:linguobyte/features/profile/presentation/profile_screen.dart';

// TODO: обернуть в @riverpod-провайдер и добавить refreshListenable
// когда будет готов AuthNotifier (см. ARCHITECTURE.md раздел 6)
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.auth,
      builder: (context, state) => const AuthorizationScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfileScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => LessonScreen(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.lesson,
          // При входе без sub-пути сразу переходим на theory
          redirect: (context, state) => '${state.matchedLocation}/theory',
          routes: [
            GoRoute(
              path: AppRoutes.theory,
              builder: (context, state) => const TheoryScreen(),
            ),
            GoRoute(
              path: AppRoutes.practice,
              builder: (context, state) => const PracticeScreen(),
            ),
            GoRoute(
              path: AppRoutes.additional,
              builder: (context, state) => const AdditionalScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
