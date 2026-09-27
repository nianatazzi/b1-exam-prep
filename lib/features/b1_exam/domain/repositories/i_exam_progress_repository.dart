import 'package:b1_exam_prep/features/b1_exam/domain/models/dialogue_message_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/lesson_step.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/speech_analysis_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/topic_progress_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/exercise_result.dart';
import 'package:b1_exam_prep/features/profile/domain/achievement_model.dart';

/// [langId] везде — StudyLanguage.name (ARCHITECTURE.md §12.1): прогресс
/// изолирован по языку обучения, b1_progress/{userId}/{langId}.
abstract class IExamProgressRepository {
  Future<TopicProgressModel> getProgress(String userId, String langId);

  /// Сохраняет результат прохождения блока упражнений.
  /// [stepKey] — "{lessonId}_{block}"
  Future<void> saveStepResult({
    required String userId,
    required String langId,
    required String stepKey,
    required int correct,
    required int total,
    required List<ExerciseResult> results,
  });

  Future<void> updateAchievement({
    required String userId,
    required String langId,
    required AchievementType type,
    required int newLevel,
  });

  /// Сохраняет результат устного шага урока (image/monologue/dialogue,
  /// Lesson Matrix). Перезаписывает предыдущую попытку по тому же
  /// [lessonId]/[oralStep] — хранится только последняя (см. FIRESTORE.md,
  /// b1_progress.lessonResults). [transcript] — для image/monologue,
  /// [turns] — для dialogue, заполняется ровно одно из двух.
  Future<void> saveLessonStepResult({
    required String userId,
    required String langId,
    required String lessonId,
    required OralStep oralStep,
    String? transcript,
    List<DialogueMessageModel> turns = const [],
    required int durationSeconds,
    int? score,
    SpeechAnalysisModel? analysis,
  });
}
