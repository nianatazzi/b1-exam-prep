import 'package:b1_exam_prep/features/b1_exam/domain/models/grammar_rule_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/grammar_topic_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/lesson_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/lexical_topic_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/topic_vocabulary_model.dart';

/// Контент Lesson Matrix (Lesson Matrix §A) — читает lexical_topics/
/// grammar_topics/lessons. Отдельный интерфейс от IExamContentRepository:
/// та коллекция моделей (sections→topics) уходит на пенсию вместе со
/// старой схемой (§0), новая читает независимую схему.
/// [langId] — StudyLanguage.name (ARCHITECTURE.md §12.1), контент
/// изолирован по языку обучения.
abstract class ILessonContentRepository {
  Future<List<LexicalTopicModel>> getLexicalTopics(String langId);
  Future<List<GrammarTopicModel>> getGrammarTopics(String langId);
  Future<List<TopicVocabularyModel>> getLexicalVocabulary(
    String langId,
    String lexicalTopicId,
  );
  Future<List<GrammarRuleModel>> getGrammarRules(
    String langId,
    String grammarTopicId,
  );
  Future<List<LessonModel>> getLessons(String langId);
  Future<LessonModel> getLesson(String langId, String lessonId);
}
