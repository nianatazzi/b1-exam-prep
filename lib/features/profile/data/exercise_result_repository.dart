import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linguobyte/core/constants/firestore_paths.dart';
import 'package:linguobyte/core/errors/app_error.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_result.dart';
import 'package:linguobyte/features/profile/domain/repositories/i_exercise_result_repository.dart';
import 'package:linguobyte/features/profile/domain/step_result_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'exercise_result_repository.g.dart';

@riverpod
ExerciseResultRepository exerciseResultRepository(Ref ref) =>
    ExerciseResultRepository(FirebaseFirestore.instance);

class ExerciseResultRepository implements IExerciseResultRepository {
  final FirebaseFirestore _firestore;

  const ExerciseResultRepository(this._firestore);

  @override
  Future<void> saveStepResult({
    required String userId,
    required String langId,
    required String stepKey,
    required StepResultModel result,
    required List<ExerciseResult> exerciseResults,
  }) async {
    try {
      final docRef = _firestore.doc(FirestorePaths.userLanguage(userId, langId));

      final statsIncrements = _buildStatsIncrements(exerciseResults);

      await docRef.update({
        'stepResults.$stepKey': {
          'correct': result.correct,
          'total': result.total,
          'firstAttempt': result.firstAttempt,
          'completedAt': FieldValue.serverTimestamp(),
          'incorrectExerciseIds': result.incorrectExerciseIds,
        },
        ...statsIncrements,
      });
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }

  /// Строит map инкрементов для stats по grammarTypes каждого упражнения.
  Map<String, FieldValue> _buildStatsIncrements(
    List<ExerciseResult> results,
  ) {
    final increments = <String, FieldValue>{};

    final categoryTotals = <String, int>{};
    final categoryCorrects = <String, int>{};

    for (final r in results) {
      for (final category in r.grammarTypes) {
        final key = category.toLowerCase();
        if (!const {'grammar', 'vocabulary', 'listening', 'speaking'}
            .contains(key)) {
          continue;
        }
        categoryTotals[key] = (categoryTotals[key] ?? 0) + 1;
        if (r.isCorrect) {
          categoryCorrects[key] = (categoryCorrects[key] ?? 0) + 1;
        }
      }
    }

    for (final category in categoryTotals.keys) {
      increments['stats.$category.total'] =
          FieldValue.increment(categoryTotals[category]!);
      final correct = categoryCorrects[category] ?? 0;
      if (correct > 0) {
        increments['stats.$category.correct'] =
            FieldValue.increment(correct);
      }
    }

    return increments;
  }
}
