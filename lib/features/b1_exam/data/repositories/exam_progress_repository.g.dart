// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_progress_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(examProgressRepository)
const examProgressRepositoryProvider = ExamProgressRepositoryProvider._();

final class ExamProgressRepositoryProvider
    extends
        $FunctionalProvider<
          ExamProgressRepository,
          ExamProgressRepository,
          ExamProgressRepository
        >
    with $Provider<ExamProgressRepository> {
  const ExamProgressRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'examProgressRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$examProgressRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExamProgressRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExamProgressRepository create(Ref ref) {
    return examProgressRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExamProgressRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExamProgressRepository>(value),
    );
  }
}

String _$examProgressRepositoryHash() =>
    r'11f4df2a0f29ee8ea1293016d299a8559620de76';
