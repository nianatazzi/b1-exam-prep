import 'package:linguobyte/features/b1_exam/domain/models/topic_progress_model.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_result.dart';

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
}
