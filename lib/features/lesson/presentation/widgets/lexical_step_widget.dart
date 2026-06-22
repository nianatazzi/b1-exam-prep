import 'package:flutter/material.dart';
import 'package:linguobyte/core/constants/app_sizes.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/core/theme/app_colors.dart';
import 'package:linguobyte/features/lesson/domain/models/lesson_step.dart';
import 'package:linguobyte/features/lesson/domain/models/lexical_set_model.dart';
import 'package:linguobyte/features/lesson/presentation/widgets/exercise_widget.dart';
import 'package:linguobyte/l10n/app_localizations.dart';

class LexicalStepWidget extends StatelessWidget {
  final LexicalLessonStep step;
  final bool isExercisePhase;
  final int exerciseIndex;
  final VoidCallback onToExercises;
  final VoidCallback onNextExercise;
  final VoidCallback onComplete;

  const LexicalStepWidget({
    super.key,
    required this.step,
    required this.isExercisePhase,
    required this.exerciseIndex,
    required this.onToExercises,
    required this.onNextExercise,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return isExercisePhase
        ? _ExercisePhase(
            step: step,
            exerciseIndex: exerciseIndex,
            onNext: onNextExercise,
            onComplete: onComplete,
          )
        : _ContentPhase(
            step: step,
            onToExercises: onToExercises,
            onComplete: onComplete,
          );
  }
}

class _ContentPhase extends StatelessWidget {
  final LexicalLessonStep step;
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

    final setTitle = step.sets.isNotEmpty ? step.sets.first.setTitle : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (setTitle.isNotEmpty) ...[
          Text(setTitle, style: theme.textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.lg),
        ],
        Expanded(
          child: ListView.separated(
            itemCount: step.sets.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (_, i) => _VocabCard(
              index: i + 1,
              vocab: step.sets[i],
              theme: theme,
              cs: cs,
              ac: ac,
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

class _VocabCard extends StatelessWidget {
  final int index;
  final LexicalSetModel vocab;
  final ThemeData theme;
  final ColorScheme cs;
  final AppColors ac;

  const _VocabCard({
    required this.index,
    required this.vocab,
    required this.theme,
    required this.cs,
    required this.ac,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: ac.surfaceOverlay,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: ac.n600),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: AppSizes.iconLg,
            height: AppSizes.iconLg,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cs.primary.withValues(alpha: 0.15),
            ),
            child: Center(
              child: Text(
                '$index',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vocab.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: ac.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (vocab.transcription.isNotEmpty ||
                    vocab.translation.isNotEmpty)
                  const SizedBox(height: AppSpacing.xs),
                RichText(
                  text: TextSpan(
                    children: [
                      if (vocab.transcription.isNotEmpty)
                        TextSpan(
                          text: '[${vocab.transcription}]  ',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: ac.textMuted),
                        ),
                      if (vocab.translation.isNotEmpty)
                        TextSpan(
                          text: vocab.translation,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: cs.primary),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExercisePhase extends StatefulWidget {
  final LexicalLessonStep step;
  final int exerciseIndex;
  final VoidCallback onNext;
  final VoidCallback onComplete;

  const _ExercisePhase({
    required this.step,
    required this.exerciseIndex,
    required this.onNext,
    required this.onComplete,
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
