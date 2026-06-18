import 'package:linguobyte/features/lesson/domain/models/exercise_model.dart';
import 'package:linguobyte/features/lesson/domain/models/lexical_set_model.dart';
import 'package:linguobyte/features/lesson/domain/models/theory_model.dart';
import 'package:linguobyte/features/lesson/domain/models/verb_model.dart';

/// Один шаг урока = пара "контент + упражнения".
/// Индекс шага в `List<LessonStep>` соответствует значению lastParagraph в Firestore.
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

/// Один глагол внутри шага verbs: таблица + упражнения именно на этот глагол.
class VerbSubStep {
  final VerbModel verb;
  final List<ExerciseModel> exercises;

  const VerbSubStep({required this.verb, required this.exercises});
}

class VerbsLessonStep extends LessonStep {
  final List<VerbSubStep> verbSubSteps;

  const VerbsLessonStep({required this.verbSubSteps});
}

/// Финальные упражнения после всех блоков урока (segment_type = "final").
class FinalLessonStep extends LessonStep {
  final List<ExerciseModel> exercises;

  const FinalLessonStep({required this.exercises});
}
