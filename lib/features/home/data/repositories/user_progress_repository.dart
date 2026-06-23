import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linguobyte/core/constants/firestore_paths.dart';
import 'package:linguobyte/core/errors/app_error.dart';
import 'package:linguobyte/features/home/domain/models/user_language_progress_model.dart';
import 'package:linguobyte/features/home/domain/repositories/i_user_progress_repository.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_result.dart';
import 'package:linguobyte/features/profile/domain/achievement_model.dart';
import 'package:linguobyte/features/profile/domain/step_result_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_progress_repository.g.dart';

@riverpod
UserProgressRepository userProgressRepository(Ref ref) =>
    UserProgressRepository(FirebaseFirestore.instance);

/// Единый репозиторий прогресса по языку. Инкапсулирует весь документ
/// private_user_info/{userId}/languages/{langId}: прогресс урока,
/// результаты субпартов (stepResults + stats) и достижения.
class UserProgressRepository implements IUserProgressRepository {
  final FirebaseFirestore _firestore;

  const UserProgressRepository(this._firestore);

  @override
  Future<UserLanguageProgressModel?> getUserLanguageProgress(
    String userId,
    String langId,
  ) async {
    try {
      final doc = await _firestore
          .doc(FirestorePaths.userLanguage(userId, langId))
          .get();
      if (!doc.exists || doc.data() == null) return null;
      final data = _preprocessProgressData(doc.data()!);
      return UserLanguageProgressModel.fromJson({...data, 'id': doc.id});
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }

  @override
  Future<void> updateProgress(
    String userId,
    String langId,
    String lastLesson,
    int lastParagraph,
  ) async {
    try {
      // merge: true — документ языка создаётся при первом сохранении прогресса,
      // если его ещё нет (новый пользователь). Остальные поля прогресса не затираются.
      await _firestore.doc(FirestorePaths.userLanguage(userId, langId)).set(
        {
          'lastLesson': lastLesson,
          'lastParagraph': lastParagraph,
        },
        SetOptions(merge: true),
      );
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }

  @override
  Future<void> saveStepResult({
    required String userId,
    required String langId,
    required String stepKey,
    required StepResultModel result,
    required List<ExerciseResult> exerciseResults,
  }) async {
    try {
      final docRef =
          _firestore.doc(FirestorePaths.userLanguage(userId, langId));
      final updateData = {
        'stepResults.$stepKey': {
          'correct': result.correct,
          'total': result.total,
          'firstAttempt': result.firstAttempt,
          'completedAt': FieldValue.serverTimestamp(),
          'incorrectExerciseIds': result.incorrectExerciseIds,
        },
        ..._buildStatsIncrements(exerciseResults),
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
    required String langId,
    required AchievementType type,
    required int newLevel,
  }) async {
    try {
      final key = _achievementKey(type);
      final docRef =
          _firestore.doc(FirestorePaths.userLanguage(userId, langId));
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
      await docRef.set(_initialLanguageDocument());
      await docRef.update(updateData);
    }
  }

  /// Начальная структура документа языка. Единственный источник —
  /// используется и при saveStepResult, и при updateAchievement.
  Map<String, dynamic> _initialLanguageDocument() => {
        'lastLesson': '',
        'lastParagraph': 0,
        'stats': {
          'grammar': {'correct': 0, 'total': 0},
          'vocabulary': {'correct': 0, 'total': 0},
          'listening': {'correct': 0, 'total': 0},
          'speaking': {'correct': 0, 'total': 0},
        },
        'stepResults': <String, dynamic>{},
        'achievements': <String, dynamic>{},
      };

  /// Строит map инкрементов stats по grammarTypes каждого упражнения.
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

  String _achievementKey(AchievementType type) => switch (type) {
        AchievementType.masterConjugator => 'master_conjugator',
        AchievementType.firstStep => 'first_step',
        AchievementType.focusedLearner => 'focused_learner',
        AchievementType.interestedLearner => 'interested_learner',
        AchievementType.vocabularyMaster => 'vocabulary_master',
      };

  /// Конвертирует Timestamp → ISO строку в stepResults и achievements,
  /// подставляет type достижения из ключа map для старых документов.
  Map<String, dynamic> _preprocessProgressData(Map<String, dynamic> data) {
    final result = Map<String, dynamic>.from(data);

    final stepResults = result['stepResults'];
    if (stepResults is Map) {
      final converted = <String, dynamic>{};
      for (final entry in stepResults.entries) {
        if (entry.value is Map) {
          final step = Map<String, dynamic>.from(entry.value as Map);
          final completedAt = step['completedAt'];
          if (completedAt is Timestamp) {
            step['completedAt'] = completedAt.toDate().toIso8601String();
          }
          converted[entry.key as String] = step;
        }
      }
      result['stepResults'] = converted;
    }

    final achievements = result['achievements'];
    if (achievements is Map) {
      final converted = <String, dynamic>{};
      for (final entry in achievements.entries) {
        if (entry.value is Map) {
          final key = entry.key as String;
          final ach = Map<String, dynamic>.from(entry.value as Map);
          // Обратная совместимость: документы, записанные до добавления type,
          // не содержат его — подставляем из ключа map (= JsonValue достижения).
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

    return result;
  }
}
