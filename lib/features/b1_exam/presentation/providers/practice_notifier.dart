import 'package:b1_exam_prep/features/auth/presentation/auth_notifier.dart';
import 'package:b1_exam_prep/features/b1_exam/data/repositories/exam_content_repository.dart';
import 'package:b1_exam_prep/features/b1_exam/data/repositories/exam_exercise_repository.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/usecases/complete_b1_step_use_case.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/grammar_rule_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/phrase_pattern_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/prep_step.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/topic_vocabulary_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/exercise_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/exercise_result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'practice_notifier.g.dart';

class PracticeState {
  final PrepStep step;
  final int exerciseIndex;
  final List<ExerciseResult> results;
  final bool isContentPhase;
  final bool isCompleted;

  const PracticeState({
    required this.step,
    this.exerciseIndex = 0,
    this.results = const [],
    this.isContentPhase = true,
    this.isCompleted = false,
  });

  List<ExerciseModel> get exercises => switch (step) {
        VocabularyPrepStep(:final exercises) => exercises,
        GrammarPrepStep(:final exercises) => exercises,
        PhrasesPrepStep(:final exercises) => exercises,
      };

  PracticeState copyWith({
    PrepStep? step,
    int? exerciseIndex,
    List<ExerciseResult>? results,
    bool? isContentPhase,
    bool? isCompleted,
  }) =>
      PracticeState(
        step: step ?? this.step,
        exerciseIndex: exerciseIndex ?? this.exerciseIndex,
        results: results ?? this.results,
        isContentPhase: isContentPhase ?? this.isContentPhase,
        isCompleted: isCompleted ?? this.isCompleted,
      );
}

@riverpod
class PracticeNotifier extends _$PracticeNotifier {
  String get _userId => ref.read(authProvider).requireValue!.id;

  @override
  Future<PracticeState> build(
    String sectionId,
    String topicId,
    String prepLevel,
  ) async {
    final contentRepo = ref.read(examContentRepositoryProvider);
    final exerciseRepo = ref.read(examExerciseRepositoryProvider);

    final (vocabulary, grammar, phrases, allExercises) = await (
      prepLevel == 'vocabulary'
          ? contentRepo.getVocabulary(sectionId, topicId)
          : Future.value(<TopicVocabularyModel>[]),
      prepLevel == 'grammar'
          ? contentRepo.getGrammarRules(sectionId, topicId)
          : Future.value(<GrammarRuleModel>[]),
      prepLevel == 'phrases'
          ? contentRepo.getPhrases(sectionId, topicId)
          : Future.value(<PhrasePatternModel>[]),
      _loadExercises(contentRepo, exerciseRepo, sectionId, topicId),
    ).wait;

    final exercises =
        allExercises.where((e) => e.segmentType == prepLevel).toList();

    final step = switch (prepLevel) {
      'vocabulary' => VocabularyPrepStep(
          vocabulary: vocabulary,
          exercises: exercises,
        ),
      'grammar' => GrammarPrepStep(
          rules: grammar,
          exercises: exercises,
        ),
      'phrases' => PhrasesPrepStep(
          phrases: phrases,
          exercises: exercises,
        ),
      _ => VocabularyPrepStep(vocabulary: vocabulary, exercises: exercises),
    };

    return PracticeState(step: step);
  }

  Future<List<ExerciseModel>> _loadExercises(
    ExamContentRepository contentRepo,
    ExamExerciseRepository exerciseRepo,
    String sectionId,
    String topicId,
  ) async {
    final topics = await contentRepo.getTopics(sectionId);
    final topic = topics.firstWhere((t) => t.id == topicId);
    return exerciseRepo.getExercisesForTopic(topic.tId);
  }

  void switchToExercises() {
    final current = state.requireValue;
    state = AsyncData(current.copyWith(isContentPhase: false));
  }

  void recordResult(ExerciseResult result) {
    final current = state.requireValue;
    state = AsyncData(current.copyWith(
      results: [...current.results, result],
    ));
  }

  void nextExercise() {
    final current = state.requireValue;
    if (current.exerciseIndex < current.exercises.length - 1) {
      state = AsyncData(current.copyWith(
        exerciseIndex: current.exerciseIndex + 1,
      ));
    }
  }

  Future<void> completeStep(String sectionType, int topicTId) async {
    final current = state.requireValue;
    final useCase = ref.read(completeB1StepUseCaseProvider);

    final prepLevelName = switch (current.step) {
      VocabularyPrepStep() => 'vocabulary',
      GrammarPrepStep() => 'grammar',
      PhrasesPrepStep() => 'phrases',
    };

    await useCase.execute(
      userId: _userId,
      sectionType: sectionType,
      topicTId: topicTId,
      prepLevel: prepLevelName,
      exerciseResults: current.results,
    );

    state = AsyncData(current.copyWith(isCompleted: true));
  }
}
