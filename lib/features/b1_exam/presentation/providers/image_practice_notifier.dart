import 'package:b1_exam_prep/features/auth/presentation/auth_notifier.dart';
import 'package:b1_exam_prep/features/b1_exam/data/repositories/exam_content_repository.dart';
import 'package:b1_exam_prep/features/b1_exam/data/repositories/exam_exercise_repository.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/usecases/complete_b1_step_use_case.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/usecases/submit_free_practice_use_case.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/exam_topic_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/exercise_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/exercise_result.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/free_practice_analysis_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/grammar_rule_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/image_practice_step.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_practice_notifier.g.dart';

/// Уровни подготовки, реально используемые в фиксированной последовательности
/// image_description (Фаза 1) — без "vocabulary" (см. ImagePracticeStep.prepLevel
/// и docs/ARCHITECTURE.md §20, CheckB1AchievementUseCase.requiredPrepLevels).
const _imageDescriptionPrepLevels = ['grammar', 'phrases'];

class ImagePracticeState {
  final ExamTopicModel topic;
  final List<ImagePracticeStep> steps;
  final int stepIndex;
  final bool isContentPhase;
  final int exerciseIndex;
  final Map<String, List<ExerciseResult>> resultsByPrepLevel;
  final bool isFreePractice;
  final bool isCompleted;
  final String? transcript;
  final FreePracticeAnalysisModel? analysis;

  const ImagePracticeState({
    required this.topic,
    required this.steps,
    this.stepIndex = 0,
    this.isContentPhase = true,
    this.exerciseIndex = 0,
    this.resultsByPrepLevel = const {},
    this.isFreePractice = false,
    this.isCompleted = false,
    this.transcript,
    this.analysis,
  });

  ImagePracticeStep? get currentStep =>
      stepIndex < steps.length ? steps[stepIndex] : null;

  List<ExerciseModel> get exercises => currentStep?.exercises ?? const [];

  ImagePracticeState copyWith({
    int? stepIndex,
    bool? isContentPhase,
    int? exerciseIndex,
    Map<String, List<ExerciseResult>>? resultsByPrepLevel,
    bool? isFreePractice,
    bool? isCompleted,
    String? transcript,
    FreePracticeAnalysisModel? analysis,
  }) =>
      ImagePracticeState(
        topic: topic,
        steps: steps,
        stepIndex: stepIndex ?? this.stepIndex,
        isContentPhase: isContentPhase ?? this.isContentPhase,
        exerciseIndex: exerciseIndex ?? this.exerciseIndex,
        resultsByPrepLevel: resultsByPrepLevel ?? this.resultsByPrepLevel,
        isFreePractice: isFreePractice ?? this.isFreePractice,
        isCompleted: isCompleted ?? this.isCompleted,
        transcript: transcript ?? this.transcript,
        analysis: analysis ?? this.analysis,
      );
}

@riverpod
class ImagePracticeNotifier extends _$ImagePracticeNotifier {
  String get _userId => ref.read(authProvider).requireValue!.id;

  @override
  Future<ImagePracticeState> build(String sectionId, String topicId) async {
    final contentRepo = ref.read(examContentRepositoryProvider);
    final exerciseRepo = ref.read(examExerciseRepositoryProvider);

    final topics = await contentRepo.getTopics(sectionId);
    final topic = topics.firstWhere((t) => t.id == topicId);

    final (grammar, phrases, allExercises) = await (
      contentRepo.getGrammarRules(sectionId, topicId),
      contentRepo.getPhrases(sectionId, topicId),
      exerciseRepo.getExercisesForTopic(topic.tId),
    ).wait;

    final verbRules = grammar
        .where((r) => r.ruleType == GrammarRuleType.conjugation)
        .toList();
    final nounRules = grammar
        .where((r) => r.ruleType == GrammarRuleType.declension)
        .toList();
    final verbGIds = verbRules.map((r) => r.gId).toSet();
    final nounGIds = nounRules.map((r) => r.gId).toSet();

    final grammarExercises =
        allExercises.where((e) => e.segmentType == 'grammar').toList();
    final verbExercises = grammarExercises
        .where((e) => verbGIds.contains(e.linkedItemId))
        .toList();
    final nounExercises = grammarExercises
        .where((e) => nounGIds.contains(e.linkedItemId))
        .toList();
    final phraseExercises =
        allExercises.where((e) => e.segmentType == 'phrases').toList();

    final steps = <ImagePracticeStep>[
      if (verbRules.isNotEmpty || verbExercises.isNotEmpty)
        VerbConjugationStep(rules: verbRules, exercises: verbExercises),
      if (nounRules.isNotEmpty || nounExercises.isNotEmpty)
        NounDeclensionStep(rules: nounRules, exercises: nounExercises),
      if (phrases.isNotEmpty || phraseExercises.isNotEmpty)
        IntroPhrasesStep(phrases: phrases, exercises: phraseExercises),
    ];

    return ImagePracticeState(
      topic: topic,
      steps: steps,
      isFreePractice: steps.isEmpty,
    );
  }

