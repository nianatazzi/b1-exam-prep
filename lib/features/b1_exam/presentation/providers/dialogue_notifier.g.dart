// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialogue_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Диалог урока (дизайн диалога, Lesson Matrix) — состояние хода хранится на
/// клиенте, continueDialogue вызывается заново на каждый ход с полной
/// историей (функция без состояния). STT здесь запускается и
/// останавливается на КАЖДЫЙ ход, а не работает непрерывно как в
/// FreePracticeView — микрофон включается только пока студент отвечает.

@ProviderFor(DialogueNotifier)
const dialogueProvider = DialogueNotifierFamily._();

/// Диалог урока (дизайн диалога, Lesson Matrix) — состояние хода хранится на
/// клиенте, continueDialogue вызывается заново на каждый ход с полной
/// историей (функция без состояния). STT здесь запускается и
/// останавливается на КАЖДЫЙ ход, а не работает непрерывно как в
/// FreePracticeView — микрофон включается только пока студент отвечает.
final class DialogueNotifierProvider
    extends $AsyncNotifierProvider<DialogueNotifier, DialogueState> {
  /// Диалог урока (дизайн диалога, Lesson Matrix) — состояние хода хранится на
  /// клиенте, continueDialogue вызывается заново на каждый ход с полной
  /// историей (функция без состояния). STT здесь запускается и
  /// останавливается на КАЖДЫЙ ход, а не работает непрерывно как в
  /// FreePracticeView — микрофон включается только пока студент отвечает.
  const DialogueNotifierProvider._({
    required DialogueNotifierFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'dialogueProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dialogueNotifierHash();

  @override
  String toString() {
    return r'dialogueProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  DialogueNotifier create() => DialogueNotifier();

  @override
  bool operator ==(Object other) {
    return other is DialogueNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dialogueNotifierHash() => r'5c760b78eacd05437f610debbc22db0b17732454';

/// Диалог урока (дизайн диалога, Lesson Matrix) — состояние хода хранится на
/// клиенте, continueDialogue вызывается заново на каждый ход с полной
/// историей (функция без состояния). STT здесь запускается и
/// останавливается на КАЖДЫЙ ход, а не работает непрерывно как в
/// FreePracticeView — микрофон включается только пока студент отвечает.

final class DialogueNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          DialogueNotifier,
          AsyncValue<DialogueState>,
          DialogueState,
          FutureOr<DialogueState>,
          (String, String)
        > {
  const DialogueNotifierFamily._()
    : super(
        retry: null,
        name: r'dialogueProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Диалог урока (дизайн диалога, Lesson Matrix) — состояние хода хранится на
  /// клиенте, continueDialogue вызывается заново на каждый ход с полной
  /// историей (функция без состояния). STT здесь запускается и
  /// останавливается на КАЖДЫЙ ход, а не работает непрерывно как в
  /// FreePracticeView — микрофон включается только пока студент отвечает.

  DialogueNotifierProvider call(String langId, String lessonId) =>
      DialogueNotifierProvider._(argument: (langId, lessonId), from: this);

  @override
  String toString() => r'dialogueProvider';
}

/// Диалог урока (дизайн диалога, Lesson Matrix) — состояние хода хранится на
/// клиенте, continueDialogue вызывается заново на каждый ход с полной
/// историей (функция без состояния). STT здесь запускается и
/// останавливается на КАЖДЫЙ ход, а не работает непрерывно как в
/// FreePracticeView — микрофон включается только пока студент отвечает.

abstract class _$DialogueNotifier extends $AsyncNotifier<DialogueState> {
  late final _$args = ref.$arg as (String, String);
  String get langId => _$args.$1;
  String get lessonId => _$args.$2;

  FutureOr<DialogueState> build(String langId, String lessonId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args.$1, _$args.$2);
    final ref = this.ref as $Ref<AsyncValue<DialogueState>, DialogueState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DialogueState>, DialogueState>,
              AsyncValue<DialogueState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
