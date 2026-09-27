// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_oral_step_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(submitOralStepUseCase)
const submitOralStepUseCaseProvider = SubmitOralStepUseCaseProvider._();

final class SubmitOralStepUseCaseProvider
    extends
        $FunctionalProvider<
          SubmitOralStepUseCase,
          SubmitOralStepUseCase,
          SubmitOralStepUseCase
        >
    with $Provider<SubmitOralStepUseCase> {
  const SubmitOralStepUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'submitOralStepUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$submitOralStepUseCaseHash();

  @$internal
  @override
  $ProviderElement<SubmitOralStepUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SubmitOralStepUseCase create(Ref ref) {
    return submitOralStepUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SubmitOralStepUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SubmitOralStepUseCase>(value),
    );
  }
}

String _$submitOralStepUseCaseHash() =>
    r'da6f5e0f08c068dde096907924286c7e00baa3c9';
