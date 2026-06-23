import 'package:flutter/material.dart';
import 'package:linguobyte/core/constants/app_sizes.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/core/theme/app_colors.dart';
import 'package:linguobyte/features/home/domain/usecases/get_home_data_use_case.dart';
import 'package:linguobyte/features/profile/domain/step_result_model.dart';
import 'package:linguobyte/l10n/app_localizations.dart';
import 'package:linguobyte/shared/models/lesson_step_summary.dart';

/// Карточка одного урока на HomeScreen.
/// Состояние (done / active / locked) приходит уже вычисленным в [LessonCardData].
class LessonCard extends StatelessWidget {
  final LessonCardData cardData;

  /// Индекс урока в списке — для подписи "LESSON 01", "LESSON 02"…
  final int lessonIndex;

  /// null для locked-карточки — тогда карточка не реагирует на нажатие.
  final VoidCallback? onTap;

  const LessonCard({
    super.key,
    required this.cardData,
    required this.lessonIndex,
    this.onTap,
  });

  StepResultModel? _findStepResult(LessonStepSummary step) {
    final lId = cardData.lesson.lId;
    final prefix = switch (step.type) {
      LessonStepType.theory => '${lId}_theory_',
      LessonStepType.lexical => '${lId}_vocab_',
      LessonStepType.verbs => '${lId}_verb_',
      LessonStepType.finalStep => '${lId}_final_',
    };
    for (final entry in cardData.stepResults.entries) {
      if (entry.key.startsWith(prefix)) {
        return entry.value;
      }
    }
    return null;
  }

  /// Вычисляет состояние шага по его позиции (0-based index) в списке.
  LessonCardState _stepState(int index) {
    return switch (cardData.state) {
      LessonCardState.done => LessonCardState.done,
      LessonCardState.locked => LessonCardState.locked,
      LessonCardState.active => index < cardData.lastParagraph
          ? LessonCardState.done
          : index == cardData.lastParagraph
              ? LessonCardState.active
              : LessonCardState.locked,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final state = cardData.state;
    final isLocked = state == LessonCardState.locked;

    final numberColor = isLocked
        ? cs.onSurface.withValues(alpha: 0.4)
        : cs.primary;

    final themeTextColor = isLocked
        ? cs.onSurface.withValues(alpha: 0.5)
        : cs.onSurface;

    final BoxBorder border;
    final List<BoxShadow> shadow;
    switch (state) {
      case LessonCardState.done:
        border = Border.all(color: cs.primary.withValues(alpha: 0.4));
        shadow = const [];
      case LessonCardState.active:
        border = Border.all(color: cs.primary, width: 1.5);
        shadow = [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.3),
            blurRadius: AppSpacing.md,
          ),
        ];
      case LessonCardState.locked:
        border = Border.all(color: cs.primary.withValues(alpha: 0.2));
        shadow = const [];
    }

    final lessonNumber =
        '${l10n.lessonTitle} ${(lessonIndex + 1).toString().padLeft(2, '0')}'
            .toUpperCase();

    final steps = cardData.steps;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: AppSizes.lessonCardWidth,
        height: AppSizes.lessonCardHeight,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          child: Container(
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              border: border,
              boxShadow: shadow,
            ),
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── ГОЛОВА ──
                Text(
                  lessonNumber,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: numberColor,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  cardData.lesson.theme,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: themeTextColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.md),
                LinearProgressIndicator(
                  value: cardData.progressPercent,
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                  backgroundColor: cs.primary.withValues(alpha: 0.15),
                ),
                const SizedBox(height: AppSpacing.lg),

                // ── СПИСОК ШАГОВ ──
                Expanded(
                  child: Column(
                    children: List.generate(steps.length, (i) {
                      final step = steps[i];
                      return _StepRow(
                        step: step,
                        state: _stepState(i),
                        isLast: i == steps.length - 1,
                        l10n: l10n,
                        stepResult: _findStepResult(step),
                      );
                    }),
                  ),
                ),

                // ── ФУТЕР ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(cardData.progressPercent * 100).round()}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    _StatusBadge(state: state),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Строка шага с timeline-колонкой слева ────────────────────────────────────

class _StepRow extends StatelessWidget {
  final LessonStepSummary step;
  final LessonCardState state;
  final bool isLast;
  final AppLocalizations l10n;
  final StepResultModel? stepResult;

  const _StepRow({
    required this.step,
    required this.state,
    required this.isLast,
    required this.l10n,
    this.stepResult,
  });

  /// Зелёный ≥78%, красный <78%, primary если нет результатов.
  Color _resultDotColor(ColorScheme cs, AppColors ac) {
    if (stepResult == null || stepResult!.total == 0) return cs.primary;
    final percent = stepResult!.correct / stepResult!.total * 100;
    return percent >= 78 ? ac.success : cs.error;
  }

  String _displayTitle() {
    return switch (step.type) {
      LessonStepType.theory => step.title,
      LessonStepType.lexical => l10n.lexicalSection,
      LessonStepType.verbs => l10n.verbsSection,
      LessonStepType.finalStep => l10n.finalSection,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final ac = theme.extension<AppColors>()!;

    final Color dotColor;
    final Color textColor;
    final bool isDotFilled;
    switch (state) {
      case LessonCardState.done:
        dotColor = cs.primary;
        textColor = cs.onSurface;
        isDotFilled = true;
      case LessonCardState.active:
        dotColor = cs.primary;
        textColor = cs.onSurface;
        isDotFilled = false;
      case LessonCardState.locked:
        dotColor = cs.primary.withValues(alpha: 0.35);
        textColor = cs.onSurface.withValues(alpha: 0.6);
        isDotFilled = true;
    }

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: AppSpacing.lg,
            child: Center(
              child: Container(
                width: AppSizes.timelineDot,
                height: AppSizes.timelineDot,
                decoration: isDotFilled
                    ? BoxDecoration(color: dotColor, shape: BoxShape.circle)
                    : BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: dotColor, width: 1.5),
                      ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: AppSpacing.sm),
              child: Text(
                _displayTitle(),
                style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Бейдж статуса в футере ──────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final LessonCardState state;

  const _StatusBadge({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final Color bg;
    final Color fg;
    final String label;
    switch (state) {
      case LessonCardState.done:
        bg = cs.primary.withValues(alpha: 0.15);
        fg = cs.primary;
        label = l10n.statusDone;
      case LessonCardState.active:
        bg = cs.primary.withValues(alpha: 0.2);
        fg = cs.primary;
        label = l10n.statusInProgress;
      case LessonCardState.locked:
        bg = cs.primary.withValues(alpha: 0.12);
        fg = cs.primary.withValues(alpha: 0.7);
        label = l10n.statusLocked;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
