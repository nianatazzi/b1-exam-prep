import 'package:b1_exam_prep/features/b1_exam/domain/models/grammar_rule_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/phrase_pattern_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/exercise_model.dart';

/// Шаг фиксированной последовательности image_description (Фаза 1):
/// глаголы (спряжение) → существительные (склонение) → фразы → свободная практика.
/// Свободная практика в эту последовательность не входит — отдельный экран,
/// управляется через ImagePracticeState.isFreePractice.
sealed class ImagePracticeStep {
  const ImagePracticeStep();

  List<ExerciseModel> get exercises;

  /// Ключ уровня подготовки для CompleteB1StepUseCase/stepKey.
  /// Глаголы и существительные пишутся под одним ключом "grammar" —
  /// см. GrammarRuleModel.ruleType (conjugation/declension), обе группы
  /// относятся к одному prepLevel "grammar" в существующей схеме прогресса.
  String get prepLevel => switch (this) {
        VerbConjugationStep() => 'grammar',
        NounDeclensionStep() => 'grammar',
        IntroPhrasesStep() => 'phrases',
      };
}

class VerbConjugationStep extends ImagePracticeStep {
  final List<GrammarRuleModel> rules;
  @override
  final List<ExerciseModel> exercises;

  const VerbConjugationStep({required this.rules, required this.exercises});
}

class NounDeclensionStep extends ImagePracticeStep {
  final List<GrammarRuleModel> rules;
  @override
  final List<ExerciseModel> exercises;

  const NounDeclensionStep({required this.rules, required this.exercises});
}

class IntroPhrasesStep extends ImagePracticeStep {
  final List<PhrasePatternModel> phrases;
  @override
  final List<ExerciseModel> exercises;

  const IntroPhrasesStep({required this.phrases, required this.exercises});
}
