import 'package:flutter/material.dart';
import 'package:linguobyte/core/constants/app_sizes.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/features/home/domain/models/theory_subpart_model.dart';
import 'package:linguobyte/features/home/domain/usecases/get_home_data_use_case.dart';
import 'package:linguobyte/l10n/app_localizations.dart';

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

  /// Вычисляет состояние субчасти по её позиции (0-based index) в списке.
  LessonCardState _subpartState(int index) {
    switch (cardData.state) {
      case LessonCardState.done:
        return LessonCardState.done;
      case LessonCardState.locked:
        return LessonCardState.locked;
      case LessonCardState.active:
        if (index < cardData.lastParagraph) return LessonCardState.done;
        if (index == cardData.lastParagraph) return LessonCardState.active;
        return LessonCardState.locked;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final state = cardData.state;
    final isLocked = state == LessonCardState.locked;

    // Цвет номера урока
    final numberColor = isLocked
        ? cs.onSurface.withValues(alpha: 0.4)
        : cs.primary;

    // Цвет заголовка — яркий для всех состояний
    final themeTextColor = isLocked
        ? cs.onSurface.withValues(alpha: 0.5)
        : cs.onSurface;

    // Рамка по состоянию (без Opacity-виджета на всю карточку)
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

    final subparts = cardData.subparts;

    // Фиксированный размер — ClipRect обрезает если контент не помещается
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: AppSizes.lessonCardWidth,
        height: AppSizes.lessonCardHeight,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          child: Container(
            decoration: BoxDecoration(
              // colorScheme.surface вместо surfaceRaised — насыщеннее на тёмной теме
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

                // ── СПИСОК СУБЧАСТЕЙ ──
                Expanded(
                  child: Column(
                    children: List.generate(subparts.length, (i) {
                      final sp = subparts[i];
                      return _SubpartRow(
                        subpart: sp,
                        state: _subpartState(i),
                        isLast: i == subparts.length - 1,
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

// ── Строка субчасти с timeline-колонкой слева ───────────────────────────────

class _SubpartRow extends StatelessWidget {
  final TheorySubpartModel subpart;
  final LessonCardState state;
  final bool isLast;

  const _SubpartRow({
    required this.subpart,
    required this.state,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final Color dotColor;
    final Color lineColor;
    final Color textColor;
    switch (state) {
      case LessonCardState.done:
        dotColor = cs.primary;
        lineColor = cs.primary.withValues(alpha: 0.3);
        textColor = cs.onSurface;
      case LessonCardState.active:
        dotColor = cs.primary;
        lineColor = cs.primary.withValues(alpha: 0.3);
        textColor = cs.onSurface;
      case LessonCardState.locked:
        dotColor = cs.primary.withValues(alpha: 0.35);
        lineColor = cs.primary.withValues(alpha: 0.2);
        textColor = cs.onSurface.withValues(alpha: 0.6);
    }

    // IntrinsicHeight нужен, чтобы вертикальная линия растянулась на высоту строки
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: AppSpacing.lg,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: AppSpacing.xs),
                  width: AppSizes.timelineDot,
                  height: AppSizes.timelineDot,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: AppSizes.timelineLineWidth,
                      color: lineColor,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.sm,
                bottom: AppSpacing.sm,
              ),
              child: Text(
                subpart.topic,
                style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
                maxLines: 2,
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
