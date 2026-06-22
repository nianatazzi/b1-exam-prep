import 'package:linguobyte/core/errors/app_error.dart';
import 'package:linguobyte/core/logger/app_logger.dart';
import 'package:linguobyte/features/auth/presentation/auth_notifier.dart';
import 'package:linguobyte/features/home/data/repositories/user_progress_repository.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_result.dart';
import 'package:linguobyte/features/lesson/domain/models/lesson_step.dart';
import 'package:linguobyte/features/lesson/domain/usecases/build_lesson_use_case.dart';
import 'package:linguobyte/features/profile/data/achievement_repository.dart';
import 'package:linguobyte/features/profile/data/exercise_result_repository.dart';
import 'package:linguobyte/features/profile/data/streak_repository.dart';
import 'package:linguobyte/features/profile/domain/achievement_model.dart';
import 'package:linguobyte/features/profile/domain/step_result_model.dart';
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

  /// Формирует stepKey для текущего шага.
  String? _buildStepKey(LessonStep step, int lessonLId) {
    return switch (step) {
      TheoryLessonStep(:final theory) =>
        '${lessonLId}_theory_${theory.thId}',
      LexicalLessonStep() =>
        '${lessonLId}_vocab_0',
      VerbsLessonStep() => null,
      FinalLessonStep() =>
        '${lessonLId}_final_0',
    };
  }

  /// stepKey для verb-субшага (вызывается отдельно из VerbsStepWidget).
  String buildVerbStepKey(int lessonLId, int vId) =>
      '${lessonLId}_verb_$vId';

  /// Пользователь завершил текущий шаг: сохраняет результаты, инкрементирует прогресс.
  Future<void> completeCurrentStep({
    String? overrideStepKey,
    String? overrideSegmentType,
  }) async {
    final current = state.requireValue;
    final newProgress = current.progressIndex + 1;
    final lessonLId = current.data.lesson.lId;

    try {
      // Определяем ключ и тип сегмента
      final currentStep = current.currentStep;
      final stepKey = overrideStepKey ??
          (currentStep != null ? _buildStepKey(currentStep, lessonLId) : null);
      final segmentType = overrideSegmentType ??
          _segmentTypeFromStep(currentStep);

      // Сохраняем результаты упражнений (если есть)
      if (stepKey != null && _currentStepResults.isNotEmpty) {
        final correctCount =
            _currentStepResults.where((r) => r.isCorrect).length;
        final allCorrectFirstAttempt =
            _currentStepResults.every((r) => r.isCorrect);
        final incorrectIds = _currentStepResults
            .where((r) => !r.isCorrect)
            .map((r) => r.exerciseId)
            .toList();

        final stepResult = StepResultModel(
          correct: correctCount,
          total: _currentStepResults.length,
          firstAttempt: allCorrectFirstAttempt,
          incorrectExerciseIds: incorrectIds,
        );

        await ref.read(exerciseResultRepositoryProvider).saveStepResult(
          userId: _userId,
          langId: langId,
          stepKey: stepKey,
          result: stepResult,
          exerciseResults: _currentStepResults,
        );
      }

      // Обновляем стрик
      int currentStreak = 0;
      try {
        currentStreak = await ref
            .read(streakRepositoryProvider)
            .updateStreak(_userId);
      } catch (e) {
        AppLogger.e('Streak update failed', error: e);
      }

      // Проверяем достижения
      if (segmentType != null) {
        try {
          final progressData = await ref
              .read(userProgressRepositoryProvider)
              .getUserLanguageProgress(_userId, langId);

          final isLessonComplete =
              newProgress >= current.data.steps.length;

          final updates = CheckAchievementUseCase().check(
            segmentType: segmentType,
            lessonLId: lessonLId,
            exerciseResults: _currentStepResults,
            allStepResults: progressData?.stepResults ?? {},
            currentAchievements: _toAchievementMap(
                progressData?.achievements ?? {}),
            lessonSteps: current.data.steps,
            isLessonComplete: isLessonComplete,
            currentStreak: currentStreak,
          );

          for (final update in updates) {
            await ref.read(achievementRepositoryProvider).updateAchievement(
              userId: _userId,
              langId: langId,
              type: update.type,
              newLevel: update.newLevel,
            );
          }

          _lastAchievementUpdates =
              updates.isNotEmpty ? updates : null;
        } catch (e) {
          AppLogger.e('Achievement check failed', error: e);
        }
      }

      // Обновляем прогресс урока
      if (newProgress >= current.data.steps.length) {
        final next = current.data.nextLesson;
        if (next != null) {
          await ref.read(userProgressRepositoryProvider).updateProgress(
            _userId, langId, next.id, 0,
          );
        } else {
          await ref.read(userProgressRepositoryProvider).updateProgress(
            _userId, langId, current.data.lesson.id, newProgress,
          );
        }
      } else {
        await ref.read(userProgressRepositoryProvider).updateProgress(
          _userId, langId, current.data.lesson.id, newProgress,
        );
      }

      _currentStepResults.clear();

      final stepCount = current.data.steps.length;
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
      AppLogger.e('completeCurrentStep unexpected error', error: e, stackTrace: st);
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

  String? _segmentTypeFromStep(LessonStep? step) => switch (step) {
        TheoryLessonStep() => 'theory',
        LexicalLessonStep() => 'vocab',
        VerbsLessonStep() => 'verb',
        FinalLessonStep() => 'final',
        null => null,
      };

  Map<String, AchievementModel> _toAchievementMap(
    Map<String, AchievementModel> raw,
  ) => raw;
}
