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

### Развязка слоёв через интерфейсы

Если UseCase или domain-класс нуждается в данных из репозитория — он зависит только от **абстрактного интерфейса** (`ILessonRepository`), объявленного в `domain/repositories/`. Конкретная реализация (`LessonRepository`) живёт в `data/` и реализует этот интерфейс. Riverpod-провайдер служит DI-мостом: создаёт конкретную реализацию и передаёт её туда, где ожидается интерфейс.

```
domain/repositories/i_lesson_repository.dart   ← абстракция (domain)
data/repositories/lesson_repository.dart        ← реализация (data, implements ILessonRepository)
domain/usecases/get_home_data_use_case.dart     ← использует ILessonRepository
                @riverpod-функция               ← DI: передаёт LessonRepository как ILessonRepository
```

### Когда использовать UseCase

UseCase нужен когда есть **бизнес-логика** — не просто чтение данных, а их обработка:

**Использовать UseCase если:**
- Данные из нескольких источников **трансформируются** или **объединяются** по правилу (например: показать урок только если у пользователя есть подписка и прогресс > 50%)
- Логика была бы **продублирована** в нескольких нотификаторах
- Данные приходят из **разных систем** (Firestore + REST API, Firestore + локальная БД)
- Есть **инварианты** которые нужно соблюдать (нельзя выбрать premium-язык без подписки)
- Операция состоит из нескольких шагов с условиями (если A → сделай B, иначе C)

**Не использовать UseCase если:**
- Нотификатор просто вызывает один или несколько методов репозитория без трансформации
- Два Firestore-документа загружаются параллельно — это не логика, это два `await`
- Логика используется только в одном месте и умещается в 3–5 строк

**Правило проверки:** если UseCase можно заменить на прямой вызов `repo.getX()` в нотификаторе без потери читаемости — UseCase не нужен.

В остальных случаях — провайдер обращается к репозиторию напрямую.

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
    locale/           # AppLocaleNotifier — выбранный пользователем язык интерфейса
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
- `ref.watch` — в синхронных провайдерах и в `build()` для **реактивных** провайдеров (чьё изменение должно перезапустить build)
- `ref.read` — в обработчиках событий (`onPressed` и т.п.), а также в `async build()` для **сервисных** провайдеров (репозитории, UseCase): `ref.watch` после `await` вызывает бесконечный rebuild-цикл, потому что Riverpod отменяет текущий `build()` при каждой переоценке зависимостей
- `StreamBuilder` без кэширования не использовать — лишние reads Firestore
- UI-состояние — локально в виджете, не в провайдере
- После мутации данных для перезагрузки использовать `ref.invalidateSelf()` — **не вызывать `build()` напрямую**: прямой вызов обходит систему отслеживания зависимостей Riverpod

---

## 6. Навигация (GoRouter)

- Все маршруты декларативные, пути — константы в `AppRoutes`
- **`SplashScreen`** — только UI (spinner). Навигацию целиком берёт на себя `redirect` в GoRouter: пока auth загружается — остаётся на splash; когда auth определился — уходит на `/auth` или `/home`/`/profile`.
- **Авторизация:** `refreshListenable` + `redirect`. `AuthNotifier` в Riverpod слушается GoRouter:
  - Не авторизован → `/auth`
  - Авторизован, новый пользователь (`_isNewUser = true`) → `/profile`
  - Авторизован, вернувшийся пользователь → `/home`
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
- **Язык интерфейса** и **язык обучения** — разные сущности, не смешивать:
  - **Язык интерфейса** — выбирается пользователем в `ProfileScreen`. Хранится в `public_user_info/{userId}.preference.uiLanguage`. Управляется через `AppLocaleNotifier` (`core/locale/`). `MaterialApp.locale` берёт значение из этого провайдера.
  - **Язык обучения** — выбирается на `HomeScreen`. Хранится в `private_user_info/{userId}/languages/{langId}`.
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

---

## 20. Технический долг

Фиксируется здесь. Решается до постMVP-итерации или при выходе на соответствующую фазу.

### Фазы 1–2 (Auth + Profile)

- **`mapFirebaseException`**: добавить Auth-специфичные коды (`wrong-password`, `user-not-found`, `email-already-in-use`, `weak-password`) → маппить в `AuthError`, сейчас падают в `UnknownError`
- **Валидация форм** (`AuthorizationScreen`): добавить проверку формата email и минимальной длины пароля
- **`UserModel.fromDocument`**: перенести из `domain` в `data`-слой (репозиторий) для соблюдения чистоты слоёв — domain не должен зависеть от `cloud_firestore`
- **`AuthRepository.signUp`**: создаёт документы в Firestore (`public_user_info`, `private_user_info`) — нарушает единственную ответственность. Перенести в отдельный UseCase (`CreateUserProfileUseCase`) или заменить Cloud Function триггером `onCreate`.
- **`AuthNotifier._isNewUser`**: флаг новой регистрации хранится in-memory — не переживает перезапуск приложения. Если пользователь закрыл приложение до заполнения профиля, при следующем входе попадёт на HomeScreen. Пост-MVP: заменить на поле `onboardingComplete: bool` в `private_user_info` Firestore.
- **Запоминание входа** (`AuthorizationScreen`): чтобы не приходилось постоянно заново вводить пароль и логин

### Фаза 3 (HomeScreen)

- **`get_home_data_use_case.dart`**: `@riverpod`-провайдер в domain-файле импортирует data-репозитории для DI-wiring. Класс `GetHomeDataUseCase` уже зависит только от domain-интерфейсов, но файловый уровень связи остался. Долгосрочное решение: перенести провайдер в `presentation/providers/home_providers.dart`.
- **Exercise dots** (`LessonCard`): точки прогресса упражнений отсутствуют (Вариант А, MVP). При реализации Фазы 4 добавить `completedExercises` в схему Firestore и вернуть ex-dots в `LessonCard`.
- **Порядок уроков**: `LessonModel` не имеет поля `position`, Firestore не гарантирует порядок документов. Добавить `position: number` в коллекцию `lessons`, сортировать по нему в `LessonRepository`.
- **Новый пользователь**: при `lastLesson = null` первый урок разблокируется в коде (MVP-решение). Фаза 4: реализовать полноценный онбординг-флоу или подтвердить, что текущего решения достаточно.
- **`activeIndex == -1`**: если `lastLesson` установлен, но урок не найден в списке — все карточки locked без возможности восстановления. Пост-MVP: добавить кнопку сброса прогресса по языку в `ProfileScreen`.
- **`UserRepository` cross-feature**: `UserRepository` из `features/profile/` используется в `HomeNotifier` (`features/home/`) — зависимость между фичами. Допустимо для MVP. Пост-MVP: вынести общие методы в `shared/` или `core/`.

### К Фазе 4 (LessonScreen)

- **Запись `lastLesson`**: при первом тапе на урок (или при его завершении) нужно записывать `lastLesson` и `lastParagraph` в `private_user_info/{userId}/languages/{langId}`. Без этого прогресс не сохраняется между сессиями.
- **`HomeScreen` → `LessonScreen`**: навигация по `AppRoutes.lessonPath(lessonId)` настроена, но `LessonScreen` ещё не реализован — реализовать в Фазе 4.
