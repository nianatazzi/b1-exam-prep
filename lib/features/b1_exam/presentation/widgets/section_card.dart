import 'package:flutter/material.dart';
import 'package:b1_exam_prep/core/constants/app_spacing.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/exam_section_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/exam_topic_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/topic_progress_model.dart';
import 'package:b1_exam_prep/features/b1_exam/presentation/widgets/topic_tile.dart';
import 'package:b1_exam_prep/l10n/app_localizations.dart';

class SectionCard extends StatelessWidget {
  final ExamSectionModel section;
  final List<ExamTopicModel> topics;
  final TopicProgressModel progress;
  final ValueChanged<String> onTopicTap;

  const SectionCard({
    super.key,
    required this.section,
    required this.topics,
    required this.progress,
    required this.onTopicTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final sectionTitle = switch (section.type) {
      ExamSectionType.imageDescription => l10n.b1ImageDescription,
      ExamSectionType.monologue => l10n.b1Monologue,
      ExamSectionType.dialogue => l10n.b1Dialogue,
    };

    final sectionIcon = switch (section.type) {
      ExamSectionType.imageDescription => Icons.image_outlined,
      ExamSectionType.monologue => Icons.record_voice_over_outlined,
      ExamSectionType.dialogue => Icons.forum_outlined,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Icon(sectionIcon, size: 28, color: theme.colorScheme.primary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sectionTitle,
                        style: theme.textTheme.titleLarge,
                      ),
                      if (section.description.isNotEmpty)
                        Text(
                          section.description,
                          style: theme.textTheme.bodyMedium,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...topics.map((topic) => TopicTile(
                topic: topic,
                sectionType: section.type,
                progress: progress,
                onTap: () => onTopicTap(topic.id),
              )),
        ],
      ),
    );
  }
}
