import 'package:flutter/material.dart';
import 'package:linguobyte/core/constants/app_sizes.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/core/theme/app_colors.dart';
import 'package:linguobyte/core/utils/string_utils.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_model.dart';
import 'package:linguobyte/features/lesson/domain/models/exercise_result.dart';
import 'package:linguobyte/features/lesson/presentation/widgets/exercises/exercise_feedback_banner.dart';
import 'package:linguobyte/l10n/app_localizations.dart';
import 'package:speech_to_text/speech_to_text.dart';

enum _VoiceState { idle, listening, done }

class VoiceTranslateExerciseWidget extends StatefulWidget {
  final ExerciseModel exercise;
  final VoidCallback onReady;
  final ValueChanged<ExerciseResult>? onResult;
  final VoidCallback? onAutoAdvance;

  const VoiceTranslateExerciseWidget({
    super.key,
    required this.exercise,
    required this.onReady,
    this.onResult,
    this.onAutoAdvance,
  });

  @override
  State<VoiceTranslateExerciseWidget> createState() =>
      _VoiceTranslateExerciseWidgetState();
}

class _VoiceTranslateExerciseWidgetState
    extends State<VoiceTranslateExerciseWidget> {
  final SpeechToText _speech = SpeechToText();

  bool _useTextMode = false;
  bool _sttAvailable = false;
  _VoiceState _voiceState = _VoiceState.idle;
  String _recognizedText = '';

  final _textCtrl = TextEditingController();
  bool _isSubmitted = false;
  bool _isCorrect = false;
  bool _hasDiacriticsMismatch = false;
  String _correctAnswer = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    final available = await _speech.initialize();
    if (mounted) setState(() => _sttAvailable = available);
  }

  @override
  void dispose() {
    _speech.stop();
    _textCtrl.dispose();
    super.dispose();
  }

  Future<void> _toggleRecording(String localeId) async {
    if (_voiceState == _VoiceState.listening) {
      await _speech.stop();
      setState(() => _voiceState = _VoiceState.done);
      _checkAndAutoAdvance();
      return;
    }

    if (!_sttAvailable) return;

    setState(() {
      _voiceState = _VoiceState.listening;
      _recognizedText = '';
    });

    await _speech.listen(
      onResult: (result) {
        setState(() {
          _recognizedText = result.recognizedWords;
          if (result.finalResult) _voiceState = _VoiceState.done;
        });
        if (result.finalResult) _checkAndAutoAdvance();
      },
      listenOptions: SpeechListenOptions(
        localeId: localeId,
        cancelOnError: true,
        listenMode: ListenMode.confirmation,
      ),
    );
  }

  // Вызывается автоматически после окончания записи в голосовом режиме.
  // В текстовом режиме или без onAutoAdvance — ничего не делает.
  void _checkAndAutoAdvance() {
    if (widget.onAutoAdvance == null || _useTextMode || _isSubmitted) return;
    final td = widget.exercise.typeData ?? {};
    final correctAnswer = (td['correct_answer'] as String?) ?? '';
    final rawAccepted = td['accepted_answers'];
    final acceptedAnswers =
        rawAccepted is List ? rawAccepted.cast<String>() : <String>[];
    _check(correctAnswer, acceptedAnswers);
    if (_isCorrect) {
      Future.delayed(const Duration(milliseconds: 1300), () {
        if (mounted) widget.onAutoAdvance!();
      });
    }
    // при ошибке — ждём тапа пользователя на кнопку "Продолжить"
  }

  void _check(String correctAnswer, List<String> acceptedAnswers) {
    _correctAnswer = correctAnswer;
    final input = _useTextMode ? _textCtrl.text : _recognizedText;
    final normalized = normalizeAnswer(input);
    final exactMatch = normalized == normalizeAnswer(correctAnswer) ||
        acceptedAnswers.any((a) => normalizeAnswer(a) == normalized);

    // Проверка без акцентов только для текстового режима (STT и так не даёт акценты)
    final bool accentMatch = !exactMatch &&
        _useTextMode &&
        (normalizeAnswer(stripDiacritics(input)) ==
                normalizeAnswer(stripDiacritics(correctAnswer)) ||
            acceptedAnswers.any((a) =>
                normalizeAnswer(stripDiacritics(a)) ==
                normalizeAnswer(stripDiacritics(input))));

    setState(() {
      _isSubmitted = true;
      _isCorrect = exactMatch || accentMatch;
      _hasDiacriticsMismatch = accentMatch;
    });
    // Сообщаем результат наружу — без этого голосовые упражнения не попадают
    // в stepResults/stats (и verb-субпарт не сохраняется).
    widget.onResult?.call(ExerciseResult(
      exerciseId: widget.exercise.exId.toString(),
      isCorrect: _isCorrect,
      grammarTypes: widget.exercise.grammarTypes,
      userAnswer: input.trim(),
      correctAnswer: correctAnswer,
    ));
    // в авто-голосовом режиме кнопка "Далее" не нужна
    if (_useTextMode || widget.onAutoAdvance == null) widget.onReady();
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
    final title = (titleMap[langCode] ?? titleMap['ru'] ?? titleMap['en'] ?? '').toString();

    final promptsMap = (td['prompts'] as Map?)?.cast<String, dynamic>() ?? {};
    final prompt = (promptsMap[langCode] ?? promptsMap['ru'] ?? promptsMap['en'] ?? '').toString();

    final correctAnswer = (td['correct_answer'] as String?) ?? '';
    final rawAccepted = td['accepted_answers'];
    final acceptedAnswers = rawAccepted is List
        ? rawAccepted.cast<String>()
        : <String>[];

    final sttLocaleId = (td['stt_language_code'] as String?) ?? 'en-US';

    final Color feedbackColor;
    final Color feedbackBg;
    if (_isSubmitted) {
      feedbackColor = _isCorrect ? ac.success : cs.error;
      feedbackBg = _isCorrect ? ac.successSub : ac.errorSub;
    } else {
      feedbackColor = Colors.transparent;
      feedbackBg = Colors.transparent;
    }

    final bool canCheck = _useTextMode
        ? _textCtrl.text.trim().isNotEmpty
        : _voiceState == _VoiceState.done && _recognizedText.isNotEmpty;

    final bool isAutoVoiceMode = widget.onAutoAdvance != null && !_useTextMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок инструкции
        if (title.isNotEmpty)
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(color: ac.textPrimary),
          ),

        if (prompt.isNotEmpty) ...[
          _useTextMode ? const SizedBox(height: AppSpacing.xl) : const Spacer(),
          // Фраза для перевода
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
              prompt,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(color: ac.textPrimary),
            ),
          ),
        ],

        _useTextMode ? const SizedBox(height: AppSpacing.xl) : const Spacer(),

        // Зона ввода: голос или текст
        if (_useTextMode)
          _buildTextInput(theme, cs, ac, l10n)
        else
          _buildVoiceInput(theme, cs, ac, l10n, sttLocaleId),

        _useTextMode ? const SizedBox(height: AppSpacing.lg) : const Spacer(),

        // Фидбэк или кнопки
        if (_isSubmitted) ...[
          ExerciseFeedbackBanner(
            isCorrect: _isCorrect,
            correctAnswer: _correctAnswer,
            color: feedbackColor,
            backgroundColor: feedbackBg,
            accentWarning: _hasDiacriticsMismatch ? l10n.accentWarning : null,
          ),
          // в авто-режиме при ошибке показываем кнопку продолжить
          if (isAutoVoiceMode && !_isCorrect) ...[
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onAutoAdvance,
                child: Text(l10n.nextButton),
              ),
            ),
          ],
        ] else if (isAutoVoiceMode) ...[
          // авто-режим: кнопки "Проверить" нет, только ссылка на текстовый режим
          Center(
            child: TextButton(
              onPressed: () => setState(() => _useTextMode = true),
              child: Text(
                l10n.cantSpeakNow,
                style: theme.textTheme.bodySmall?.copyWith(color: ac.textMuted),
              ),
            ),
          ),
        ] else ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: canCheck
                  ? () => _check(correctAnswer, acceptedAnswers)
                  : null,
              child: Text(l10n.checkButton),
            ),
          ),
          if (!_useTextMode) ...[
            const SizedBox(height: AppSpacing.md),
            Center(
              child: TextButton(
                onPressed: () => setState(() => _useTextMode = true),
                child: Text(
                  l10n.cantSpeakNow,
                  style: theme.textTheme.bodySmall?.copyWith(color: ac.textMuted),
                ),
              ),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildVoiceInput(
    ThemeData theme,
    ColorScheme cs,
    AppColors ac,
    AppLocalizations l10n,
    String sttLocaleId,
  ) {
    final isListening = _voiceState == _VoiceState.listening;
    final isDone = _voiceState == _VoiceState.done;

    return SizedBox(
      width: double.infinity,
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Кнопка микрофона
        GestureDetector(
          onTap: _isSubmitted ? null : () => _toggleRecording(sttLocaleId),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: AppSizes.audioButtonSize * 1.5,
            height: AppSizes.audioButtonSize * 1.5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isListening
                  ? cs.error.withValues(alpha: 0.15)
                  : ac.secondarySub,
              border: Border.all(
                color: isListening ? cs.error : cs.secondary,
                width: 2,
              ),
            ),
            child: Icon(
              isListening ? Icons.stop_rounded : Icons.mic_rounded,
              size: AppSizes.iconLg * 1.5,
              color: isListening ? cs.error : cs.secondary,
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // Статус
        Text(
          isListening
              ? l10n.listeningLabel
              : isDone
                  ? ''
                  : l10n.tapToRecord,
          style: theme.textTheme.bodySmall?.copyWith(color: ac.textMuted),
        ),

        // Распознанный текст
        if (_recognizedText.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: ac.surfaceOverlay,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ac.n500),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.recognizedText,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: ac.textMuted),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _recognizedText,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: ac.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ],
      ),
    );
  }

  Widget _buildTextInput(
    ThemeData theme,
    ColorScheme cs,
    AppColors ac,
    AppLocalizations l10n,
  ) {
    return TextField(
      controller: _textCtrl,
      enabled: !_isSubmitted,
      onChanged: (_) => setState(() {}),
      maxLines: 3,
      minLines: 2,
      style: theme.textTheme.bodyLarge?.copyWith(color: ac.textPrimary),
      decoration: InputDecoration(
        hintText: l10n.answerHint,
        hintStyle: theme.textTheme.bodyLarge?.copyWith(color: ac.textMuted),
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
    );
  }
}
