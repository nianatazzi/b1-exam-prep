import 'package:linguobyte/features/lesson/domain/models/exercise_model.dart';
import 'package:linguobyte/features/lesson/domain/models/lexical_set_model.dart';
import 'package:linguobyte/features/lesson/domain/models/theory_model.dart';
import 'package:linguobyte/features/lesson/domain/models/verb_model.dart';

/// Один шаг урока = пара "контент + упражнения".
/// Индекс шага в List<LessonStep> соответствует значению lastParagraph в Firestore.
sealed class LessonStep {
  const LessonStep();
}

class TheoryLessonStep extends LessonStep {
  final TheoryModel theory;
  final List<ExerciseModel> exercises;

  const TheoryLessonStep({required this.theory, required this.exercises});
}

class LexicalLessonStep extends LessonStep {
  final List<LexicalSetModel> sets;
  final List<ExerciseModel> exercises;

  const LexicalLessonStep({required this.sets, required this.exercises});
}

class VerbsLessonStep extends LessonStep {
  final List<VerbModel> verbs;
  final List<ExerciseModel> exercises;

  const VerbsLessonStep({required this.verbs, required this.exercises});
}
