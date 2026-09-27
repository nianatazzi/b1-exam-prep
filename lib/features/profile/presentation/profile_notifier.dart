import 'package:flutter/material.dart';
import 'package:b1_exam_prep/core/errors/app_error.dart';
import 'package:b1_exam_prep/core/locale/locale_provider.dart';
import 'package:b1_exam_prep/features/auth/presentation/auth_notifier.dart';
import 'package:b1_exam_prep/features/b1_exam/data/repositories/exam_progress_repository.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/topic_progress_model.dart';
import 'package:b1_exam_prep/features/profile/data/user_repository.dart';
import 'package:b1_exam_prep/features/profile/domain/achievement_model.dart';
import 'package:b1_exam_prep/features/profile/domain/exercise_stats_model.dart';
import 'package:b1_exam_prep/features/profile/domain/private_user_model.dart';
import 'package:b1_exam_prep/features/profile/domain/public_user_model.dart';
import 'package:b1_exam_prep/features/profile/domain/streak_model.dart';
import 'package:b1_exam_prep/shared/models/study_language.dart';
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

    // publicProfile грузится первым отдельно — прогресс нужно запросить по
    // b1_progress/{userId}/{langId} (ARCHITECTURE.md §12.1), а langId лежит
    // именно в publicProfile.preference.selectedLanguage.
    final publicProfile = await repo.getPublicProfile(user.id);
    final langId =
        StudyLanguage.fromCode(publicProfile.preference['selectedLanguage'] as String?)
            ?.name;

    // Дальше — параллельно. Прогресс изолирован от languages/{langId}
    // linguobyte (см. FIRESTORE.md §4), но выбранный язык обучения общий.
    final privateFuture = repo.getPrivateProfile(user.id);
    final progressFuture = langId == null
        ? Future.value(TopicProgressModel(id: user.id))
        : ref.read(examProgressRepositoryProvider).getProgress(user.id, langId);

    final results = await (privateFuture, progressFuture).wait;
    final privateProfile = results.$1;
    final progress = results.$2;

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
