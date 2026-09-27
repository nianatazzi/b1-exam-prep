import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:b1_exam_prep/core/constants/app_spacing.dart';
import 'package:b1_exam_prep/core/errors/app_error.dart';
import 'package:b1_exam_prep/features/b1_exam/domain/models/dialogue_message_model.dart';
import 'package:b1_exam_prep/features/b1_exam/presentation/providers/dialogue_notifier.dart';
import 'package:b1_exam_prep/l10n/app_localizations.dart';
import 'package:b1_exam_prep/shared/models/study_language.dart';
import 'package:b1_exam_prep/shared/widgets/error_view.dart';

/// Диалог урока (дизайн диалога, Lesson Matrix) — ходовой чат с
/// ИИ-собеседником, голосовой ввод (без набора текста). STT запускается и
/// останавливается на каждый ход (не непрерывно, как в FreePracticeView) —
/// микрофон включается только пока студент формулирует ответ, ход
/// отправляется автоматически по остановке записи. По завершении
/// (shouldClose/max_turns) — финальная отправка через DialogueNotifier.finish,
/// возвращает результат пop'ом наверх в LessonScreen.
class DialogueScreen extends ConsumerStatefulWidget {
  final String langId;
  final String lessonId;

  const DialogueScreen({
    super.key,
    required this.langId,
    required this.lessonId,
  });

  @override
  ConsumerState<DialogueScreen> createState() => _DialogueScreenState();
}

class _DialogueScreenState extends ConsumerState<DialogueScreen> {
  final _speech = SpeechToText();
  bool _isListening = false;
  String _recognizedText = '';
  int _secondsElapsed = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _secondsElapsed++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _speech.stop();
    super.dispose();
  }

  Future<void> _toggleMic(String locale) async {
    if (_isListening) {
      await _speech.stop();
      if (mounted) setState(() => _isListening = false);
      _sendRecognized(locale);
      return;
    }

    final available = await _speech.initialize();
    if (!available || !mounted) return;

    setState(() {
      _isListening = true;
      _recognizedText = '';
    });
    // langId всегда валиден — та же гарантия, что в LessonScreen.
    final sttLocaleId = StudyLanguage.fromCode(widget.langId)!.sttLocaleId;
    await _speech.listen(
      onResult: (result) {
        if (!mounted) return;
        setState(() => _recognizedText = result.recognizedWords);
        if (result.finalResult) {
          setState(() => _isListening = false);
          _sendRecognized(locale);
        }
      },
      listenOptions: SpeechListenOptions(
        localeId: sttLocaleId,
        partialResults: true,
        cancelOnError: true,
      ),
    );
  }

  void _sendRecognized(String locale) {
    final text = _recognizedText.trim();
    if (text.isEmpty) return;
    _recognizedText = '';
    ref
        .read(dialogueProvider(widget.langId, widget.lessonId).notifier)
        .sendUserTurn(text, locale);
  }

  String _errorText(AppError error, AppLocalizations l10n) => switch (error) {
        NetworkError() => l10n.errorNetwork,
        _ => l10n.errorGeneric,
      };

  Future<void> _finish() async {
    final locale = Localizations.localeOf(context).languageCode;
    final outcome = await ref
        .read(dialogueProvider(widget.langId, widget.lessonId).notifier)
        .finish(durationSeconds: _secondsElapsed, uiLanguage: locale);
    if (mounted) context.pop(outcome);
  }

  @override
  Widget build(BuildContext context) {
    final provider = dialogueProvider(widget.langId, widget.lessonId);
    final state = ref.watch(provider);
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.b1Dialogue)),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorView(
          message: l10n.errorGeneric,
          onRetry: () => ref.invalidate(provider),
        ),
        data: (data) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.b1DialogueTurnsLeft(data.turnsLeft),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                itemCount: data.turns.length,
                itemBuilder: (context, index) =>
                    _MessageBubble(message: data.turns[index]),
              ),
            ),
            if (data.isAwaitingReply)
              const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: LinearProgressIndicator(),
              ),
            if (data.error != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                ),
                child: Text(
                  _errorText(data.error!, l10n),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Theme.of(context).colorScheme.error),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: data.shouldClose
                  ? SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: data.isSubmitting ? null : _finish,
                        child: data.isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(l10n.b1DialogueFinish),
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_isListening && _recognizedText.isNotEmpty) ...[
                          Text(
                            _recognizedText,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                        ],
                        if (_isListening) ...[
                          Text(
                            l10n.listeningLabel,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                        ],
                        FilledButton.icon(
                          onPressed: data.isAwaitingReply
                              ? null
                              : () => _toggleMic(locale),
                          icon: Icon(_isListening
                              ? Icons.stop_circle_outlined
                              : Icons.mic),
                          label: Text(_isListening
                              ? l10n.b1StopRecording
                              : l10n.b1StartRecording),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final DialogueMessageModel message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message.role == DialogueRole.user;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        padding: const EdgeInsets.all(AppSpacing.sm),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(message.text),
      ),
    );
  }
}
