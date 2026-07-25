// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TopicDetailNotifier)
const topicDetailProvider = TopicDetailNotifierFamily._();

final class TopicDetailNotifierProvider
    extends $AsyncNotifierProvider<TopicDetailNotifier, TopicDetailState> {
  const TopicDetailNotifierProvider._({
    required TopicDetailNotifierFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'topicDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$topicDetailNotifierHash();

  @override
  String toString() {
    return r'topicDetailProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  TopicDetailNotifier create() => TopicDetailNotifier();

  @override
  bool operator ==(Object other) {
    return other is TopicDetailNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$topicDetailNotifierHash() =>
    r'f45f7acd5c0097433f1c6ecddb2f28418cb29cc8';

final class TopicDetailNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          TopicDetailNotifier,
          AsyncValue<TopicDetailState>,
          TopicDetailState,
          FutureOr<TopicDetailState>,
          (String, String)
        > {
  const TopicDetailNotifierFamily._()
    : super(
        retry: null,
        name: r'topicDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TopicDetailNotifierProvider call(String sectionId, String topicId) =>
      TopicDetailNotifierProvider._(argument: (sectionId, topicId), from: this);

  @override
  String toString() => r'topicDetailProvider';
}

abstract class _$TopicDetailNotifier extends $AsyncNotifier<TopicDetailState> {
  late final _$args = ref.$arg as (String, String);
  String get sectionId => _$args.$1;
  String get topicId => _$args.$2;

  FutureOr<TopicDetailState> build(String sectionId, String topicId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args.$1, _$args.$2);
    final ref =
        this.ref as $Ref<AsyncValue<TopicDetailState>, TopicDetailState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TopicDetailState>, TopicDetailState>,
              AsyncValue<TopicDetailState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
