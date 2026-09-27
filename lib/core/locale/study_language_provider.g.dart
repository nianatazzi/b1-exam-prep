// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_language_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Текущий язык обучения (ARCHITECTURE.md §12.1) — читает
/// public_user_info/{userId}.preference.selectedLanguage напрямую, тот же
/// паттерн, что onboardingStatusProvider: не зависит от того, был ли уже
/// открыт ProfileScreen (простой independent fetch, не тянет тяжёлый
/// profileProvider с b1-прогрессом/достижениями только ради одного поля).
/// null — язык не выбран ИЛИ вне поддерживаемого набора StudyLanguage
/// (например "ru", который поддерживает linguobyte, но не b1-exam-prep) —
/// вызывающая сторона показывает пустое состояние "content coming soon",
/// не падает.

@ProviderFor(studyLanguage)
const studyLanguageProvider = StudyLanguageProvider._();

/// Текущий язык обучения (ARCHITECTURE.md §12.1) — читает
/// public_user_info/{userId}.preference.selectedLanguage напрямую, тот же
/// паттерн, что onboardingStatusProvider: не зависит от того, был ли уже
/// открыт ProfileScreen (простой independent fetch, не тянет тяжёлый
/// profileProvider с b1-прогрессом/достижениями только ради одного поля).
/// null — язык не выбран ИЛИ вне поддерживаемого набора StudyLanguage
/// (например "ru", который поддерживает linguobyte, но не b1-exam-prep) —
/// вызывающая сторона показывает пустое состояние "content coming soon",
/// не падает.

final class StudyLanguageProvider
    extends
        $FunctionalProvider<
          AsyncValue<StudyLanguage?>,
          StudyLanguage?,
          FutureOr<StudyLanguage?>
        >
    with $FutureModifier<StudyLanguage?>, $FutureProvider<StudyLanguage?> {
  /// Текущий язык обучения (ARCHITECTURE.md §12.1) — читает
  /// public_user_info/{userId}.preference.selectedLanguage напрямую, тот же
  /// паттерн, что onboardingStatusProvider: не зависит от того, был ли уже
  /// открыт ProfileScreen (простой independent fetch, не тянет тяжёлый
  /// profileProvider с b1-прогрессом/достижениями только ради одного поля).
  /// null — язык не выбран ИЛИ вне поддерживаемого набора StudyLanguage
  /// (например "ru", который поддерживает linguobyte, но не b1-exam-prep) —
  /// вызывающая сторона показывает пустое состояние "content coming soon",
  /// не падает.
  const StudyLanguageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'studyLanguageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$studyLanguageHash();

  @$internal
  @override
  $FutureProviderElement<StudyLanguage?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<StudyLanguage?> create(Ref ref) {
    return studyLanguage(ref);
  }
}

String _$studyLanguageHash() => r'2c6533f9202bb83fa4356167b358d473ae3ba938';
