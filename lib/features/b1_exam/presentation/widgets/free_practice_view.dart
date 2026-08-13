import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:b1_exam_prep/core/constants/app_sizes.dart';
import 'package:b1_exam_prep/core/constants/app_spacing.dart';
import 'package:b1_exam_prep/core/logger/app_logger.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/exam_topic_model.dart';
import 'package:b1_exam_prep/l10n/app_localizations.dart';

const _practiceDurationSeconds = 180;
// Изучаемый язык фиксирован (польский) — см. ARCHITECTURE.md §12.
const _sttLocaleId = 'pl-PL';

enum _Stage { idle, recording, timeUp }

/// Свободная практика image_description: картинка темы, таймер 3 минуты,
/// запись голоса через speech_to_text, транскрипт по истечении времени.
/// Сам transcript отправляется на AI-анализ при сабмите — см.
/// SubmitFreePracticeUseCase и ImagePracticeScreen._CompletedView.
class FreePracticeView extends StatefulWidget {
  final ExamTopicModel topic;
  final bool isSubmitting;
  final Future<void> Function(String transcript, int durationSeconds)
      onSubmit;

  const FreePracticeView({
    super.key,
    required this.topic,
    required this.isSubmitting,
    required this.onSubmit,
  });

  @override
  State<FreePracticeView> createState() => _FreePracticeViewState();
}

class _FreePracticeViewState extends State<FreePracticeView> {
  final SpeechToText _speech = SpeechToText();

  _Stage _stage = _Stage.idle;
  int _secondsRemaining = _practiceDurationSeconds;
  Timer? _timer;

  // Текст завершённых сессий распознавания + текущий незавершённый кусок.
  // Сессия speech_to_text может закончиться раньше таймера (лимит движка на
  // некоторых устройствах) — тогда перезапускаем listen, пока время не вышло.
  String _committedTranscript = '';
  String _currentPartial = '';

  // true, если initialize()/listen() сообщили об ошибке (движок недоступен,
  // локаль не поддерживается и т.п.) — раньше такие ошибки просто терялись
  // (onError не был подключён), транскрипт оставался пустым без объяснения.
  bool _speechUnavailable = false;

  String get _fullTranscript =>
      [_committedTranscript, _currentPartial].where((s) => s.isNotEmpty).join(' ');

  @override
  void dispose() {
    _timer?.cancel();
    _speech.stop();
    super.dispose();
  }

  Future<void> _start() async {
    final available = await _speech.initialize(onError: _onSpeechError);
    if (!available || !mounted) {
      setState(() => _speechUnavailable = true);
      return;
    }

    setState(() {
      _stage = _Stage.recording;
      _secondsRemaining = _practiceDurationSeconds;
      _committedTranscript = '';
      _currentPartial = '';
      _speechUnavailable = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsRemaining <= 1) {
        _finish();
        return;
      }
      setState(() => _secondsRemaining--);
    });

    await _listenOnce();
  }

  Future<void> _listenOnce() async {
    await _speech.listen(
      onResult: (result) {
        if (!mounted) return;
        if (result.finalResult) {
          setState(() {
            _committedTranscript = _fullTranscript.isEmpty
                ? result.recognizedWords
                : '$_committedTranscript ${result.recognizedWords}'.trim();
            _currentPartial = '';
          });
          _restartListening();
        } else {
          setState(() => _currentPartial = result.recognizedWords);
        }
      },
      listenOptions: SpeechListenOptions(
        localeId: _sttLocaleId,
        listenMode: ListenMode.dictation,
        partialResults: true,
        cancelOnError: true,
      ),
    );
  }

  // Нативный плагин (Android) сбрасывает свой внутренний флаг "listening"
  // только по explicit stop()/cancel() или по onError — обычный final result
  // его не трогает. Поэтому listen() сразу после finalResult молча
  // отклоняется нативной стороной (isListening() всё ещё true) — сессия
  // без единой ошибки просто умирает после первой фразы. cancel() форсирует
  // сброс флага перед тем как начать новую сессию.
  Future<void> _restartListening() async {
    if (!mounted || _stage != _Stage.recording) return;
    await _speech.cancel();
    if (!mounted || _stage != _Stage.recording) return;
    await _listenOnce();
  }

  void _onSpeechError(SpeechRecognitionError error) {
    AppLogger.w(
      'Speech recognition error: ${error.errorMsg} (permanent: ${error.permanent})',
    );
    if (!mounted) return;

    if (_stage == _Stage.recording) {
      // Сессия распознавания может оборваться ошибкой в любой момент — из-за
      // паузы в речи, лимита движка и т.п. На iOS такие ошибки всегда
      // приходят с permanent:true (нативный плагин не различает их), на
      // Android часть — с permanent:false. Раньше проверка `!error.permanent`
      // из-за этого либо молча обрывала запись на середине (Android,
      // ошибка просто игнорировалась), либо сбрасывала практику на idle
      // посреди таймера (iOS). Пока идёт запись — просто начинаем новую
      // сессию распознавания вместо остановки, как и при finalResult.
      _restartListening();
      return;
    }

    // Ошибка вне записи (при initialize()) — движок недоступен, ждать нечего.
    _timer?.cancel();
    setState(() {
      _speechUnavailable = true;
      _stage = _Stage.idle;
    });
  }

  void _finish() {
    _timer?.cancel();
    _speech.stop();
    if (!mounted) return;
    setState(() {
      _stage = _Stage.timeUp;
      _secondsRemaining = 0;
      _committedTranscript = _fullTranscript;
      _currentPartial = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final imageUrl = widget.topic.imageUrl;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.b1FreePractice, style: theme.textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.md),
          if (imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                height: 220,
                placeholder: (_, _) => Container(
                  height: 220,
                  color: theme.colorScheme.surfaceContainerHighest,
                ),
                errorWidget: (_, _, _) => Container(
                  height: 220,
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.broken_image_outlined),
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          if (_stage == _Stage.idle) ...[
            Text(
              l10n.b1FreePracticeInstructions,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.lg),
            if (_speechUnavailable) ...[
              Text(
                l10n.b1SpeechRecognitionUnavailable,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.error),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            FilledButton.icon(
              onPressed: _start,
              icon: const Icon(Icons.mic),
              label: Text(l10n.b1StartRecording),
            ),
          ] else ...[
            Center(
              child: Text(
                _formatDuration(_secondsRemaining),
                style: theme.textTheme.displayMedium,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Center(
              child: Text(
                _stage == _Stage.recording ? l10n.listeningLabel : l10n.b1TimeUp,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (_stage == _Stage.recording) ...[
              Center(
                child: OutlinedButton.icon(
                  onPressed: _finish,
                  icon: const Icon(Icons.stop_circle_outlined),
                  label: Text(l10n.b1StopRecording),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            if (_fullTranscript.isNotEmpty) ...[
              Text(l10n.b1YourTranscript, style: theme.textTheme.labelLarge),
              const SizedBox(height: AppSpacing.xs),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Text(_fullTranscript, style: theme.textTheme.bodyLarge),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            if (_stage == _Stage.timeUp) ...[
              Text(
                l10n.b1FreePracticeAnalysisNotice,
                style: theme.textTheme.bodySmall
                    ?.copyWith(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                onPressed: widget.isSubmitting
                    ? null
                    : () => widget.onSubmit(
                          _fullTranscript,
                          _practiceDurationSeconds,
                        ),
                child: widget.isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.b1FinishPractice),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

String _formatDuration(int seconds) {
  final m = (seconds ~/ 60).toString().padLeft(2, '0');
  final s = (seconds % 60).toString().padLeft(2, '0');
  return '$m:$s';
}
