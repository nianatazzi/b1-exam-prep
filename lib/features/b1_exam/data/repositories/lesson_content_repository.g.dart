// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_content_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(lessonContentRepository)
const lessonContentRepositoryProvider = LessonContentRepositoryProvider._();

final class LessonContentRepositoryProvider
    extends
        $FunctionalProvider<
          LessonContentRepository,
          LessonContentRepository,
          LessonContentRepository
        >
    with $Provider<LessonContentRepository> {
  const LessonContentRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lessonContentRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lessonContentRepositoryHash();

  @$internal
  @override
  $ProviderElement<LessonContentRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LessonContentRepository create(Ref ref) {
    return lessonContentRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LessonContentRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LessonContentRepository>(value),
    );
  }
}

String _$lessonContentRepositoryHash() =>
    r'6c0796d875e5b2eff8794b08216633a4578e3a64';
