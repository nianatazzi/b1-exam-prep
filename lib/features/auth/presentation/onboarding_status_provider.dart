import 'package:linguobyte/features/auth/presentation/auth_notifier.dart';
import 'package:linguobyte/features/profile/data/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_status_provider.g.dart';

/// Флаг onboardingComplete текущего пользователя, кэшированный для роутера.
/// autoDispose — router ref держит подписку через ref.listen, не даёт GC убрать
/// раньше времени. После завершения онбординга провайдер утилизируется сам.
@riverpod
Future<bool> onboardingStatus(Ref ref) async {
  final userId = ref.watch(authProvider).asData?.value?.id;
  if (userId == null) return true;
  final profile = await ref.read(userRepositoryProvider).getPublicProfile(userId);
  // Пользователи, зарегистрированные до появления onboardingComplete, не имеют
  // этого поля в Firestore → fromJson возвращает false по умолчанию.
  // Признак «онбординг пройден» — заполненное имя.
  return profile.onboardingComplete || profile.name.isNotEmpty;
}
