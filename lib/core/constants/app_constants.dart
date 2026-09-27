/// Бизнес-константы приложения (пороги, лимиты), не зависящие от темы/размеров.
abstract class AppConstants {
  /// Порог успешного прохождения субпарта, % правильных ответов.
  /// Зелёный индикатор ≥ порога, красный — ниже.
  static const int passThresholdPercent = 78;

  /// Показывать debug-кнопку Skip в упражнениях в release/profile сборках.
  /// Включается флагом сборки: --dart-define=SHOW_SKIP_BUTTON=true
  /// (тестовые TestFlight/ad-hoc билды для тестеров). В debug-режиме
  /// кнопка видна всегда, независимо от флага.
  static const bool showSkipButton = bool.fromEnvironment('SHOW_SKIP_BUTTON');

  /// Максимум упражнений в одном блоке урока (verb/noun/phrase) —
  /// Lesson Matrix, три капа по 10.
  static const int lessonBlockExerciseCap = 10;

  /// Длительность по умолчанию устного шага (image/monologue/dialogue),
  /// когда LessonModel.durationSeconds не задан в контенте — см. комментарий
  /// в lesson_model.dart (тот же паттерн, что у FreePracticeTaskModel).
  static const int oralStepDurationSeconds = 180;

  /// Рубрика оценки устного шага (0-100), Lesson Matrix §D — явный
  /// плейсхолдер на реальных критериях польского B1-экзамена, не итог.
  /// Вынесено в именованные константы, чтобы пересмотр был конфигом,
  /// а не правкой кода.
  static const int speechScoreTaskCoverageMax = 25;
  static const int speechScoreGrammarMax = 35;
  static const int speechScoreVocabularyMax = 25;
  static const int speechScoreCoherenceMax = 15;

  /// Ошибки в целевой грамматике урока (targetGrammarErrors) весят вдвое
  /// больше при списании баллов из speechScoreGrammarMax, чем
  /// otherGrammarErrors.
  static const int speechScoreTargetGrammarErrorWeight = 2;

  /// Списание за одну грамматическую/лексическую ошибку — баллы вычитаются
  /// из speechScoreGrammarMax/speechScoreVocabularyMax соответственно, не
  /// уходят в минус (итог по каждой части рубрики не ниже 0).
  static const int speechScoreGrammarErrorPenalty = 5;
  static const int speechScoreLexicalErrorPenalty = 5;
}
