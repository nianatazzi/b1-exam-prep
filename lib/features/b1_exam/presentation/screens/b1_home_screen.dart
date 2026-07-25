import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:b1_exam_prep/core/constants/app_routes.dart';
import 'package:b1_exam_prep/core/constants/app_spacing.dart';
import 'package:b1_exam_prep/features/b1_exam/presentation/providers/b1_home_notifier.dart';
import 'package:b1_exam_prep/features/b1_exam/presentation/widgets/section_card.dart';
import 'package:b1_exam_prep/l10n/app_localizations.dart';
import 'package:b1_exam_prep/shared/widgets/error_view.dart';

class B1HomeScreen extends ConsumerWidget {
  const B1HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(b1HomeProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.b1HomeTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: l10n.profileTitle,
            onPressed: () => context.push(AppRoutes.profile),
          ),
        ],
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorView(
          message: l10n.errorGeneric,
          onRetry: () => ref.invalidate(b1HomeProvider),
        ),
        data: (data) => ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: data.sections.length,
          itemBuilder: (context, index) {
            final sectionWithTopics = data.sections[index];
            return SectionCard(
              section: sectionWithTopics.section,
              topics: sectionWithTopics.topics,
              progress: data.progress,
              onTopicTap: (topicId) {
                context.push(AppRoutes.b1TopicPath(
                  sectionWithTopics.section.id,
                  topicId,
                ));
              },
            );
          },
        ),
      ),
    );
  }
}
