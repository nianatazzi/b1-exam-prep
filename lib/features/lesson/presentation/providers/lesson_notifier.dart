import 'package:firebase_auth/firebase_auth.dart';
import 'package:linguobyte/core/errors/app_error.dart';
import 'package:linguobyte/core/logger/app_logger.dart';
import 'package:linguobyte/features/home/data/repositories/user_progress_repository.dart';
import 'package:linguobyte/features/lesson/domain/models/lesson_step.dart';
import 'package:linguobyte/features/lesson/domain/usecases/build_lesson_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lesson_notifier.g.dart';

// ── UI-состояние ─────────────────────────────────────────────────────────────

class LessonState {
  final LessonData data;

  /// Количество завершённых шагов (персистентный, синхронизирован с Firestore).
  final int progressIndex;

  /// Индекс шага, который пользователь видит сейчас.
  /// Может быть <= progressIndex при навигации назад / через панель.
  final int viewIndex;

  const LessonState({
    required this.data,
    required this.progressIndex,
    required this.viewIndex,
  });

  LessonStep? get currentStep {
    if (viewIndex >= data.steps.length) return null;
    return data.steps[viewIndex];
  }

  bool get isCompleted => progressIndex >= data.steps.length;

  double get progressPercent => data.steps.isEmpty
      ? 0.0
      : (progressIndex / data.steps.length).clamp(0.0, 1.0);

  LessonState copyWith({
    int? progressIndex,
    int? viewIndex,
  }) {
    return LessonState(
      data: data,
      progressIndex: progressIndex ?? this.progressIndex,
      viewIndex: viewIndex ?? this.viewIndex,
    );
  }
}

// ── Нотификатор ──────────────────────────────────────────────────────────────

@riverpod
class LessonNotifier extends _$LessonNotifier {
  String get _userId => FirebaseAuth.instance.currentUser!.uid;

  @override
  Future<LessonState> build(String langId, String lessonId) async {
    final data = await ref
        .read(buildLessonUseCaseProvider)
        .execute(_userId, langId, lessonId);

    // progressIndex не должен превышать число шагов (устаревший прогресс,
    // сокращённый контент). viewIndex == stepCount означает экран завершения урока.
    final stepCount = data.steps.length;
    final progressIndex = data.initialProgressIndex.clamp(0, stepCount);
    final viewIndex = progressIndex >= stepCount
        ? stepCount
        : progressIndex.clamp(0, stepCount == 0 ? 0 : stepCount - 1);

    return LessonState(
      data: data,
      progressIndex: progressIndex,
      viewIndex: viewIndex,
    );
  }

  /// Пользователь завершил текущий шаг: инкрементирует прогресс и пишет в Firestore.
  Future<void> completeCurrentStep() async {
    final current = state.requireValue;
    final newProgress = current.progressIndex + 1;

    try {
      if (newProgress >= current.data.steps.length) {
        // Урок завершён — переключаем на следующий урок (если есть)
        final next = current.data.nextLesson;
        if (next != null) {
          await ref.read(userProgressRepositoryProvider).updateProgress(
            _userId, langId, next.id, 0,
          );
        } else {
          // Последний урок — оставляем lastLesson, обновляем прогресс
          await ref.read(userProgressRepositoryProvider).updateProgress(
            _userId, langId, current.data.lesson.id, newProgress,
          );
        }
      } else {
        await ref.read(userProgressRepositoryProvider).updateProgress(
          _userId, langId, current.data.lesson.id, newProgress,
        );
      }

      final stepCount = current.data.steps.length;
      state = AsyncData(current.copyWith(
        progressIndex: newProgress,
        // viewIndex == stepCount → экран завершения урока
        viewIndex: newProgress >= stepCount
            ? stepCount
            : newProgress.clamp(0, stepCount == 0 ? 0 : stepCount - 1),
      ));
    } on AppError catch (e, st) {
      // Не переводим в AsyncError — экран урока остаётся, пользователь может повторить
      // [TD-5] TODO: показать SnackBar с ошибкой через UI-callback или ref.invalidate
      AppLogger.e('completeCurrentStep failed', error: e, stackTrace: st);
      state = AsyncData(current);
    } catch (e, st) {
      AppLogger.e('completeCurrentStep unexpected error', error: e, stackTrace: st);
      state = AsyncData(current);
    }
  }

  /// Навигация через панель или кнопку "Назад" — только меняет viewIndex.
  /// Переход возможен только к уже пройденным или текущему шагу.
  void navigateToStep(int stepIndex) {
    final current = state.asData?.value;
    if (current == null) return;
    if (stepIndex < 0 || stepIndex > current.progressIndex) return;
    state = AsyncData(current.copyWith(viewIndex: stepIndex));
  }
}
