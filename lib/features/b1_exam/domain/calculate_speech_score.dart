import 'package:b1_exam_prep/core/constants/app_constants.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/speech_analysis_model.dart';

/// Считает итоговую оценку (0-100) устного шага урока по рубрике
/// (AppConstants, Lesson Matrix §D — явный плейсхолдер, см. комментарий
/// там). Общая для SubmitOralStepUseCase и SubmitDialogueUseCase — оба
/// сохраняют SpeechAnalysisModel и должны считать оценку одинаково.
int calculateSpeechScore(SpeechAnalysisModel analysis) {
  final taskCoverage = _taskCoverageScore(analysis);
  final grammar = _grammarScore(analysis);
  final vocabulary = _vocabularyScore(analysis);
  final coherence = analysis.coherenceScore.clamp(
    0,
    AppConstants.speechScoreCoherenceMax,
  );

  return (taskCoverage + grammar + vocabulary + coherence).clamp(0, 100);
}

int _taskCoverageScore(SpeechAnalysisModel analysis) {
  if (analysis.talkingPointsCovered.isEmpty) {
    return AppConstants.speechScoreTaskCoverageMax;
  }
  final covered =
      analysis.talkingPointsCovered.where((p) => p.covered).length;
  final fraction = covered / analysis.talkingPointsCovered.length;
  return (fraction * AppConstants.speechScoreTaskCoverageMax).round();
}

int _grammarScore(SpeechAnalysisModel analysis) {
  final weightedErrors =
      analysis.targetGrammarErrors.length *
          AppConstants.speechScoreTargetGrammarErrorWeight +
      analysis.otherGrammarErrors.length;
  final deduction = weightedErrors * AppConstants.speechScoreGrammarErrorPenalty;
  return (AppConstants.speechScoreGrammarMax - deduction).clamp(
    0,
    AppConstants.speechScoreGrammarMax,
  );
}

int _vocabularyScore(SpeechAnalysisModel analysis) {
  final deduction =
      analysis.lexicalErrors.length * AppConstants.speechScoreLexicalErrorPenalty;
  return (AppConstants.speechScoreVocabularyMax - deduction).clamp(
    0,
    AppConstants.speechScoreVocabularyMax,
  );
}
