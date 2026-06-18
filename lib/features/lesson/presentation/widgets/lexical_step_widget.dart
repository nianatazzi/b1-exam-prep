import 'package:flutter/material.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/features/lesson/domain/models/lesson_step.dart';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (step.sets.isNotEmpty)
          Text(
            step.sets.first.setTitle,
            style: theme.textTheme.titleLarge,
          ),
        const SizedBox(height: AppSpacing.lg),
        Expanded(
          child: ListView.separated(
            itemCount: step.sets.length,
            separatorBuilder: (_, _) =>
                const Divider(height: AppSpacing.lg),
            itemBuilder: (_, i) {
              final vocab = step.sets[i];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vocab.title,
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    vocab.transcription,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    vocab.translation,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.primary,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed:
                step.exercises.isEmpty ? onComplete : onToExercises,
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

class _ExercisePhase extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isLast = exerciseIndex >= step.exercises.length - 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${exerciseIndex + 1} / ${step.exercises.length}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.5),
              ),
        ),
        const SizedBox(height: AppSpacing.lg),
        ExerciseWidget(exercise: step.exercises[exerciseIndex]),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLast ? onComplete : onNext,
            child: Text(
                isLast ? l10n.completeStepButton : l10n.nextButton),
          ),
        ),
      ],
    );
  }
}
