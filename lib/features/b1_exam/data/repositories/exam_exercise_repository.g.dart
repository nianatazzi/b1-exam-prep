// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_exercise_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(examExerciseRepository)
const examExerciseRepositoryProvider = ExamExerciseRepositoryProvider._();

final class ExamExerciseRepositoryProvider
    extends
        $FunctionalProvider<
          ExamExerciseRepository,
          ExamExerciseRepository,
          ExamExerciseRepository
        >
    with $Provider<ExamExerciseRepository> {
  const ExamExerciseRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'examExerciseRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$examExerciseRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExamExerciseRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExamExerciseRepository create(Ref ref) {
    return examExerciseRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExamExerciseRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExamExerciseRepository>(value),
    );
  }
}

String _$examExerciseRepositoryHash() =>
    r'86e5f53f19edc2b25ae08f13ae679e7989456126';
