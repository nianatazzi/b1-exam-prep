import 'package:flutter/material.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/core/utils/string_utils.dart';
import 'package:linguobyte/core/theme/app_colors.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_model.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_result.dart';
import 'package:linguobyte/features/lesson/presentation/widgets/exercises/exercise_feedback_banner.dart';
import 'package:linguobyte/l10n/app_localizations.dart';

class FillBlankExerciseWidget extends StatefulWidget {
  final ExerciseModel exercise;
  final VoidCallback onReady;
  final ValueChanged<ExerciseResult>? onResult;

  const FillBlankExerciseWidget({
    super.key,
    required this.exercise,
    required this.onReady,
    this.onResult,
  });

  @override
  State<FillBlankExerciseWidget> createState() =>
      _FillBlankExerciseWidgetState();
}

class _FillBlankExerciseWidgetState extends State<FillBlankExerciseWidget> {
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
    final blanks = (td['blanks'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    // whereType безопасно пропускает не-строки (на случай неверной схемы в Firestore)
    final accepted = blanks.isEmpty
        ? <String>[]
        : ((blanks[0]['accepted'] as List?) ?? []).whereType<String>().toList();
    _correctAnswer = accepted.isNotEmpty ? accepted.first : '';

    final userInput = normalizeAnswer(_controller.text);
    final bool exactMatch = accepted.any((a) => normalizeAnswer(a) == userInput);
    final bool accentMatch = !exactMatch &&
        accepted.any((a) =>
            normalizeAnswer(stripDiacritics(a)) ==
            normalizeAnswer(stripDiacritics(_controller.text)));
    // При совпадении без акцентов — находим каноническую форму для подсказки
    if (accentMatch) {
      _correctAnswer = accepted.firstWhere(
        (a) =>
            normalizeAnswer(stripDiacritics(a)) ==
            normalizeAnswer(stripDiacritics(_controller.text)),
        orElse: () => _correctAnswer,
      );
    }
    setState(() {
      _isSubmitted = true;
      _isCorrect = exactMatch || accentMatch;
      _hasDiacriticsMismatch = accentMatch;
    });
    widget.onResult?.call(ExerciseResult(
      exerciseId: widget.exercise.exId.toString(),
      isCorrect: _isCorrect,
      grammarTypes: widget.exercise.grammarTypes,
      userAnswer: _controller.text.trim(),
      correctAnswer: _correctAnswer,
      question: (widget.exercise.typeData?['sentence'] as String?) ?? '',
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

    final promptsMap = (td['prompts'] as Map?)?.cast<String, dynamic>() ?? {};
    final prompt = (promptsMap[langCode] ?? promptsMap['en'] ?? '').toString();

    final form = (td['form'] as String?) ?? '';
    final parts = form.split('[]');

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

        if (prompt.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xl),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: ac.primarySub,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cs.primary.withValues(alpha: 0.25)),
            ),
            child: Text(
              prompt,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: ac.textSecondary),
            ),
          ),
        ],

        const SizedBox(height: AppSpacing.xl),

        // Предложение с полем ввода
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 4,
          runSpacing: AppSpacing.sm,
          children: [
            if (parts.isNotEmpty && parts[0].isNotEmpty)
              Text(parts[0], style: theme.textTheme.titleMedium),
            SizedBox(
              width: 140,
              child: TextField(
                controller: _controller,
                enabled: !_isSubmitted,
                onChanged: (_) => setState(() {}),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: _isSubmitted ? feedbackColor : cs.primary,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 4,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: cs.primary, width: 2),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ac.primaryGlow, width: 2),
                  ),
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: _isSubmitted ? feedbackColor : ac.n500,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
            if (parts.length > 1 && parts[1].isNotEmpty)
              Text(parts[1], style: theme.textTheme.titleMedium),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),

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
