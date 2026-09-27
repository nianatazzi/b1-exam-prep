import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:b1_exam_prep/core/constants/firestore_paths.dart';
import 'package:b1_exam_prep/core/errors/app_error.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/grammar_rule_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/grammar_topic_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/lesson_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/lexical_topic_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/topic_vocabulary_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/repositories/i_lesson_content_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lesson_content_repository.g.dart';

@riverpod
LessonContentRepository lessonContentRepository(Ref ref) =>
    LessonContentRepository(FirebaseFirestore.instance);

class LessonContentRepository implements ILessonContentRepository {
  final FirebaseFirestore _firestore;

  const LessonContentRepository(this._firestore);

  @override
  Future<List<LexicalTopicModel>> getLexicalTopics(String langId) async {
    try {
      final snapshot = await _firestore
          .collection(FirestorePaths.b1LexicalTopics(langId))
          .orderBy('lt_id')
          .get();
      return snapshot.docs
          .map((doc) =>
              LexicalTopicModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }

  @override
  Future<List<GrammarTopicModel>> getGrammarTopics(String langId) async {
    try {
      final snapshot = await _firestore
          .collection(FirestorePaths.b1GrammarTopics(langId))
          .orderBy('gt_id')
          .get();
      return snapshot.docs
          .map((doc) =>
              GrammarTopicModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }

  @override
  Future<List<TopicVocabularyModel>> getLexicalVocabulary(
    String langId,
    String lexicalTopicId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(FirestorePaths.b1LexicalVocabulary(langId, lexicalTopicId))
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
    String langId,
    String grammarTopicId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(FirestorePaths.b1GrammarTopicRules(langId, grammarTopicId))
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
  Future<List<LessonModel>> getLessons(String langId) async {
    try {
      final snapshot = await _firestore
          .collection(FirestorePaths.b1Lessons(langId))
          .get();
      return snapshot.docs
          .map((doc) => LessonModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }

  @override
  Future<LessonModel> getLesson(String langId, String lessonId) async {
    try {
      final doc = await _firestore
          .doc(FirestorePaths.b1Lesson(langId, lessonId))
          .get();
      if (!doc.exists || doc.data() == null) {
        throw const NotFoundError();
      }
      return LessonModel.fromJson({...doc.data()!, 'id': doc.id});
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } on AppError {
      // NotFoundError выше должен пройти как есть, не завернуться в
      // UnknownError общим catch ниже.
      rethrow;
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }
}
