import 'package:flutter/material.dart';
import 'package:linguobyte/core/errors/app_error.dart';
import 'package:linguobyte/core/locale/locale_provider.dart';
import 'package:linguobyte/core/logger/app_logger.dart';
import 'package:linguobyte/features/auth/presentation/auth_notifier.dart';
import 'package:linguobyte/features/profile/data/user_repository.dart';
import 'package:linguobyte/features/profile/presentation/profile_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_notifier.g.dart';

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  void build() {}

  /// Меняет тему (dark/light) и сохраняет в Firestore.
  Future<void> setTheme(String theme) async {
    final user = ref.read(authProvider).asData?.value;
    if (user == null) return;

    try {
      await ref
          .read(userRepositoryProvider)
          .updatePublicProfile(user.id, {'preference.theme': theme});
      if (!ref.mounted) return;
      ref.invalidate(profileProvider);
    } on AppError catch (e, st) {
      AppLogger.e('setTheme failed', error: e, stackTrace: st);
    } catch (e, st) {
      AppLogger.e('setTheme unexpected error', error: e, stackTrace: st);
    }
  }

  /// Меняет скорость воспроизведения аудио и сохраняет в Firestore.
  Future<void> setSpeechSpeed(double speed) async {
    final user = ref.read(authProvider).asData?.value;
    if (user == null) return;

    try {
      await ref
          .read(userRepositoryProvider)
          .updatePublicProfile(user.id, {'preference.speechSpeed': speed});
      if (!ref.mounted) return;
      ref.invalidate(profileProvider);
    } on AppError catch (e, st) {
      AppLogger.e('setSpeechSpeed failed', error: e, stackTrace: st);
    } catch (e, st) {
      AppLogger.e('setSpeechSpeed unexpected error', error: e, stackTrace: st);
    }
  }

  /// Меняет язык интерфейса.
  Future<void> setUiLanguage(String langCode) async {
    final user = ref.read(authProvider).asData?.value;
    if (user == null) return;

    // setLocale перестраивает дерево виджетов — settingsProvider может быть
    // диспозен до завершения await. ref.mounted проверяем перед invalidate.
    ref.read(appLocaleProvider.notifier).setLocale(Locale(langCode));

    try {
      await ref
          .read(userRepositoryProvider)
          .updatePublicProfile(user.id, {'preference.uiLanguage': langCode});
      if (!ref.mounted) return;
      ref.invalidate(profileProvider);
    } on AppError catch (e, st) {
      AppLogger.e('setUiLanguage failed', error: e, stackTrace: st);
    } catch (e, st) {
      AppLogger.e('setUiLanguage unexpected error', error: e, stackTrace: st);
    }
  }
}
