// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_practice_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ImagePracticeNotifier)
const imagePracticeProvider = ImagePracticeNotifierFamily._();

final class ImagePracticeNotifierProvider
    extends $AsyncNotifierProvider<ImagePracticeNotifier, ImagePracticeState> {
  const ImagePracticeNotifierProvider._({
    required ImagePracticeNotifierFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'imagePracticeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$imagePracticeNotifierHash();

  @override
  String toString() {
    return r'imagePracticeProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  ImagePracticeNotifier create() => ImagePracticeNotifier();

  @override
  bool operator ==(Object other) {
    return other is ImagePracticeNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$imagePracticeNotifierHash() =>
    r'faa706dfe49e592bedb2f32d6749760f597eb21b';

final class ImagePracticeNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          ImagePracticeNotifier,
          AsyncValue<ImagePracticeState>,
          ImagePracticeState,
          FutureOr<ImagePracticeState>,
          (String, String)
        > {
  const ImagePracticeNotifierFamily._()
    : super(
        retry: null,
        name: r'imagePracticeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ImagePracticeNotifierProvider call(String sectionId, String topicId) =>
      ImagePracticeNotifierProvider._(
        argument: (sectionId, topicId),
        from: this,
      );

  @override
  String toString() => r'imagePracticeProvider';
}

abstract class _$ImagePracticeNotifier
    extends $AsyncNotifier<ImagePracticeState> {
  late final _$args = ref.$arg as (String, String);
  String get sectionId => _$args.$1;
  String get topicId => _$args.$2;

  FutureOr<ImagePracticeState> build(String sectionId, String topicId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args.$1, _$args.$2);
    final ref =
        this.ref as $Ref<AsyncValue<ImagePracticeState>, ImagePracticeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ImagePracticeState>, ImagePracticeState>,
              AsyncValue<ImagePracticeState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
