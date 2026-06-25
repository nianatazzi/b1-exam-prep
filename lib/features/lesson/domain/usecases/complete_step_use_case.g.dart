// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_step_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(completeStepUseCase)
const completeStepUseCaseProvider = CompleteStepUseCaseProvider._();

final class CompleteStepUseCaseProvider
    extends
        $FunctionalProvider<
          CompleteStepUseCase,
          CompleteStepUseCase,
          CompleteStepUseCase
        >
    with $Provider<CompleteStepUseCase> {
  const CompleteStepUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'completeStepUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$completeStepUseCaseHash();

  @$internal
  @override
  $ProviderElement<CompleteStepUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CompleteStepUseCase create(Ref ref) {
    return completeStepUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CompleteStepUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CompleteStepUseCase>(value),
    );
  }
}

String _$completeStepUseCaseHash() =>
    r'b39c35789cb57625e18aec1255684ae310edc223';
