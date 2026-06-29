import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/features/b1_exam/domain/models/prep_step.dart';
import 'package:linguobyte/features/b1_exam/presentation/providers/practice_notifier.dart';
import 'package:linguobyte/features/b1_exam/presentation/widgets/grammar_table_widget.dart';
import 'package:linguobyte/features/b1_exam/presentation/widgets/phrase_card_widget.dart';
import 'package:linguobyte/features/lesson/presentation/widgets/exercise_phase_widget.dart';
import 'package:linguobyte/l10n/app_localizations.dart';
import 'package:linguobyte/shared/widgets/error_view.dart';

class PracticeScreen extends ConsumerWidget {
  final String sectionId;
  final String topicId;
  final String prepLevel;

  const PracticeScreen({
    super.key,
    required this.sectionId,
    required this.topicId,
    required this.prepLevel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(
      practiceNotifierProvider(sectionId, topicId, prepLevel),
    );
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(_prepLevelTitle(l10n)),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorView(
          message: l10n.errorGeneric,
          onRetry: () => ref.invalidate(
            practiceNotifierProvider(sectionId, topicId, prepLevel),
          ),
        ),
        data: (data) {
          if (data.isCompleted) {
            return _CompletedView(
              results: data.results,
              onBack: () => context.pop(),
            );
          }

          if (data.isContentPhase) {
            return _ContentPhase(
              step: data.step,
              onContinue: () {
                ref
                    .read(practiceNotifierProvider(
                      sectionId,
                      topicId,
                      prepLevel,
                    ).notifier)
                    .switchToExercises();
              },
            );
          }

          if (data.exercises.isEmpty) {
            return Center(
              child: Text(l10n.b1NoExercises),
            );
          }

          return ExercisePhaseWidget(
            exercises: data.exercises,
            exerciseIndex: data.exerciseIndex,
            nextButtonLabel: l10n.continueLabel,
            completeButtonLabel: l10n.b1CompleteLevel,
            onResult: (result) {
              ref
                  .read(practiceNotifierProvider(
                    sectionId,
                    topicId,
                    prepLevel,
                  ).notifier)
                  .recordResult(result);
            },
            onNext: () {
              ref
                  .read(practiceNotifierProvider(
                    sectionId,
                    topicId,
                    prepLevel,
                  ).notifier)
                  .nextExercise();
            },
            onComplete: () {
              // TODO: передать sectionType и topicTId для записи прогресса
              context.pop();
            },
          );
        },
      ),
    );
  }

  String _prepLevelTitle(AppLocalizations l10n) => switch (prepLevel) {
        'vocabulary' => l10n.b1Vocabulary,
        'grammar' => l10n.b1Grammar,
        'phrases' => l10n.b1Phrases,
        _ => '',
      };
}

class _ContentPhase extends StatelessWidget {
  final PrepStep step;
  final VoidCallback onContinue;

  const _ContentPhase({required this.step, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Expanded(
          child: switch (step) {
            VocabularyPrepStep(:final vocabulary) => ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: vocabulary.length,
                itemBuilder: (context, index) {
                  final word = vocabulary[index];
                  return Card(
                    child: ListTile(
                      title: Text(word.word),
                      subtitle: Text(word.transcription),
                      trailing: word.gender != null
                          ? Chip(label: Text(word.gender!))
                          : null,
                    ),
                  );
                },
              ),
            GrammarPrepStep(:final rules) => ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: rules.length,
                itemBuilder: (context, index) =>
                    GrammarTableWidget(rule: rules[index]),
              ),
            PhrasesPrepStep(:final phrases) => ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: phrases.length,
                itemBuilder: (context, index) =>
                    PhraseCardWidget(phrase: phrases[index]),
              ),
          },
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onContinue,
              child: Text(l10n.b1StartExercises),
            ),
          ),
        ),
      ],
    );
  }
}

class _CompletedView extends StatelessWidget {
  final List results;
  final VoidCallback onBack;

  const _CompletedView({required this.results, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.b1LevelCompleted,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: onBack,
            child: Text(l10n.back),
          ),
        ],
      ),
    );
  }
}
