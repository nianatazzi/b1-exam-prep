import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:b1_exam_prep/core/constants/firestore_paths.dart';
import 'package:b1_exam_prep/core/errors/app_error.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/free_practice_analysis_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/topic_progress_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/repositories/i_exam_progress_repository.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/exercise_result.dart';
import 'package:b1_exam_prep/features/profile/domain/achievement_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'exam_progress_repository.g.dart';

@riverpod
ExamProgressRepository examProgressRepository(Ref ref) =>
    ExamProgressRepository(FirebaseFirestore.instance);

/// Прогресс B1 Polish exam prep — документ b1_progress/{userId}, полностью
/// изолирован от languages/{langId} (FIRESTORE.md §4), но stats/achievements
/// используют ту же форму, что и linguobyte, для общего ProfileScreen.
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
      final data = _preprocessProgressData(doc.data()!);
      return TopicProgressModel.fromJson({...data, 'id': doc.id});
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }

  /// Конвертирует Timestamp → ISO строку в topicResults и achievements,
  /// подставляет type достижения из ключа map для старых документов.
  Map<String, dynamic> _preprocessProgressData(Map<String, dynamic> data) {
    final result = Map<String, dynamic>.from(data);

    final topicResults = result['topicResults'];
    if (topicResults is Map) {
      final converted = <String, dynamic>{};
      for (final entry in topicResults.entries) {
        if (entry.value is Map) {
          final step = Map<String, dynamic>.from(entry.value as Map);
          final completedAt = step['completedAt'];
          if (completedAt is Timestamp) {
            step['completedAt'] = completedAt.toDate().toIso8601String();
          }
          converted[entry.key as String] = step;
        }
      }
      result['topicResults'] = converted;
    }

    final achievements = result['achievements'];
    if (achievements is Map) {
      final converted = <String, dynamic>{};
      for (final entry in achievements.entries) {
        if (entry.value is Map) {
          final key = entry.key as String;
          final ach = Map<String, dynamic>.from(entry.value as Map);
          ach.putIfAbsent('type', () => key);
          final updatedAt = ach['updatedAt'];
          if (updatedAt is Timestamp) {
            ach['updatedAt'] = updatedAt.toDate().toIso8601String();
          }
          converted[key] = ach;
        }
      }
      result['achievements'] = converted;
    }

    final freePractice = result['freePractice'];
    if (freePractice is Map) {
      final converted = <String, dynamic>{};
      for (final entry in freePractice.entries) {
        if (entry.value is Map) {
          final attempt = Map<String, dynamic>.from(entry.value as Map);
          final completedAt = attempt['completedAt'];
          if (completedAt is Timestamp) {
            attempt['completedAt'] = completedAt.toDate().toIso8601String();
          }
          converted[entry.key as String] = attempt;
        }
      }
      result['freePractice'] = converted;
    }

    return result;
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

      final docRef = _firestore.doc(FirestorePaths.b1Progress(userId));
      final updateData = {
        'topicResults.$stepKey': {
          'correct': correct,
          'total': total,
          'firstAttempt': incorrectIds.isEmpty,
          'completedAt': FieldValue.serverTimestamp(),
          'incorrectExerciseIds': incorrectIds,
        },
        ..._buildStatsIncrements(results),
      };
      await _updateOrInit(docRef, updateData);
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }

  @override
  Future<void> updateAchievement({
    required String userId,
    required AchievementType type,
    required int newLevel,
  }) async {
    try {
      final key = type.key;
      final docRef = _firestore.doc(FirestorePaths.b1Progress(userId));
      await _updateOrInit(docRef, {
        'achievements.$key': {
          // type внутри документа — иначе AchievementModel.fromJson падает на
          // $enumDecode(null) и роняет загрузку всего прогресса.
          'type': key,
          'level': newLevel,
          'updatedAt': FieldValue.serverTimestamp(),
        },
      });
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }

  @override
  Future<void> saveFreePracticeResult({
    required String userId,
    required String sectionType,
    required int topicTId,
    required String transcript,
    required int durationSeconds,
    FreePracticeAnalysisModel? analysis,
  }) async {
    try {
      final key = '${sectionType}_$topicTId';
      final docRef = _firestore.doc(FirestorePaths.b1Progress(userId));
      await _updateOrInit(docRef, {
        'freePractice.$key': {
          'transcript': transcript,
          'durationSeconds': durationSeconds,
          'completedAt': FieldValue.serverTimestamp(),
          'analysis': analysis?.toJson(),
        },
      });
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }

  /// Выполняет update(); если документа ещё нет (первый шаг нового
  /// пользователя) — создаёт с начальной структурой и повторяет.
  Future<void> _updateOrInit(
    DocumentReference<Map<String, dynamic>> docRef,
    Map<String, dynamic> updateData,
  ) async {
    try {
      await docRef.update(updateData);
    } on FirebaseException catch (e) {
      if (e.code != 'not-found') rethrow;
      await docRef.set(_initialProgressDocument());
      await docRef.update(updateData);
    }
  }

  Map<String, dynamic> _initialProgressDocument() => {
        'topicResults': <String, dynamic>{},
        'stats': {
          'grammar': {'correct': 0, 'total': 0},
          'vocabulary': {'correct': 0, 'total': 0},
          'listening': {'correct': 0, 'total': 0},
          'speaking': {'correct': 0, 'total': 0},
        },
        'achievements': <String, dynamic>{},
        'freePractice': <String, dynamic>{},
      };

  /// Строит map инкрементов stats по grammarTypes каждого упражнения.
  /// Идентично UserProgressRepository — та же форма stats у обоих приложений.
  Map<String, FieldValue> _buildStatsIncrements(List<ExerciseResult> results) {
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
        increments['stats.$category.correct'] = FieldValue.increment(correct);
      }
    }

    return increments;
  }
}
