import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linguobyte/core/constants/firestore_paths.dart';
import 'package:linguobyte/core/errors/app_error.dart';
import 'package:linguobyte/features/home/domain/models/lesson_model.dart';
import 'package:linguobyte/features/home/domain/models/theory_subpart_model.dart';
import 'package:linguobyte/features/home/domain/repositories/i_lesson_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lesson_repository.g.dart';

@riverpod
LessonRepository lessonRepository(Ref ref) =>
    LessonRepository(FirebaseFirestore.instance);

class LessonRepository implements ILessonRepository {
  final FirebaseFirestore _firestore;

  // Имя поля сортировки — вынесено чтобы не хардкодить строку в запросе
  static const _fieldNumber = 'number';

  const LessonRepository(this._firestore);

  @override
  Future<List<LessonModel>> getLessons(String langId) async {
    try {
      final snapshot =
          await _firestore.collection(FirestorePaths.lessons(langId)).get();
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
  Future<List<TheorySubpartModel>> getTheorySubparts(
    String langId,
    String lessonId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(FirestorePaths.theory(langId, lessonId))
          .orderBy(_fieldNumber)
          .get();
      return snapshot.docs
          .map((doc) =>
              TheorySubpartModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }
}
