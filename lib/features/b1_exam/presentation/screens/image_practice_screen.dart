import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:b1_exam_prep/core/constants/app_spacing.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/free_practice_analysis_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/image_practice_step.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/misused_word_model.dart';
import 'package:b1_exam_prep/features/b1_exam/presentation/providers/image_practice_notifier.dart';
import 'package:b1_exam_prep/features/b1_exam/presentation/widgets/free_practice_view.dart';
import 'package:b1_exam_prep/features/b1_exam/presentation/widgets/grammar_table_widget.dart';
import 'package:b1_exam_prep/features/b1_exam/presentation/widgets/phrase_card_widget.dart';
import 'package:b1_exam_prep/features/b1_exam/presentation/widgets/exercise_phase_widget.dart';
import 'package:b1_exam_prep/l10n/app_localizations.dart';
import 'package:b1_exam_prep/shared/widgets/error_view.dart';

/// Фиксированная последовательность image_description (Фаза 1):
/// глаголы (спряжение) → существительные (склонение) → фразы → свободная
/// практика. См. docs/ARCHITECTURE.md §6.1 и ImagePracticeNotifier.
class ImagePracticeScreen extends ConsumerStatefulWidget {
  final String sectionId;
  final String topicId;

  const ImagePracticeScreen({
    super.key,
    required this.sectionId,
    required this.topicId,
  });

  @override
  ConsumerState<ImagePracticeScreen> createState() =>
      _ImagePracticeScreenState();
}

class _ImagePracticeScreenState extends ConsumerState<ImagePracticeScreen> {
  bool _isSubmittingFreePractice = false;

  @override
  Widget build(BuildContext context) {
    final provider =
        imagePracticeProvider(widget.sectionId, widget.topicId);
    final state = ref.watch(provider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(state.asData?.value.topic.title ?? ''),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorView(
          message: l10n.errorGeneric,
          onRetry: () => ref.invalidate(provider),
        ),
        data: (data) {
          if (data.isCompleted) {
            return _CompletedView(
              analysis: data.analysis,
              onBack: () => context.pop(),
            );
          }

          if (data.isFreePractice) {
            return FreePracticeView(
              topic: data.topic,
              isSubmitting: _isSubmittingFreePractice,
              onSubmit: (transcript, durationSeconds) async {
                setState(() => _isSubmittingFreePractice = true);
                final uiLanguage = Localizations.localeOf(context).languageCode;
                await ref.read(provider.notifier).submitFreePractice(
                      sectionType: widget.sectionId,
                      transcript: transcript,
                      durationSeconds: durationSeconds,
                      uiLanguage: uiLanguage,
                    );
                if (mounted) {
                  setState(() => _isSubmittingFreePractice = false);
                }
              },
            );
          }

          final step = data.currentStep;
          if (step == null) {
            return Center(child: Text(l10n.b1NoExercises));
          }

          if (data.isContentPhase) {
            return _ContentPhase(
              step: step,
              onContinue: () =>
                  ref.read(provider.notifier).switchToExercises(),
            );
          }

          if (data.exercises.isEmpty) {
            return Center(child: Text(l10n.b1NoExercises));
          }

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: ExercisePhaseWidget(
              exercises: data.exercises,
              exerciseIndex: data.exerciseIndex,
              nextButtonLabel: l10n.continueLabel,
              completeButtonLabel: l10n.continueLabel,
              autoAdvance: step is VerbConjugationStep,
              onResult: (result) =>
                  ref.read(provider.notifier).recordResult(result),
              onNext: () => ref.read(provider.notifier).nextExercise(),
              onComplete: () =>
                  ref.read(provider.notifier).finishCurrentStep(
                        widget.sectionId,
                      ),
            ),
          );
        },
      ),
    );
  }
}

class _ContentPhase extends StatelessWidget {
  final ImagePracticeStep step;
  final VoidCallback onContinue;

  const _ContentPhase({required this.step, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            0,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _stepTitle(step, l10n),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        Expanded(
          child: switch (step) {
            VerbConjugationStep(:final rules) => ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: rules.length,
                itemBuilder: (context, index) =>
                    GrammarTableWidget(rule: rules[index]),
              ),
            NounDeclensionStep(:final rules) => ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: rules.length,
                itemBuilder: (context, index) =>
                    GrammarTableWidget(rule: rules[index]),
              ),
            IntroPhrasesStep(:final phrases) => ListView.builder(
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

String _stepTitle(ImagePracticeStep step, AppLocalizations l10n) =>
    switch (step) {
      VerbConjugationStep() => l10n.b1VerbConjugation,
      NounDeclensionStep() => l10n.b1NounDeclension,
      IntroPhrasesStep() => l10n.b1Phrases,
    };

class _CompletedView extends StatelessWidget {
  final FreePracticeAnalysisModel? analysis;
  final VoidCallback onBack;

  const _CompletedView({required this.analysis, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final misusedWords = analysis?.misusedWords ?? const [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: Icon(
              Icons.check_circle_outline,
              size: 80,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: Text(
              l10n.b1LevelCompleted,
              style: theme.textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          if (analysis == null)
            Text(
              l10n.b1AnalysisUnavailable,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            )
          else if (misusedWords.isEmpty)
            Text(
              l10n.b1AnalysisNoMistakes,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            )
          else ...[
            Text(l10n.b1AnalysisTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            ...misusedWords.map((word) => _MisusedWordCard(word: word)),
          ],
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

class _MisusedWordCard extends StatelessWidget {
  final MisusedWordModel word;

  const _MisusedWordCard({required this.word});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final typeLabel = switch (word.type) {
      MisusedWordType.verb => l10n.b1WordTypeVerb,
      MisusedWordType.noun => l10n.b1WordTypeNoun,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Chip(label: Text(typeLabel)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    word.word,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${l10n.b1AnalysisYouSaid}: ${word.userForm}',
              style: theme.textTheme.bodyMedium,
            ),
            Text(
              '${l10n.b1AnalysisCorrectForm}: ${word.correctForm}',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            if (word.explanation.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                word.explanation,
                style: theme.textTheme.bodySmall
                    ?.copyWith(fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
