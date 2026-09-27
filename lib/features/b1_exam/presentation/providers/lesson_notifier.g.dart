// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Фиксированная последовательность урока (Lesson Matrix §0/opening): три
/// капа упражнений (verb → noun → phrase, по 10) → три устных упражнения
/// подряд (image → monologue → dialogue). Диалог — отдельный экран
/// (DialogueScreen/DialogueNotifier), сюда возвращается уже готовым
/// OralStepOutcome через completeDialogueStep.

@ProviderFor(LessonNotifier)
const lessonProvider = LessonNotifierFamily._();

/// Фиксированная последовательность урока (Lesson Matrix §0/opening): три
/// капа упражнений (verb → noun → phrase, по 10) → три устных упражнения
/// подряд (image → monologue → dialogue). Диалог — отдельный экран
/// (DialogueScreen/DialogueNotifier), сюда возвращается уже готовым
/// OralStepOutcome через completeDialogueStep.
final class LessonNotifierProvider
    extends $AsyncNotifierProvider<LessonNotifier, LessonState> {
  /// Фиксированная последовательность урока (Lesson Matrix §0/opening): три
  /// капа упражнений (verb → noun → phrase, по 10) → три устных упражнения
  /// подряд (image → monologue → dialogue). Диалог — отдельный экран
  /// (DialogueScreen/DialogueNotifier), сюда возвращается уже готовым
  /// OralStepOutcome через completeDialogueStep.
  const LessonNotifierProvider._({
    required LessonNotifierFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'lessonProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lessonNotifierHash();

  @override
  String toString() {
    return r'lessonProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  LessonNotifier create() => LessonNotifier();

  @override
  bool operator ==(Object other) {
    return other is LessonNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lessonNotifierHash() => r'c6038ae7c360dbf1468c21c98ebe964ff4bb38ca';

/// Фиксированная последовательность урока (Lesson Matrix §0/opening): три
/// капа упражнений (verb → noun → phrase, по 10) → три устных упражнения
/// подряд (image → monologue → dialogue). Диалог — отдельный экран
/// (DialogueScreen/DialogueNotifier), сюда возвращается уже готовым
/// OralStepOutcome через completeDialogueStep.

final class LessonNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          LessonNotifier,
          AsyncValue<LessonState>,
          LessonState,
          FutureOr<LessonState>,
          (String, String)
        > {
  const LessonNotifierFamily._()
    : super(
        retry: null,
        name: r'lessonProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Фиксированная последовательность урока (Lesson Matrix §0/opening): три
  /// капа упражнений (verb → noun → phrase, по 10) → три устных упражнения
  /// подряд (image → monologue → dialogue). Диалог — отдельный экран
  /// (DialogueScreen/DialogueNotifier), сюда возвращается уже готовым
  /// OralStepOutcome через completeDialogueStep.

  LessonNotifierProvider call(String langId, String lessonId) =>
      LessonNotifierProvider._(argument: (langId, lessonId), from: this);

  @override
  String toString() => r'lessonProvider';
}

/// Фиксированная последовательность урока (Lesson Matrix §0/opening): три
/// капа упражнений (verb → noun → phrase, по 10) → три устных упражнения
/// подряд (image → monologue → dialogue). Диалог — отдельный экран
/// (DialogueScreen/DialogueNotifier), сюда возвращается уже готовым
/// OralStepOutcome через completeDialogueStep.

abstract class _$LessonNotifier extends $AsyncNotifier<LessonState> {
  late final _$args = ref.$arg as (String, String);
  String get langId => _$args.$1;
  String get lessonId => _$args.$2;

  FutureOr<LessonState> build(String langId, String lessonId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args.$1, _$args.$2);
    final ref = this.ref as $Ref<AsyncValue<LessonState>, LessonState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LessonState>, LessonState>,
              AsyncValue<LessonState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
