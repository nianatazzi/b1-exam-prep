import 'package:linguobyte/features/lesson/domain/models/additional_model.dart';
import 'package:linguobyte/features/lesson/domain/models/lexical_set_model.dart';
import 'package:linguobyte/features/lesson/domain/models/theory_model.dart';
import 'package:linguobyte/features/lesson/domain/models/verb_model.dart';

abstract interface class ILessonContentRepository {
  Future<List<TheoryModel>> getTheory(String langId, String lessonId);
  Future<List<LexicalSetModel>> getLexicalSets(String langId, String lessonId);
  Future<List<VerbModel>> getVerbs(String langId, String lessonId);
  Future<List<AdditionalModel>> getAdditional(String langId, String lessonId);
}
