import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:b1_exam_prep/core/constants/app_sizes.dart';

enum _AudioState { idle, loading, playing }

/// Переиспользуемая кнопка воспроизведения аудио.
/// [audioUrl] == null → кнопка задизейблена.
class AudioPlayButton extends StatefulWidget {
  final String? audioUrl;
  final double size;

  const AudioPlayButton({
    super.key,
    required this.audioUrl,
    this.size = AppSizes.audioButtonSize,
  });

  @override
  State<AudioPlayButton> createState() => _AudioPlayButtonState();
}

class _AudioPlayButtonState extends State<AudioPlayButton> {
  late final AudioPlayer _player;
  _AudioState _state = _AudioState.idle;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.playerStateStream.listen((s) {
      if (!mounted) return;
      if (s.processingState == ProcessingState.completed) {
        setState(() => _state = _AudioState.idle);
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    final url = widget.audioUrl;
    if (url == null) return;

    // Повторный тап во время воспроизведения — перемотка в начало
    if (_state == _AudioState.playing) {
      await _player.seek(Duration.zero);
      await _player.play();
      return;
    }

    setState(() => _state = _AudioState.loading);
    try {
      await _player.setUrl(url);
      setState(() => _state = _AudioState.playing);
      await _player.play();
    } catch (_) {
      setState(() => _state = _AudioState.idle);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDisabled = widget.audioUrl == null;
    final color = isDisabled
        ? cs.secondary.withValues(alpha: 0.4)
        : cs.secondary;

    return GestureDetector(
      onTap: isDisabled ? null : _handleTap,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: _state == _AudioState.loading
              ? SizedBox(
                  width: widget.size * 0.4,
                  height: widget.size * 0.4,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: cs.onSecondary,
                  ),
                )
              : Icon(
                  _state == _AudioState.playing
                      ? Icons.stop_rounded
                      : Icons.volume_up_rounded,
                  color: cs.onSecondary,
                  size: widget.size * 0.45,
                ),
        ),
      ),
    );
  }
}
