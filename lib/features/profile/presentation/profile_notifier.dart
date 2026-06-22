import 'package:flutter/material.dart';
import 'package:linguobyte/core/errors/app_error.dart';
import 'package:linguobyte/core/locale/locale_provider.dart';
import 'package:linguobyte/features/auth/presentation/auth_notifier.dart';
import 'package:linguobyte/features/home/data/repositories/user_progress_repository.dart';
import 'package:linguobyte/features/home/domain/models/user_language_progress_model.dart';
import 'package:linguobyte/features/profile/data/user_repository.dart';
import 'package:linguobyte/features/profile/domain/achievement_model.dart';
import 'package:linguobyte/features/profile/domain/exercise_stats_model.dart';
import 'package:linguobyte/features/profile/domain/private_user_model.dart';
import 'package:linguobyte/features/profile/domain/public_user_model.dart';
import 'package:linguobyte/features/profile/domain/streak_model.dart';
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

    // Определяем выбранный язык обучения для загрузки прогресса
    final selectedLang = await repo.getSelectedLanguage(user.id);

    // Загружаем все данные параллельно
    final publicFuture = repo.getPublicProfile(user.id);
    final privateFuture = repo.getPrivateProfile(user.id);
    final progressFuture = selectedLang != null
        ? ref.read(userProgressRepositoryProvider)
            .getUserLanguageProgress(user.id, selectedLang)
        : Future<UserLanguageProgressModel?>.value(null);

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
      stats: progress?.stats ?? const ExerciseStatsModel(),
      achievements: _buildAchievementList(progress?.achievements ?? {}),
    );
  }

  /// Обновляет поля публичного профиля.
  Future<void> updateProfile(Map<String, dynamic> data) async {
    final user = ref.read(authProvider).asData?.value;
    if (user == null) return;

    state = const AsyncLoading();
    try {
      await ref
          .read(userRepositoryProvider)
          .updatePublicProfile(user.id, data);
      ref.invalidateSelf();
    } on AppError catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Меняет язык интерфейса.
  Future<void> setUiLanguage(String langCode) async {
    final user = ref.read(authProvider).asData?.value;
    if (user == null) return;

    ref.read(appLocaleProvider.notifier).setLocale(Locale(langCode));

    try {
      await ref
          .read(userRepositoryProvider)
          .updatePublicProfile(user.id, {'preference.uiLanguage': langCode});
    } on AppError {
      // MVP: ошибка сохранения не откатывает визуальное изменение
    }
  }

  /// Конвертирует map достижений в отсортированный список.
  List<AchievementModel> _buildAchievementList(
    Map<String, AchievementModel> raw,
  ) {
    final all = <AchievementModel>[];
    for (final type in AchievementType.values) {
      final key = _achievementKey(type);
      final existing = raw[key];
      all.add(existing ?? AchievementModel(type: type, level: 0));
    }
    return all;
  }

  String _achievementKey(AchievementType type) => switch (type) {
        AchievementType.masterConjugator => 'master_conjugator',
        AchievementType.firstStep => 'first_step',
        AchievementType.focusedLearner => 'focused_learner',
        AchievementType.interestedLearner => 'interested_learner',
        AchievementType.vocabularyMaster => 'vocabulary_master',
      };
}
