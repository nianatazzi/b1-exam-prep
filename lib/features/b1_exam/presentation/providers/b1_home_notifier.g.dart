// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'b1_home_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Тайл темы — лексическая тема (Lesson Matrix §A, тайл первого уровня —
/// решение подтверждено пользователем). Группировка уроков по теме — в
/// памяти, отдельного запроса на тему не нужно (лексических тем и уроков
/// мало, см. §F: 4 урока для MVP). [language] — null, если выбранный язык
/// обучения (ARCHITECTURE.md §12.1) вне поддерживаемого набора
/// b1-exam-prep: экран показывает пустое состояние, не падает.

@ProviderFor(B1HomeNotifier)
const b1HomeProvider = B1HomeNotifierProvider._();

/// Тайл темы — лексическая тема (Lesson Matrix §A, тайл первого уровня —
/// решение подтверждено пользователем). Группировка уроков по теме — в
/// памяти, отдельного запроса на тему не нужно (лексических тем и уроков
/// мало, см. §F: 4 урока для MVP). [language] — null, если выбранный язык
/// обучения (ARCHITECTURE.md §12.1) вне поддерживаемого набора
/// b1-exam-prep: экран показывает пустое состояние, не падает.
final class B1HomeNotifierProvider
    extends $AsyncNotifierProvider<B1HomeNotifier, B1HomeState> {
  /// Тайл темы — лексическая тема (Lesson Matrix §A, тайл первого уровня —
  /// решение подтверждено пользователем). Группировка уроков по теме — в
  /// памяти, отдельного запроса на тему не нужно (лексических тем и уроков
  /// мало, см. §F: 4 урока для MVP). [language] — null, если выбранный язык
  /// обучения (ARCHITECTURE.md §12.1) вне поддерживаемого набора
  /// b1-exam-prep: экран показывает пустое состояние, не падает.
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

String _$b1HomeNotifierHash() => r'aa4bc971f3eff546fab4eb20c006df6be24739c3';

/// Тайл темы — лексическая тема (Lesson Matrix §A, тайл первого уровня —
/// решение подтверждено пользователем). Группировка уроков по теме — в
/// памяти, отдельного запроса на тему не нужно (лексических тем и уроков
/// мало, см. §F: 4 урока для MVP). [language] — null, если выбранный язык
/// обучения (ARCHITECTURE.md §12.1) вне поддерживаемого набора
/// b1-exam-prep: экран показывает пустое состояние, не падает.

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
