// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_free_practice_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(submitFreePracticeUseCase)
const submitFreePracticeUseCaseProvider = SubmitFreePracticeUseCaseProvider._();

final class SubmitFreePracticeUseCaseProvider
    extends
        $FunctionalProvider<
          SubmitFreePracticeUseCase,
          SubmitFreePracticeUseCase,
          SubmitFreePracticeUseCase
        >
    with $Provider<SubmitFreePracticeUseCase> {
  const SubmitFreePracticeUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'submitFreePracticeUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$submitFreePracticeUseCaseHash();

  @$internal
  @override
  $ProviderElement<SubmitFreePracticeUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SubmitFreePracticeUseCase create(Ref ref) {
    return submitFreePracticeUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SubmitFreePracticeUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SubmitFreePracticeUseCase>(value),
    );
  }
}

String _$submitFreePracticeUseCaseHash() =>
    r'f2d61bf2159a93beae1c8777fe8d8267b729433d';
