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
    final blanks = (td['blanks'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    // whereType безопасно пропускает не-строки (на случай неверной схемы в Firestore)
    final accepted = blanks.isEmpty
        ? <String>[]
        : ((blanks[0]['accepted'] as List?) ?? []).whereType<String>().toList();
    _correctAnswer = accepted.isNotEmpty ? accepted.first : '';

    final userInput = _controller.text.trim().toLowerCase();
    setState(() {
      _isSubmitted = true;
      _isCorrect = accepted.any((a) => a.toLowerCase() == userInput);
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

        const Spacer(),

        // Перевод-подсказка
        if (prompt.isNotEmpty)
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

        const Spacer(),

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

        const Spacer(),

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
              onPressed: _controller.text.trim().isEmpty ? null : _check,
              child: Text(l10n.checkButton),
            ),
          ),
      ],
    );
  }
}
