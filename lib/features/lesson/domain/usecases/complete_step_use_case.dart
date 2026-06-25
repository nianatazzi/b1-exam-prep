import 'package:linguobyte/core/logger/app_logger.dart';
import 'package:linguobyte/features/home/data/repositories/user_progress_repository.dart';
import 'package:linguobyte/features/home/domain/repositories/i_user_progress_repository.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_result.dart';
import 'package:linguobyte/features/lesson/domain/models/lesson_step.dart';
import 'package:linguobyte/features/lesson/domain/usecases/build_lesson_use_case.dart';
import 'package:linguobyte/features/profile/data/user_repository.dart';
import 'package:linguobyte/features/profile/domain/repositories/i_streak_repository.dart';
import 'package:linguobyte/features/profile/domain/step_result_model.dart';
import 'package:linguobyte/features/profile/domain/usecases/check_achievement_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'complete_step_use_case.g.dart';

@riverpod
CompleteStepUseCase completeStepUseCase(Ref ref) => CompleteStepUseCase(
      progressRepository: ref.read(userProgressRepositoryProvider),
      streakRepository: ref.read(userRepositoryProvider),
    );

/// Результат завершения шага: новый индекс прогресса и разблокированные достижения.
class CompleteStepOutcome {
  final int newProgressIndex;
  final List<AchievementUpdate> achievementUpdates;

  const CompleteStepOutcome({
    required this.newProgressIndex,
    required this.achievementUpdates,
  });
}

/// Оркестрация завершения шага урока: сохранение результатов субпарта,
/// обновление стрика, проверка достижений и продвижение прогресса.
/// Вся эта бизнес-логика вынесена из LessonNotifier (presentation).
class CompleteStepUseCase {
  final IUserProgressRepository progressRepository;
  final IStreakRepository streakRepository;

  const CompleteStepUseCase({
    required this.progressRepository,
    required this.streakRepository,
  });

  /// Завершает текущий шаг урока. Возвращает новый индекс прогресса и
  /// список разблокированных достижений.
  Future<CompleteStepOutcome> execute({
    required String userId,
    required String langId,
    required LessonData data,
    required int progressIndex,
    required int viewIndex,
    required LessonStep? currentStep,
    required List<ExerciseResult> exerciseResults,
  }) async {
    final lessonLId = data.lesson.lId;

    // Переигровка пройденного шага (viewIndex < progressIndex): обновляем
    // результаты и достижения, но прогресс урока не двигаем — иначе он уйдёт
    // за пределы steps.length.
    final isReplay = viewIndex < progressIndex;
    final newProgress =
        isReplay ? progressIndex : (viewIndex + 1).clamp(0, data.steps.length);

    // Для VerbsLessonStep stepKey == null: результаты глаголов уже сохранены
    // пер-глагольно через saveSubStepResult, здесь только двигаем прогресс.
    final stepKey =
        currentStep != null ? _buildStepKey(currentStep, lessonLId) : null;
    final segmentType = _segmentTypeFromStep(currentStep);

    if (stepKey != null) {
      await saveSubStepResult(
        userId: userId,
        langId: langId,
        stepKey: stepKey,
        exerciseResults: exerciseResults,
      );
    }

    // Стрик — сбой не должен ронять завершение шага.
    int currentStreak = 0;
    try {
      currentStreak = await streakRepository.updateStreak(userId);
    } catch (e, st) {
      AppLogger.e('Streak update failed', error: e, stackTrace: st);
    }

    // Достижения — сбой не должен ронять завершение шага.
    var updates = <AchievementUpdate>[];
    if (segmentType != null) {
      try {
        final progressData =
            await progressRepository.getUserLanguageProgress(userId, langId);
        final isLessonComplete = newProgress >= data.steps.length;

        updates = CheckAchievementUseCase().check(
          segmentType: segmentType,
          lessonLId: lessonLId,
          exerciseResults: exerciseResults,
          allStepResults: progressData?.stepResults ?? {},
          currentAchievements: progressData?.achievements ?? {},
          lessonSteps: data.steps,
          isLessonComplete: isLessonComplete,
          currentStreak: currentStreak,
        );

        for (final update in updates) {
          await progressRepository.updateAchievement(
            userId: userId,
            langId: langId,
            type: update.type,
            newLevel: update.newLevel,
          );
        }
      } catch (e, st) {
        AppLogger.e('Achievement check failed', error: e, stackTrace: st);
      }
    }

    // Продвижение прогресса урока — только при обычном прохождении.
    // При переигровке прогресс уже учтён, перезаписывать не нужно.
    if (!isReplay) {
      if (newProgress >= data.steps.length) {
        final next = data.nextLesson;
        if (next != null) {
          await progressRepository.updateProgress(userId, langId, next.id, 0);
        } else {
          await progressRepository.updateProgress(
              userId, langId, data.lesson.id, newProgress);
        }
      } else {
        await progressRepository.updateProgress(
            userId, langId, data.lesson.id, newProgress);
      }
    }

    return CompleteStepOutcome(
      newProgressIndex: newProgress,
      achievementUpdates: updates,
    );
  }

  /// Сохраняет результаты одного субпарта (stepResult + stats) под [stepKey].
  /// Используется и внутри [execute], и для verb-субшагов из LessonNotifier.
  ///
  /// [persistEmpty] — записать stepResult даже при отсутствии упражнений
  /// (для verb-субшага без упражнений: блок считается пройденным с total=0,
  /// чтобы работал master_conjugator). Для обычных шагов false, чтобы не
  /// засорять stepResults пустыми записями.
  Future<void> saveSubStepResult({
    required String userId,
    required String langId,
    required String stepKey,
    required List<ExerciseResult> exerciseResults,
    bool persistEmpty = false,
  }) async {
    if (exerciseResults.isEmpty && !persistEmpty) return;

    final correct = exerciseResults.where((r) => r.isCorrect).length;
    final allCorrect = exerciseResults.every((r) => r.isCorrect);
    final incorrect = exerciseResults
        .where((r) => !r.isCorrect)
        .map((r) => r.exerciseId)
        .toList();

    await progressRepository.saveStepResult(
      userId: userId,
      langId: langId,
      stepKey: stepKey,
      result: StepResultModel(
        correct: correct,
        total: exerciseResults.length,
        firstAttempt: allCorrect,
        incorrectExerciseIds: incorrect,
      ),
      exerciseResults: exerciseResults,
    );
  }

  String? _buildStepKey(LessonStep step, int lessonLId) => switch (step) {
        TheoryLessonStep(:final theory) => '${lessonLId}_theory_${theory.thId}',
        LexicalLessonStep() => '${lessonLId}_vocab_0',
        VerbsLessonStep() => null,
        FinalLessonStep() => '${lessonLId}_final_0',
      };

  String? _segmentTypeFromStep(LessonStep? step) => switch (step) {
        TheoryLessonStep() => 'theory',
        LexicalLessonStep() => 'vocab',
        VerbsLessonStep() => 'verb',
        FinalLessonStep() => 'final',
        null => null,
      };
}
