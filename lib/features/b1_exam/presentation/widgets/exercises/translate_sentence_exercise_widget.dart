import 'package:flutter/material.dart';
import 'package:b1_exam_prep/core/constants/app_spacing.dart';
import 'package:b1_exam_prep/core/utils/string_utils.dart';
import 'package:b1_exam_prep/core/theme/app_colors.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/exercise_model.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/exercise_result.dart';
import 'package:b1_exam_prep/features/b1_exam/presentation/widgets/exercises/exercise_feedback_banner.dart';
import 'package:b1_exam_prep/l10n/app_localizations.dart';

class TranslateSentenceExerciseWidget extends StatefulWidget {
  final ExerciseModel exercise;
  final VoidCallback onReady;
  final ValueChanged<ExerciseResult>? onResult;

  const TranslateSentenceExerciseWidget({
    super.key,
    required this.exercise,
    required this.onReady,
    this.onResult,
  });

  @override
  State<TranslateSentenceExerciseWidget> createState() =>
      _TranslateSentenceExerciseWidgetState();
}

class _TranslateSentenceExerciseWidgetState
    extends State<TranslateSentenceExerciseWidget> {
  final _controller = TextEditingController();
  bool _isSubmitted = false;
  bool _isCorrect = false;
  bool _hasDiacriticsMismatch = false;
  String _correctAnswer = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _check() {
    final td = widget.exercise.typeData ?? {};
    final langCode = Localizations.localeOf(context).languageCode;

    final correctAnswerMap =
        (td['correct_answer'] as Map?)?.cast<String, dynamic>() ?? {};
    _correctAnswer =
        (correctAnswerMap[langCode] ?? correctAnswerMap['en'] ?? '').toString();

    final patternMap =
        (td['correct_pattern'] as Map?)?.cast<String, dynamic>() ?? {};
    final pattern = (patternMap[langCode] ?? '').toString();

    final userInput = _controller.text.trim();
    final bool isCorrect;
    bool accentMatch = false;

    if (pattern.isNotEmpty) {
      bool regexMatch;
      try {
        regexMatch = RegExp(pattern).hasMatch(userInput);
      } on FormatException {
        // Невалидный regex в Firestore — откатываемся к строковому сравнению
        regexMatch = normalizeAnswer(userInput) == normalizeAnswer(_correctAnswer);
        if (!regexMatch) {
          accentMatch = normalizeAnswer(stripDiacritics(userInput)) ==
              normalizeAnswer(stripDiacritics(_correctAnswer));
          regexMatch = accentMatch;
        }
      }
      isCorrect = regexMatch;
    } else {
      final exactMatch =
          normalizeAnswer(userInput) == normalizeAnswer(_correctAnswer);
      if (!exactMatch) {
        accentMatch = normalizeAnswer(stripDiacritics(userInput)) ==
            normalizeAnswer(stripDiacritics(_correctAnswer));
      }
      isCorrect = exactMatch || accentMatch;
    }

    setState(() {
      _isSubmitted = true;
      _isCorrect = isCorrect;
      _hasDiacriticsMismatch = accentMatch;
    });
    widget.onResult?.call(ExerciseResult(
      exerciseId: widget.exercise.exId.toString(),
      isCorrect: isCorrect,
      grammarTypes: widget.exercise.grammarTypes,
      userAnswer: userInput,
      correctAnswer: _correctAnswer,
      question: (widget.exercise.typeData?['question'] as String?) ?? '',
    ));
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
    final question = (td['question'] as String?) ?? '';

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
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(color: ac.textPrimary),
          ),

        if (question.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.lg,
            ),
            decoration: BoxDecoration(
              color: ac.primarySub,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cs.primary.withValues(alpha: 0.25)),
            ),
            child: Text(
              question,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(color: ac.textPrimary),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],

        TextField(
          controller: _controller,
          enabled: !_isSubmitted,
          onChanged: (_) => setState(() {}),
          maxLines: 3,
          minLines: 2,
          style: theme.textTheme.bodyLarge?.copyWith(color: ac.textPrimary),
          decoration: InputDecoration(
            hintText: l10n.answerHint,
            hintStyle:
                theme.textTheme.bodyLarge?.copyWith(color: ac.textMuted),
            filled: true,
            fillColor: ac.surfaceOverlay,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: ac.n500, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: cs.primary, width: 1.5),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: ac.n600, width: 1),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        if (_isSubmitted)
          ExerciseFeedbackBanner(
            isCorrect: _isCorrect,
            correctAnswer: _correctAnswer,
            color: feedbackColor,
            backgroundColor: feedbackBg,
            accentWarning: _hasDiacriticsMismatch ? l10n.accentWarning : null,
          )
        else
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _controller.text.trim().isEmpty ? null : _check,
              child: Text(l10n.checkButton),
            ),
          ),
      ],
    );
  }
}
