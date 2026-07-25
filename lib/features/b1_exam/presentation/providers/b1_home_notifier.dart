import 'package:b1_exam_prep/features/auth/presentation/auth_notifier.dart';
import 'package:b1_exam_prep/features/b1_exam/data/repositories/exam_content_repository.dart';
import 'package:b1_exam_prep/features/b1_exam/data/repositories/exam_progress_repository.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/exam_section_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/exam_topic_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/topic_progress_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'b1_home_notifier.g.dart';

class B1HomeState {
  final List<SectionWithTopics> sections;
  final TopicProgressModel progress;

  const B1HomeState({
    required this.sections,
    required this.progress,
  });
}

class SectionWithTopics {
  final ExamSectionModel section;
  final List<ExamTopicModel> topics;

  const SectionWithTopics({required this.section, required this.topics});
}

@riverpod
class B1HomeNotifier extends _$B1HomeNotifier {
  String get _userId => ref.read(authProvider).requireValue!.id;

  @override
  Future<B1HomeState> build() async {
    final contentRepo = ref.read(examContentRepositoryProvider);
    final progressRepo = ref.read(examProgressRepositoryProvider);

    final sections = await contentRepo.getSections();

    // Параллельно: темы для каждой секции + прогресс пользователя
    final topicFutures =
        sections.map((s) => contentRepo.getTopics(s.id)).toList();
    final progressFuture = progressRepo.getProgress(_userId);

    final results = await Future.wait([
      ...topicFutures,
      progressFuture,
    ]);

    final sectionsWithTopics = <SectionWithTopics>[];
    for (var i = 0; i < sections.length; i++) {
      sectionsWithTopics.add(SectionWithTopics(
        section: sections[i],
        topics: results[i] as List<ExamTopicModel>,
      ));
    }

    final progress = results.last as TopicProgressModel;

    return B1HomeState(
      sections: sectionsWithTopics,
      progress: progress,
    );
  }
}
