import 'package:flutter/material.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/core/theme/app_colors.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_model.dart';
import 'package:linguobyte/features/lesson/presentation/widgets/exercises/exercise_feedback_banner.dart';
import 'package:linguobyte/l10n/app_localizations.dart';

class FillBlankExerciseWidget extends StatefulWidget {
  final ExerciseModel exercise;
  final VoidCallback onReady;

  const FillBlankExerciseWidget({
    super.key,
    required this.exercise,
    required this.onReady,
  });

  @override
  State<FillBlankExerciseWidget> createState() =>
      _FillBlankExerciseWidgetState();
}

class _FillBlankExerciseWidgetState extends State<FillBlankExerciseWidget> {
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
    final blanks =
        (td['blanks'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final accepted = blanks.isEmpty
        ? <String>[]
        : ((blanks[0]['accepted'] as List?) ?? []).cast<String>();
    _correctAnswer = accepted.isNotEmpty ? accepted.first : '';

    final userInput = _controller.text.trim().toLowerCase();
    final isCorrect =
        accepted.any((a) => a.toLowerCase() == userInput);

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

    final titleMap =
        (td['title'] as Map?)?.cast<String, dynamic>() ?? {};
    final title =
        (titleMap[langCode] ?? titleMap['en'] ?? '').toString();
    final promptsMap =
        (td['prompts'] as Map?)?.cast<String, dynamic>() ?? {};
    final prompt =
        (promptsMap[langCode] ?? promptsMap['en'] ?? '').toString();
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
        if (title.isNotEmpty) ...[
          Text(
            title,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: ac.textMuted),
          ),
          const SizedBox(height: AppSpacing.md),
        ],

        // Перевод-подсказка
        if (prompt.isNotEmpty) ...[
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
              prompt,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: ac.textSecondary),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],

        // Предложение с пропуском
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 2,
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
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: cs.primary, width: 2),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: ac.primaryGlow, width: 2),
                  ),
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: _isSubmitted ? feedbackColor : ac.textMuted,
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
        const SizedBox(height: AppSpacing.xl),

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
    );
  }
}
