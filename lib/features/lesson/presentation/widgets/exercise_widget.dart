import 'package:flutter/material.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/core/theme/app_colors.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_model.dart';
import 'package:linguobyte/features/lesson/presentation/widgets/exercises/fill_blank_exercise_widget.dart';
import 'package:linguobyte/features/lesson/presentation/widgets/exercises/translate_sentence_exercise_widget.dart';

/// Роутер упражнений: делегирует в под-виджет по [ExerciseModel.type].
/// [onReady] вызывается после того, как пользователь проверил ответ —
/// родительский шаг разблокирует кнопку "Далее".
class ExerciseWidget extends StatelessWidget {
  final ExerciseModel exercise;
  final VoidCallback onReady;

  const ExerciseWidget({
    super.key,
    required this.exercise,
    required this.onReady,
  });

  @override
  Widget build(BuildContext context) {
    return switch (exercise.type) {
      'fill_blank' => FillBlankExerciseWidget(
          exercise: exercise,
          onReady: onReady,
        ),
      'translate_sentence' => TranslateSentenceExerciseWidget(
          exercise: exercise,
          onReady: onReady,
        ),
      _ => _UnknownExerciseStub(exercise: exercise, onReady: onReady),
    };
  }
}

/// Заглушка для типов упражнений, виджеты которых ещё не реализованы.
class _UnknownExerciseStub extends StatelessWidget {
  final ExerciseModel exercise;
  final VoidCallback onReady;

  const _UnknownExerciseStub({
    required this.exercise,
    required this.onReady,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ac = theme.extension<AppColors>()!;

    // Автоматически разблокируем "Далее" для нереализованных типов
    WidgetsBinding.instance.addPostFrameCallback((_) => onReady());

    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              exercise.type,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: ac.textMuted),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '#${exercise.exId}',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: ac.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
