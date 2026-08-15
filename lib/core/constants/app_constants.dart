/// Бизнес-константы приложения (пороги, лимиты), не зависящие от темы/размеров.
abstract class AppConstants {
  /// Порог успешного прохождения субпарта, % правильных ответов.
  /// Зелёный индикатор ≥ порога, красный — ниже.
  static const int passThresholdPercent = 78;

  /// Показывать debug-кнопку Skip в упражнениях в release/profile сборках.
  /// Включается флагом сборки: --dart-define=SHOW_SKIP_BUTTON=true
  /// (тестовые TestFlight/ad-hoc билды для тестеров). В debug-режиме
  /// кнопка видна всегда, независимо от флага.
  static const bool showSkipButton = bool.fromEnvironment('SHOW_SKIP_BUTTON');
}
