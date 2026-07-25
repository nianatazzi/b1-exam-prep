// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_b1_step_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(completeB1StepUseCase)
const completeB1StepUseCaseProvider = CompleteB1StepUseCaseProvider._();

final class CompleteB1StepUseCaseProvider
    extends
        $FunctionalProvider<
          CompleteB1StepUseCase,
          CompleteB1StepUseCase,
          CompleteB1StepUseCase
        >
    with $Provider<CompleteB1StepUseCase> {
  const CompleteB1StepUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'completeB1StepUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$completeB1StepUseCaseHash();

  @$internal
  @override
  $ProviderElement<CompleteB1StepUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CompleteB1StepUseCase create(Ref ref) {
    return completeB1StepUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CompleteB1StepUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CompleteB1StepUseCase>(value),
    );
  }
}

String _$completeB1StepUseCaseHash() =>
    r'ab84142895205ec8211508105fe179491b855828';