  void switchToExercises() {
    final current = state.requireValue;
    state = AsyncData(current.copyWith(isContentPhase: false));
  }

  void recordResult(ExerciseResult result) {
    final current = state.requireValue;
    final step = current.currentStep;
    if (step == null) return;

    final level = step.prepLevel;
    final updated =
        Map<String, List<ExerciseResult>>.from(current.resultsByPrepLevel);
    updated[level] = [...(updated[level] ?? const []), result];
    state = AsyncData(current.copyWith(resultsByPrepLevel: updated));
  }

  void nextExercise() {
    final current = state.requireValue;
    if (current.exerciseIndex < current.exercises.length - 1) {
      state = AsyncData(
        current.copyWith(exerciseIndex: current.exerciseIndex + 1),
      );
    }
  }

  /// Вызывается после последнего упражнения текущего шага (verbs / nouns /
  /// phrases). Verbs и nouns относятся к одному prepLevel "grammar" —
  /// результаты копятся и сохраняются одним вызовом CompleteB1StepUseCase,
  /// когда следующий шаг относится уже к другому prepLevel (или шагов
  /// больше нет — тогда включается свободная практика).
  Future<void> finishCurrentStep(String sectionType) async {
    final current = state.requireValue;
    final step = current.currentStep;
    if (step == null) return;

    final nextIndex = current.stepIndex + 1;
    final nextStep =
        nextIndex < current.steps.length ? current.steps[nextIndex] : null;

    if (nextStep != null && nextStep.prepLevel == step.prepLevel) {
      state = AsyncData(current.copyWith(
        stepIndex: nextIndex,
        isContentPhase: true,
        exerciseIndex: 0,
      ));
      return;
    }

    final useCase = ref.read(completeB1StepUseCaseProvider);
    final results = current.resultsByPrepLevel[step.prepLevel] ?? const [];
    await useCase.execute(
      userId: _userId,
      sectionType: sectionType,
      topicTId: current.topic.tId,
      prepLevel: step.prepLevel,
      exerciseResults: results,
      requiredPrepLevels: _imageDescriptionPrepLevels,
    );

    final clearedResults =
        Map<String, List<ExerciseResult>>.from(current.resultsByPrepLevel)
          ..remove(step.prepLevel);

    state = AsyncData(current.copyWith(
      stepIndex: nextIndex,
      isContentPhase: true,
      exerciseIndex: 0,
      resultsByPrepLevel: clearedResults,
      isFreePractice: nextStep == null,
    ));
  }

  Future<void> submitFreePractice({
    required String sectionType,
    required String transcript,
    required int durationSeconds,
    required String uiLanguage,
  }) async {
    final current = state.requireValue;
    final useCase = ref.read(submitFreePracticeUseCaseProvider);
    final analysis = await useCase.execute(
      userId: _userId,
      sectionType: sectionType,
      topicTId: current.topic.tId,
      transcript: transcript,
      durationSeconds: durationSeconds,
      uiLanguage: uiLanguage,
    );
    state = AsyncData(current.copyWith(
      isCompleted: true,
      transcript: transcript,
      analysis: analysis,
    ));
  }
}
