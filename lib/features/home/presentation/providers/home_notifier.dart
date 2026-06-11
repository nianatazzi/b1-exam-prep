import 'package:firebase_auth/firebase_auth.dart';
import 'package:linguobyte/core/errors/app_error.dart';
import 'package:linguobyte/features/home/data/repositories/language_repository.dart';
import 'package:linguobyte/features/home/domain/models/language_model.dart';
import 'package:linguobyte/features/home/domain/usecases/get_home_data_use_case.dart';
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
  String get _userId => FirebaseAuth.instance.currentUser!.uid;

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

    final selectedLangId = languages.first.id;

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
    } on AppError catch (e, st) {
      state = AsyncError(e, st);
    } catch (e, st) {
      state = AsyncError(UnknownError(e.toString()), st);
    }
  }
}
