import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:linguobyte/core/constants/app_routes.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/features/b1_exam/presentation/providers/b1_home_notifier.dart';
import 'package:linguobyte/features/b1_exam/presentation/widgets/section_card.dart';
import 'package:linguobyte/l10n/app_localizations.dart';
import 'package:linguobyte/shared/widgets/error_view.dart';

class B1HomeScreen extends ConsumerWidget {
  const B1HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(b1HomeNotifierProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.b1HomeTitle),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorView(
          message: l10n.errorGeneric,
          onRetry: () => ref.invalidate(b1HomeNotifierProvider),
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
