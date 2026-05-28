# ARCHITECTURE.md

> Главный ориентир при написании кодовой базы. Читать перед началом любой задачи.

---

## 1. Обзор проекта

Мобильное приложение для изучения иностранных языков на базовом уровне (грамматика, словарный запас, общее понимание). Платформы: Android, iOS.

Контент: теория, упражнения, дополнительные материалы.
Роли: пользователь, администратор. Админ-панель — отдельное веб-приложение, не часть этого проекта.

---

## 2. Стек

| Область | Инструмент |
|---|---|
| Фреймворк | Flutter + Dart |
| База данных | Firestore |
| Авторизация | Firebase Auth |
| Хранилище медиа | Firebase Storage |
| Мониторинг | Firebase Crashlytics, Firebase Analytics |
| State management | Riverpod 3.x с code generation (`@riverpod`) |
| Навигация | GoRouter |
| Сериализация | `freezed` + `json_serializable` |
| Изображения | `cached_network_image` |
| Аудио | `just_audio` |
| Локализация | `flutter_localizations` + `intl` + ARB-файлы |
| Логирование | `logger` через абстракцию `AppLogger` |
| Shimmer | `shimmer` |

> Видеоплеер и видеохостинг — открытый пункт, решается отдельно.
> Не подключать новые пакеты без явного указания.

---

## 3. Архитектурный паттерн

**Clean Architecture** (слои `data` / `domain` / `presentation`) + **MVVM** в `presentation`-слое.

Направление зависимостей: `presentation` → `domain` ← `data`. Зависимости направлены только внутрь. `domain` не зависит ни от чего.

### Когда использовать UseCase
- В экране более одного источника данных
- Есть бизнес-логика

В остальных случаях — провайдер обращается к репозиторию напрямую, UseCase не нужен.

### Когда использовать Riverpod
Только для глобального состояния, асинхронных данных и dependency injection.

- Простые виджеты без состояния — `StatelessWidget`
- Локальное UI-состояние (анимации, фокус, раскрытый элемент) — `StatefulWidget`
- Не оборачивать в провайдер то, что не нужно за пределами виджета

---

## 4. Структура папок

```
lib/
  features/
    auth/
      data/
      domain/
      presentation/
    home/
      data/
      domain/
      presentation/
    lesson/
      data/
      domain/
      presentation/
    profile/
      data/
      domain/
      presentation/
  core/
    constants/        # FirestorePaths, AppRoutes, AppSpacing, AppSizes
    errors/           # AppError, маппинг исключений
    router/           # GoRouter конфиг
    theme/            # AppTheme, ThemeData
    logger/           # AppLogger
  shared/
    widgets/          # переиспользуемые виджеты
    models/           # общие модели
```

**Правила:**
- Всё, что используется более чем в одной фиче — в `core/` (инфраструктура) или `shared/` (виджеты, модели)
- Циклические импорты между фичами запрещены

---

## 5. State Management (Riverpod)

- Использовать Riverpod 3.x с `@riverpod` code generation
- `AsyncNotifier` — основной ViewModel для экранов с асинхронными данными
- `ref.watch` — в провайдерах и методе `build`
- `ref.read` — только в обработчиках событий (`onPressed` и т.п.)
- `StreamBuilder` без кэширования не использовать — лишние reads Firestore
- UI-состояние — локально в виджете, не в провайдере

---

## 6. Навигация (GoRouter)

- Все маршруты декларативные, пути — константы в `AppRoutes`
- **Авторизация:** `refreshListenable` + `redirect`. `AuthNotifier` в Riverpod слушается GoRouter. Если не авторизован — редирект на `/auth`. Если авторизован и открывает `/auth` — редирект на `/home`.
- **LessonScreen** содержит вложенные маршруты через `ShellRoute`: `TheoryScreen` → `PracticeScreen` → `AdditionalScreen`. Это последовательный флоу, не вкладки.

---

## 7. Экраны MVP

- `SplashScreen`
- `AuthorizationScreen` (вход, регистрация, восстановление пароля)
- `HomeScreen`
- `ProfileScreen`
- `LessonScreen`
  - `TheoryScreen`
  - `PracticeScreen`
  - `AdditionalScreen`

---

## 8. Firebase / Firestore

- `persistenceEnabled: true` — указать явно при инициализации
- **Security Rules** настроить с первого дня:
  - `basic` — чтение для всех авторизованных пользователей
  - `private_user_info/{userId}` — только владелец
- Все пути к коллекциям — только через `FirestorePaths`. Строки напрямую в коде запрещены.
- Роль пользователя проверяется в Security Rules или Cloud Functions. Проверка только на клиенте запрещена.
- Структура коллекций описана в `FIRESTORE.md`.

---

## 9. Модели данных

- Все модели — `freezed` + `json_serializable`
- Обязательно: `fromJson`, `toJson`, `copyWith`
- `AppError` — `sealed class`:

```dart
sealed class AppError {
  const AppError();
}
class NetworkError extends AppError {}
class AuthError extends AppError {}
class NotFoundError extends AppError {}
class UnknownError extends AppError {
  final String message;
  const UnknownError(this.message);
}
```

