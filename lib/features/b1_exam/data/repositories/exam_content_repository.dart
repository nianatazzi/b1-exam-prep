import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linguobyte/core/constants/firestore_paths.dart';
import 'package:linguobyte/core/errors/app_error.dart';
import 'package:linguobyte/features/b1_exam/domain/models/exam_section_model.dart';
import 'package:linguobyte/features/b1_exam/domain/models/exam_topic_model.dart';
import 'package:linguobyte/features/b1_exam/domain/models/grammar_rule_model.dart';
import 'package:linguobyte/features/b1_exam/domain/models/phrase_pattern_model.dart';
import 'package:linguobyte/features/b1_exam/domain/models/topic_vocabulary_model.dart';
import 'package:linguobyte/features/b1_exam/domain/repositories/i_exam_content_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'exam_content_repository.g.dart';

@riverpod
ExamContentRepository examContentRepository(Ref ref) =>
    ExamContentRepository(FirebaseFirestore.instance);

class ExamContentRepository implements IExamContentRepository {
  final FirebaseFirestore _firestore;

  const ExamContentRepository(this._firestore);

  @override
  Future<List<ExamSectionModel>> getSections() async {
    try {
      final snapshot = await _firestore
          .collection(FirestorePaths.b1Sections)
          .orderBy('s_id')
          .get();
      return snapshot.docs
          .map((doc) =>
              ExamSectionModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }

  @override
  Future<List<ExamTopicModel>> getTopics(String sectionId) async {
    try {
      final snapshot = await _firestore
          .collection(FirestorePaths.b1Topics(sectionId))
          .orderBy('t_id')
          .get();
      return snapshot.docs
          .map(
              (doc) => ExamTopicModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }

  @override
  Future<List<TopicVocabularyModel>> getVocabulary(
    String sectionId,
    String topicId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(FirestorePaths.b1Vocabulary(sectionId, topicId))
          .orderBy('voc_id')
          .get();
      return snapshot.docs
          .map((doc) =>
              TopicVocabularyModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }

  @override
  Future<List<GrammarRuleModel>> getGrammarRules(
    String sectionId,
    String topicId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(FirestorePaths.b1Grammar(sectionId, topicId))
          .orderBy('g_id')
          .get();
      return snapshot.docs
          .map((doc) =>
              GrammarRuleModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }

  @override
  Future<List<PhrasePatternModel>> getPhrases(
    String sectionId,
    String topicId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(FirestorePaths.b1Phrases(sectionId, topicId))
          .orderBy('p_id')
          .get();
      return snapshot.docs
          .map((doc) =>
              PhrasePatternModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }
}
