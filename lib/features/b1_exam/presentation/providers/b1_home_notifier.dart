import 'package:b1_exam_prep/core/locale/study_language_provider.dart';
import 'package:b1_exam_prep/features/auth/presentation/auth_notifier.dart';
import 'package:b1_exam_prep/features/b1_exam/data/repositories/exam_progress_repository.dart';
import 'package:b1_exam_prep/features/b1_exam/data/repositories/lesson_content_repository.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/lesson_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/lexical_topic_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/topic_progress_model.dart';
import 'package:b1_exam_prep/shared/models/study_language.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'b1_home_notifier.g.dart';

class LexicalTopicWithLessons {
  final LexicalTopicModel topic;
  final List<LessonModel> lessons;

  const LexicalTopicWithLessons({required this.topic, required this.lessons});
}

class B1HomeState {
  final StudyLanguage? language;
  final List<LexicalTopicWithLessons> topics;
  final TopicProgressModel progress;

  const B1HomeState({
    required this.language,
    required this.topics,
    required this.progress,
  });
}

/// Тайл темы — лексическая тема (Lesson Matrix §A, тайл первого уровня —
/// решение подтверждено пользователем). Группировка уроков по теме — в
/// памяти, отдельного запроса на тему не нужно (лексических тем и уроков
/// мало, см. §F: 4 урока для MVP). [language] — null, если выбранный язык
/// обучения (ARCHITECTURE.md §12.1) вне поддерживаемого набора
/// b1-exam-prep: экран показывает пустое состояние, не падает.
@riverpod
class B1HomeNotifier extends _$B1HomeNotifier {
  String get _userId => ref.read(authProvider).requireValue!.id;

  @override
  Future<B1HomeState> build() async {
    final language = await ref.watch(studyLanguageProvider.future);
    if (language == null) {
      return B1HomeState(
        language: null,
        topics: const [],
        progress: TopicProgressModel(id: _userId),
      );
    }

    final contentRepo = ref.read(lessonContentRepositoryProvider);
    final progressRepo = ref.read(examProgressRepositoryProvider);
    final langId = language.name;

    final results = await Future.wait([
      contentRepo.getLexicalTopics(langId),
      contentRepo.getLessons(langId),
      progressRepo.getProgress(_userId, langId),
    ]);

    final lexicalTopics = results[0] as List<LexicalTopicModel>;
    final lessons = results[1] as List<LessonModel>;
    final progress = results[2] as TopicProgressModel;

    final topicsWithLessons = lexicalTopics
        .map((topic) => LexicalTopicWithLessons(
              topic: topic,
              lessons: lessons
                  .where((lesson) => lesson.lexicalTopicId == topic.id)
                  .toList(),
            ))
        .toList();

    return B1HomeState(
      language: language,
      topics: topicsWithLessons,
      progress: progress,
    );
  }
}
