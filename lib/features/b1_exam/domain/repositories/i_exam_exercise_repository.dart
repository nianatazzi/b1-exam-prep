import 'package:b1_exam_prep/features/b1_exam/domain/models/exercise_model.dart';

abstract class IExamExerciseRepository {
  /// Загружает все упражнения урока (lesson) одним запросом.
  /// Группировка по блоку (verb/noun/phrase) — на стороне клиента.
  /// [langId] — StudyLanguage.name (ARCHITECTURE.md §12.1).
  Future<List<ExerciseModel>> getExercisesForLesson(
    String langId,
    String lessonId,
  );
}
