import 'package:linguobyte/features/lesson/domain/models/exercise_result.dart';
import 'package:linguobyte/features/lesson/domain/models/lesson_step.dart';
import 'package:linguobyte/features/profile/domain/achievement_model.dart';
import 'package:linguobyte/features/profile/domain/step_result_model.dart';

/// Результат проверки: какие достижения нужно обновить.
class AchievementUpdate {
  final AchievementType type;
  final int newLevel;

  const AchievementUpdate({required this.type, required this.newLevel});
}

/// Проверяет все 5 типов достижений после завершения субпарта.
/// Чистая бизнес-логика без зависимостей от Firebase.
class CheckAchievementUseCase {
  /// Возвращает список достижений, которые нужно обновить.
  List<AchievementUpdate> check({
    required String segmentType,
    required int lessonLId,
    required List<ExerciseResult> exerciseResults,
    required Map<String, StepResultModel> allStepResults,
    required Map<String, AchievementModel> currentAchievements,
    required List<LessonStep> lessonSteps,
    required bool isLessonComplete,
    required int currentStreak,
  }) {
    final updates = <AchievementUpdate>[];

    final masterConj = _checkMasterConjugator(
      segmentType: segmentType,
      lessonLId: lessonLId,
      allStepResults: allStepResults,
      currentAchievements: currentAchievements,
      lessonSteps: lessonSteps,
    );
    if (masterConj != null) updates.add(masterConj);

    final firstStep = _checkFirstStep(
      lessonLId: lessonLId,
      isLessonComplete: isLessonComplete,
      currentAchievements: currentAchievements,
    );
    if (firstStep != null) updates.add(firstStep);

    final focused = _checkFocusedLearner(
      currentStreak: currentStreak,
      currentAchievements: currentAchievements,
    );
    if (focused != null) updates.add(focused);

    final vocabMaster = _checkVocabularyMaster(
      segmentType: segmentType,
      exerciseResults: exerciseResults,
      currentAchievements: currentAchievements,
    );
    if (vocabMaster != null) updates.add(vocabMaster);

    return updates;
  }

  /// Master Conjugator: все verb-субпарты урока завершены.
  AchievementUpdate? _checkMasterConjugator({
    required String segmentType,
    required int lessonLId,
    required Map<String, StepResultModel> allStepResults,
    required Map<String, AchievementModel> currentAchievements,
    required List<LessonStep> lessonSteps,
  }) {
    if (segmentType != 'verb') return null;

    final verbStep = lessonSteps.whereType<VerbsLessonStep>().firstOrNull;
    if (verbStep == null) return null;

    final allVerbsDone = verbStep.verbSubSteps.every((sub) {
      final key = '${lessonLId}_verb_${sub.verb.vId}';
      return allStepResults.containsKey(key);
    });

    if (!allVerbsDone) return null;

    final current = currentAchievements['master_conjugator'];
    final currentLevel = current?.level ?? 0;
    return AchievementUpdate(
      type: AchievementType.masterConjugator,
      newLevel: currentLevel + 1,
    );
  }

  /// First Step: урок 1 завершён. Одноразовое.
  AchievementUpdate? _checkFirstStep({
    required int lessonLId,
    required bool isLessonComplete,
    required Map<String, AchievementModel> currentAchievements,
  }) {
    if (lessonLId != 1 || !isLessonComplete) return null;

    final current = currentAchievements['first_step'];
    if (current != null && current.level >= 1) return null;

    return const AchievementUpdate(
      type: AchievementType.firstStep,
      newLevel: 1,
    );
  }

  /// Focused Learner: каждые 7 дней стрика.
  AchievementUpdate? _checkFocusedLearner({
    required int currentStreak,
    required Map<String, AchievementModel> currentAchievements,
  }) {
    if (currentStreak < 7) return null;

    final expectedLevel = currentStreak ~/ 7;
    final current = currentAchievements['focused_learner'];
    final currentLevel = current?.level ?? 0;

    if (expectedLevel <= currentLevel) return null;

    return AchievementUpdate(
      type: AchievementType.focusedLearner,
      newLevel: expectedLevel,
    );
  }

  // Interested Learner: пост-MVP (зависит от additional-контента и подписки)

  /// Vocabulary Master: все vocab-упражнения правильно с первой попытки.
  AchievementUpdate? _checkVocabularyMaster({
    required String segmentType,
    required List<ExerciseResult> exerciseResults,
    required Map<String, AchievementModel> currentAchievements,
  }) {
    if (segmentType != 'vocab') return null;
    if (exerciseResults.isEmpty) return null;

    final allCorrect = exerciseResults.every((r) => r.isCorrect);
    if (!allCorrect) return null;

    final current = currentAchievements['vocabulary_master'];
    final currentLevel = current?.level ?? 0;
    return AchievementUpdate(
      type: AchievementType.vocabularyMaster,
      newLevel: currentLevel + 1,
    );
  }
}
