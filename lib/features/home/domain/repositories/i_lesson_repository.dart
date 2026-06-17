import 'package:linguobyte/features/home/domain/models/lesson_model.dart';
import 'package:linguobyte/shared/models/lesson_step_summary.dart';

abstract class ILessonRepository {
  Future<List<LessonModel>> getLessons(String langId);
  Future<List<LessonStepSummary>> getLessonStepSummaries(
    String langId,
    String lessonId,
  );
}
