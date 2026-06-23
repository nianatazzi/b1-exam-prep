import 'package:linguobyte/core/errors/app_error.dart';
import 'package:linguobyte/core/logger/app_logger.dart';
import 'package:linguobyte/features/auth/presentation/auth_notifier.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_result.dart';
import 'package:linguobyte/features/lesson/domain/models/lesson_step.dart';
import 'package:linguobyte/features/lesson/domain/usecases/build_lesson_use_case.dart';
import 'package:linguobyte/features/lesson/domain/usecases/complete_step_use_case.dart';
import 'package:linguobyte/features/profile/domain/usecases/check_achievement_use_case.dart';
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
  String get _userId => ref.read(authProvider).requireValue!.id;

  /// Результаты упражнений текущего субпарта (in-memory).
  final List<ExerciseResult> _currentStepResults = [];

  /// Разблокированные достижения после последнего completeCurrentStep.
  List<AchievementUpdate>? _lastAchievementUpdates;

  List<ExerciseResult> get currentStepResults =>
      List.unmodifiable(_currentStepResults);

  List<AchievementUpdate>? get lastAchievementUpdates =>
      _lastAchievementUpdates;

  @override
  Future<LessonState> build(String langId, String lessonId) async {
    final data = await ref
        .read(buildLessonUseCaseProvider)
        .execute(_userId, langId, lessonId);

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

  /// Записывает результат одного упражнения в in-memory список.
  void recordExerciseResult(ExerciseResult result) {
    _currentStepResults.add(result);
  }

  /// Очищает результаты текущего субпарта (при переходе к новому).
  void clearCurrentStepResults() {
    _currentStepResults.clear();
    _lastAchievementUpdates = null;
  }

  /// stepKey для verb-субшага.
  String buildVerbStepKey(int lessonLId, int vId) =>
      '${lessonLId}_verb_$vId';

  /// Сохраняет результаты одного глагола под ключом `{lId}_verb_{vId}`.
  /// Вызывается из VerbsStepWidget после каждого глагола. Прогресс урока
  /// не двигает — весь шаг verbs остаётся одним элементом последовательности
  /// и завершается через [completeCurrentStep] на последнем глаголе.
  Future<void> recordVerbSubStep(int vId) async {
    final current = state.asData?.value;
    if (current == null) return;
    final lessonLId = current.data.lesson.lId;
    try {
      await ref.read(completeStepUseCaseProvider).saveSubStepResult(
            userId: _userId,
            langId: langId,
            stepKey: buildVerbStepKey(lessonLId, vId),
            exerciseResults: List.of(_currentStepResults),
            // глагол без упражнений всё равно отмечается пройденным
            persistEmpty: true,
          );
    } catch (e, st) {
      AppLogger.e('recordVerbSubStep failed', error: e, stackTrace: st);
    } finally {
      _currentStepResults.clear();
    }
  }

  /// Пользователь завершил текущий шаг: делегирует оркестрацию в UseCase,
  /// обновляет локальный прогресс/просмотр.
  Future<void> completeCurrentStep() async {
    final current = state.requireValue;
    try {
      final outcome = await ref.read(completeStepUseCaseProvider).execute(
            userId: _userId,
            langId: langId,
            data: current.data,
            progressIndex: current.progressIndex,
            currentStep: current.currentStep,
            exerciseResults: List.of(_currentStepResults),
          );

      _lastAchievementUpdates = outcome.achievementUpdates.isNotEmpty
          ? outcome.achievementUpdates
          : null;
      _currentStepResults.clear();

      final stepCount = current.data.steps.length;
      final newProgress = outcome.newProgressIndex;
      state = AsyncData(current.copyWith(
        progressIndex: newProgress,
        viewIndex: newProgress >= stepCount
            ? stepCount
            : newProgress.clamp(0, stepCount == 0 ? 0 : stepCount - 1),
      ));
    } on AppError catch (e, st) {
      AppLogger.e('completeCurrentStep failed', error: e, stackTrace: st);
      state = AsyncData(current);
    } catch (e, st) {
      AppLogger.e('completeCurrentStep unexpected error',
          error: e, stackTrace: st);
      state = AsyncData(current);
    }
  }

  /// Навигация через панель или кнопку "Назад" — только меняет viewIndex.
  void navigateToStep(int stepIndex) {
    final current = state.asData?.value;
    if (current == null) return;
    if (stepIndex < 0 || stepIndex > current.progressIndex) return;
    state = AsyncData(current.copyWith(viewIndex: stepIndex));
  }
}
