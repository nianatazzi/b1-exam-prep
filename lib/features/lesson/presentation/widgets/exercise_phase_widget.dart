import 'package:flutter/material.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_model.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_result.dart';
import 'package:linguobyte/features/lesson/presentation/widgets/exercise_widget.dart';

/// Единая фаза упражнений шага: счётчик «N / M», текущее упражнение и кнопка
/// «Далее» / «Завершить» (разблокируется после проверки ответа).
///
/// Раньше эта логика была скопирована в theory/lexical/verbs/final-виджетах.
/// Различия параметризованы:
/// - [nextButtonLabel] / [completeButtonLabel] — подписи кнопки;
/// - [autoAdvance] — авто-переход после ответа (verbs / voice_translate).
class ExercisePhaseWidget extends StatefulWidget {
  final List<ExerciseModel> exercises;
  final int exerciseIndex;
  final VoidCallback onNext;
  final VoidCallback onComplete;
  final ValueChanged<ExerciseResult>? onResult;
  final String nextButtonLabel;
  final String completeButtonLabel;
  final bool autoAdvance;

  const ExercisePhaseWidget({
    super.key,
    required this.exercises,
    required this.exerciseIndex,
    required this.onNext,
    required this.onComplete,
    required this.nextButtonLabel,
    required this.completeButtonLabel,
    this.onResult,
    this.autoAdvance = false,
  });

  @override
  State<ExercisePhaseWidget> createState() => _ExercisePhaseWidgetState();
}

class _ExercisePhaseWidgetState extends State<ExercisePhaseWidget> {
  bool _isReady = false;

  @override
  void didUpdateWidget(ExercisePhaseWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exerciseIndex != widget.exerciseIndex) {
      setState(() => _isReady = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLast = widget.exerciseIndex >= widget.exercises.length - 1;
    final advance = isLast ? widget.onComplete : widget.onNext;
    final label = isLast ? widget.completeButtonLabel : widget.nextButtonLabel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.exerciseIndex + 1} / ${widget.exercises.length}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Expanded(
          child: ExerciseWidget(
            exercise: widget.exercises[widget.exerciseIndex],
            onReady: () => setState(() => _isReady = true),
            onResult: widget.onResult,
            onSkip: advance,
            onAutoAdvance: widget.autoAdvance ? advance : null,
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
              onPressed: _isReady ? advance : null,
              child: Text(label),
            ),
          ),
        ),
      ],
    );
  }
}
