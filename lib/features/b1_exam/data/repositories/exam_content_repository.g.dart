// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_content_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(examContentRepository)
const examContentRepositoryProvider = ExamContentRepositoryProvider._();

final class ExamContentRepositoryProvider
    extends
        $FunctionalProvider<
          ExamContentRepository,
          ExamContentRepository,
          ExamContentRepository
        >
    with $Provider<ExamContentRepository> {
  const ExamContentRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'examContentRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$examContentRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExamContentRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExamContentRepository create(Ref ref) {
    return examContentRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExamContentRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExamContentRepository>(value),
    );
  }
}

String _$examContentRepositoryHash() =>
    r'e22fed750c4b2e55474f4eea541ee4ffd3c28577';
