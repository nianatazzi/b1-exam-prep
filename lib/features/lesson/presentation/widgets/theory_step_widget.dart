import 'package:flutter/material.dart';
import 'package:linguobyte/core/constants/app_sizes.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_result.dart';
import 'package:linguobyte/core/theme/app_colors.dart';
import 'package:linguobyte/features/lesson/domain/models/lesson_step.dart';
import 'package:linguobyte/features/lesson/presentation/widgets/exercise_widget.dart';
import 'package:linguobyte/l10n/app_localizations.dart';

class TheoryStepWidget extends StatelessWidget {
  final TheoryLessonStep step;
  final bool isExercisePhase;
  final int exerciseIndex;
  final VoidCallback onToExercises;
  final VoidCallback onNextExercise;
  final VoidCallback onComplete;
  final ValueChanged<ExerciseResult>? onExerciseResult;

  const TheoryStepWidget({
    super.key,
    required this.step,
    required this.isExercisePhase,
    required this.exerciseIndex,
    required this.onToExercises,
    required this.onNextExercise,
    required this.onComplete,
    this.onExerciseResult,
  });

  @override
  Widget build(BuildContext context) {
    return isExercisePhase
        ? _ExercisePhase(
            step: step,
            exerciseIndex: exerciseIndex,
            onNext: onNextExercise,
            onComplete: onComplete,
            onExerciseResult: onExerciseResult,
          )
        : _ContentPhase(
            step: step,
            onToExercises: onToExercises,
            onComplete: onComplete,
          );
  }
}

class _ContentPhase extends StatelessWidget {
  final TheoryLessonStep step;
  final VoidCallback onToExercises;
  final VoidCallback onComplete;

