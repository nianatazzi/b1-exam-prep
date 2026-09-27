// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_dialogue_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(submitDialogueUseCase)
const submitDialogueUseCaseProvider = SubmitDialogueUseCaseProvider._();

final class SubmitDialogueUseCaseProvider
    extends
        $FunctionalProvider<
          SubmitDialogueUseCase,
          SubmitDialogueUseCase,
          SubmitDialogueUseCase
        >
    with $Provider<SubmitDialogueUseCase> {
  const SubmitDialogueUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'submitDialogueUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$submitDialogueUseCaseHash();

  @$internal
  @override
  $ProviderElement<SubmitDialogueUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SubmitDialogueUseCase create(Ref ref) {
    return submitDialogueUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SubmitDialogueUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SubmitDialogueUseCase>(value),
    );
  }
}

String _$submitDialogueUseCaseHash() =>
    r'df1a337813b83085ed5bc9fdf80a4c6bea89e42b';
