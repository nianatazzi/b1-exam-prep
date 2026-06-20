import 'package:flutter/material.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/core/theme/app_colors.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_model.dart';
import 'package:linguobyte/features/lesson/presentation/widgets/exercises/exercise_feedback_banner.dart';
import 'package:linguobyte/l10n/app_localizations.dart';

class TranslateSentenceExerciseWidget extends StatefulWidget {
  final ExerciseModel exercise;
  final VoidCallback onReady;

  const TranslateSentenceExerciseWidget({
    super.key,
    required this.exercise,
    required this.onReady,
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
    if (pattern.isNotEmpty) {
      bool regexMatch;
      try {
        regexMatch = RegExp(pattern).hasMatch(userInput);
      } on FormatException {
        // Невалидный regex в Firestore — откатываемся к строковому сравнению
        regexMatch = userInput.toLowerCase() == _correctAnswer.toLowerCase();
      }
      isCorrect = regexMatch;
    } else {
      isCorrect = userInput.toLowerCase() == _correctAnswer.toLowerCase();
    }

    setState(() {
      _isSubmitted = true;
      _isCorrect = isCorrect;
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

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (title.isNotEmpty)
                  Text(
                    title,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(color: ac.textPrimary),
                  ),

                // Исходное предложение для перевода
                if (question.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                      vertical: AppSpacing.lg,
                    ),
                    decoration: BoxDecoration(
                      color: ac.primarySub,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: cs.primary.withValues(alpha: 0.25)),
                    ),
                    child: Text(
                      question,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: ac.textPrimary),
                    ),
                  ),

                // Поле ввода перевода
                TextField(
                  controller: _controller,
                  enabled: !_isSubmitted,
                  onChanged: (_) => setState(() {}),
                  maxLines: 3,
                  minLines: 2,
                  style:
                      theme.textTheme.bodyLarge?.copyWith(color: ac.textPrimary),
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

                if (_isSubmitted)
                  ExerciseFeedbackBanner(
                    isCorrect: _isCorrect,
                    correctAnswer: _correctAnswer,
                    color: feedbackColor,
                    backgroundColor: feedbackBg,
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          _controller.text.trim().isEmpty ? null : _check,
                      child: Text(l10n.checkButton),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