  const _ContentPhase({
    required this.step,
    required this.onToExercises,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ac = theme.extension<AppColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          step.theory.topic,
          style: theme.textTheme.bodySmall?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(step.theory.title, style: theme.textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.lg),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _parseTheoryBlocks(step.theory.text, theme, ac, cs),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: step.exercises.isEmpty ? onComplete : onToExercises,
            child: Text(
              step.exercises.isEmpty
                  ? l10n.completeStepButton
                  : l10n.toExercisesButton,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Парсер текста теории ──────────────────────────────────────────────────────

final _transcriptionRegex = RegExp(r'^(.+?) \[([^\]]+)\] (.+)$');
final _dashRegex = RegExp(r'^(.+?) – (.+)$');

List<Widget> _parseTheoryBlocks(
  String text,
  ThemeData theme,
  AppColors ac,
  ColorScheme cs,
) {
  final widgets = <Widget>[];
  final lines = text.split('\n');

  for (int i = 0; i < lines.length; i++) {
    final line = lines[i].trim();

    if (line.isEmpty) {
      widgets.add(const SizedBox(height: AppSpacing.md));
      continue;
    }

    // Подсказка: строка начинается с «Ü », собираем все следующие строки
    // в тот же блок до первой пустой строки или нового блок-типа.
    if (line.startsWith('Ü ')) {
      final buf = StringBuffer(line.substring(2).trim());
      while (i + 1 < lines.length) {
        final next = lines[i + 1].trim();
        if (next.isEmpty ||
            next.startsWith('Ü ') ||
            _transcriptionRegex.hasMatch(next) ||
            _dashRegex.hasMatch(next)) {
          break;
        }
        i++;
        buf.write(' ');
        buf.write(next);
      }
      widgets.add(_TipBlock(text: buf.toString(), theme: theme, ac: ac, cs: cs));
      widgets.add(const SizedBox(height: AppSpacing.lg));
      continue;
    }

    // Пример с транскрипцией: «Слово [транскр.] Перевод»
    final tm = _transcriptionRegex.firstMatch(line);
    if (tm != null) {
      var translation = tm.group(3)!;
      if (translation.startsWith('– ')) translation = translation.substring(2);
      widgets.add(_ExampleCard(
        original: tm.group(1)!,
        transcription: tm.group(2)!,
        translation: translation,
        theme: theme,
        ac: ac,
        cs: cs,
      ));
      widgets.add(const SizedBox(height: AppSpacing.sm));
      continue;
    }

    // Пример с тире: «Фраза – Перевод»
    final dm = _dashRegex.firstMatch(line);
    if (dm != null) {
      widgets.add(_ExampleDash(
        original: dm.group(1)!,
        translation: dm.group(2)!,
        theme: theme,
        ac: ac,
      ));
      widgets.add(const SizedBox(height: AppSpacing.xs));
      continue;
    }

    // Подзаголовок секции: короткая строка, заканчивающаяся на «:»
    if (line.endsWith(':') && line.length < 80) {
      widgets.add(const SizedBox(height: AppSpacing.sm));
      widgets.add(Text(
        line,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: ac.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ));
      widgets.add(const SizedBox(height: AppSpacing.sm));
      continue;
    }

    // Обычный абзац
    widgets.add(Text(
      line,
      style: theme.textTheme.bodyMedium?.copyWith(color: ac.textSecondary),
    ));
    widgets.add(const SizedBox(height: AppSpacing.md));
  }

  return widgets;
}

// ── Блок-подсказка ────────────────────────────────────────────────────────────

class _TipBlock extends StatelessWidget {
  final String text;
  final ThemeData theme;
  final AppColors ac;
  final ColorScheme cs;

  const _TipBlock({
    required this.text,
    required this.theme,
    required this.ac,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: ac.primarySub,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: cs.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline_rounded, color: cs.primary, size: 18),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(color: ac.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Карточка примера с транскрипцией ─────────────────────────────────────────

class _ExampleCard extends StatelessWidget {
  final String original;
  final String transcription;
  final String translation;
  final ThemeData theme;
  final AppColors ac;
  final ColorScheme cs;

  const _ExampleCard({
    required this.original,
    required this.transcription,
    required this.translation,
    required this.theme,
    required this.ac,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = theme.textTheme.bodyMedium;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: ac.surfaceOverlay,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border(left: BorderSide(color: cs.secondary, width: 3)),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$original  ',
              style: baseStyle?.copyWith(
                color: ac.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: '[$transcription]  ',
              style: baseStyle?.copyWith(
                color: ac.textMuted,
                fontSize: (baseStyle.fontSize ?? 14) - 1,
              ),
            ),
            TextSpan(
              text: translation,
              style: baseStyle?.copyWith(color: ac.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Строка примера с тире ─────────────────────────────────────────────────────

class _ExampleDash extends StatelessWidget {
  final String original;
  final String translation;
  final ThemeData theme;
  final AppColors ac;

  const _ExampleDash({
    required this.original,
    required this.translation,
    required this.theme,
    required this.ac,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              original,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: ac.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Text(
              '–',
              style: theme.textTheme.bodyMedium?.copyWith(color: ac.textMuted),
            ),
          ),
          Flexible(
            child: Text(
              translation,
              style: theme.textTheme.bodyMedium?.copyWith(color: ac.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExercisePhase extends StatefulWidget {
  final TheoryLessonStep step;
  final int exerciseIndex;
  final VoidCallback onNext;
  final VoidCallback onComplete;
  final ValueChanged<ExerciseResult>? onExerciseResult;

  const _ExercisePhase({
    required this.step,
    required this.exerciseIndex,
    required this.onNext,
    required this.onComplete,
    this.onExerciseResult,
  });

  @override
  State<_ExercisePhase> createState() => _ExercisePhaseState();
}

class _ExercisePhaseState extends State<_ExercisePhase> {
  bool _isReady = false;

  @override
  void didUpdateWidget(_ExercisePhase oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exerciseIndex != widget.exerciseIndex) {
      setState(() => _isReady = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isLast = widget.exerciseIndex >= widget.step.exercises.length - 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.exerciseIndex + 1} / ${widget.step.exercises.length}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.5),
              ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Expanded(
          child: ExerciseWidget(
            exercise: widget.step.exercises[widget.exerciseIndex],
            onReady: () => setState(() => _isReady = true),
            onResult: widget.onExerciseResult,
            onSkip: isLast ? widget.onComplete : widget.onNext,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Visibility(
          visible: _isReady,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isReady ? (isLast ? widget.onComplete : widget.onNext) : null,
              child: Text(isLast ? l10n.completeStepButton : l10n.nextButton),
            ),
          ),
        ),
      ],
    );
  }
}
