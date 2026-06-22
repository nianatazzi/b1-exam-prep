import 'package:linguobyte/features/lesson/domain/models/exercise_result.dart';
import 'package:linguobyte/features/profile/domain/step_result_model.dart';

abstract class IExerciseResultRepository {
  /// Сохраняет агрегированный результат субпарта и инкрементирует stats.
  Future<void> saveStepResult({
    required String userId,
    required String langId,
    required String stepKey,
    required StepResultModel result,
    required List<ExerciseResult> exerciseResults,
  });
}
