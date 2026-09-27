import 'package:b1_exam_prep/features/b1_exam/domain/models/speech_analysis_model.dart';

/// Итог одного устного шага (image/monologue/dialogue) для LessonNotifier —
/// используется и SubmitOralStepUseCase-based шагами, и DialogueNotifier
/// (диалог завершается отдельным флоу, но итог складывается в тот же тип
/// для единого summary-экрана урока).
class OralStepOutcome {
  final int? score;
  final SpeechAnalysisModel? analysis;

  const OralStepOutcome({this.score, this.analysis});
}
