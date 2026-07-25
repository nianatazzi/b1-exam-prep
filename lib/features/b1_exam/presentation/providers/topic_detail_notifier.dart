import 'package:b1_exam_prep/features/auth/presentation/auth_notifier.dart';
import 'package:b1_exam_prep/features/b1_exam/data/repositories/exam_content_repository.dart';
import 'package:b1_exam_prep/features/b1_exam/data/repositories/exam_exercise_repository.dart';
import 'package:b1_exam_prep/features/b1_exam/data/repositories/exam_progress_repository.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/exam_topic_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/prep_step.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/topic_progress_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/exercise_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'topic_detail_notifier.g.dart';

class TopicDetailState {
  final ExamTopicModel topic;
  final List<PrepStep> steps;
  final TopicProgressModel progress;

  const TopicDetailState({
    required this.topic,
    required this.steps,
    required this.progress,
  });
}

@riverpod
class TopicDetailNotifier extends _$TopicDetailNotifier {
  String get _userId => ref.read(authProvider).requireValue!.id;

  @override
  Future<TopicDetailState> build(
    String sectionId,
    String topicId,
  ) async {
    final contentRepo = ref.read(examContentRepositoryProvider);
    final exerciseRepo = ref.read(examExerciseRepositoryProvider);
    final progressRepo = ref.read(examProgressRepositoryProvider);

    // Параллельная загрузка всех данных
    final (topic, vocabulary, grammar, phrases, exercises, progress) =
        await (
      contentRepo.getTopics(sectionId).then(
            (topics) => topics.firstWhere((t) => t.id == topicId),
          ),
      contentRepo.getVocabulary(sectionId, topicId),
      contentRepo.getGrammarRules(sectionId, topicId),
      contentRepo.getPhrases(sectionId, topicId),
      _loadExercises(contentRepo, exerciseRepo, sectionId, topicId),
      progressRepo.getProgress(_userId),
    ).wait;

    final vocabExercises = exercises
        .where((e) => e.segmentType == 'vocabulary')
        .toList();
    final grammarExercises = exercises
        .where((e) => e.segmentType == 'grammar')
        .toList();
    final phraseExercises = exercises
        .where((e) => e.segmentType == 'phrases')
        .toList();

    final steps = <PrepStep>[
      if (vocabulary.isNotEmpty || vocabExercises.isNotEmpty)
        VocabularyPrepStep(
          vocabulary: vocabulary,
          exercises: vocabExercises,
        ),
      if (grammar.isNotEmpty || grammarExercises.isNotEmpty)
        GrammarPrepStep(
          rules: grammar,
          exercises: grammarExercises,
        ),
      if (phrases.isNotEmpty || phraseExercises.isNotEmpty)
        PhrasesPrepStep(
          phrases: phrases,
          exercises: phraseExercises,
        ),
    ];

    return TopicDetailState(
      topic: topic,
      steps: steps,
      progress: progress,
    );
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
}
