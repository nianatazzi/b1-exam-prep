// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// keepAlive — GoRouter не должен пересоздаваться в течение жизни приложения.

@ProviderFor(router)
const routerProvider = RouterProvider._();

/// keepAlive — GoRouter не должен пересоздаваться в течение жизни приложения.

final class RouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// keepAlive — GoRouter не должен пересоздаваться в течение жизни приложения.
  const RouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'routerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$routerHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return router(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$routerHash() => r'd4ed15c9e6e4aa0028b531058432bb7b4d4e6cd5';