- Исключения Firestore маппятся в `AppError` на уровне `data`-слоя. До `domain` исключения не доходят.
- `catch` без маппинга в `AppError` запрещён.

---

## 10. Обработка ошибок

- `AsyncValue` (Riverpod) — основной механизм состояний `loading` / `data` / `error` в UI
- Для MVP: одно сообщение об ошибке + кнопка Retry
- Детальные сообщения для разных типов ошибок — после MVP

---

## 11. Loading state

| Ситуация | Компонент |
|---|---|
| Действие (кнопка, отправка формы) | `CircularProgressIndicator` |
| Загрузка контента (списки, карточки) | `Shimmer` (пакет `shimmer`) |

---

## 12. Локализация

- `flutter_localizations` + `intl`, ARB-файлы с первого дня
- Расположение: `lib/l10n/app_en.arb`, `app_ru.arb`, `app_fr.arb`, `app_es.arb`
- Язык интерфейса по умолчанию: английский
- Языки интерфейса MVP: EN, RU, FR, ES
- **Язык интерфейса** (локаль устройства) и **язык обучения** (выбор пользователя в профиле) — разные сущности, не смешивать
- Все строки интерфейса — только через ARB. Хардкод строк запрещён.

---

## 13. Тема оформления

- Вся тема — через `AppTheme` и `ThemeData`
- Хардкод цветов, размеров и отступов в виджетах запрещён
- Определить до написания первого экрана: primary / secondary / error цвета, стили текста, `AppSpacing`, `AppSizes`
- Цвета и типографика — в `ThemeData`
- Отступы и размеры — в константах `AppSpacing` / `AppSizes`

---

## 14. Именование

| Сущность | Стиль | Пример |
|---|---|---|
| Файлы | `snake_case` | `get_lesson_use_case.dart` |
| Экраны | `PascalCase` + `Screen` | `HomeScreen` |
| Модели | `PascalCase` + `Model` | `LessonModel` |
| Репозитории | `PascalCase` + `Repository` | `LessonRepository` |
| UseCase | `PascalCase` + `UseCase` | `GetLessonUseCase` |
| Классы нотификаторов | `PascalCase` | `LessonNotifier` |
| Провайдеры | `camelCase` + `Provider` | `lessonProvider` |
| Коллекции Firestore | `camelCase` | `privateUserInfo` |

> Провайдеры в `camelCase` — не исключение из правил, а поведение генератора `@riverpod`. Класс нотификатора (`LessonNotifier`) — `PascalCase`. Провайдер (`lessonProvider`) генерируется автоматически в `camelCase`. Riverpod 3.x убирает суффикс `Notifier` из имени провайдера.

---

## 15. Константы

| Класс | Содержимое |
|---|---|
| `FirestorePaths` | Все пути Firestore (статические строки + методы для динамических путей) |
| `AppRoutes` | Все маршруты GoRouter |
| `AppSpacing` | Отступы |
| `AppSizes` | Размеры UI-элементов |

Цвета и типографика — не константы, только `ThemeData`.

Пример `FirestorePaths`:
```dart
abstract class FirestorePaths {
  static const String basic = 'basic';
  static const String privateUserInfo = 'private_user_info';
  static const String publicUserInfo = 'public_user_info';
  static String lessons(String langId) => '$basic/$langId/lessons';
  static String exercises(String langId) => '$basic/$langId/exercises';
}
```

---

## 16. Медиа

- **Изображения:** `cached_network_image`. Настроить `maxCacheSize` и `maxCacheAge`.
- **Аудио:** `just_audio` для MVP. Миграция на `audio_service` (фоновое воспроизведение) — при необходимости в будущем, без переписывания логики.
- **Видео:** открытый пункт, решается после выбора хранилища.

---

## 17. Инициализация (до написания первого экрана)

- **Crashlytics** — подключить сразу
- **Firebase Analytics** — подключить сразу, события настраивать позже
- **`AppLogger`** — абстракция над `logger`. В проде отключается одной строкой.
- **Переменные окружения** (Firebase конфиг, ключи) — через `--dart-define` или `.env`. Хардкод в коде запрещён.

---

## 18. Офлайн

- Встроенный кэш Firestore (`persistenceEnabled: true`) — достаточно для MVP
- Предзагрузка контента и офлайн-доступ к медиа — за пределами MVP

---

## 19. Открытые пункты

- Видеоплеер и видеохостинг — решается после выбора хранилища
- Тестирование и CI/CD — после реализации MVP
- Детальная обработка ошибок с разными сообщениями — после MVP
- Офлайн-предзагрузка медиа — после MVP

### Технический долг (зафиксировать до постMVP-итерации)

- **`mapFirebaseException`**: добавить Auth-специфичные коды (`wrong-password`, `user-not-found`, `email-already-in-use`, `weak-password`) → маппить в `AuthError`, сейчас падают в `UnknownError`
- **Валидация форм** (`AuthorizationScreen`): добавить проверку формата email и минимальной длины пароля
- **`UserModel.fromDocument`**: перенести из `domain` в `data`-слой (репозиторий) для соблюдения чистоты слоёв — domain не должен зависеть от `cloud_firestore`
- **Запоминание входа** (`AuthorizationScreen`): чтобы не приходилось постоянно заново вводить пароль и логин
