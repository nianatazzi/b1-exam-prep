import 'package:b1_exam_prep/features/auth/presentation/auth_notifier.dart';
import 'package:b1_exam_prep/features/profile/data/user_repository.dart';
import 'package:b1_exam_prep/shared/models/study_language.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'study_language_provider.g.dart';

/// Текущий язык обучения (ARCHITECTURE.md §12.1) — читает
/// public_user_info/{userId}.preference.selectedLanguage напрямую, тот же
/// паттерн, что onboardingStatusProvider: не зависит от того, был ли уже
/// открыт ProfileScreen (простой independent fetch, не тянет тяжёлый
/// profileProvider с b1-прогрессом/достижениями только ради одного поля).
/// null — язык не выбран ИЛИ вне поддерживаемого набора StudyLanguage
/// (например "ru", который поддерживает linguobyte, но не b1-exam-prep) —
/// вызывающая сторона показывает пустое состояние "content coming soon",
/// не падает.
@riverpod
Future<StudyLanguage?> studyLanguage(Ref ref) async {
  final userId = ref.watch(authProvider).asData?.value?.id;
  if (userId == null) return null;

  final profile =
      await ref.read(userRepositoryProvider).getPublicProfile(userId);
  final code = profile.preference['selectedLanguage'] as String?;
  return StudyLanguage.fromCode(code);
}
