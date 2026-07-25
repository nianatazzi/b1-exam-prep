import 'package:flutter/material.dart';
import 'package:b1_exam_prep/core/constants/app_spacing.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/prep_step.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/topic_progress_model.dart';
import 'package:b1_exam_prep/l10n/app_localizations.dart';

class PrepLevelCard extends StatelessWidget {
  final PrepLevel prepLevel;
  final PrepStep step;
  final TopicProgressModel progress;
  final String sectionId;
  final int topicTId;
  final VoidCallback onStart;

  const PrepLevelCard({
    super.key,
    required this.prepLevel,
    required this.step,
    required this.progress,
    required this.sectionId,
    required this.topicTId,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final title = switch (prepLevel) {
      PrepLevel.vocabulary => l10n.b1Vocabulary,
      PrepLevel.grammar => l10n.b1Grammar,
      PrepLevel.phrases => l10n.b1Phrases,
    };

    final icon = switch (prepLevel) {
      PrepLevel.vocabulary => Icons.abc_outlined,
      PrepLevel.grammar => Icons.auto_stories_outlined,
      PrepLevel.phrases => Icons.chat_bubble_outline,
    };

    final subtitle = switch (step) {
      VocabularyPrepStep(:final vocabulary, :final exercises) =>
        l10n.b1LevelSubtitle(vocabulary.length, exercises.length),
      GrammarPrepStep(:final rules, :final exercises) =>
        l10n.b1LevelSubtitle(rules.length, exercises.length),
      PhrasesPrepStep(:final phrases, :final exercises) =>
        l10n.b1LevelSubtitle(phrases.length, exercises.length),
    };

    final stepKey = '${sectionId}_${topicTId}_${prepLevel.name}';
    final result = progress.topicResults[stepKey];
    final isCompleted = result != null;

    return Card(
      child: InkWell(
        onTap: onStart,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Icon(icon, size: 32, color: theme.colorScheme.primary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(subtitle, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              if (isCompleted)
                Icon(
                  Icons.check_circle,
                  color: theme.colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
