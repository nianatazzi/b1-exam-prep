// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Список языков для пикера — загружается один раз при открытии онбординга.

@ProviderFor(onboardingLanguages)
const onboardingLanguagesProvider = OnboardingLanguagesProvider._();

/// Список языков для пикера — загружается один раз при открытии онбординга.

final class OnboardingLanguagesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LanguageModel>>,
          List<LanguageModel>,
          FutureOr<List<LanguageModel>>
        >
    with
        $FutureModifier<List<LanguageModel>>,
        $FutureProvider<List<LanguageModel>> {
  /// Список языков для пикера — загружается один раз при открытии онбординга.
  const OnboardingLanguagesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingLanguagesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingLanguagesHash();

  @$internal
  @override
  $FutureProviderElement<List<LanguageModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LanguageModel>> create(Ref ref) {
    return onboardingLanguages(ref);
  }
}

String _$onboardingLanguagesHash() =>
    r'f67ab639f98e908c235f25c3da3b3943802560eb';

@ProviderFor(OnboardingNotifier)
const onboardingProvider = OnboardingNotifierProvider._();

final class OnboardingNotifierProvider
    extends $NotifierProvider<OnboardingNotifier, OnboardingState> {
  const OnboardingNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingNotifierHash();

  @$internal
  @override
  OnboardingNotifier create() => OnboardingNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnboardingState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OnboardingState>(value),
    );
  }
}

String _$onboardingNotifierHash() =>
    r'dbe6310db5410da4e73a0bf615579ff144beca62';

abstract class _$OnboardingNotifier extends $Notifier<OnboardingState> {
  OnboardingState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<OnboardingState, OnboardingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OnboardingState, OnboardingState>,
              OnboardingState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
