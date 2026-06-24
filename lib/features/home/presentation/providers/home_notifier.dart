import 'package:flutter/material.dart';
import 'package:linguobyte/core/errors/app_error.dart';
import 'package:linguobyte/core/locale/locale_provider.dart';
import 'package:linguobyte/features/auth/presentation/auth_notifier.dart';
import 'package:linguobyte/features/home/data/repositories/language_repository.dart';
import 'package:linguobyte/features/home/domain/models/language_model.dart';
import 'package:linguobyte/features/home/domain/usecases/get_home_data_use_case.dart';
import 'package:linguobyte/features/profile/data/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_notifier.g.dart';

/// UI-состояние экрана домой.
/// Не сериализуется — используется только в presentation-слое.
class HomeState {
  final List<LanguageModel> languages;
  final String selectedLangId;
  final HomeScreenData screenData;

  const HomeState({
    required this.languages,
    required this.selectedLangId,
    required this.screenData,
  });
}

@riverpod
class HomeNotifier extends _$HomeNotifier {
  // Единый источник userId — через authProvider (как в Lesson/Profile),
  // а не FirebaseAuth напрямую. Пользователь гарантированно авторизован
  // (GoRouter обеспечивает редирект).
  String get _userId => ref.read(authProvider).requireValue!.id;

  @override
  Future<HomeState> build() async {
    // Пользователь гарантированно авторизован — GoRouter обеспечивает редирект
    // ref.read — репозиторий и UseCase не реактивны, ref.watch вызовет
    // бесконечную перестройку: awaited-вызов отменяется при каждой переоценке зависимостей
    final languages =
        await ref.read(languageRepositoryProvider).getLanguages();

    if (languages.isEmpty) {
      throw const NotFoundError();
    }

    // Читаем public_user_info одним запросом: берём selectedLanguage и
    // восстанавливаем uiLanguage, чтобы HomeScreen открывался с правильной локалью.
    final publicProfile =
        await ref.read(userRepositoryProvider).getPublicProfile(_userId);

    final saved = publicProfile.preference['selectedLanguage'] as String?;
    final selectedLangId =
        (saved != null && languages.any((l) => l.id == saved))
            ? saved
            : languages.first.id;

    final uiLang = publicProfile.preference['uiLanguage'] as String?;
    if (uiLang != null) {
      ref.read(appLocaleProvider.notifier).setLocale(Locale(uiLang));
    }

    final screenData = await ref
        .read(getHomeDataUseCaseProvider)
        .execute(_userId, selectedLangId);

    return HomeState(
      languages: languages,
      selectedLangId: selectedLangId,
      screenData: screenData,
    );
  }

  /// Переключает активный язык и перезагружает данные экрана.
  Future<void> selectLanguage(String langId) async {
    final current = state.asData?.value;
    if (current == null) return;

    state = const AsyncLoading();
    try {
      final screenData = await ref
          .read(getHomeDataUseCaseProvider)
          .execute(_userId, langId);

      state = AsyncData(
        HomeState(
          languages: current.languages,
          selectedLangId: langId,
          screenData: screenData,
        ),
      );

      await ref
          .read(userRepositoryProvider)
          .saveSelectedLanguage(_userId, langId);
    } on AppError catch (e, st) {
      state = AsyncError(e, st);
    } catch (e, st) {
      state = AsyncError(UnknownError(e.toString()), st);
    }
  }
}
