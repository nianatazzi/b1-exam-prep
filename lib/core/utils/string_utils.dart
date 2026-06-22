/// Нормализация строки для сравнения ответов:
/// нижний регистр + пунктуация → пробел (апостроф сохраняется для сокращений),
/// повторные пробелы схлопываются.
String normalizeAnswer(String s) => s
    .toLowerCase()
    .replaceAll(RegExp(r"[^\p{L}\p{N}\s']", unicode: true), ' ')
    .replaceAll(RegExp(r'\s+'), ' ')
    .trim();
