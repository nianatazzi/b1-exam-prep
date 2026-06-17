// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'build_lesson_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(buildLessonUseCase)
const buildLessonUseCaseProvider = BuildLessonUseCaseProvider._();

final class BuildLessonUseCaseProvider
    extends
        $FunctionalProvider<
          BuildLessonUseCase,
          BuildLessonUseCase,
          BuildLessonUseCase
        >
    with $Provider<BuildLessonUseCase> {
  const BuildLessonUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'buildLessonUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$buildLessonUseCaseHash();

  @$internal
  @override
  $ProviderElement<BuildLessonUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BuildLessonUseCase create(Ref ref) {
    return buildLessonUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BuildLessonUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BuildLessonUseCase>(value),
    );
  }
}

String _$buildLessonUseCaseHash() =>
    r'e27945f2429dcf29279752957b50a9531dcb7555';
