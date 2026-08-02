import 'package:b1_exam_prep/features/b1_exam/domain/models/exercise_result.dart';
import 'package:b1_exam_prep/features/profile/domain/achievement_model.dart';
import 'package:b1_exam_prep/features/profile/domain/achievement_update.dart';
import 'package:b1_exam_prep/features/profile/domain/step_result_model.dart';

/// Проверяет достижения после завершения уровня подготовки B1-темы.
/// Те же 5 типов достижений, что и в linguobyte (см. CheckAchievementUseCase),
/// но триггеры адаптированы под структуру B1: раздел → тема → уровень
/// подготовки (vocabulary/grammar/phrases), без уроков и суб-шагов глаголов.
class CheckB1AchievementUseCase {
  /// [allTopicResults] — topicResults ПОСЛЕ сохранения текущего шага.
  /// [requiredPrepLevels] — какие уровни подготовки должны быть пройдены,
  /// чтобы тема считалась завершённой. Разные секции экзамена имеют разный
  /// набор уровней (например image_description не использует "vocabulary" —
  /// существительные проходятся через "grammar", см. ImagePracticeStep).
  List<AchievementUpdate> check({
    required String sectionType,
    required int topicTId,
    required String prepLevel,
    required List<ExerciseResult> exerciseResults,
    required Map<String, StepResultModel> allTopicResults,
    required Map<String, AchievementModel> currentAchievements,
    required int currentStreak,
    required List<String> requiredPrepLevels,
  }) {
    final updates = <AchievementUpdate>[];

    final isTopicComplete = _isTopicComplete(
      sectionType: sectionType,
      topicTId: topicTId,
      allTopicResults: allTopicResults,
      requiredPrepLevels: requiredPrepLevels,
    );

    final masterConj = _checkMasterConjugator(
      prepLevel: prepLevel,
      isTopicComplete: isTopicComplete,
      currentAchievements: currentAchievements,
    );
    if (masterConj != null) updates.add(masterConj);

    final firstStep = _checkFirstStep(
      topicTId: topicTId,
      isTopicComplete: isTopicComplete,
      currentAchievements: currentAchievements,
    );
    if (firstStep != null) updates.add(firstStep);

    final focused = _checkFocusedLearner(
      currentStreak: currentStreak,
      currentAchievements: currentAchievements,
    );
    if (focused != null) updates.add(focused);

    final vocabMaster = _checkVocabularyMaster(
      prepLevel: prepLevel,
      exerciseResults: exerciseResults,
      currentAchievements: currentAchievements,
    );
    if (vocabMaster != null) updates.add(vocabMaster);

    return updates;
  }

  bool _isTopicComplete({
    required String sectionType,
    required int topicTId,
    required Map<String, StepResultModel> allTopicResults,
    required List<String> requiredPrepLevels,
  }) {
    return requiredPrepLevels.every(
      (level) =>
          allTopicResults.containsKey('${sectionType}_${topicTId}_$level'),
    );
  }

  /// Master Conjugator: тема полностью пройдена (vocab+grammar+phrases),
  /// грамматика — финальный/только что завершённый уровень. Повторяемо:
  /// уровень растёт при каждом повторном прохождении, аналог linguobyte.
  AchievementUpdate? _checkMasterConjugator({
    required String prepLevel,
    required bool isTopicComplete,
    required Map<String, AchievementModel> currentAchievements,
  }) {
    if (prepLevel != 'grammar' || !isTopicComplete) return null;

    final current = currentAchievements[AchievementType.masterConjugator.key];
    final currentLevel = current?.level ?? 0;
    return AchievementUpdate(
      type: AchievementType.masterConjugator,
      newLevel: currentLevel + 1,
    );
  }

  /// First Step: первая тема (t_id == 1) полностью пройдена. Одноразовое.
  AchievementUpdate? _checkFirstStep({
    required int topicTId,
    required bool isTopicComplete,
    required Map<String, AchievementModel> currentAchievements,
  }) {
    if (topicTId != 1 || !isTopicComplete) return null;

    final current = currentAchievements[AchievementType.firstStep.key];
    if (current != null && current.level >= 1) return null;

    return const AchievementUpdate(
      type: AchievementType.firstStep,
      newLevel: 1,
    );
  }

  /// Focused Learner: каждые 7 дней стрика. Стрик общий для аккаунта.
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

  /// Vocabulary Master: все vocabulary-упражнения темы правильно с первой
  /// попытки. Повторяемо, аналог linguobyte.
  AchievementUpdate? _checkVocabularyMaster({
    required String prepLevel,
    required List<ExerciseResult> exerciseResults,
    required Map<String, AchievementModel> currentAchievements,
  }) {
    if (prepLevel != 'vocabulary') return null;
    if (exerciseResults.isEmpty) return null;

    final allCorrect = exerciseResults.every((r) => r.isCorrect);
    if (!allCorrect) return null;

    final current = currentAchievements[AchievementType.vocabularyMaster.key];
    final currentLevel = current?.level ?? 0;
    return AchievementUpdate(
      type: AchievementType.vocabularyMaster,
      newLevel: currentLevel + 1,
    );
  }
}
