import 'package:linguobyte/features/lesson/domain/models/exercise_model.dart';

abstract interface class IExerciseRepository {
  /// Загружает все упражнения урока одним запросом.
  /// [courseId] = "basic_{langId}", [lessonLId] = числовой l_id урока.
  Future<List<ExerciseModel>> getExercisesForLesson(
    String courseId,
    int lessonLId,
  );
}
