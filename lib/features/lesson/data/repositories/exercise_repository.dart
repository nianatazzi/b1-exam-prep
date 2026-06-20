import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:linguobyte/core/constants/firestore_paths.dart';
import 'package:linguobyte/core/errors/app_error.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_model.dart';
import 'package:linguobyte/features/lesson/domain/repositories/i_exercise_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'exercise_repository.g.dart';

@riverpod
ExerciseRepository exerciseRepository(Ref ref) =>
    ExerciseRepository(FirebaseFirestore.instance);

class ExerciseRepository implements IExerciseRepository {
  final FirebaseFirestore _firestore;

  const ExerciseRepository(this._firestore);

  @override
  Future<List<ExerciseModel>> getExercisesForLesson(
    String courseId,
    int lessonLId,
  ) async {
    try {
      final snap = await _firestore
          .collection(FirestorePaths.exercises)
          .where('course_id', isEqualTo: courseId)
          .where('lesson_id', isEqualTo: lessonLId)
          .get();
      final docs = snap.docs
          .map((doc) {
            try {
              return ExerciseModel.fromJson({...doc.data(), 'id': doc.id});
            } catch (e) {
              if (kDebugMode) debugPrint('⚠️ [ExerciseRepository] пропущен документ ${doc.id}: $e');
              return null;
            }
          })
          .whereType<ExerciseModel>()
          .toList()
        ..sort((a, b) => a.exId.compareTo(b.exId));
      return docs;
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }
}
