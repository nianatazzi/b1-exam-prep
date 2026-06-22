import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:linguobyte/core/constants/app_sizes.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/core/theme/app_colors.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_model.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_result.dart';
import 'package:linguobyte/features/lesson/presentation/widgets/exercises/fill_blank_exercise_widget.dart';
import 'package:linguobyte/features/lesson/presentation/widgets/exercises/listen_pick_exercise_widget.dart';
import 'package:linguobyte/features/lesson/presentation/widgets/exercises/multiple_choice_exercise_widget.dart';
import 'package:linguobyte/features/lesson/presentation/widgets/exercises/flashcard_exercise_widget.dart';
import 'package:linguobyte/features/lesson/presentation/widgets/exercises/voice_translate_exercise_widget.dart';
import 'package:linguobyte/features/lesson/presentation/widgets/exercises/wordcard_exercise_widget.dart';
import 'package:linguobyte/features/lesson/presentation/widgets/exercises/mosaic_exercise_widget.dart';
import 'package:linguobyte/features/lesson/presentation/widgets/exercises/translate_sentence_exercise_widget.dart';

/// Роутер упражнений: делегирует в под-виджет по [ExerciseModel.type].
/// [onReady] вызывается после того, как пользователь проверил ответ —
/// родительский шаг разблокирует кнопку "Далее".
/// [onResult] вызывается с результатом упражнения для записи статистики.
class ExerciseWidget extends StatelessWidget {
  final ExerciseModel exercise;
  final VoidCallback onReady;
  final ValueChanged<ExerciseResult>? onResult;
  // только для дебаг-кнопки Skip — переходит к следующему упражнению без проверки
  final VoidCallback? onSkip;
  // автопереход после ответа (используется в verbs для voice_translate)
  final VoidCallback? onAutoAdvance;

  const ExerciseWidget({
    super.key,
    required this.exercise,
    required this.onReady,
    this.onResult,
    this.onSkip,
    this.onAutoAdvance,
  });

  @override
  Widget build(BuildContext context) {
    final child = switch (exercise.type) {
      'fill_blank' => FillBlankExerciseWidget(
          key: ValueKey(exercise.exId),
          exercise: exercise,
          onReady: onReady,
          onResult: onResult,
        ),
      'translate_sentence' => TranslateSentenceExerciseWidget(
          key: ValueKey(exercise.exId),
          exercise: exercise,
          onReady: onReady,
          onResult: onResult,
        ),
      'mosaic' => MosaicExerciseWidget(
          key: ValueKey(exercise.exId),
          exercise: exercise,
          onReady: onReady,
          onResult: onResult,
        ),
      'listen_pick' => ListenPickExerciseWidget(
          key: ValueKey(exercise.exId),
          exercise: exercise,
          onReady: onReady,
          onResult: onResult,
        ),
      'multiple_choice' => MultipleChoiceExerciseWidget(
          key: ValueKey(exercise.exId),
          exercise: exercise,
          onReady: onReady,
          onResult: onResult,
        ),
      'wordcard' => WordcardExerciseWidget(
          key: ValueKey(exercise.exId),
          exercise: exercise,
          onReady: onReady,
          onResult: onResult,
        ),
      'flashcard' => FlashcardExerciseWidget(
          key: ValueKey(exercise.exId),
          exercise: exercise,
          onReady: onReady,
          onResult: onResult,
        ),
      'voice_translate' => VoiceTranslateExerciseWidget(
          key: ValueKey(exercise.exId),
          exercise: exercise,
          onReady: onReady,
          onAutoAdvance: onAutoAdvance,
        ),
      _ => _UnknownExerciseStub(exercise: exercise, onReady: onReady),
    };

    if (!kDebugMode) return child;

    return Stack(
      children: [
        child,
        Positioned(
          top: 0,
          right: 0,
          child: TextButton(
            onPressed: onSkip,
            child: Text(
              'Skip',
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ],
    );
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
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
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
