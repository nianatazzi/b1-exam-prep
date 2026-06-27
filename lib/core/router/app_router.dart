import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:linguobyte/core/constants/app_routes.dart';
import 'package:linguobyte/features/auth/presentation/auth_notifier.dart';
import 'package:linguobyte/features/auth/presentation/authorization_screen.dart';
import 'package:linguobyte/features/auth/presentation/onboarding_screen.dart';
import 'package:linguobyte/features/auth/presentation/onboarding_status_provider.dart';
import 'package:linguobyte/features/home/presentation/screens/home_screen.dart';
import 'package:linguobyte/core/router/splash_screen.dart';
import 'package:linguobyte/features/lesson/presentation/screens/lesson_screen.dart';
import 'package:linguobyte/features/profile/presentation/profile_screen.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_result.dart';
import 'package:linguobyte/features/lesson/presentation/screens/result_screen.dart';
import 'package:linguobyte/features/profile/presentation/settings_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(Ref ref) {
    ref.listen(authProvider, (prev, next) => notifyListeners());
    ref.listen(onboardingStatusProvider, (prev, next) => notifyListeners());
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

      // Пока статус онбординга загружается из Firestore — не редиректим.
      final onboardingState = ref.read(onboardingStatusProvider);
      if (isLoggedIn && onboardingState.isLoading) return null;
      final onboardingComplete = onboardingState.asData?.value ?? true;

      if (location == AppRoutes.splash) {
        if (!isLoggedIn) return AppRoutes.auth;
        return onboardingComplete ? AppRoutes.home : AppRoutes.onboarding;
      }

      if (!isLoggedIn && location != AppRoutes.auth) return AppRoutes.auth;

      if (isLoggedIn && location == AppRoutes.auth) {
        return onboardingComplete ? AppRoutes.home : AppRoutes.onboarding;
      }

      // После завершения онбординга — уходим с экрана онбординга на home.
      if (isLoggedIn && onboardingComplete && location == AppRoutes.onboarding) {
        return AppRoutes.home;
      }

      // Защита: пользователь без онбординга не попадёт на другие экраны.
      if (isLoggedIn && !onboardingComplete && location != AppRoutes.onboarding) {
        return AppRoutes.onboarding;
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
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
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
