import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:b1_exam_prep/core/constants/app_routes.dart';
import 'package:b1_exam_prep/core/constants/app_spacing.dart';
import 'package:b1_exam_prep/core/utils/localized_text.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/exercise_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/lesson_step.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/speech_error_model.dart';
import 'package:b1_exam_prep/features/b1_exam/presentation/providers/lesson_notifier.dart';
import 'package:b1_exam_prep/features/b1_exam/presentation/providers/oral_step_outcome.dart';
import 'package:b1_exam_prep/features/b1_exam/presentation/widgets/exercise_phase_widget.dart';
import 'package:b1_exam_prep/features/b1_exam/presentation/widgets/free_practice_view.dart';
import 'package:b1_exam_prep/l10n/app_localizations.dart';
import 'package:b1_exam_prep/shared/models/study_language.dart';
import 'package:b1_exam_prep/shared/widgets/error_view.dart';

/// Флоу урока (Lesson Matrix §0): три капа упражнений (verb → noun → phrase)
/// → три устных упражнения подряд (image → monologue → dialogue). Диалог —
/// отдельный маршрут (DialogueScreen), сюда возвращается уже с итогом.
class LessonScreen extends ConsumerWidget {
  final String langId;
  final String lessonId;

  const LessonScreen({super.key, required this.langId, required this.lessonId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = lessonProvider(langId, lessonId);
    final state = ref.watch(provider);
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    // langId всегда валиден (route дошёл сюда только через валидный
    // StudyLanguage, см. B1HomeScreen/LexicalTopicLessonsScreen).
    final sttLocaleId = StudyLanguage.fromCode(langId)!.sttLocaleId;

    return Scaffold(
      appBar: AppBar(
        title: state.maybeWhen(
          data: (data) => Text(
            '${data.lexicalTopic.title} · ${data.grammarTopic.title}',
          ),
          orElse: () => null,
        ),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorView(
          message: l10n.errorGeneric,
          onRetry: () => ref.invalidate(provider),
        ),
        data: (data) {
          if (data.isComplete) {
            return _LessonSummaryView(
              oralOutcomes: data.oralOutcomes,
              onBack: () => context.pop(),
            );
          }

          return switch (data.currentStep) {
            VerbBlockStep(:final exercises) ||
            NounBlockStep(:final exercises) ||
            PhraseBlockStep(:final exercises) =>
              _BlockExerciseView(
                langId: langId,
                lessonId: lessonId,
                exercises: exercises,
                exerciseIndex: data.exerciseIndex,
              ),
            ImageStep(:final task) => _OralStepView(
                langId: langId,
                lessonId: lessonId,
                oralStep: OralStep.image,
                title: l10n.b1ImageDescription,
                imageUrl: task.imageUrl,
                promptText: '',
                pointsToDescribe:
                    localizedTextList(task.pointsToDescribe, locale),
                durationSeconds: data.durationSeconds,
                sttLocaleId: sttLocaleId,
                isSubmitting: data.isSubmittingOralStep,
              ),
            MonologueStep(:final task) => _OralStepView(
                langId: langId,
                lessonId: lessonId,
                oralStep: OralStep.monologue,
                title: l10n.b1Monologue,
                imageUrl: null,
                promptText: localizedText(task.prompt, locale),
                pointsToDescribe: localizedTextList(task.points, locale),
                durationSeconds: data.durationSeconds,
                sttLocaleId: sttLocaleId,
                isSubmitting: data.isSubmittingOralStep,
              ),
            DialogueStep() =>
              _DialogueEntryView(langId: langId, lessonId: lessonId),
            null => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}

class _BlockExerciseView extends ConsumerWidget {
  final String langId;
  final String lessonId;
  final List<ExerciseModel> exercises;
  final int exerciseIndex;

  const _BlockExerciseView({
    required this.langId,
    required this.lessonId,
    required this.exercises,
    required this.exerciseIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    if (exercises.isEmpty) {
      return Center(child: Text(l10n.b1NoExercises));
    }

    final notifier = ref.read(lessonProvider(langId, lessonId).notifier);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: ExercisePhaseWidget(
        exercises: exercises,
        exerciseIndex: exerciseIndex,
        nextButtonLabel: l10n.continueLabel,
        completeButtonLabel: l10n.b1CompleteLevel,
        onResult: notifier.recordExerciseResult,
        onNext: notifier.nextExercise,
        onComplete: notifier.finishBlockStep,
      ),
    );
  }
}

class _OralStepView extends ConsumerWidget {
  final String langId;
  final String lessonId;
  final OralStep oralStep;
  final String title;
  final String? imageUrl;
  final String promptText;
  final List<String> pointsToDescribe;
  final int durationSeconds;
  final String sttLocaleId;
  final bool isSubmitting;

  const _OralStepView({
    required this.langId,
    required this.lessonId,
    required this.oralStep,
    required this.title,
    required this.imageUrl,
    required this.promptText,
    required this.pointsToDescribe,
    required this.durationSeconds,
    required this.sttLocaleId,
    required this.isSubmitting,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).languageCode;

    return FreePracticeView(
      imageUrl: imageUrl,
      promptText: promptText.isNotEmpty ? promptText : title,
      pointsToDescribe: pointsToDescribe,
      durationSeconds: durationSeconds,
      sttLocaleId: sttLocaleId,
      isSubmitting: isSubmitting,
      onSubmit: (transcript, _) => ref
          .read(lessonProvider(langId, lessonId).notifier)
          .submitOralStep(
            oralStep: oralStep,
            transcript: transcript,
            uiLanguage: locale,
          ),
    );
  }
}

class _DialogueEntryView extends ConsumerWidget {
  final String langId;
  final String lessonId;

  const _DialogueEntryView({required this.langId, required this.lessonId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.b1Dialogue,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: () async {
                final outcome = await context.push<OralStepOutcome>(
                  AppRoutes.b1DialoguePath(langId, lessonId),
                );
                if (outcome != null && context.mounted) {
                  ref
                      .read(lessonProvider(langId, lessonId).notifier)
                      .completeDialogueStep(outcome);
                }
              },
              child: Text(l10n.b1DialogueStart),
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonSummaryView extends StatelessWidget {
  final Map<OralStep, OralStepOutcome> oralOutcomes;
  final VoidCallback onBack;

  const _LessonSummaryView({
    required this.oralOutcomes,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 80,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: Text(
              l10n.b1LessonComplete,
              style: theme.textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          for (final entry in oralOutcomes.entries)
            _OralOutcomeCard(oralStep: entry.key, outcome: entry.value),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(onPressed: onBack, child: Text(l10n.back)),
        ],
      ),
    );
  }
}

class _OralOutcomeCard extends StatelessWidget {
  final OralStep oralStep;
  final OralStepOutcome outcome;

  const _OralOutcomeCard({required this.oralStep, required this.outcome});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final title = switch (oralStep) {
      OralStep.image => l10n.b1ImageDescription,
      OralStep.monologue => l10n.b1Monologue,
      OralStep.dialogue => l10n.b1Dialogue,
    };

    final analysis = outcome.analysis;
    final misused = <SpeechErrorModel>[
      ...?analysis?.targetGrammarErrors,
      ...?analysis?.otherGrammarErrors,
      ...?analysis?.lexicalErrors,
    ];

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                if (outcome.score != null)
                  Text(
                    '${outcome.score}/100',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            if (analysis == null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(l10n.b1AnalysisUnavailable, style: theme.textTheme.bodyMedium),
            ] else if (misused.isEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(l10n.b1NoMisusedWords, style: theme.textTheme.bodyMedium),
            ] else ...[
              const SizedBox(height: AppSpacing.sm),
              Text(l10n.b1RemedialReviewTitle, style: theme.textTheme.labelLarge),
              const SizedBox(height: AppSpacing.xs),
              for (final error in misused)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Text(
                    '${error.userForm} → ${error.correctForm}',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
