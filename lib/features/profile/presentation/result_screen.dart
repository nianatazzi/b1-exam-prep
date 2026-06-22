import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linguobyte/core/constants/app_sizes.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/core/theme/app_colors.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_result.dart';
import 'package:linguobyte/l10n/app_localizations.dart';

class ResultScreen extends StatelessWidget {
  final List<ExerciseResult> results;

  const ResultScreen({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;

    final correct = results.where((r) => r.isCorrect).length;
    final total = results.length;
    final percent = total == 0 ? 0 : (correct / total * 100).round();

    final feedback = percent == 100
        ? l10n.resultPerfect
        : percent >= 78
            ? l10n.resultGood
            : l10n.resultNeedsWork;

    final feedbackColor = percent == 100
        ? colors.success
        : percent >= 78
            ? theme.colorScheme.primary
            : theme.colorScheme.error;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n.resultTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        ),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.xl),
            Text(
              feedback,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: feedbackColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.resultScore(correct, total),
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.x2l),
            if (results.any((r) => !r.isCorrect)) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.correctAnswerLabel,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ...results
                  .where((r) => !r.isCorrect)
                  .map((r) => _IncorrectItem(result: r)),
            ],
            const SizedBox(height: AppSpacing.x2l),
            SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeight,
              child: ElevatedButton(
                onPressed: () => context.pop(),
                child: Text(l10n.continueLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IncorrectItem extends StatelessWidget {
  final ExerciseResult result;
  const _IncorrectItem({required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (result.question != null)
            Text(
              result.question!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
              ),
            ),
          if (result.question != null)
            const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Icon(Icons.close, size: AppSizes.iconSm,
                  color: theme.colorScheme.error),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  result.userAnswer,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Icon(Icons.check, size: AppSizes.iconSm,
                  color: colors.success),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  result.correctAnswer,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
