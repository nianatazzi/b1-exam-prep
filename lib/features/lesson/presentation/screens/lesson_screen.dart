import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:linguobyte/core/constants/app_routes.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/features/home/presentation/providers/home_notifier.dart';
import 'package:linguobyte/features/lesson/domain/models/lesson_step.dart';
import 'package:linguobyte/features/lesson/presentation/providers/lesson_notifier.dart';
import 'package:linguobyte/features/lesson/presentation/widgets/final_step_widget.dart';
import 'package:linguobyte/features/lesson/presentation/widgets/lesson_nav_panel.dart';
import 'package:linguobyte/features/lesson/presentation/widgets/lexical_step_widget.dart';
import 'package:linguobyte/features/lesson/presentation/widgets/theory_step_widget.dart';
import 'package:linguobyte/features/lesson/presentation/widgets/verbs_step_widget.dart';
import 'package:linguobyte/l10n/app_localizations.dart';

class LessonScreen extends ConsumerStatefulWidget {
  final String langId;
  final String lessonId;

  const LessonScreen({
    super.key,
    required this.langId,
    required this.lessonId,
  });

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  // Фаза внутри шага: false = контент, true = упражнения
  bool _isExercisePhase = false;
  int _exerciseIndex = 0;

  // Предыдущий viewIndex — для сброса фазы при навигации
  int? _lastViewIndex;

  // Сохраняем контейнер в initState — ref недоступен в dispose()
  late final ProviderContainer _container;

  @override
  void initState() {
    super.initState();
    _container = ProviderScope.containerOf(context, listen: false);
  }

  void _resetStepPhase() {
    setState(() {
      _isExercisePhase = false;
      _exerciseIndex = 0;
    });
  }

  void _onToExercises() => setState(() => _isExercisePhase = true);

  void _onNextExercise() => setState(() => _exerciseIndex++);

  Future<void> _onComplete() async {
    await ref
        .read(lessonProvider(widget.langId, widget.lessonId).notifier)
        .completeCurrentStep();
    _resetStepPhase();
  }

  void _onNavigateToStep(int index) {
    ref
        .read(lessonProvider(widget.langId, widget.lessonId).notifier)
        .navigateToStep(index);
    _resetStepPhase();
  }

  @override
  void dispose() {
    // ProviderContainer не привязан к lifecycle виджета — безопасно вызывать в dispose().
    // ref здесь уже деактивирован и недоступен.
    _container.invalidate(homeProvider);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lessonAsync =
        ref.watch(lessonProvider(widget.langId, widget.lessonId));

    return lessonAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.errorGeneric),
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton(
                onPressed: () => ref.invalidate(
                  lessonProvider(widget.langId, widget.lessonId),
                ),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      ),
      data: (state) {
        // Сбрасываем фазу при смене шага через навигацию
        if (_lastViewIndex != state.viewIndex) {
          _lastViewIndex = state.viewIndex;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _resetStepPhase();
          });
        }

        return Scaffold(
          appBar: _LessonAppBar(
            title: state.data.lesson.theme,
            progressIndex: state.progressIndex,
            totalSteps: state.data.steps.length,
            progressPercent: state.progressPercent,
            onContentsTap: () => showLessonNavPanel(
              context: context,
              steps: state.data.steps,
              additional: state.data.additional,
              progressIndex: state.progressIndex,
              viewIndex: state.viewIndex,
              onStepTap: _onNavigateToStep,
            ),
          ),
          body: state.viewIndex >= state.data.steps.length
              ? _LessonCompleteStub(
                  hasNextLesson: state.data.nextLesson != null,
                  onContinue: () => context.go(AppRoutes.home),
                )
              : _StepBody(
                  // Ключ сбрасывает внутренний стейт VerbsStepWidget при смене шага
                  key: ValueKey(state.viewIndex),
                  step: state.currentStep!,
                  isExercisePhase: _isExercisePhase,
                  exerciseIndex: _exerciseIndex,
                  onToExercises: _onToExercises,
                  onNextExercise: _onNextExercise,
                  onComplete: _onComplete,
                ),
        );
      },
    );
  }
}

// ── AppBar с прогресс-баром ──────────────────────────────────────────────────

class _LessonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int progressIndex;
  final int totalSteps;
  final double progressPercent;
  final VoidCallback onContentsTap;

  const _LessonAppBar({
    required this.title,
    required this.progressIndex,
    required this.totalSteps,
    required this.progressPercent,
    required this.onContentsTap,
  });

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + _progressBarHeight);

  static const double _progressBarHeight = 36.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          icon: const Icon(Icons.menu_book_rounded),
          tooltip: l10n.lessonContents,
          onPressed: onContentsTap,
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(_progressBarHeight),
        child: GestureDetector(
          onTap: onContentsTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: progressPercent,
                    borderRadius: BorderRadius.circular(99),
                    valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                    backgroundColor: cs.primary.withValues(alpha: 0.15),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '$progressIndex / $totalSteps',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.6),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Тело шага ────────────────────────────────────────────────────────────────

class _StepBody extends StatelessWidget {
  final LessonStep step;
  final bool isExercisePhase;
  final int exerciseIndex;
  final VoidCallback onToExercises;
  final VoidCallback onNextExercise;
  final VoidCallback onComplete;

  const _StepBody({
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
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: switch (step) {
        TheoryLessonStep s => TheoryStepWidget(
            step: s,
            isExercisePhase: isExercisePhase,
            exerciseIndex: exerciseIndex,
            onToExercises: onToExercises,
            onNextExercise: onNextExercise,
            onComplete: onComplete,
          ),
        LexicalLessonStep s => LexicalStepWidget(
            step: s,
            isExercisePhase: isExercisePhase,
            exerciseIndex: exerciseIndex,
            onToExercises: onToExercises,
            onNextExercise: onNextExercise,
            onComplete: onComplete,
          ),
        // VerbsStepWidget управляет суб-навигацией самостоятельно
        VerbsLessonStep s => VerbsStepWidget(
            step: s,
            onComplete: onComplete,
          ),
        // FinalStepWidget управляет счётчиком упражнений самостоятельно
        FinalLessonStep s => FinalStepWidget(
            step: s,
            onComplete: onComplete,
          ),
      },
    );
  }
}

// ── Завершение урока / курса (заглушка) ──────────────────────────────────────

class _LessonCompleteStub extends StatelessWidget {
  final bool hasNextLesson;
  final VoidCallback onContinue;

  const _LessonCompleteStub({
    required this.hasNextLesson,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_rounded,
              size: 72,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              hasNextLesson
                  ? l10n.lessonCompleteTitle
                  : l10n.courseCompleteTitle,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onContinue,
                child: Text(l10n.backToHomeButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
