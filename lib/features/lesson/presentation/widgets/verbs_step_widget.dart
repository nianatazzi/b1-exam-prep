import 'package:flutter/material.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/features/lesson/domain/models/lesson_step.dart';
import 'package:linguobyte/features/lesson/presentation/widgets/exercise_widget.dart';
import 'package:linguobyte/features/lesson/presentation/widgets/verb_conjugation_table.dart';
import 'package:linguobyte/l10n/app_localizations.dart';

/// Шаг урока "Глаголы". Самостоятельно управляет суб-навигацией:
/// для каждого глагола — таблица → упражнения → следующий глагол.
/// Вызывает [onComplete] только после последнего упражнения последнего глагола.
class VerbsStepWidget extends StatefulWidget {
  final VerbsLessonStep step;
  final VoidCallback onComplete;

  const VerbsStepWidget({
    super.key,
    required this.step,
    required this.onComplete,
  });

  @override
  State<VerbsStepWidget> createState() => _VerbsStepWidgetState();
}

class _VerbsStepWidgetState extends State<VerbsStepWidget> {
  int _verbIndex = 0;
  bool _isExercisePhase = false;
  int _exerciseIndex = 0;

  VerbSubStep get _current => widget.step.verbSubSteps[_verbIndex];
  bool get _isLastVerb => _verbIndex >= widget.step.verbSubSteps.length - 1;

  void _onToExercises() => setState(() => _isExercisePhase = true);

  void _onNextExercise() => setState(() => _exerciseIndex++);

  void _onSubStepComplete() {
    if (_isLastVerb) {
      widget.onComplete();
    } else {
      setState(() {
        _verbIndex++;
        _isExercisePhase = false;
        _exerciseIndex = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final subStep = _current;
    return _isExercisePhase
        ? _ExercisePhase(
            subStep: subStep,
            exerciseIndex: _exerciseIndex,
            isLastVerb: _isLastVerb,
            onNext: _onNextExercise,
            onComplete: _onSubStepComplete,
          )
        : _ContentPhase(
            subStep: subStep,
            verbIndex: _verbIndex,
            totalVerbs: widget.step.verbSubSteps.length,
            isLastVerb: _isLastVerb,
            onToExercises: _onToExercises,
            onComplete: _onSubStepComplete,
          );
  }
}

// ── Фаза таблицы ─────────────────────────────────────────────────────────────

class _ContentPhase extends StatelessWidget {
  final VerbSubStep subStep;
  final int verbIndex;
  final int totalVerbs;
  final bool isLastVerb;
  final VoidCallback onToExercises;
  final VoidCallback onComplete;

  const _ContentPhase({
    required this.subStep,
    required this.verbIndex,
    required this.totalVerbs,
    required this.isLastVerb,
    required this.onToExercises,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final langCode = Localizations.localeOf(context).languageCode;
    final verb = subStep.verb;
    final transcription =
        (verb.transcription[langCode] ?? verb.transcription['en'] ?? '')
            .toString();
    final translation =
        (verb.translation[langCode] ?? verb.translation['en'] ?? '')
            .toString();

    final String buttonLabel;
    if (subStep.exercises.isNotEmpty) {
      buttonLabel = l10n.toExercisesButton;
    } else if (isLastVerb) {
      buttonLabel = l10n.completeStepButton;
    } else {
      buttonLabel = l10n.nextVerbButton;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (totalVerbs > 1)
          Text(
            '${verbIndex + 1} / $totalVerbs',
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.5),
            ),
          ),
        if (totalVerbs > 1) const SizedBox(height: AppSpacing.sm),

        // Название, транскрипция, перевод
        Text(
          verb.title,
          style: theme.textTheme.headlineSmall?.copyWith(color: cs.primary),
        ),
        if (transcription.isNotEmpty || translation.isNotEmpty)
          Text(
            [
              if (transcription.isNotEmpty) transcription,
              if (translation.isNotEmpty) translation,
            ].join(' · '),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.7),
            ),
          ),
        const SizedBox(height: AppSpacing.lg),

        // Таблица спряжения
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: VerbConjugationTable(conjugation: verb.conjugation),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed:
                subStep.exercises.isNotEmpty ? onToExercises : onComplete,
            child: Text(buttonLabel),
          ),
        ),
      ],
    );
  }
}

// ── Фаза упражнений ───────────────────────────────────────────────────────────

class _ExercisePhase extends StatelessWidget {
  final VerbSubStep subStep;
  final int exerciseIndex;
  final bool isLastVerb;
  final VoidCallback onNext;
  final VoidCallback onComplete;

  const _ExercisePhase({
    required this.subStep,
    required this.exerciseIndex,
    required this.isLastVerb,
    required this.onNext,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final exercises = subStep.exercises;
    final isLastExercise = exerciseIndex >= exercises.length - 1;

    final String buttonLabel;
    if (!isLastExercise) {
      buttonLabel = l10n.nextButton;
    } else if (isLastVerb) {
      buttonLabel = l10n.completeStepButton;
    } else {
      buttonLabel = l10n.nextVerbButton;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${exerciseIndex + 1} / ${exercises.length}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.5),
              ),
        ),
        const SizedBox(height: AppSpacing.lg),
        ExerciseWidget(exercise: exercises[exerciseIndex]),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLastExercise ? onComplete : onNext,
            child: Text(buttonLabel),
          ),
        ),
      ],
    );
  }
}
