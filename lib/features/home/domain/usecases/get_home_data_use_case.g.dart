// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_home_data_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getHomeDataUseCase)
const getHomeDataUseCaseProvider = GetHomeDataUseCaseProvider._();

final class GetHomeDataUseCaseProvider
    extends
        $FunctionalProvider<
          GetHomeDataUseCase,
          GetHomeDataUseCase,
          GetHomeDataUseCase
        >
    with $Provider<GetHomeDataUseCase> {
  const GetHomeDataUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getHomeDataUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getHomeDataUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetHomeDataUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetHomeDataUseCase create(Ref ref) {
    return getHomeDataUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetHomeDataUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetHomeDataUseCase>(value),
    );
  }
}

String _$getHomeDataUseCaseHash() =>
    r'75800fc7d80af0b4a278df49c060448d0eca1cc5';
