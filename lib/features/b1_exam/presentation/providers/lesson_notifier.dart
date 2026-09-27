import 'package:b1_exam_prep/core/constants/app_constants.dart';
import 'package:b1_exam_prep/features/auth/presentation/auth_notifier.dart';
import 'package:b1_exam_prep/features/b1_exam/data/repositories/exam_exercise_repository.dart';
import 'package:b1_exam_prep/features/b1_exam/data/repositories/lesson_content_repository.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/calculate_speech_score.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/exercise_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/exercise_result.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/grammar_topic_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/lesson_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/lesson_step.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/lexical_topic_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/usecases/complete_b1_step_use_case.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/usecases/submit_oral_step_use_case.dart';
import 'package:b1_exam_prep/features/b1_exam/presentation/providers/oral_step_outcome.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lesson_notifier.g.dart';

class LessonState {
  final LessonModel lesson;
  final LexicalTopicModel lexicalTopic;
  final GrammarTopicModel grammarTopic;
  final List<LessonStep> steps;
  final int stepIndex;
  final int exerciseIndex;
  final List<ExerciseResult> currentBlockResults;
  final bool isSubmittingOralStep;
  final Map<OralStep, OralStepOutcome> oralOutcomes;

  const LessonState({
    required this.lesson,
    required this.lexicalTopic,
    required this.grammarTopic,
    required this.steps,
    this.stepIndex = 0,
    this.exerciseIndex = 0,
    this.currentBlockResults = const [],
    this.isSubmittingOralStep = false,
    this.oralOutcomes = const {},
  });

  LessonStep? get currentStep =>
      stepIndex < steps.length ? steps[stepIndex] : null;

  bool get isComplete => stepIndex >= steps.length;

  int get durationSeconds =>
      lesson.durationSeconds ?? AppConstants.oralStepDurationSeconds;

  LessonState copyWith({
    int? stepIndex,
    int? exerciseIndex,
    List<ExerciseResult>? currentBlockResults,
    bool? isSubmittingOralStep,
    Map<OralStep, OralStepOutcome>? oralOutcomes,
  }) =>
      LessonState(
        lesson: lesson,
        lexicalTopic: lexicalTopic,
        grammarTopic: grammarTopic,
        steps: steps,
        stepIndex: stepIndex ?? this.stepIndex,
        exerciseIndex: exerciseIndex ?? this.exerciseIndex,
        currentBlockResults: currentBlockResults ?? this.currentBlockResults,
        isSubmittingOralStep:
            isSubmittingOralStep ?? this.isSubmittingOralStep,
        oralOutcomes: oralOutcomes ?? this.oralOutcomes,
      );
}

/// Фиксированная последовательность урока (Lesson Matrix §0/opening): три
/// капа упражнений (verb → noun → phrase, по 10) → три устных упражнения
/// подряд (image → monologue → dialogue). Диалог — отдельный экран
/// (DialogueScreen/DialogueNotifier), сюда возвращается уже готовым
/// OralStepOutcome через completeDialogueStep.
@riverpod
class LessonNotifier extends _$LessonNotifier {
  String get _userId => ref.read(authProvider).requireValue!.id;

