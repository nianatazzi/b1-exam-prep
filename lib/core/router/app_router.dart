import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:b1_exam_prep/core/constants/app_routes.dart';
import 'package:b1_exam_prep/features/auth/presentation/auth_notifier.dart';
import 'package:b1_exam_prep/features/auth/presentation/authorization_screen.dart';
import 'package:b1_exam_prep/features/auth/presentation/onboarding_screen.dart';
import 'package:b1_exam_prep/features/auth/presentation/onboarding_status_provider.dart';
import 'package:b1_exam_prep/core/router/splash_screen.dart';
import 'package:b1_exam_prep/features/profile/presentation/profile_screen.dart';
import 'package:b1_exam_prep/features/b1_exam/presentation/screens/b1_home_screen.dart';
import 'package:b1_exam_prep/features/b1_exam/presentation/screens/practice_screen.dart';
import 'package:b1_exam_prep/features/b1_exam/presentation/screens/topic_detail_screen.dart';
import 'package:b1_exam_prep/features/profile/presentation/settings_screen.dart';
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
        return onboardingComplete ? AppRoutes.b1Home : AppRoutes.onboarding;
      }

      if (!isLoggedIn && location != AppRoutes.auth) return AppRoutes.auth;

      if (isLoggedIn && location == AppRoutes.auth) {
        return onboardingComplete ? AppRoutes.b1Home : AppRoutes.onboarding;
      }

      // После завершения онбординга — уходим с экрана онбординга на B1Home.
      if (isLoggedIn && onboardingComplete && location == AppRoutes.onboarding) {
        return AppRoutes.b1Home;
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
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.b1Home,
        builder: (context, state) => const B1HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.b1Topic,
        builder: (context, state) => TopicDetailScreen(
          sectionId: state.pathParameters['sectionId']!,
          topicId: state.pathParameters['topicId']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.b1Practice,
        builder: (context, state) => PracticeScreen(
          sectionId: state.pathParameters['sectionId']!,
          topicId: state.pathParameters['topicId']!,
          prepLevel: state.pathParameters['prepLevel']!,
        ),
      ),
    ],
  );
}
