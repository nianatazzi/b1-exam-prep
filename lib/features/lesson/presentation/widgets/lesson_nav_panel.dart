import 'package:flutter/material.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/features/lesson/domain/models/additional_model.dart';
import 'package:linguobyte/features/lesson/domain/models/lesson_step.dart';
import 'package:linguobyte/l10n/app_localizations.dart';

/// Bottom sheet навигации по блокам урока.
/// [progressIndex] — количество завершённых шагов (= lastParagraph).
/// [viewIndex] — шаг, который пользователь видит сейчас.
/// [onStepTap] — вызывается при тапе на доступный шаг; получает индекс.
void showLessonNavPanel({
  required BuildContext context,
  required List<LessonStep> steps,
  required List<AdditionalModel> additional,
  required int progressIndex,
  required int viewIndex,
  required ValueChanged<int> onStepTap,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => _NavPanelSheet(
      steps: steps,
      additional: additional,
      progressIndex: progressIndex,
      viewIndex: viewIndex,
      onStepTap: (index) {
        Navigator.of(context).pop();
        onStepTap(index);
      },
    ),
  );
}

class _NavPanelSheet extends StatelessWidget {
  final List<LessonStep> steps;
  final List<AdditionalModel> additional;
  final int progressIndex;
  final int viewIndex;
  final ValueChanged<int> onStepTap;

  const _NavPanelSheet({
    required this.steps,
    required this.additional,
    required this.progressIndex,
    required this.viewIndex,
    required this.onStepTap,
  });

  String _stepTitle(LessonStep step, AppLocalizations l10n) {
    return switch (step) {
      TheoryLessonStep s => s.theory.topic,
      LexicalLessonStep _ => l10n.lexicalSection,
      VerbsLessonStep _ => l10n.verbsSection,
      FinalLessonStep _ => l10n.finalSection,
    };
  }

  /// done = завершён, active = текущий (viewIndex), locked = ещё не достигнут.
  _StepStatus _status(int index) {
    if (index < progressIndex) return _StepStatus.done;
    if (index == viewIndex) return _StepStatus.active;
    if (index <= progressIndex) return _StepStatus.done;
    return _StepStatus.locked;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ручка
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
              decoration: BoxDecoration(
                color: cs.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(99),
              ),
            ),

            // Шаги урока
            for (var i = 0; i < steps.length; i++)
              _StepTile(
                title: _stepTitle(steps[i], l10n),
                status: _status(i),
                onTap: _status(i) != _StepStatus.locked
                    ? () => onStepTap(i)
                    : null,
              ),

            // Additional — всегда доступен, отдельная секция
            if (additional.isNotEmpty) ...[
              const Divider(height: AppSpacing.xl),
              _StepTile(
                title: l10n.additionalSection,
                status: _StepStatus.bonus,
                onTap: () {
                  Navigator.of(context).pop();
                  showDialog<void>(
                    context: context,
                    builder: (_) => _AdditionalDialog(items: additional),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

enum _StepStatus { done, active, locked, bonus }

class _StepTile extends StatelessWidget {
  final String title;
  final _StepStatus status;
  final VoidCallback? onTap;

  const _StepTile({
    required this.title,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final IconData icon;
    final Color iconColor;
    switch (status) {
      case _StepStatus.done:
        icon = Icons.check_circle_rounded;
        iconColor = cs.primary;
      case _StepStatus.active:
        icon = Icons.play_circle_rounded;
        iconColor = cs.primary;
      case _StepStatus.locked:
        icon = Icons.radio_button_unchecked;
        iconColor = cs.onSurface.withValues(alpha: 0.3);
      case _StepStatus.bonus:
        icon = Icons.attach_file_rounded;
        iconColor = cs.secondary;
    }

    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(
          color: status == _StepStatus.locked
              ? cs.onSurface.withValues(alpha: 0.4)
              : cs.onSurface,
        ),
      ),
      onTap: onTap,
    );
  }
}

class _AdditionalDialog extends StatelessWidget {
  final List<AdditionalModel> items;

  const _AdditionalDialog({required this.items});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.additionalSection),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final item in items) ...[
              Text(item.title,
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: AppSpacing.xs),
              Text(item.content),
              const SizedBox(height: AppSpacing.lg),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.back),
        ),
      ],
    );
  }
}
