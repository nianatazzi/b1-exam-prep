import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:b1_exam_prep/core/constants/app_routes.dart';
import 'package:b1_exam_prep/core/constants/app_spacing.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/prep_step.dart';
import 'package:b1_exam_prep/features/b1_exam/presentation/providers/topic_detail_notifier.dart';
import 'package:b1_exam_prep/features/b1_exam/presentation/widgets/prep_level_card.dart';
import 'package:b1_exam_prep/l10n/app_localizations.dart';
import 'package:b1_exam_prep/shared/widgets/error_view.dart';

class TopicDetailScreen extends ConsumerWidget {
  final String sectionId;
  final String topicId;

  const TopicDetailScreen({
    super.key,
    required this.sectionId,
    required this.topicId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(
      topicDetailProvider(sectionId, topicId),
    );
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorView(
          message: l10n.errorGeneric,
          onRetry: () => ref.invalidate(
            topicDetailProvider(sectionId, topicId),
          ),
        ),
        data: (data) => ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Text(
              data.topic.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (data.topic.description.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                data.topic.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            ...data.steps.map((step) {
              final prepLevel = switch (step) {
                VocabularyPrepStep() => PrepLevel.vocabulary,
                GrammarPrepStep() => PrepLevel.grammar,
                PhrasesPrepStep() => PrepLevel.phrases,
              };

              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: PrepLevelCard(
                  prepLevel: prepLevel,
                  step: step,
                  progress: data.progress,
                  sectionId: sectionId,
                  topicTId: data.topic.tId,
                  onStart: () {
                    context.push(AppRoutes.b1PracticePath(
                      sectionId,
                      topicId,
                      prepLevel.name,
                    ));
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
