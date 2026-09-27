// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialogue_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dialogueRepository)
const dialogueRepositoryProvider = DialogueRepositoryProvider._();

final class DialogueRepositoryProvider
    extends
        $FunctionalProvider<
          DialogueRepository,
          DialogueRepository,
          DialogueRepository
        >
    with $Provider<DialogueRepository> {
  const DialogueRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dialogueRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dialogueRepositoryHash();

  @$internal
  @override
  $ProviderElement<DialogueRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DialogueRepository create(Ref ref) {
    return dialogueRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DialogueRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DialogueRepository>(value),
    );
  }
}

String _$dialogueRepositoryHash() =>
    r'8cae44c7498de53d1d369832fb498b21f4d4ed24';
