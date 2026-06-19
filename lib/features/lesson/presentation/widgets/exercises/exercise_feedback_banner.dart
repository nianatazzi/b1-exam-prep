import 'package:flutter/material.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/l10n/app_localizations.dart';

class ExerciseFeedbackBanner extends StatelessWidget {
  final bool isCorrect;
  final String correctAnswer;
  final Color color;
  final Color backgroundColor;

  const ExerciseFeedbackBanner({
    super.key,
    required this.isCorrect,
    required this.correctAnswer,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect
                    ? Icons.check_circle_rounded
                    : Icons.cancel_rounded,
                color: color,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                isCorrect ? l10n.correctLabel : l10n.incorrectLabel,
                style: theme.textTheme.labelLarge?.copyWith(color: color),
              ),
            ],
          ),
          if (!isCorrect && correctAnswer.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.correctAnswerLabel,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: color.withValues(alpha: 0.7)),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              correctAnswer,
              style: theme.textTheme.bodyMedium?.copyWith(color: color),
            ),
          ],
        ],
      ),
    );
  }
}
