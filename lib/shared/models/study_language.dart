/// Язык обучения (ARCHITECTURE.md §12.1) — общий для b1_exam/profile/auth,
/// отсюда shared/, не b1_exam/domain/. Источник истины —
/// public_user_info/{userId}.preference.selectedLanguage, то же поле, что
/// пишет linguobyte — намеренно не заводим отдельное поле для b1-exam-prep
/// (см. ARCHITECTURE.md §12.1 про кросс-приложенческую консистентность).
enum StudyLanguage {
  pl,
  fr,
  es,
  en,
  de;

  /// Локаль для speech_to_text (BCP-47).
  String get sttLocaleId => switch (this) {
        StudyLanguage.pl => 'pl-PL',
        StudyLanguage.fr => 'fr-FR',
        StudyLanguage.es => 'es-ES',
        StudyLanguage.en => 'en-US',
        StudyLanguage.de => 'de-DE',
      };

  /// Парсит код языка (сырое значение preference.selectedLanguage) в
  /// поддерживаемый b1-exam-prep StudyLanguage. null — язык не выбран ИЛИ
  /// вне поддерживаемого набора (например "ru", который поддерживает
  /// linguobyte, но не b1-exam-prep) — вызывающая сторона показывает то же
  /// пустое состояние, что и для темы без уроков, не падает.
  static StudyLanguage? fromCode(String? code) {
    for (final lang in StudyLanguage.values) {
      if (lang.name == code) return lang;
    }
    return null;
  }
}
