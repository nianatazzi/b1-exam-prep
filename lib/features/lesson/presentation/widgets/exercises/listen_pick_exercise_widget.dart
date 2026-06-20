import 'package:flutter/material.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/core/theme/app_colors.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_model.dart';
import 'package:linguobyte/features/lesson/presentation/widgets/exercises/exercise_feedback_banner.dart';
import 'package:linguobyte/l10n/app_localizations.dart';
import 'package:linguobyte/shared/widgets/audio_play_button.dart';

class ListenPickExerciseWidget extends StatefulWidget {
  final ExerciseModel exercise;
  final VoidCallback onReady;

  const ListenPickExerciseWidget({
    super.key,
    required this.exercise,
    required this.onReady,
  });

  @override
  State<ListenPickExerciseWidget> createState() =>
      _ListenPickExerciseWidgetState();
}

class _ListenPickExerciseWidgetState extends State<ListenPickExerciseWidget> {
  int? _selectedIndex;
  bool _isSubmitted = false;
  bool _isCorrect = false;

  void _check() {
    final td = widget.exercise.typeData ?? {};
    final answerIndex = (td['answer_index'] as num?)?.toInt() ?? 0;
    setState(() {
      _isSubmitted = true;
      _isCorrect = _selectedIndex == answerIndex;
    });
    widget.onReady();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ac = theme.extension<AppColors>()!;
    final td = widget.exercise.typeData ?? {};
    final langCode = Localizations.localeOf(context).languageCode;

    final titleMap = (td['title'] as Map?)?.cast<String, dynamic>() ?? {};
    final title = (titleMap[langCode] ?? titleMap['en'] ?? '').toString();

    final variants = (td['variants'] as List?)?.cast<String>() ?? [];
    final answerIndex = (td['answer_index'] as num?)?.toInt() ?? 0;
    final transcript = (td['transcript'] as String?) ?? '';
    final audioUrl = widget.exercise.audioUrl;

    final correctAnswer = answerIndex < variants.length
        ? variants[answerIndex]
        : '';

    final Color feedbackColor;
    final Color feedbackBg;
    if (_isSubmitted) {
      feedbackColor = _isCorrect ? ac.success : cs.error;
      feedbackBg = _isCorrect ? ac.successSub : ac.errorSub;
    } else {
      feedbackColor = Colors.transparent;
      feedbackBg = Colors.transparent;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: ac.textMuted),
            ),
          ),

        const Spacer(),

        Center(child: AudioPlayButton(audioUrl: audioUrl)),

        const Spacer(),

        // Варианты ответа
        Column(
          children: List.generate(variants.length, (i) {
            final isSelected = _selectedIndex == i;
            final isCorrectItem = i == answerIndex;

            final Color borderColor;
            final Color bgColor;
            if (_isSubmitted) {
              if (isCorrectItem) {
                borderColor = ac.success;
                bgColor = ac.successSub;
              } else if (isSelected) {
                borderColor = cs.error;
                bgColor = ac.errorSub;
              } else {
                borderColor = ac.n600;
                bgColor = Colors.transparent;
              }
            } else {
              borderColor = isSelected ? cs.primary : ac.n600;
              bgColor = isSelected ? ac.primarySub : Colors.transparent;
            }

            return GestureDetector(
              onTap: _isSubmitted ? null : () {
                setState(() => _selectedIndex = i);
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        variants[i],
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(color: ac.textPrimary),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    _RadioCircle(
                      selected: isSelected,
                      submitted: _isSubmitted,
                      isCorrect: isCorrectItem,
                    ),
                  ],
                ),
              ),
            );
          }),
        ),

        const Spacer(),

        if (_isSubmitted) ...[
          ExerciseFeedbackBanner(
            isCorrect: _isCorrect,
            correctAnswer: correctAnswer,
            color: feedbackColor,
            backgroundColor: feedbackBg,
          ),
          if (transcript.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: ac.surfaceOverlay,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                transcript,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: ac.textSecondary),
              ),
            ),
          ],
        ] else
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedIndex == null ? null : _check,
              child: Text(l10n.checkButton),
            ),
          ),
      ],
    );
  }
}

class _RadioCircle extends StatelessWidget {
  final bool selected;
  final bool submitted;
  final bool isCorrect;

  const _RadioCircle({
    required this.selected,
    required this.submitted,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ac = Theme.of(context).extension<AppColors>()!;

    final Color borderColor;
    final Color? fillColor;

    if (submitted) {
      if (isCorrect) {
        borderColor = ac.success;
        fillColor = selected ? ac.success : null;
      } else if (selected) {
        borderColor = cs.error;
        fillColor = cs.error;
      } else {
        borderColor = ac.n600;
        fillColor = null;
      }
    } else {
      borderColor = selected ? cs.primary : ac.n600;
      fillColor = selected ? cs.primary : null;
    }

    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
        color: fillColor,
      ),
      child: fillColor != null
          ? Icon(Icons.check, size: 12, color: cs.onPrimary)
          : null,
    );
  }
}
