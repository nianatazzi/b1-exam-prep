import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:b1_exam_prep/core/constants/app_routes.dart';
import 'package:b1_exam_prep/core/constants/app_spacing.dart';
import 'package:b1_exam_prep/features/b1_exam/presentation/providers/lexical_topic_lessons_notifier.dart';
import 'package:b1_exam_prep/l10n/app_localizations.dart';
import 'package:b1_exam_prep/shared/widgets/error_view.dart';

/// Список уроков одной лексической темы. Тап по уроку открывает LessonScreen
/// (флоу из 6 шагов урока).
class LexicalTopicLessonsScreen extends ConsumerWidget {
  final String langId;
  final String lexicalTopicId;

  const LexicalTopicLessonsScreen({
    super.key,
    required this.langId,
    required this.lexicalTopicId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = lexicalTopicLessonsProvider(langId, lexicalTopicId);
    final state = ref.watch(provider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: state.maybeWhen(
          data: (data) => Text(data.topic.title),
          orElse: () => null,
        ),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorView(
          message: l10n.errorGeneric,
          onRetry: () => ref.invalidate(provider),
        ),
        data: (data) => data.lessons.isEmpty
            ? Center(child: Text(l10n.b1TopicNoLessonsYet))
            : ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: data.lessons.length,
                itemBuilder: (context, index) {
                  final item = data.lessons[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ListTile(
                      title: Text(
                        '${data.topic.title} · ${item.grammarTopic.title}',
                      ),
                      onTap: () => context.push(
                        AppRoutes.b1LessonPath(langId, item.lesson.id),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
