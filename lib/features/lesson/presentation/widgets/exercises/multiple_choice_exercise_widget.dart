import 'package:flutter/material.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/core/theme/app_colors.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_model.dart';
import 'package:linguobyte/features/lesson/presentation/widgets/exercises/exercise_feedback_banner.dart';
import 'package:linguobyte/l10n/app_localizations.dart';

class MultipleChoiceExerciseWidget extends StatefulWidget {
  final ExerciseModel exercise;
  final VoidCallback onReady;

  const MultipleChoiceExerciseWidget({
    super.key,
    required this.exercise,
    required this.onReady,
  });

  @override
  State<MultipleChoiceExerciseWidget> createState() =>
      _MultipleChoiceExerciseWidgetState();
}

class _MultipleChoiceExerciseWidgetState
    extends State<MultipleChoiceExerciseWidget> {
  late final List<String> _allBankChunks;
  late final List<bool> _isUsed;
  late final List<int?> _slotBankIndex; // индекс в _allBankChunks или null
  bool _isSubmitted = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    final td = widget.exercise.typeData ?? {};
    final blanks = _getBlanks(td);

    final allVariants = <String>[];
    for (final b in blanks) {
      allVariants.addAll((b['variants'] as List?)?.cast<String>() ?? []);
    }
    _allBankChunks = allVariants..shuffle();
    _isUsed = List.filled(_allBankChunks.length, false);
    _slotBankIndex = List.filled(blanks.length, null);
  }

  List<Map<String, dynamic>> _getBlanks(Map<String, dynamic> td) =>
      (td['blanks'] as List?)?.cast<Map<String, dynamic>>() ?? [];

  void _pickChunk(int bankIndex) {
    final firstEmpty = _slotBankIndex.indexOf(null);
    if (firstEmpty == -1) return;
    setState(() {
      _isUsed[bankIndex] = true;
      _slotBankIndex[firstEmpty] = bankIndex;
    });
  }

  void _returnFromSlot(int slotIndex) {
    final bankIndex = _slotBankIndex[slotIndex];
    if (bankIndex == null) return;
    setState(() {
      _isUsed[bankIndex] = false;
      _slotBankIndex[slotIndex] = null;
    });
  }

  bool _isSlotCorrect(int slotIndex, List<Map<String, dynamic>> blanks) {
    final bankIndex = _slotBankIndex[slotIndex];
    if (bankIndex == null || slotIndex >= blanks.length) return false;
    final variants = (blanks[slotIndex]['variants'] as List?)?.cast<String>() ?? [];
    final answerIdx = (blanks[slotIndex]['answer_index'] as num?)?.toInt() ?? 0;
    final correct = answerIdx < variants.length ? variants[answerIdx] : '';
    return _allBankChunks[bankIndex] == correct;
  }

  void _check() {
    final td = widget.exercise.typeData ?? {};
    final blanks = _getBlanks(td);
    final allCorrect = List.generate(blanks.length, (i) => _isSlotCorrect(i, blanks))
        .every((v) => v);
    setState(() {
      _isSubmitted = true;
      _isCorrect = allCorrect;
    });
    widget.onReady();
  }

  String _buildCorrectSentence(
      String form, List<Map<String, dynamic>> blanks) {
    final parts = form.split('[]');
    final buf = StringBuffer();
    for (int i = 0; i < parts.length; i++) {
      buf.write(parts[i]);
      if (i < blanks.length) {
        final variants = (blanks[i]['variants'] as List?)?.cast<String>() ?? [];
        final idx = (blanks[i]['answer_index'] as num?)?.toInt() ?? 0;
        buf.write(idx < variants.length ? variants[idx] : '?');
      }
    }
    return buf.toString();
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
    final blanks = _getBlanks(td);
    final correctSentence = _buildCorrectSentence(form, blanks);

    final allFilled = _slotBankIndex.every((i) => i != null);

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

        // Предложение со слотами
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 4,
          runSpacing: AppSpacing.sm,
          children: [
            for (int i = 0; i < parts.length; i++) ...[
              if (parts[i].isNotEmpty)
                Text(parts[i], style: theme.textTheme.titleMedium),
              if (i < blanks.length)
                _Slot(
                  word: _slotBankIndex[i] != null
                      ? _allBankChunks[_slotBankIndex[i]!]
                      : null,
                  isSubmitted: _isSubmitted,
                  isCorrect: _isSubmitted
                      ? _isSlotCorrect(i, blanks)
                      : false,
                  onTap: _isSubmitted
                      ? null
                      : () => _returnFromSlot(i),
                ),
            ],
          ],
        ),

        const SizedBox(height: AppSpacing.xl),

        // Банк слов с ghost-плейсхолдерами
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: List.generate(
            _allBankChunks.length,
            (i) => _isUsed[i]
                ? _GhostChip(label: _allBankChunks[i])
                : _BankChip(
                    label: _allBankChunks[i],
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
              onPressed: allFilled ? _check : null,
              child: Text(l10n.checkButton),
            ),
          ),
      ],
    );
  }
}

class _Slot extends StatelessWidget {
  final String? word;
  final bool isSubmitted;
  final bool isCorrect;
  final VoidCallback? onTap;

  const _Slot({
    required this.word,
    required this.isSubmitted,
    required this.isCorrect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ac = theme.extension<AppColors>()!;

    final Color borderColor;
    final Color bgColor;
    if (isSubmitted) {
      borderColor = isCorrect ? ac.success : cs.error;
      bgColor = isCorrect ? ac.successSub : ac.errorSub;
    } else if (word != null) {
      borderColor = cs.primary;
      bgColor = ac.primarySub;
    } else {
      borderColor = ac.n500;
      bgColor = ac.surfaceOverlay;
    }

    return GestureDetector(
      onTap: word != null ? onTap : null,
      child: Container(
        constraints: const BoxConstraints(minWidth: 72),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          word ?? '',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium?.copyWith(
            color: word != null ? ac.textPrimary : Colors.transparent,
          ),
        ),
      ),
    );
  }
}

class _BankChip extends StatelessWidget {
  final String label;
  final bool disabled;
  final VoidCallback onTap;

  const _BankChip({
    required this.label,
    required this.disabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ac = theme.extension<AppColors>()!;

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
            color: ac.n500,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: ac.n400),
          ),
          child: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: ac.textPrimary,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

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
        border: Border.all(color: ac.n600.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.transparent, fontSize: 15),
      ),
    );
  }
}
