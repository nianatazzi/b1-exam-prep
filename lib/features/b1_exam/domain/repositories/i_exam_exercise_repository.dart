import 'package:linguobyte/features/lesson/domain/models/exercise_model.dart';

abstract class IExamExerciseRepository {
  /// Загружает все упражнения для темы (topic) одним запросом.
  /// Группировка по prep_level (segment_type) — на стороне клиента.
  Future<List<ExerciseModel>> getExercisesForTopic(int topicTId);
}
