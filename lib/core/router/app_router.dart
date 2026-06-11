import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:linguobyte/core/constants/app_routes.dart';
import 'package:linguobyte/features/auth/presentation/auth_notifier.dart';
import 'package:linguobyte/features/auth/presentation/authorization_screen.dart';
import 'package:linguobyte/features/home/presentation/screens/home_screen.dart';
import 'package:linguobyte/features/home/presentation/splash_screen.dart';
import 'package:linguobyte/features/lesson/presentation/additional_screen.dart';
import 'package:linguobyte/features/lesson/presentation/lesson_screen.dart';
import 'package:linguobyte/features/lesson/presentation/practice_screen.dart';
import 'package:linguobyte/features/lesson/presentation/theory_screen.dart';
import 'package:linguobyte/features/profile/presentation/profile_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(Ref ref) {
    ref.listen(authProvider, (prev, next) => notifyListeners());
  }
}

/// keepAlive — GoRouter не должен пересоздаваться в течение жизни приложения.
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final notifier = _RouterNotifier(ref);

  return GoRouter(
    refreshListenable: notifier,
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final location = state.matchedLocation;

      // Пока идёт инициализация — остаёмся на сплеше
      if (authState.isLoading) return null;

      final isLoggedIn = authState.asData?.value != null;
      final isNewUser = ref.read(authProvider.notifier).isNewUser;

      // Уходим со сплеша как только auth определён
      if (location == AppRoutes.splash) {
        if (!isLoggedIn) return AppRoutes.auth;
        return isNewUser ? AppRoutes.profile : AppRoutes.home;
      }

      // Гард: не авторизован — только на /auth
      if (!isLoggedIn && location != AppRoutes.auth) return AppRoutes.auth;

      // После входа/регистрации уходим с /auth
      if (isLoggedIn && location == AppRoutes.auth) {
        return isNewUser ? AppRoutes.profile : AppRoutes.home;
      }

      return null;
    },
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
}
