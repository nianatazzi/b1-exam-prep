// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'free_practice_analysis_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(freePracticeAnalysisRepository)
const freePracticeAnalysisRepositoryProvider =
    FreePracticeAnalysisRepositoryProvider._();

final class FreePracticeAnalysisRepositoryProvider
    extends
        $FunctionalProvider<
          FreePracticeAnalysisRepository,
          FreePracticeAnalysisRepository,
          FreePracticeAnalysisRepository
        >
    with $Provider<FreePracticeAnalysisRepository> {
  const FreePracticeAnalysisRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'freePracticeAnalysisRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$freePracticeAnalysisRepositoryHash();

  @$internal
  @override
  $ProviderElement<FreePracticeAnalysisRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FreePracticeAnalysisRepository create(Ref ref) {
    return freePracticeAnalysisRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FreePracticeAnalysisRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FreePracticeAnalysisRepository>(
        value,
      ),
    );
  }
}

String _$freePracticeAnalysisRepositoryHash() =>
    r'40ddada42bfb8355112cb5e55f89aac15a33fcc3';
