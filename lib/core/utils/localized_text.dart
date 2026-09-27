/// Достаёт текст по коду языка интерфейса из карты map&lt;langCode,string&gt;
/// (GrammarRuleModel.explanation, FreePracticeTaskModel.prompt и т.п.) —
/// тот же паттерн, что раньше был инлайн в PhraseCardWidget/GrammarTableWidget,
/// вынесен сюда: с Lesson Matrix то же самое нужно ещё в нескольких местах
/// (image/monologue/dialogue задания урока). Фолбэк на английский, затем на
/// пустую строку.
String localizedText(Map<String, dynamic> map, String locale) =>
    (map[locale] ?? map['en'] ?? '').toString();
