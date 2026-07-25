import 'package:b1_exam_prep/features/b1_exam/domain/models/grammar_rule_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/phrase_pattern_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/topic_vocabulary_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/exercise_model.dart';

enum PrepLevel { vocabulary, grammar, phrases }

/// Один шаг подготовки = пара "контент + упражнения".
/// Аналог LessonStep из linguobyte, адаптированный для B1.
sealed class PrepStep {
  const PrepStep();
}

class VocabularyPrepStep extends PrepStep {
  final List<TopicVocabularyModel> vocabulary;
  final List<ExerciseModel> exercises;

  const VocabularyPrepStep({
    required this.vocabulary,
    required this.exercises,
  });
}

class GrammarPrepStep extends PrepStep {
  final List<GrammarRuleModel> rules;
  final List<ExerciseModel> exercises;

  const GrammarPrepStep({
    required this.rules,
    required this.exercises,
  });
}

class PhrasesPrepStep extends PrepStep {
  final List<PhrasePatternModel> phrases;
  final List<ExerciseModel> exercises;

  const PhrasesPrepStep({
    required this.phrases,
    required this.exercises,
  });
}
