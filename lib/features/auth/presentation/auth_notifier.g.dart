// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Глобальное состояние авторизации.
/// keepAlive — живёт всё время работы приложения, GoRouter зависит от него.

@ProviderFor(AuthNotifier)
const authProvider = AuthNotifierProvider._();

/// Глобальное состояние авторизации.
/// keepAlive — живёт всё время работы приложения, GoRouter зависит от него.
final class AuthNotifierProvider
    extends $AsyncNotifierProvider<AuthNotifier, UserModel?> {
  /// Глобальное состояние авторизации.
  /// keepAlive — живёт всё время работы приложения, GoRouter зависит от него.
  const AuthNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authNotifierHash();

  @$internal
  @override
  AuthNotifier create() => AuthNotifier();
}

String _$authNotifierHash() => r'51b5bfc264bf757e745cc9e9a7b92c7833b32730';

/// Глобальное состояние авторизации.
/// keepAlive — живёт всё время работы приложения, GoRouter зависит от него.

abstract class _$AuthNotifier extends $AsyncNotifier<UserModel?> {
  FutureOr<UserModel?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<UserModel?>, UserModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserModel?>, UserModel?>,
              AsyncValue<UserModel?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
