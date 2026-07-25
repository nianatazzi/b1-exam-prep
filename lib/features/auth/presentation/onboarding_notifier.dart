import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:b1_exam_prep/core/constants/avatar_presets.dart';
import 'package:b1_exam_prep/core/errors/app_error.dart';
import 'package:b1_exam_prep/features/auth/presentation/onboarding_status_provider.dart';
import 'package:b1_exam_prep/features/profile/data/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_notifier.freezed.dart';
part 'onboarding_notifier.g.dart';

/// Изучаемый язык в b1-exam-prep всегда польский — пикера языков нет.
const String kB1SelectedLanguage = 'pl';

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
      // Прямой вызов репозитория — как в ProfileNotifier.updateProfile.
      // Без UseCase: чистый проброс данных, бизнес-логики нет (ARCHITECTURE §3).
      await ref.read(userRepositoryProvider).updatePublicProfile(userId, {
        'name': state.name.trim(),
        'surname': state.surname.trim(),
        'avatar': state.avatar,
        'onboardingComplete': true,
        'preference.selectedLanguage': kB1SelectedLanguage,
      });
      // Инвалидация заставит роутер перечитать onboardingComplete и уйти на B1Home.
      ref.invalidate(onboardingStatusProvider);
    } on AppError catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: UnknownError(e.toString()));
    }
  }
}
