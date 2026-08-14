import 'package:b1_exam_prep/features/b1_exam/domain/models/free_practice_analysis_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/topic_progress_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/exercise_result.dart';
import 'package:b1_exam_prep/features/profile/domain/achievement_model.dart';

abstract class IExamProgressRepository {
  Future<TopicProgressModel> getProgress(String userId);

  /// Сохраняет результат прохождения уровня подготовки.
  /// [stepKey] — "{sectionType}_{topicTId}_{prepLevel}"
  Future<void> saveStepResult({
    required String userId,
    required String stepKey,
    required int correct,
    required int total,
    required List<ExerciseResult> results,
  });

  Future<void> updateAchievement({
    required String userId,
    required AchievementType type,
    required int newLevel,
  });

  /// Сохраняет транскрипт свободной практики (image_description, Фаза 1).
  /// Перезаписывает предыдущую попытку по тому же [sectionType]/[topicTId] —
  /// хранится только последняя (см. FIRESTORE.md, b1_progress.freePractice).
  Future<void> saveFreePracticeResult({
    required String userId,
    required String sectionType,
    required int topicTId,
    required String transcript,
    required int durationSeconds,
    FreePracticeAnalysisModel? analysis,
  });
}
