import 'package:flutter/material.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_model.dart';

/// Скелет упражнения — показывает ex_id и type.
/// Детальный UI для каждого типа реализуется в отдельной сессии.
class ExerciseWidget extends StatelessWidget {
  final ExerciseModel exercise;

  const ExerciseWidget({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Exercise #${exercise.exId}',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Type: ${exercise.type}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color: cs.onSurface.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              exercise.type,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
