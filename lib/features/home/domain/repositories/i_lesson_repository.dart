import 'package:linguobyte/features/home/domain/models/lesson_model.dart';
import 'package:linguobyte/features/home/domain/models/theory_subpart_model.dart';

abstract class ILessonRepository {
  Future<List<LessonModel>> getLessons(String langId);
  Future<List<TheorySubpartModel>> getTheorySubparts(String langId, String lessonId);
}
