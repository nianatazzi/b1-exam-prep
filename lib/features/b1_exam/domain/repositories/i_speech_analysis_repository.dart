import 'package:b1_exam_prep/features/b1_exam/domain/models/lesson_step.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/speech_analysis_model.dart';

abstract class ISpeechAnalysisRepository {
  /// Вызывает Cloud Function analyzeSpeech (Lesson Matrix §C) — расширенный
  /// анализ транскрипта устного шага урока: лемматизация, ошибки в целевой
  /// грамматике урока отдельно от прочих грамматических ошибок, лексические
  /// ошибки (сверка со словарём лексической темы урока), покрытие пунктов
  /// задания, связность. Заменяет более узкий analyzeFreePractice —
  /// функция знает [lessonId] и читает его grammar_topic_id/lexical_topic_id
  /// на сервере, чтобы промпт мог указать целевую грамматику явно.
  Future<SpeechAnalysisModel> analyze({
    required String langId,
    required String lessonId,
    required OralStep oralStep,
    required String transcript,
    required String uiLanguage,
  });
}
