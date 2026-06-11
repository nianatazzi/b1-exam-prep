// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_progress_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userProgressRepository)
const userProgressRepositoryProvider = UserProgressRepositoryProvider._();

final class UserProgressRepositoryProvider
    extends
        $FunctionalProvider<
          UserProgressRepository,
          UserProgressRepository,
          UserProgressRepository
        >
    with $Provider<UserProgressRepository> {
  const UserProgressRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userProgressRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userProgressRepositoryHash();

  @$internal
  @override
  $ProviderElement<UserProgressRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UserProgressRepository create(Ref ref) {
    return userProgressRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserProgressRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserProgressRepository>(value),
    );
  }
}

String _$userProgressRepositoryHash() =>
    r'd27bec8b18db563ff5b4b5866c85d683beeffc1a';
