// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'b1_home_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(B1HomeNotifier)
const b1HomeProvider = B1HomeNotifierProvider._();

final class B1HomeNotifierProvider
    extends $AsyncNotifierProvider<B1HomeNotifier, B1HomeState> {
  const B1HomeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'b1HomeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$b1HomeNotifierHash();

  @$internal
  @override
  B1HomeNotifier create() => B1HomeNotifier();
}

String _$b1HomeNotifierHash() => r'563b5f5045c2c9baf399014dd5a7cf729bfe2baf';

abstract class _$B1HomeNotifier extends $AsyncNotifier<B1HomeState> {
  FutureOr<B1HomeState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<B1HomeState>, B1HomeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<B1HomeState>, B1HomeState>,
              AsyncValue<B1HomeState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
