import 'dart:math';
import 'package:flutter/material.dart';
import 'package:linguobyte/core/utils/string_utils.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/core/theme/app_colors.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_model.dart';
import 'package:linguobyte/features/lesson/presentation/widgets/exercises/exercise_feedback_banner.dart';
import 'package:linguobyte/l10n/app_localizations.dart';
import 'package:linguobyte/shared/widgets/audio_play_button.dart';

class FlashcardExerciseWidget extends StatefulWidget {
  final ExerciseModel exercise;
  final VoidCallback onReady;

  const FlashcardExerciseWidget({
    super.key,
    required this.exercise,
    required this.onReady,
  });

  @override
  State<FlashcardExerciseWidget> createState() =>
      _FlashcardExerciseWidgetState();
}

class _FlashcardExerciseWidgetState extends State<FlashcardExerciseWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flipCtrl;
  late final Animation<double> _flipAnim;

  bool _isFlipped = false;
  bool _isSubmitted = false;
  bool _isCorrect = false;
  String _correctAnswer = '';
  final _textCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _flipCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _flipAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _flipCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _flipCtrl.dispose();
    _textCtrl.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_isSubmitted) return;
    if (_isFlipped) {
      _flipCtrl.reverse();
      setState(() => _isFlipped = false);
    } else {
      _flipCtrl.forward();
      setState(() => _isFlipped = true);
      widget.onReady();
    }
  }

  void _check(String baseWord) {
    _correctAnswer = baseWord;
    setState(() {
      _isSubmitted = true;
      _isCorrect = normalizeAnswer(_textCtrl.text) == normalizeAnswer(baseWord);
    });
    widget.onReady();
  }

  List<String> _parseTranslations(dynamic raw) {
    if (raw is List) return raw.cast<String>();
    if (raw is String && raw.isNotEmpty) {
      final matches = RegExp(r'"([^"]+)"').allMatches(raw);
      if (matches.isNotEmpty) return matches.map((m) => m.group(1)!).toList();
      return [raw];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ac = theme.extension<AppColors>()!;
    final td = widget.exercise.typeData ?? {};
    final langCode = Localizations.localeOf(context).languageCode;

    final baseWord = (td['base_word'] as String?) ?? '';

    final translationsMap =
        (td['translations'] as Map?)?.cast<String, dynamic>() ?? {};
    final rawTr = translationsMap[langCode] ?? translationsMap['en'];
    final translations = _parseTranslations(rawTr);

    final contextMap =
        (td['context_sentence'] as Map?)?.cast<String, dynamic>() ?? {};
    final contextSentence =
        (contextMap[langCode] ?? contextMap['en'] ?? '').toString();

    final audioUrl = widget.exercise.audioUrl;

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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedBuilder(
              animation: _flipAnim,
              builder: (context, _) {
                final value = _flipAnim.value;
                final angle = value * pi;
                final showFront = value <= 0.5;

                Widget face = showFront
                    ? _buildFront(
                        theme: theme,
                        cs: cs,
                        ac: ac,
                        l10n: l10n,
                        translations: translations,
                      )
                    : Transform(
                        // Зеркалируем обратную сторону, чтобы текст не отражался
                        transform: Matrix4.identity()..rotateY(pi),
                        alignment: Alignment.center,
                        child: _buildBack(
                          theme: theme,
                          ac: ac,
                          l10n: l10n,
                          baseWord: baseWord,
                          audioUrl: audioUrl,
                          contextSentence: contextSentence,
                        ),
                      );

                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // перспектива
                    ..rotateY(angle),
                  alignment: Alignment.center,
                  child: face,
                );
              },
        ),

        const SizedBox(height: AppSpacing.md),

        // Нижняя зона: кнопка Проверить или фидбэк, или пусто после флипа
        if (_isFlipped)
          const SizedBox.shrink()
        else if (_isSubmitted)
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
              onPressed: _textCtrl.text.trim().isEmpty
                  ? null
                  : () => _check(baseWord),
              child: Text(l10n.checkButton),
            ),
          ),
      ],
    );
  }

  Widget _buildFront({
    required ThemeData theme,
    required ColorScheme cs,
    required AppColors ac,
    required AppLocalizations l10n,
    required List<String> translations,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ac.surfaceOverlay,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ac.n600),
      ),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Переводы — подсказка для пользователя
          Text(
            translations.join(', '),
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineLarge
                ?.copyWith(color: cs.secondary),
          ),

          const SizedBox(height: AppSpacing.lg),
          Divider(color: ac.n600),
          const SizedBox(height: AppSpacing.lg),

          // Поле ввода перевода
          TextField(
            controller: _textCtrl,
            onChanged: (_) => setState(() {}),
            style: theme.textTheme.bodyLarge?.copyWith(color: ac.textPrimary),
            decoration: InputDecoration(
              hintText: l10n.answerHint,
              hintStyle:
                  theme.textTheme.bodyLarge?.copyWith(color: ac.textMuted),
              filled: true,
              fillColor: ac.surfaceRaised,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: ac.n500),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: cs.primary, width: 1.5),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Ссылка "посмотреть перевод"
          TextButton.icon(
            onPressed: _flipCard,
            icon: Icon(Icons.rotate_right_rounded,
                size: 16, color: ac.textMuted),
            label: Text(
              l10n.seeTranslation,
              style: theme.textTheme.bodySmall?.copyWith(color: ac.textMuted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBack({
    required ThemeData theme,
    required AppColors ac,
    required AppLocalizations l10n,
    required String baseWord,
    required String? audioUrl,
    required String contextSentence,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ac.surfaceOverlay,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ac.n600),
      ),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            baseWord,
            textAlign: TextAlign.center,
            style: theme.textTheme.displayLarge
                ?.copyWith(color: ac.textPrimary),
          ),

          const SizedBox(height: AppSpacing.lg),

          AudioPlayButton(audioUrl: audioUrl),

          if (contextSentence.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            Divider(color: ac.n600),
            const SizedBox(height: AppSpacing.md),
            Text(
              contextSentence,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: ac.textSecondary),
            ),
          ],

          const SizedBox(height: AppSpacing.md),

          TextButton.icon(
            onPressed: _flipCard,
            icon: Icon(Icons.rotate_left_rounded,
                size: 16, color: ac.textMuted),
            label: Text(
              l10n.hideTranslation,
              style: theme.textTheme.bodySmall?.copyWith(color: ac.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}