  @override
  Future<LessonState> build(String langId, String lessonId) async {
    final contentRepo = ref.read(lessonContentRepositoryProvider);
    final exerciseRepo = ref.read(examExerciseRepositoryProvider);

    final (lesson, lexicalTopics, grammarTopics, exercises) = await (
      contentRepo.getLesson(langId, lessonId),
      contentRepo.getLexicalTopics(langId),
      contentRepo.getGrammarTopics(langId),
      exerciseRepo.getExercisesForLesson(langId, lessonId),
    ).wait;

    final lexicalTopic =
        lexicalTopics.firstWhere((t) => t.id == lesson.lexicalTopicId);
    final grammarTopic =
        grammarTopics.firstWhere((t) => t.id == lesson.grammarTopicId);

    List<ExerciseModel> capped(ExerciseBlock block) => exercises
        .where((e) => e.block == block)
        .take(AppConstants.lessonBlockExerciseCap)
        .toList();

    final steps = <LessonStep>[
      VerbBlockStep(exercises: capped(ExerciseBlock.verb)),
      NounBlockStep(exercises: capped(ExerciseBlock.noun)),
      PhraseBlockStep(exercises: capped(ExerciseBlock.phrase)),
      ImageStep(task: lesson.imageTask),
      MonologueStep(task: lesson.monologueTask),
      DialogueStep(task: lesson.dialogueTask),
    ];

    return LessonState(
      lesson: lesson,
      lexicalTopic: lexicalTopic,
      grammarTopic: grammarTopic,
      steps: steps,
    );
  }

  void recordExerciseResult(ExerciseResult result) {
    final current = state.requireValue;
    state = AsyncData(current.copyWith(
      currentBlockResults: [...current.currentBlockResults, result],
    ));
  }

  void nextExercise() {
    final current = state.requireValue;
    state = AsyncData(
      current.copyWith(exerciseIndex: current.exerciseIndex + 1),
    );
  }

  /// Завершение текущего блока упражнений (verb/noun/phrase) — сохраняет
  /// результат через CompleteB1StepUseCase и переходит к следующему шагу.
  Future<void> finishBlockStep() async {
    final current = state.requireValue;
    final block = switch (current.currentStep) {
      VerbBlockStep() => ExerciseBlock.verb,
      NounBlockStep() => ExerciseBlock.noun,
      PhraseBlockStep() => ExerciseBlock.phrase,
      _ => null,
    };
    if (block == null) return;

    final useCase = ref.read(completeB1StepUseCaseProvider);
    await useCase.execute(
      userId: _userId,
      langId: langId,
      lessonId: current.lesson.id,
      block: block,
      exerciseResults: current.currentBlockResults,
    );

    state = AsyncData(current.copyWith(
      stepIndex: current.stepIndex + 1,
      exerciseIndex: 0,
      currentBlockResults: const [],
    ));
  }

  /// Отправка устного шага image/monologue — не dialogue, у него отдельный
  /// флоу (DialogueScreen сохраняет через SubmitDialogueUseCase сам, потом
  /// зовёт completeDialogueStep здесь).
  Future<void> submitOralStep({
    required OralStep oralStep,
    required String transcript,
    required String uiLanguage,
  }) async {
    final current = state.requireValue;
    state = AsyncData(current.copyWith(isSubmittingOralStep: true));

    final useCase = ref.read(submitOralStepUseCaseProvider);
    final analysis = await useCase.execute(
      userId: _userId,
      langId: langId,
      lessonId: current.lesson.id,
      oralStep: oralStep,
      transcript: transcript,
      durationSeconds: current.durationSeconds,
      uiLanguage: uiLanguage,
    );

    _advanceWithOutcome(oralStep, OralStepOutcome(
      score: analysis == null ? null : calculateSpeechScore(analysis),
      analysis: analysis,
    ));
  }

  /// Вызывается после возврата с DialogueScreen (диалог уже сохранён там
  /// через SubmitDialogueUseCase) — просто продвигает шаг и запоминает итог
  /// для итогового экрана урока.
  void completeDialogueStep(OralStepOutcome outcome) {
    _advanceWithOutcome(OralStep.dialogue, outcome);
  }

  void _advanceWithOutcome(OralStep oralStep, OralStepOutcome outcome) {
    final current = state.requireValue;
    final outcomes = Map<OralStep, OralStepOutcome>.from(current.oralOutcomes)
      ..[oralStep] = outcome;

    state = AsyncData(current.copyWith(
      stepIndex: current.stepIndex + 1,
      isSubmittingOralStep: false,
      oralOutcomes: outcomes,
    ));
  }
}
