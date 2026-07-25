import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:b1_exam_prep/core/constants/firestore_paths.dart';
import 'package:b1_exam_prep/core/errors/app_error.dart';
import 'package:b1_exam_prep/core/logger/app_logger.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/repositories/i_exam_exercise_repository.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/exercise_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'exam_exercise_repository.g.dart';

@riverpod
ExamExerciseRepository examExerciseRepository(Ref ref) =>
    ExamExerciseRepository(FirebaseFirestore.instance);

class ExamExerciseRepository implements IExamExerciseRepository {
  final FirebaseFirestore _firestore;

  const ExamExerciseRepository(this._firestore);

  @override
  Future<List<ExerciseModel>> getExercisesForTopic(int topicTId) async {
    try {
      final snapshot = await _firestore
          .collection(FirestorePaths.exercises)
          .where('course_id', isEqualTo: FirestorePaths.b1CourseId)
          .where('lesson_id', isEqualTo: topicTId)
          .orderBy('ex_id')
          .get();

      final exercises = <ExerciseModel>[];
      for (final doc in snapshot.docs) {
        try {
          exercises.add(
            ExerciseModel.fromJson({...doc.data(), 'id': doc.id}),
          );
        } catch (e) {
          AppLogger.w('B1: не удалось распарсить упражнение ${doc.id}: $e');
        }
      }
      return exercises;
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }
}
