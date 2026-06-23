import 'package:flutter/material.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_result.dart';
import 'package:linguobyte/features/lesson/domain/models/lesson_step.dart';
import 'package:linguobyte/features/lesson/presentation/widgets/exercise_phase_widget.dart';
import 'package:linguobyte/l10n/app_localizations.dart';

/// Финальные упражнения урока (segment_type = "final").
/// Держит счётчик упражнений; вызывает [onComplete] после последнего.
class FinalStepWidget extends StatefulWidget {
  final FinalLessonStep step;
  final VoidCallback onComplete;
  final ValueChanged<ExerciseResult>? onExerciseResult;

  const FinalStepWidget({
    super.key,
    required this.step,
    required this.onComplete,
    this.onExerciseResult,
  });

  @override
  State<FinalStepWidget> createState() => _FinalStepWidgetState();
}

class _FinalStepWidgetState extends State<FinalStepWidget> {
  int _exerciseIndex = 0;

  void _onNext() => setState(() => _exerciseIndex++);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ExercisePhaseWidget(
      exercises: widget.step.exercises,
      exerciseIndex: _exerciseIndex,
      onNext: _onNext,
      onComplete: widget.onComplete,
      onResult: widget.onExerciseResult,
      nextButtonLabel: l10n.nextButton,
      completeButtonLabel: l10n.completeStepButton,
    );
  }
}
