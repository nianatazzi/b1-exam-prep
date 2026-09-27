import 'package:b1_exam_prep/features/b1_exam/domain/models/dialogue_scenario_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/exercise_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/free_practice_task_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/image_task_model.dart';

/// Шаг для Cloud Function analyzeSpeech (Lesson Matrix §C, поле oralStep) —
/// какое из трёх устных упражнений урока анализируется.
enum OralStep {
  image,
  monologue,
  dialogue,
}

/// Шаг фиксированной последовательности урока (Lesson Matrix §0/opening):
/// три капа упражнений (verb/noun/phrase, по 10) → три устных упражнения
/// подряд (image → monologue → dialogue). Не freezed — in-memory UI-состояние,
/// тот же паттерн, что был у удалённого ImagePracticeStep.
sealed class LessonStep {
  const LessonStep();
}

class VerbBlockStep extends LessonStep {
  final List<ExerciseModel> exercises;
  const VerbBlockStep({required this.exercises});
}

class NounBlockStep extends LessonStep {
  final List<ExerciseModel> exercises;
  const NounBlockStep({required this.exercises});
}

class PhraseBlockStep extends LessonStep {
  final List<ExerciseModel> exercises;
  const PhraseBlockStep({required this.exercises});
}

class ImageStep extends LessonStep {
  final ImageTaskModel task;
  const ImageStep({required this.task});
}

class MonologueStep extends LessonStep {
  final FreePracticeTaskModel task;
  const MonologueStep({required this.task});
}

class DialogueStep extends LessonStep {
  final DialogueScenarioModel task;
  const DialogueStep({required this.task});
}
