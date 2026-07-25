import 'package:flutter/material.dart';
import 'package:b1_exam_prep/core/constants/app_spacing.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/phrase_pattern_model.dart';
import 'package:b1_exam_prep/l10n/app_localizations.dart';

class PhraseCardWidget extends StatelessWidget {
  final PhrasePatternModel phrase;

  const PhraseCardWidget({super.key, required this.phrase});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context)!;

    final categoryLabel = switch (phrase.category) {
      PhraseCategory.opening => l10n.b1PhraseOpening,
      PhraseCategory.transition => l10n.b1PhraseTransition,
      PhraseCategory.opinion => l10n.b1PhraseOpinion,
      PhraseCategory.conclusion => l10n.b1PhraseConclusion,
      PhraseCategory.description => l10n.b1PhraseDescription,
    };

    final categoryColor = switch (phrase.category) {
      PhraseCategory.opening => theme.colorScheme.primary,
      PhraseCategory.transition => theme.colorScheme.secondary,
      PhraseCategory.opinion => theme.colorScheme.tertiary,
      PhraseCategory.conclusion => theme.colorScheme.error,
      PhraseCategory.description => theme.colorScheme.primary,
    };

    final translation =
        (phrase.translation[locale] ?? phrase.translation['en'] ?? '')
            .toString();
    final usage =
        (phrase.usageContext[locale] ?? phrase.usageContext['en'] ?? '')
            .toString();

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    categoryLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: categoryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              phrase.phrase,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (translation.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                translation,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (usage.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                usage,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
