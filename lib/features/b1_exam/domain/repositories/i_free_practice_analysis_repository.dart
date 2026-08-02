import 'package:b1_exam_prep/features/b1_exam/domain/models/free_practice_analysis_model.dart';

abstract class IFreePracticeAnalysisRepository {
  /// Вызывает Cloud Function analyzeFreePractice — LLM находит неправильно
  /// использованные глаголы/существительные в транскрипте.
  Future<FreePracticeAnalysisModel> analyze({
    required String transcript,
    required String uiLanguage,
  });
}
