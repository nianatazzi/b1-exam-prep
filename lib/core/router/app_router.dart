import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:linguobyte/core/constants/app_routes.dart';
import 'package:linguobyte/features/auth/presentation/auth_notifier.dart';
import 'package:linguobyte/features/auth/presentation/authorization_screen.dart';
import 'package:linguobyte/features/home/presentation/screens/home_screen.dart';
import 'package:linguobyte/features/home/presentation/splash_screen.dart';
import 'package:linguobyte/features/lesson/presentation/screens/lesson_screen.dart';
import 'package:linguobyte/features/profile/presentation/profile_screen.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_result.dart';
import 'package:linguobyte/features/profile/presentation/result_screen.dart';
import 'package:linguobyte/features/profile/presentation/settings_screen.dart';
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

      if (authState.isLoading) return null;

      final isLoggedIn = authState.asData?.value != null;
      final isNewUser = ref.read(authProvider.notifier).isNewUser;

      if (location == AppRoutes.splash) {
        if (!isLoggedIn) return AppRoutes.auth;
        return isNewUser ? AppRoutes.profile : AppRoutes.home;
      }

      if (!isLoggedIn && location != AppRoutes.auth) return AppRoutes.auth;

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
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.result,
        builder: (context, state) => ResultScreen(
          results: state.extra! as List<ExerciseResult>,
        ),
      ),
      GoRoute(
        path: AppRoutes.lesson,
        builder: (context, state) => LessonScreen(
          langId: state.pathParameters['langId']!,
          lessonId: state.pathParameters['lessonId']!,
        ),
      ),
    ],
  );
}
