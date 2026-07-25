// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practice_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PracticeNotifier)
const practiceProvider = PracticeNotifierFamily._();

final class PracticeNotifierProvider
    extends $AsyncNotifierProvider<PracticeNotifier, PracticeState> {
  const PracticeNotifierProvider._({
    required PracticeNotifierFamily super.from,
    required (String, String, String) super.argument,
  }) : super(
         retry: null,
         name: r'practiceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$practiceNotifierHash();

  @override
  String toString() {
    return r'practiceProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  PracticeNotifier create() => PracticeNotifier();

  @override
  bool operator ==(Object other) {
    return other is PracticeNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$practiceNotifierHash() => r'fd87c6d8505bb8e6dbdf35f8e7dd5a813a54da71';

final class PracticeNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          PracticeNotifier,
          AsyncValue<PracticeState>,
          PracticeState,
          FutureOr<PracticeState>,
          (String, String, String)
        > {
  const PracticeNotifierFamily._()
    : super(
        retry: null,
        name: r'practiceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PracticeNotifierProvider call(
    String sectionId,
    String topicId,
    String prepLevel,
  ) => PracticeNotifierProvider._(
    argument: (sectionId, topicId, prepLevel),
    from: this,
  );

  @override
  String toString() => r'practiceProvider';
}

abstract class _$PracticeNotifier extends $AsyncNotifier<PracticeState> {
  late final _$args = ref.$arg as (String, String, String);
  String get sectionId => _$args.$1;
  String get topicId => _$args.$2;
  String get prepLevel => _$args.$3;

  FutureOr<PracticeState> build(
    String sectionId,
    String topicId,
    String prepLevel,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args.$1, _$args.$2, _$args.$3);
    final ref = this.ref as $Ref<AsyncValue<PracticeState>, PracticeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PracticeState>, PracticeState>,
              AsyncValue<PracticeState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
