// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Флаг onboardingComplete текущего пользователя, кэшированный для роутера.
/// autoDispose — router ref держит подписку через ref.listen, не даёт GC убрать
/// раньше времени. После завершения онбординга провайдер утилизируется сам.

@ProviderFor(onboardingStatus)
const onboardingStatusProvider = OnboardingStatusProvider._();

/// Флаг onboardingComplete текущего пользователя, кэшированный для роутера.
/// autoDispose — router ref держит подписку через ref.listen, не даёт GC убрать
/// раньше времени. После завершения онбординга провайдер утилизируется сам.

final class OnboardingStatusProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Флаг onboardingComplete текущего пользователя, кэшированный для роутера.
  /// autoDispose — router ref держит подписку через ref.listen, не даёт GC убрать
  /// раньше времени. После завершения онбординга провайдер утилизируется сам.
  const OnboardingStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingStatusHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return onboardingStatus(ref);
  }
}

String _$onboardingStatusHash() => r'b8326c329869dcf39313021d6e98ccda8fa701b4';
