import 'package:flutter/material.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/features/lesson/domain/models/lesson_step.dart';
import 'package:linguobyte/features/lesson/presentation/widgets/exercise_widget.dart';
import 'package:linguobyte/l10n/app_localizations.dart';

class VerbsStepWidget extends StatelessWidget {
  final VerbsLessonStep step;
  final bool isExercisePhase;
  final int exerciseIndex;
  final VoidCallback onToExercises;
  final VoidCallback onNextExercise;
  final VoidCallback onComplete;

  const VerbsStepWidget({
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
  final VerbsLessonStep step;
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

    // Заголовки колонок из ключей conjugation первого глагола
    final columns = step.verbs.isNotEmpty
        ? step.verbs.first.conjugation.keys.toList()
        : <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.verbsSection, style: theme.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.lg),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: _VerbTable(
                verbs: step.verbs
                    .map((v) => (
                          title: v.title,
                          translation: v.translation,
                          conjugation: v.conjugation,
                        ))
                    .toList(),
                columns: columns,
                cs: cs,
                theme: theme,
                langCode: Localizations.localeOf(context).languageCode,
              ),
            ),
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

class _VerbTable extends StatelessWidget {
  final List<({String title, Map<String, dynamic> translation, Map<String, dynamic> conjugation})>
      verbs;
  final List<String> columns;
  final ColorScheme cs;
  final ThemeData theme;
  final String langCode;

  const _VerbTable({
    required this.verbs,
    required this.columns,
    required this.cs,
    required this.theme,
    required this.langCode,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final headerStyle = theme.textTheme.bodySmall?.copyWith(
      fontWeight: FontWeight.w600,
      color: cs.primary,
    );
    final cellStyle = theme.textTheme.bodyMedium;

    return Table(
      border: TableBorder.all(
        color: cs.onSurface.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      defaultColumnWidth: const IntrinsicColumnWidth(),
      children: [
        // Заголовочная строка
        TableRow(
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.08),
          ),
          children: [
            _cell('', headerStyle),
            _cell(l10n.verbTranslationColumn, headerStyle),
            for (final col in columns) _cell(col, headerStyle),
          ],
        ),
        // Строки глаголов
        for (final verb in verbs)
          TableRow(
            children: [
              _cell(verb.title, cellStyle),
              _cell(
                  (verb.translation[langCode] ?? verb.translation['en'] ?? '—')
                      .toString(),
                  cellStyle?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.6))),
              for (final col in columns)
                _cell(verb.conjugation[col]?.toString() ?? '—', cellStyle),
            ],
          ),
      ],
    );
  }

  Widget _cell(String text, TextStyle? style) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Text(text, style: style),
      );
}

class _ExercisePhase extends StatelessWidget {
  final VerbsLessonStep step;
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
