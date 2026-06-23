import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linguobyte/core/constants/firestore_paths.dart';
import 'package:linguobyte/core/errors/app_error.dart';
import 'package:linguobyte/core/logger/app_logger.dart';
import 'package:linguobyte/features/lesson/domain/models/additional_model.dart';
import 'package:linguobyte/features/lesson/domain/models/lexical_set_model.dart';
import 'package:linguobyte/features/lesson/domain/models/theory_model.dart';
import 'package:linguobyte/features/lesson/domain/models/verb_model.dart';
import 'package:linguobyte/features/lesson/domain/repositories/i_lesson_content_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lesson_content_repository.g.dart';

@riverpod
LessonContentRepository lessonContentRepository(Ref ref) =>
    LessonContentRepository(FirebaseFirestore.instance);

class LessonContentRepository implements ILessonContentRepository {
  final FirebaseFirestore _firestore;

  const LessonContentRepository(this._firestore);

  /// Парсит документы, пропуская сломанные: один битый документ не должен
  /// ронять весь урок. Пропуск логируется (виден в debug).
  List<T> _parseDocs<T>(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    T Function(Map<String, dynamic>) fromJson,
    String label,
  ) {
    return docs
        .map((doc) {
          try {
            return fromJson({...doc.data(), 'id': doc.id});
          } catch (e) {
            AppLogger.w('Пропущен документ $label ${doc.id}: $e');
            return null;
          }
        })
        .whereType<T>()
        .toList();
  }

  @override
  Future<List<TheoryModel>> getTheory(String langId, String lessonId) async {
    try {
      final snap = await _firestore
          .collection(FirestorePaths.theory(langId, lessonId))
          .orderBy('th_id')
          .get();
      return _parseDocs(snap.docs, TheoryModel.fromJson, 'theory');
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }

  @override
  Future<List<LexicalSetModel>> getLexicalSets(
    String langId,
    String lessonId,
  ) async {
    try {
      final snap = await _firestore
          .collection(FirestorePaths.lexicalSet(langId, lessonId))
          .orderBy('voc_id')
          .get();
      return _parseDocs(snap.docs, LexicalSetModel.fromJson, 'lexical_set');
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }

  @override
  Future<List<VerbModel>> getVerbs(String langId, String lessonId) async {
    try {
      final snap = await _firestore
          .collection(FirestorePaths.verbs(langId, lessonId))
          .orderBy('v_id')
          .get();
      return _parseDocs(snap.docs, VerbModel.fromJson, 'verbs');
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }

  @override
  Future<List<AdditionalModel>> getAdditional(
    String langId,
    String lessonId,
  ) async {
    try {
      final snap = await _firestore
          .collection(FirestorePaths.additional(langId, lessonId))
          .get();
      return _parseDocs(snap.docs, AdditionalModel.fromJson, 'additional');
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }
}
