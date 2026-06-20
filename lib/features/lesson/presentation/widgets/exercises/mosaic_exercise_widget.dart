import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/core/theme/app_colors.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_model.dart';
import 'package:linguobyte/features/lesson/presentation/widgets/exercises/exercise_feedback_banner.dart';
import 'package:linguobyte/l10n/app_localizations.dart';

class MosaicExerciseWidget extends StatefulWidget {
  final ExerciseModel exercise;
  final VoidCallback onReady;

  const MosaicExerciseWidget({
    super.key,
    required this.exercise,
    required this.onReady,
  });

  @override
  State<MosaicExerciseWidget> createState() => _MosaicExerciseWidgetState();
}

class _MosaicExerciseWidgetState extends State<MosaicExerciseWidget> {
  late final List<String> _allBankChunks;
  late final List<bool> _isUsed;
  final List<({String label, int bankIndex})> _answer = [];
  bool _isSubmitted = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    final td = widget.exercise.typeData ?? {};
    final answer = (td['answer_chunks'] as List?)?.cast<String>() ?? [];
    final distractors = (td['distractor_chunks'] as List?)?.cast<String>() ?? [];
    _allBankChunks = [...answer, ...distractors]..shuffle();
    _isUsed = List.filled(_allBankChunks.length, false);
  }

  void _pickChunk(int bankIndex) {
    setState(() {
      _isUsed[bankIndex] = true;
      _answer.add((label: _allBankChunks[bankIndex], bankIndex: bankIndex));
    });
  }

  void _returnChunk(int answerIndex) {
    setState(() {
      _isUsed[_answer[answerIndex].bankIndex] = false;
      _answer.removeAt(answerIndex);
    });
  }

  void _check() {
    final td = widget.exercise.typeData ?? {};
    final answerChunks = (td['answer_chunks'] as List?)?.cast<String>() ?? [];
    setState(() {
      _isSubmitted = true;
      _isCorrect = listEquals(_answer.map((e) => e.label).toList(), answerChunks);
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

    final answerChunks = (td['answer_chunks'] as List?)?.cast<String>() ?? [];
    final correctSentence = answerChunks.join(' ');

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

        // Перевод-подсказка — отличается от зоны ответа цветом и рамкой
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
              border: Border.all(
                color: cs.primary.withValues(alpha: 0.25),
              ),
            ),
            child: Text(
              prompt,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: ac.textSecondary),
            ),
          ),

        const Spacer(),

        // Зона ответа
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 80),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: ac.surfaceOverlay,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ac.n500),
          ),
          child: _answer.isEmpty
              ? Center(
                  child: Text(
                    l10n.mosaicAnswerPlaceholder,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: ac.textMuted),
                  ),
                )
              : Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: List.generate(
                    _answer.length,
                    (i) => _Chip(
                      label: _answer[i].label,
                      inAnswer: true,
                      disabled: _isSubmitted,
                      onTap: () => _returnChunk(i),
                    ),
                  ),
                ),
        ),

        const SizedBox(height: AppSpacing.xl),

        // Банк слов: использованные чипы становятся призраками
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: List.generate(
            _allBankChunks.length,
            (i) => _isUsed[i]
                ? _GhostChip(label: _allBankChunks[i])
                : _Chip(
                    label: _allBankChunks[i],
                    inAnswer: false,
                    disabled: _isSubmitted,
                    onTap: () => _pickChunk(i),
                  ),
          ),
        ),

        const Spacer(),

        if (_isSubmitted)
          ExerciseFeedbackBanner(
            isCorrect: _isCorrect,
            correctAnswer: correctSentence,
            color: feedbackColor,
            backgroundColor: feedbackBg,
          )
        else
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _answer.isEmpty ? null : _check,
              child: Text(l10n.checkButton),
            ),
          ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool inAnswer;
  final bool disabled;
  final VoidCallback? onTap;

  const _Chip({
    required this.label,
    required this.inAnswer,
    required this.disabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ac = theme.extension<AppColors>()!;

    final bgColor = inAnswer ? cs.primary : ac.n500;
    final textColor = inAnswer ? cs.onPrimary : ac.textPrimary;
    final borderColor = inAnswer
        ? cs.primary
        : ac.n400;

    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: AnimatedOpacity(
        opacity: disabled ? 0.6 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
          ),
          child: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: textColor,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

// Пустой placeholder той же формы — не даёт раскладке прыгать
class _GhostChip extends StatelessWidget {
  final String label;

  const _GhostChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final ac = Theme.of(context).extension<AppColors>()!;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ac.n600.withValues(alpha: 0.4),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.transparent, fontSize: 15),
      ),
    );
  }
}
