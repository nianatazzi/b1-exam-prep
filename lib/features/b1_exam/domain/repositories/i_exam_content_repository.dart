import 'package:b1_exam_prep/features/b1_exam/domain/models/exam_section_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/exam_topic_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/grammar_rule_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/phrase_pattern_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/topic_vocabulary_model.dart';

abstract class IExamContentRepository {
  Future<List<ExamSectionModel>> getSections();
  Future<List<ExamTopicModel>> getTopics(String sectionId);
  Future<List<TopicVocabularyModel>> getVocabulary(
    String sectionId,
    String topicId,
  );
  Future<List<GrammarRuleModel>> getGrammarRules(
    String sectionId,
    String topicId,
  );
  Future<List<PhrasePatternModel>> getPhrases(
    String sectionId,
    String topicId,
  );
}
