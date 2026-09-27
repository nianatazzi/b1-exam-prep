import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:b1_exam_prep/core/constants/avatar_presets.dart';
import 'package:b1_exam_prep/core/errors/app_error.dart';
import 'package:b1_exam_prep/core/locale/study_language_provider.dart';
import 'package:b1_exam_prep/features/auth/presentation/onboarding_status_provider.dart';
import 'package:b1_exam_prep/features/profile/data/user_repository.dart';
import 'package:b1_exam_prep/shared/models/study_language.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_notifier.freezed.dart';
part 'onboarding_notifier.g.dart';

/// Язык обучения по умолчанию для аккаунтов, где preference.selectedLanguage
/// ещё вообще не установлен ни одним приложением (ARCHITECTURE.md §12.1).
const StudyLanguage kDefaultStudyLanguage = StudyLanguage.pl;

@freezed
abstract class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default('') String name,
    @Default('') String surname,
    @Default(AvatarPresets.defaultId) String avatar,
    @Default(false) bool isLoading,
    AppError? error,
  }) = _OnboardingState;
}

@riverpod
class OnboardingNotifier extends _$OnboardingNotifier {
  @override
  OnboardingState build() => const OnboardingState();

  void setName(String v) => state = state.copyWith(name: v, error: null);
  void setSurname(String v) => state = state.copyWith(surname: v, error: null);
  void setAvatar(String id) => state = state.copyWith(avatar: id);

  Future<void> submit(String userId) async {
    if (state.name.trim().isEmpty) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = ref.read(userRepositoryProvider);

      final profileData = <String, dynamic>{
        'name': state.name.trim(),
        'surname': state.surname.trim(),
        'avatar': state.avatar,
        'onboardingComplete': true,
      };

      // preference.selectedLanguage общий с linguobyte/cinephile
      // (ARCHITECTURE.md §12.1) — пишем дефолт ТОЛЬКО если поле у аккаунта
      // ещё вообще не установлено ни одним приложением. Если пользователь
      // пришёл из другого приложения с уже выбранным языком — уважаем его
      // выбор, не перезаписываем.
      final existing = await repo.getPublicProfile(userId);
      if (existing.preference['selectedLanguage'] == null) {
        profileData['preference.selectedLanguage'] = kDefaultStudyLanguage.name;
      }

      // Прямой вызов репозитория — как в ProfileNotifier.updateProfile.
      // Без UseCase: чистый проброс данных, бизнес-логики нет (ARCHITECTURE §3).
      await repo.updatePublicProfile(userId, profileData);
      // Инвалидация заставит роутер перечитать onboardingComplete и уйти на B1Home.
      ref.invalidate(onboardingStatusProvider);
      ref.invalidate(studyLanguageProvider);
    } on AppError catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: UnknownError(e.toString()));
    }
  }
}
