import 'package:b1_exam_prep/features/b1_exam/domain/models/exercise_model.dart';
import 'package:b1_exam_prep/features/profile/domain/achievement_model.dart';
import 'package:b1_exam_prep/features/profile/domain/achievement_update.dart';
import 'package:b1_exam_prep/features/profile/domain/step_result_model.dart';

/// Проверяет достижения после завершения блока упражнений урока (Lesson
/// Matrix §0). Те же 5 типов достижений, что и в linguobyte/старой B1-схеме,
/// но триггеры на lessonId/block (verb/noun/phrase) вместо
/// sectionType/topicTId/prepLevel. Урок всегда состоит ровно из трёх блоков
/// (verb+noun+phrase) — в отличие от старой схемы, где набор уровней
/// подготовки варьировался между image_description и обычными темами,
/// параметр requiredPrepLevels больше не нужен.
class CheckB1AchievementUseCase {
  /// [allTopicResults] — topicResults ПОСЛЕ сохранения текущего блока.
  List<AchievementUpdate> check({
    required String lessonId,
    required ExerciseBlock block,
    required Map<String, StepResultModel> allTopicResults,
    required Map<String, AchievementModel> currentAchievements,
    required int currentStreak,
  }) {
    final updates = <AchievementUpdate>[];

    final isLessonComplete = _isLessonComplete(
      lessonId: lessonId,
      allTopicResults: allTopicResults,
    );

    final masterConj = _checkMasterConjugator(
      block: block,
      isLessonComplete: isLessonComplete,
      currentAchievements: currentAchievements,
    );
    if (masterConj != null) updates.add(masterConj);

    final firstStep = _checkFirstStep(
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
      lessonId: lessonId,
      isLessonComplete: isLessonComplete,
      allTopicResults: allTopicResults,
      currentAchievements: currentAchievements,
    );
    if (vocabMaster != null) updates.add(vocabMaster);

    return updates;
  }

  bool _isLessonComplete({
    required String lessonId,
    required Map<String, StepResultModel> allTopicResults,
  }) {
    return ExerciseBlock.values.every(
      (b) => allTopicResults.containsKey('${lessonId}_${b.name}'),
    );
  }

  /// Master Conjugator: блок verb (спряжение) только что завершён, урок
  /// полностью пройден. Повторяемо — уровень растёт при каждом повторе.
  AchievementUpdate? _checkMasterConjugator({
    required ExerciseBlock block,
    required bool isLessonComplete,
    required Map<String, AchievementModel> currentAchievements,
  }) {
    if (block != ExerciseBlock.verb || !isLessonComplete) return null;

    final current = currentAchievements[AchievementType.masterConjugator.key];
    final currentLevel = current?.level ?? 0;
    return AchievementUpdate(
      type: AchievementType.masterConjugator,
      newLevel: currentLevel + 1,
    );
  }

  /// First Step: первый урок вообще, полностью пройденный. Одноразовое.
  /// Не привязано к конкретному lessonId — раньше проверялся t_id==1
  /// (порядковый номер темы), но у уроков нет порядкового номера
  /// (Lesson Matrix §A) — просто первое полное прохождение любого урока.
  AchievementUpdate? _checkFirstStep({
    required bool isLessonComplete,
    required Map<String, AchievementModel> currentAchievements,
  }) {
    if (!isLessonComplete) return null;

    final current = currentAchievements[AchievementType.firstStep.key];
    if (current != null && current.level >= 1) return null;

    return const AchievementUpdate(
      type: AchievementType.firstStep,
      newLevel: 1,
    );
  }

  /// Focused Learner: каждые 7 дней стрика. Стрик общий для аккаунта,
  /// не завязан на lessonId/block — не меняется этим рефакторингом.
  AchievementUpdate? _checkFocusedLearner({
    required int currentStreak,
    required Map<String, AchievementModel> currentAchievements,
  }) {
    if (currentStreak < 7) return null;

    final expectedLevel = currentStreak ~/ 7;
    final current = currentAchievements[AchievementType.focusedLearner.key];
    final currentLevel = current?.level ?? 0;

    if (expectedLevel <= currentLevel) return null;

    return AchievementUpdate(
      type: AchievementType.focusedLearner,
      newLevel: expectedLevel,
    );
  }

  // Interested Learner: пост-MVP, как и в linguobyte.

  /// Vocabulary Master: урок полностью пройден и все три блока
  /// (verb+noun+phrase) правильны с первой попытки. Раньше — отдельный
  /// уровень подготовки "vocabulary", которого в новой схеме блоков нет;
  /// решение продукта — переопределить как "весь урок начисто" (см.
  /// обсуждение при рефакторинге). Повторяемо.
  AchievementUpdate? _checkVocabularyMaster({
    required String lessonId,
    required bool isLessonComplete,
    required Map<String, StepResultModel> allTopicResults,
    required Map<String, AchievementModel> currentAchievements,
  }) {
    if (!isLessonComplete) return null;

    final allFirstAttempt = ExerciseBlock.values.every(
      (b) => allTopicResults['${lessonId}_${b.name}']?.firstAttempt ?? false,
    );
    if (!allFirstAttempt) return null;

    final current = currentAchievements[AchievementType.vocabularyMaster.key];
    final currentLevel = current?.level ?? 0;
    return AchievementUpdate(
      type: AchievementType.vocabularyMaster,
      newLevel: currentLevel + 1,
    );
  }
}
