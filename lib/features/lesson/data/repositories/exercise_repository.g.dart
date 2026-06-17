// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(exerciseRepository)
const exerciseRepositoryProvider = ExerciseRepositoryProvider._();

final class ExerciseRepositoryProvider
    extends
        $FunctionalProvider<
          ExerciseRepository,
          ExerciseRepository,
          ExerciseRepository
        >
    with $Provider<ExerciseRepository> {
  const ExerciseRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exerciseRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exerciseRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExerciseRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExerciseRepository create(Ref ref) {
    return exerciseRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExerciseRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExerciseRepository>(value),
    );
  }
}

String _$exerciseRepositoryHash() =>
    r'ce182e1a789d5a11fd118efbb3c4dd2d283f3f9d';
