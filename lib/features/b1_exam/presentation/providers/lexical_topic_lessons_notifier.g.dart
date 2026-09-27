// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lexical_topic_lessons_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Уроки одной лексической темы (Lesson Matrix §A — тайл темы подтверждён
/// как первый уровень навигации). Тема, грамматические темы и уроки — все
/// маленькие коллекции (§F: 4 урока в MVP), поэтому грузим целиком и
/// фильтруем/сопоставляем в памяти — тот же паттерн, что и в
/// B1HomeNotifier, без отдельного запроса "уроки по теме".

@ProviderFor(LexicalTopicLessonsNotifier)
const lexicalTopicLessonsProvider = LexicalTopicLessonsNotifierFamily._();

/// Уроки одной лексической темы (Lesson Matrix §A — тайл темы подтверждён
/// как первый уровень навигации). Тема, грамматические темы и уроки — все
/// маленькие коллекции (§F: 4 урока в MVP), поэтому грузим целиком и
/// фильтруем/сопоставляем в памяти — тот же паттерн, что и в
/// B1HomeNotifier, без отдельного запроса "уроки по теме".
final class LexicalTopicLessonsNotifierProvider
    extends
        $AsyncNotifierProvider<
          LexicalTopicLessonsNotifier,
          LexicalTopicLessonsState
        > {
  /// Уроки одной лексической темы (Lesson Matrix §A — тайл темы подтверждён
  /// как первый уровень навигации). Тема, грамматические темы и уроки — все
  /// маленькие коллекции (§F: 4 урока в MVP), поэтому грузим целиком и
  /// фильтруем/сопоставляем в памяти — тот же паттерн, что и в
  /// B1HomeNotifier, без отдельного запроса "уроки по теме".
  const LexicalTopicLessonsNotifierProvider._({
    required LexicalTopicLessonsNotifierFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'lexicalTopicLessonsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lexicalTopicLessonsNotifierHash();

  @override
  String toString() {
    return r'lexicalTopicLessonsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  LexicalTopicLessonsNotifier create() => LexicalTopicLessonsNotifier();

  @override
  bool operator ==(Object other) {
    return other is LexicalTopicLessonsNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lexicalTopicLessonsNotifierHash() =>
    r'fc34b0446b9ddc0dc8008088abad6dadb3d688dd';

/// Уроки одной лексической темы (Lesson Matrix §A — тайл темы подтверждён
/// как первый уровень навигации). Тема, грамматические темы и уроки — все
/// маленькие коллекции (§F: 4 урока в MVP), поэтому грузим целиком и
/// фильтруем/сопоставляем в памяти — тот же паттерн, что и в
/// B1HomeNotifier, без отдельного запроса "уроки по теме".

final class LexicalTopicLessonsNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          LexicalTopicLessonsNotifier,
          AsyncValue<LexicalTopicLessonsState>,
          LexicalTopicLessonsState,
          FutureOr<LexicalTopicLessonsState>,
          (String, String)
        > {
  const LexicalTopicLessonsNotifierFamily._()
    : super(
        retry: null,
        name: r'lexicalTopicLessonsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Уроки одной лексической темы (Lesson Matrix §A — тайл темы подтверждён
  /// как первый уровень навигации). Тема, грамматические темы и уроки — все
  /// маленькие коллекции (§F: 4 урока в MVP), поэтому грузим целиком и
  /// фильтруем/сопоставляем в памяти — тот же паттерн, что и в
  /// B1HomeNotifier, без отдельного запроса "уроки по теме".

  LexicalTopicLessonsNotifierProvider call(
    String langId,
    String lexicalTopicId,
  ) => LexicalTopicLessonsNotifierProvider._(
    argument: (langId, lexicalTopicId),
    from: this,
  );

  @override
  String toString() => r'lexicalTopicLessonsProvider';
}

/// Уроки одной лексической темы (Lesson Matrix §A — тайл темы подтверждён
/// как первый уровень навигации). Тема, грамматические темы и уроки — все
/// маленькие коллекции (§F: 4 урока в MVP), поэтому грузим целиком и
/// фильтруем/сопоставляем в памяти — тот же паттерн, что и в
/// B1HomeNotifier, без отдельного запроса "уроки по теме".

abstract class _$LexicalTopicLessonsNotifier
    extends $AsyncNotifier<LexicalTopicLessonsState> {
  late final _$args = ref.$arg as (String, String);
  String get langId => _$args.$1;
  String get lexicalTopicId => _$args.$2;

  FutureOr<LexicalTopicLessonsState> build(
    String langId,
    String lexicalTopicId,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args.$1, _$args.$2);
    final ref =
        this.ref
            as $Ref<
              AsyncValue<LexicalTopicLessonsState>,
              LexicalTopicLessonsState
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<LexicalTopicLessonsState>,
                LexicalTopicLessonsState
              >,
              AsyncValue<LexicalTopicLessonsState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
