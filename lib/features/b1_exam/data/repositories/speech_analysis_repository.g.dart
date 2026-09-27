// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speech_analysis_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(speechAnalysisRepository)
const speechAnalysisRepositoryProvider = SpeechAnalysisRepositoryProvider._();

final class SpeechAnalysisRepositoryProvider
    extends
        $FunctionalProvider<
          SpeechAnalysisRepository,
          SpeechAnalysisRepository,
          SpeechAnalysisRepository
        >
    with $Provider<SpeechAnalysisRepository> {
  const SpeechAnalysisRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'speechAnalysisRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$speechAnalysisRepositoryHash();

  @$internal
  @override
  $ProviderElement<SpeechAnalysisRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SpeechAnalysisRepository create(Ref ref) {
    return speechAnalysisRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpeechAnalysisRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SpeechAnalysisRepository>(value),
    );
  }
}

String _$speechAnalysisRepositoryHash() =>
    r'0f1a01c5f829be2f2b140aebdfb66ca3e4e33fb3';
