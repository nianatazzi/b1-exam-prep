// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Хранит выбранную пользователем локаль интерфейса.
/// null → использовать системную локаль устройства.
/// keepAlive — живёт всё время работы приложения, MaterialApp зависит от него.

@ProviderFor(AppLocaleNotifier)
const appLocaleProvider = AppLocaleNotifierProvider._();

/// Хранит выбранную пользователем локаль интерфейса.
/// null → использовать системную локаль устройства.
/// keepAlive — живёт всё время работы приложения, MaterialApp зависит от него.
final class AppLocaleNotifierProvider
    extends $NotifierProvider<AppLocaleNotifier, Locale?> {
  /// Хранит выбранную пользователем локаль интерфейса.
  /// null → использовать системную локаль устройства.
  /// keepAlive — живёт всё время работы приложения, MaterialApp зависит от него.
  const AppLocaleNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLocaleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLocaleNotifierHash();

  @$internal
  @override
  AppLocaleNotifier create() => AppLocaleNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale?>(value),
    );
  }
}

String _$appLocaleNotifierHash() => r'a9aa1edda3905a9f8501267ce96d174311f0b4cf';

/// Хранит выбранную пользователем локаль интерфейса.
/// null → использовать системную локаль устройства.
/// keepAlive — живёт всё время работы приложения, MaterialApp зависит от него.

abstract class _$AppLocaleNotifier extends $Notifier<Locale?> {
  Locale? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Locale?, Locale?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Locale?, Locale?>,
              Locale?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
