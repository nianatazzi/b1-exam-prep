import 'package:b1_exam_prep/features/b1_exam/data/repositories/lesson_content_repository.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/grammar_topic_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/lesson_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/lexical_topic_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lexical_topic_lessons_notifier.g.dart';

class LessonWithGrammarTopic {
  final LessonModel lesson;
  final GrammarTopicModel grammarTopic;

  const LessonWithGrammarTopic({
    required this.lesson,
    required this.grammarTopic,
  });
}

class LexicalTopicLessonsState {
  final LexicalTopicModel topic;
  final List<LessonWithGrammarTopic> lessons;

  const LexicalTopicLessonsState({
    required this.topic,
    required this.lessons,
  });
}

/// Уроки одной лексической темы (Lesson Matrix §A — тайл темы подтверждён
/// как первый уровень навигации). Тема, грамматические темы и уроки — все
/// маленькие коллекции (§F: 4 урока в MVP), поэтому грузим целиком и
/// фильтруем/сопоставляем в памяти — тот же паттерн, что и в
/// B1HomeNotifier, без отдельного запроса "уроки по теме".
@riverpod
class LexicalTopicLessonsNotifier extends _$LexicalTopicLessonsNotifier {
  @override
  Future<LexicalTopicLessonsState> build(
    String langId,
    String lexicalTopicId,
  ) async {
    final contentRepo = ref.read(lessonContentRepositoryProvider);

    final results = await Future.wait([
      contentRepo.getLexicalTopics(langId),
      contentRepo.getGrammarTopics(langId),
      contentRepo.getLessons(langId),
    ]);

    final lexicalTopics = results[0] as List<LexicalTopicModel>;
    final grammarTopics = results[1] as List<GrammarTopicModel>;
    final lessons = results[2] as List<LessonModel>;

    final topic = lexicalTopics.firstWhere((t) => t.id == lexicalTopicId);
    final topicLessons = lessons
        .where((lesson) => lesson.lexicalTopicId == lexicalTopicId)
        .map((lesson) => LessonWithGrammarTopic(
              lesson: lesson,
              grammarTopic: grammarTopics
                  .firstWhere((gt) => gt.id == lesson.grammarTopicId),
            ))
        .toList();

    return LexicalTopicLessonsState(topic: topic, lessons: topicLessons);
  }
}
