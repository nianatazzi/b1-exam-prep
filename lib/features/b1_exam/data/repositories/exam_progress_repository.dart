import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linguobyte/core/constants/firestore_paths.dart';
import 'package:linguobyte/core/errors/app_error.dart';
import 'package:linguobyte/features/b1_exam/domain/models/topic_progress_model.dart';
import 'package:linguobyte/features/b1_exam/domain/repositories/i_exam_progress_repository.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'exam_progress_repository.g.dart';

@riverpod
ExamProgressRepository examProgressRepository(Ref ref) =>
    ExamProgressRepository(FirebaseFirestore.instance);

class ExamProgressRepository implements IExamProgressRepository {
  final FirebaseFirestore _firestore;

  const ExamProgressRepository(this._firestore);

  @override
  Future<TopicProgressModel> getProgress(String userId) async {
    try {
      final doc = await _firestore
          .doc(FirestorePaths.b1Progress(userId))
          .get();

      if (!doc.exists || doc.data() == null) {
        return TopicProgressModel(id: doc.id);
      }
      return TopicProgressModel.fromJson({...doc.data()!, 'id': doc.id});
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }

  @override
  Future<void> saveStepResult({
    required String userId,
    required String stepKey,
    required int correct,
    required int total,
    required List<ExerciseResult> results,
  }) async {
    try {
      final incorrectIds = results
          .where((r) => !r.isCorrect)
          .map((r) => r.exerciseId)
          .toList();

      // dot-notation для вложенных полей в update()
      await _firestore.doc(FirestorePaths.b1Progress(userId)).set({
        'topicResults': {
          stepKey: {
            'correct': correct,
            'total': total,
            'firstAttempt': incorrectIds.isEmpty,
            'completedAt': FieldValue.serverTimestamp(),
            'incorrectExerciseIds': incorrectIds,
          },
        },
      }, SetOptions(mergeFields: ['topicResults.$stepKey']));
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }
}
