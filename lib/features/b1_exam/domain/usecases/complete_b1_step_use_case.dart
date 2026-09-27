import 'package:b1_exam_prep/core/logger/app_logger.dart';
import 'package:b1_exam_prep/features/b1_exam/data/repositories/exam_progress_repository.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/exercise_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/repositories/i_exam_progress_repository.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/exercise_result.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/usecases/check_b1_achievement_use_case.dart';
import 'package:b1_exam_prep/features/profile/data/user_repository.dart';
import 'package:b1_exam_prep/features/profile/domain/achievement_update.dart';
import 'package:b1_exam_prep/features/profile/domain/repositories/i_streak_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'complete_b1_step_use_case.g.dart';

@riverpod
CompleteB1StepUseCase completeB1StepUseCase(Ref ref) => CompleteB1StepUseCase(
      progressRepository: ref.read(examProgressRepositoryProvider),
      streakRepository: ref.read(userRepositoryProvider),
    );

/// Оркестрация завершения блока упражнений урока (verb/noun/phrase, Lesson
/// Matrix §0): сохранение результата (+ stats), обновление стрика (общий
/// для аккаунта), проверка достижений. Ключ прогресса —
/// "{lessonId}_{block}" вместо старого "{sectionType}_{topicTId}_{prepLevel}".
class CompleteB1StepUseCase {
  final IExamProgressRepository progressRepository;
  final IStreakRepository streakRepository;

  const CompleteB1StepUseCase({
    required this.progressRepository,
    required this.streakRepository,
  });

  Future<List<AchievementUpdate>> execute({
    required String userId,
    required String langId,
    required String lessonId,
    required ExerciseBlock block,
    required List<ExerciseResult> exerciseResults,
  }) async {
    final stepKey = '${lessonId}_${block.name}';
    final correct = exerciseResults.where((r) => r.isCorrect).length;

    await progressRepository.saveStepResult(
      userId: userId,
      langId: langId,
      stepKey: stepKey,
      correct: correct,
      total: exerciseResults.length,
      results: exerciseResults,
    );

    // Стрик — сбой не должен ронять завершение шага.
    int currentStreak = 0;
    try {
      currentStreak = await streakRepository.updateStreak(userId);
    } catch (e, st) {
      AppLogger.e('Streak update failed', error: e, stackTrace: st);
    }

    // Достижения — сбой не должен ронять завершение шага.
    var updates = <AchievementUpdate>[];
    try {
      final progress = await progressRepository.getProgress(userId, langId);

      updates = CheckB1AchievementUseCase().check(
        lessonId: lessonId,
        block: block,
        allTopicResults: progress.topicResults,
        currentAchievements: progress.achievements,
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
      AppLogger.e('B1 achievement check failed', error: e, stackTrace: st);
    }

    return updates;
  }
}
