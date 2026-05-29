import 'package:flutter/material.dart';
import 'package:linguobyte/core/errors/app_error.dart';
import 'package:linguobyte/core/locale/locale_provider.dart';
import 'package:linguobyte/features/auth/presentation/auth_notifier.dart';
import 'package:linguobyte/features/profile/data/user_repository.dart';
import 'package:linguobyte/features/profile/domain/private_user_model.dart';
import 'package:linguobyte/features/profile/domain/public_user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_notifier.g.dart';

/// Объединяет публичный и приватный профиль для экрана.
class ProfileData {
  final PublicUserModel publicProfile;
  final PrivateUserModel privateProfile;

  const ProfileData({
    required this.publicProfile,
    required this.privateProfile,
  });
}

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  Future<ProfileData> build() async {
    final authAsync = ref.watch(authProvider);

    // Если auth грузится (например во время signOut) — не бросаем AuthError
    // сразу, а возвращаем предыдущие данные чтобы избежать флеша ошибки.
    // GoRouter всё равно сделает redirect когда auth окончательно разрешится.
    if (authAsync.isLoading) {
      final previous = state.asData?.value;
      if (previous != null) return previous;
    }

    final user = authAsync.asData?.value;
    if (user == null) throw const AuthError();

    final repo = ref.read(userRepositoryProvider);

    // Загружаем оба документа параллельно
    final publicFuture = repo.getPublicProfile(user.id);
    final privateFuture = repo.getPrivateProfile(user.id);

    final profileData = ProfileData(
      publicProfile: await publicFuture,
      privateProfile: await privateFuture,
    );

    // Восстанавливаем сохранённый язык интерфейса из настроек профиля
    final uiLang =
        profileData.publicProfile.preference['uiLanguage'] as String?;
    if (uiLang != null) {
      ref.read(appLocaleProvider.notifier).setLocale(Locale(uiLang));
    }

    return profileData;
  }

  /// Обновляет поля публичного профиля и инвалидирует провайдер.
  /// ref.invalidateSelf() — правильный способ перезапустить build() через
  /// жизненный цикл Riverpod, вместо прямого вызова build().
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

  /// Меняет язык интерфейса и сохраняет выбор в preference профиля.
  /// Смена локали происходит немедленно — без ожидания ответа Firestore.
  Future<void> setUiLanguage(String langCode) async {
    final user = ref.read(authProvider).asData?.value;
    if (user == null) return;

    ref.read(appLocaleProvider.notifier).setLocale(Locale(langCode));

    try {
      // Точечное обновление вложенного поля map через dot-notation Firestore
      await ref
          .read(userRepositoryProvider)
          .updatePublicProfile(user.id, {'preference.uiLanguage': langCode});
    } on AppError {
      // MVP: ошибка сохранения не откатывает визуальное изменение
    }
  }
}
