import 'package:flutter/material.dart';
import 'package:b1_exam_prep/core/constants/app_spacing.dart';
import 'package:b1_exam_prep/core/theme/app_colors.dart';
import 'package:b1_exam_prep/l10n/app_localizations.dart';

class ExerciseFeedbackBanner extends StatelessWidget {
  final bool isCorrect;
  final String correctAnswer;
  final Color color;
  final Color backgroundColor;

  /// Если указан — ответ засчитывается правильным, но показывается
  /// предупреждение об отсутствующих акцентах вместо стандартного «Верно!».
  final String? accentWarning;

  const ExerciseFeedbackBanner({
    super.key,
    required this.isCorrect,
    required this.correctAnswer,
    required this.color,
    required this.backgroundColor,
    this.accentWarning,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ac = theme.extension<AppColors>()!;

    final bool isAccentWarning = accentWarning != null && isCorrect;

    final Color effectiveColor = isAccentWarning ? cs.secondary : color;
    final Color effectiveBg = isAccentWarning ? ac.secondarySub : backgroundColor;

    final bool showCorrectAnswer =
        isAccentWarning || (!isCorrect && correctAnswer.isNotEmpty);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: effectiveColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isAccentWarning
                    ? Icons.info_outline_rounded
                    : (isCorrect
                        ? Icons.check_circle_rounded
                        : Icons.cancel_rounded),
                color: effectiveColor,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  isAccentWarning
                      ? accentWarning!
                      : (isCorrect ? l10n.correctLabel : l10n.incorrectLabel),
                  style: theme.textTheme.labelLarge
                      ?.copyWith(color: effectiveColor),
                ),
              ),
            ],
          ),
          if (showCorrectAnswer && correctAnswer.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.correctAnswerLabel,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: effectiveColor.withValues(alpha: 0.7)),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              correctAnswer,
              style: theme.textTheme.bodyMedium?.copyWith(color: effectiveColor),
            ),
          ],
        ],
      ),
    );
  }
}
