import 'package:flutter/material.dart';
import 'package:b1_exam_prep/core/errors/app_error.dart';
import 'package:b1_exam_prep/core/locale/locale_provider.dart';
import 'package:b1_exam_prep/features/auth/presentation/auth_notifier.dart';
import 'package:b1_exam_prep/features/b1_exam/data/repositories/exam_progress_repository.dart';
import 'package:b1_exam_prep/features/profile/data/user_repository.dart';
import 'package:b1_exam_prep/features/profile/domain/achievement_model.dart';
import 'package:b1_exam_prep/features/profile/domain/exercise_stats_model.dart';
import 'package:b1_exam_prep/features/profile/domain/private_user_model.dart';
import 'package:b1_exam_prep/features/profile/domain/public_user_model.dart';
import 'package:b1_exam_prep/features/profile/domain/streak_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_notifier.g.dart';

/// Объединяет все данные для ProfileScreen.
class ProfileData {
  final PublicUserModel publicProfile;
  final PrivateUserModel privateProfile;
  final StreakModel streak;
  final ExerciseStatsModel stats;
  final List<AchievementModel> achievements;

  const ProfileData({
    required this.publicProfile,
    required this.privateProfile,
    required this.streak,
    required this.stats,
    required this.achievements,
  });
}

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  Future<ProfileData> build() async {
    final authAsync = ref.watch(authProvider);

    if (authAsync.isLoading) {
      final previous = state.asData?.value;
      if (previous != null) return previous;
    }

    final user = authAsync.asData?.value;
    if (user == null) throw const AuthError();

    final repo = ref.read(userRepositoryProvider);

    // Загружаем все данные параллельно. Прогресс — из b1_progress/{userId},
    // изолирован от languages/{langId} (см. FIRESTORE.md §4).
    final publicFuture = repo.getPublicProfile(user.id);
    final privateFuture = repo.getPrivateProfile(user.id);
    final progressFuture =
        ref.read(examProgressRepositoryProvider).getProgress(user.id);

    final results = await (publicFuture, privateFuture, progressFuture).wait;
    final publicProfile = results.$1;
    final privateProfile = results.$2;
    final progress = results.$3;

    // Восстанавливаем язык интерфейса
    final uiLang = publicProfile.preference['uiLanguage'] as String?;
    if (uiLang != null) {
      ref.read(appLocaleProvider.notifier).setLocale(Locale(uiLang));
    }

    return ProfileData(
      publicProfile: publicProfile,
      privateProfile: privateProfile,
      streak: StreakModel(
        currentStreak: privateProfile.currentStreak,
        bestStreak: privateProfile.bestStreak,
        lastActiveDate: privateProfile.lastActiveDate,
      ),
      stats: progress.stats,
      achievements: _buildAchievementList(progress.achievements),
    );
  }

  /// Обновляет поля публичного профиля. Возвращает true при успехе.
  /// При ошибке экран не роняется в AsyncError — текущие данные остаются,
  /// ошибку показывает вызывающий лист редактирования.
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    final user = ref.read(authProvider).asData?.value;
    if (user == null) return false;

    try {
      await ref
          .read(userRepositoryProvider)
          .updatePublicProfile(user.id, data);
      ref.invalidateSelf();
      return true;
    } on AppError {
      return false;
    }
  }

  /// Конвертирует map достижений в отсортированный список.
  List<AchievementModel> _buildAchievementList(
    Map<String, AchievementModel> raw,
  ) {
    final all = <AchievementModel>[];
    for (final type in AchievementType.values) {
      final existing = raw[type.key];
      all.add(existing ?? AchievementModel(type: type, level: 0));
    }
    return all;
  }
}
