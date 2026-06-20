import 'package:flutter/material.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/features/lesson/domain/models/lesson_step.dart';
import 'package:linguobyte/features/lesson/presentation/widgets/exercise_widget.dart';
import 'package:linguobyte/l10n/app_localizations.dart';

/// Финальные упражнения урока (segment_type = "final").
/// Самостоятельно управляет счётчиком упражнений;
/// вызывает [onComplete] после последнего.
class FinalStepWidget extends StatefulWidget {
  final FinalLessonStep step;
  final VoidCallback onComplete;

  const FinalStepWidget({
    super.key,
    required this.step,
    required this.onComplete,
  });

  @override
  State<FinalStepWidget> createState() => _FinalStepWidgetState();
}

class _FinalStepWidgetState extends State<FinalStepWidget> {
  int _exerciseIndex = 0;
  bool _isReady = false;

  void _onNext() => setState(() {
        _exerciseIndex++;
        _isReady = false;
      });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final exercises = widget.step.exercises;
    final isLast = _exerciseIndex >= exercises.length - 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_exerciseIndex + 1} / ${exercises.length}',
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
            exercise: exercises[_exerciseIndex],
            onReady: () => setState(() => _isReady = true),
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
              onPressed: _isReady ? (isLast ? widget.onComplete : _onNext) : null,
              child: Text(isLast ? l10n.completeStepButton : l10n.nextButton),
            ),
          ),
        ),
      ],
    );
  }
}
