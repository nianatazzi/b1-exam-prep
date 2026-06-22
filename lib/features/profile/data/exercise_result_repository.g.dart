// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_result_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(exerciseResultRepository)
const exerciseResultRepositoryProvider = ExerciseResultRepositoryProvider._();

final class ExerciseResultRepositoryProvider
    extends
        $FunctionalProvider<
          ExerciseResultRepository,
          ExerciseResultRepository,
          ExerciseResultRepository
        >
    with $Provider<ExerciseResultRepository> {
  const ExerciseResultRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exerciseResultRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exerciseResultRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExerciseResultRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExerciseResultRepository create(Ref ref) {
    return exerciseResultRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExerciseResultRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExerciseResultRepository>(value),
    );
  }
}

String _$exerciseResultRepositoryHash() =>
    r'5f0b807454e36c04bb671bdb259c577d153d04c8';
