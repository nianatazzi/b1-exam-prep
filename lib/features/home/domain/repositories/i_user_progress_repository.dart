import 'package:linguobyte/features/home/domain/models/user_language_progress_model.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_result.dart';
import 'package:linguobyte/features/profile/domain/achievement_model.dart';
import 'package:linguobyte/features/profile/domain/step_result_model.dart';

/// Единый контракт прогресса по языку (документ languages/{langId}):
/// прогресс урока, результаты субпартов (stepResults + stats) и достижения.
abstract class IUserProgressRepository {
  Future<UserLanguageProgressModel?> getUserLanguageProgress(
    String userId,
    String langId,
  );

  Future<void> updateProgress(
    String userId,
    String langId,
    String lastLesson,
    int lastParagraph,
  );

  /// Сохраняет агрегированный результат субпарта и инкрементирует stats.
  Future<void> saveStepResult({
    required String userId,
    required String langId,
    required String stepKey,
    required StepResultModel result,
    required List<ExerciseResult> exerciseResults,
  });

  /// Обновляет уровень достижения (пишет type внутрь документа).
  Future<void> updateAchievement({
    required String userId,
    required String langId,
    required AchievementType type,
    required int newLevel,
  });
}
