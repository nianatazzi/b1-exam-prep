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
| STT (голосовые упражнения) | `speech_to_text` (нативный движок Android/iOS) |
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
- **LessonScreen** — один экран без вложенных маршрутов GoRouter. Внутри себя управляет последовательностью шагов урока через локальное состояние нотификатора. См. раздел 6.1.
- Маршрут: `AppRoutes.lessonPath(langId, lessonId)` — `langId` передаётся явно, чтобы LessonScreen не зависел от `HomeNotifier` для определения языка обучения.

---

## 6.1 Логика прохождения урока (LessonScreen)

Урок строится как детерминированная последовательность шагов (`List<LessonStep>`), собираемая из данных Firestore при открытии экрана через `BuildLessonUseCase`:

1. **theory** — блоки сортируются по полю `th_id`. Каждый блок образует отдельный `TheoryLessonStep` со своими упражнениями (`segment_type = "theory"`, `linked_item_id = th_id`).
2. **lexical_set** — один `LexicalLessonStep`: все блоки подряд (сортировка по `voc_id`), затем все упражнения (`segment_type = "vocab"`).
3. **verbs** — один `VerbsLessonStep` со списком `VerbSubStep` (по одному на документ, сортировка по `v_id`). Каждый суб-шаг: таблица спряжения глагола → упражнения именно на него (`segment_type = "verb"`, `linked_item_id = v_id`). Суб-навигация — локальный стейт `VerbsStepWidget`; для `HomeScreen` и `progressIndex` вся пара остаётся одним шагом. Результаты каждого глагола сохраняются отдельно через `LessonNotifier.recordVerbSubStep(vId)` (ключ `{lId}_verb_{vId}`), а `progressIndex` всего шага двигается один раз через `completeCurrentStep` на последнем глаголе.
4. **additional** — не входит в `List<LessonStep>`, хранится отдельно в `LessonState.additional`. Доступен всегда через навигационную панель, не блокирует завершение урока.

Порядок фиксирован: theory[] → lexical? → verbs?. Блоки lexical/verbs добавляются только если их коллекции непусты.

Все упражнения урока загружаются одним запросом (`course_id = "basic_{langId}"`, `lesson_id = lId`) и группируются в памяти.

**`lastParagraph`** = количество завершённых шагов = индекс СЛЕДУЮЩЕГО шага к прохождению. Соответствует позиции в `List<LessonStep>`. Тот же индекс используется в `LessonCard` на HomeScreen.

**Два индекса в `LessonNotifier`:**
- `progressIndex` = `lastParagraph` — персистентный, пишется в Firestore при каждом завершении шага
- `viewIndex` — локальный, меняется при навигации назад/через панель без записи в Firestore

**Поток внутри шага:** content-фаза → упражнения по одному → кнопка "Завершить" (последнее упражнение или контент если упражнений нет). Фаза и индекс упражнения — локальный стейт `ConsumerStatefulWidget`.

**Завершение урока:** `progressIndex >= steps.length` → обновить Firestore (`lastLesson = nextLesson.id`, `lastParagraph = 0`), показать заглушку, вернуться на HomeScreen.

**Навигационная панель:** постоянно видимый прогресс-бар в AppBar (показывает `progressIndex / steps.length`). Тап → BottomSheet со всеми шагами. Завершённые и текущий шаг — тапабельны (меняют `viewIndex`). Залоченные — нет.

---

## 7. Экраны MVP

- `SplashScreen`
- `AuthorizationScreen` (вход, регистрация, восстановление пароля)
- `HomeScreen`
- `ProfileScreen`
- `SettingsScreen` — настройки (тема, язык интерфейса, скорость речи). Открывается из `ProfileScreen`.
- `ResultScreen` — результат прохождения субпарта (correct/total, список упражнений). Показывается после завершения шага.
- `LessonScreen` — один экран, шаги урока (теория / лексика / глаголы / упражнения / доп. материалы) переключаются внутри него, без отдельных маршрутов. См. раздел 6.1.

---

## 8. Firebase / Firestore

- `persistenceEnabled: true` — указать явно при инициализации
- **Security Rules** настроить с первого дня:
  - `basic` — чтение для всех авторизованных пользователей
  - `private_user_info/{userId}` — только владелец
- Все пути к коллекциям — только через `FirestorePaths`. Строки напрямую в коде запрещены.
- **`update()` для вложенных полей через dot-notation** (`'stepResults.$stepKey'`, `'stats.$category.correct'`). `set(merge: true)` с dot-notation ключами создаёт плоские поля с точками в имени вместо вложенных map — использовать только для top-level полей.
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
- `LoggingProviderObserver` (`core/logger/`) — печатает ошибки любых провайдеров в консоль через `debugPrint`. Подключается в `main.dart` только в debug (`kDebugMode`), в release не используется. Полноценное логирование — после MVP.

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
  - **Язык обучения** — выбирается на `HomeScreen`. Управляется через `HomeNotifier` (`features/home/presentation/providers/`).
    - Прогресс по каждому языку хранится в `private_user_info/{userId}/languages/{langId}`.
    - Последний выбранный язык (UI-предпочтение) хранится в `public_user_info/{userId}/preference.selectedLanguage` — восстанавливается при следующем открытии экрана.
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
  static const String exercises = 'exercises'; // корневая коллекция, не вложена в basic/
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
- ~~**Exercise dots**~~ **ЗАМЕНЕНО на stepResults**: цвета кругов субпартов (красный/жёлтый/зелёный) реализуются через `stepResults` map в `languages/{langId}`. Порог зелёный/жёлтый: 78% правильных ответов.
- **Новый пользователь**: при `lastLesson = null` первый урок (минимальный `id`) разблокируется автоматически в коде. Сохранение прогресса нового пользователя реализовано: `updateProgress` создаёт документ `languages/{langId}` через `set(merge:true)`, а `stats`/`stepResults`/`achievements` имеют `@Default({})` — частичный документ читается корректно. Полная инициализация документа (`updateLearningLanguage` со всеми полями) пока не вызывается — это часть будущего онбординга, для MVP не требуется.
- **`activeIndex == -1`**: если `lastLesson` установлен, но урок не найден в списке — все карточки locked без возможности восстановления. Пост-MVP: добавить кнопку сброса прогресса по языку в `ProfileScreen`.
- **`UserRepository` cross-feature**: `UserRepository` из `features/profile/` используется в `HomeNotifier` (`features/home/`) — зависимость между фичами. Допустимо для MVP. Пост-MVP: вынести общие методы в `shared/` или `core/`.
- **`getLessonStepSummaries` — 3·N чтений Firestore на каждое открытие HomeScreen**: для N уроков выполняется `1` (уроки) + `1` (прогресс) + `3·N` (theory + lexical limit(1) + verbs limit(1)). На MVP допустимо: офлайн-кэш Firestore отдаёт повторные открытия, уроков немного. Долгосрочное решение: денормализовать `steps_summary` (массив `{type, title}` по каждому шагу) в документ урока — админ-панель пишет это поле при редактировании контента + бэкафилл существующих уроков; клиент читает сводку вместе со списком уроков, убирая все `3·N`. Админ-панель готова → задача разблокирована, выполнять **отдельной веткой** (схема FIRESTORE.md + клиент + миграция данных), не в рамках lesson-screen.

### Фаза 4 (LessonScreen) — реализована

- **Виджеты упражнений**: все 8 типов реализованы в `features/lesson/presentation/widgets/exercises/`:
  - `wordcard` — карточка слова: слово, транскрипция, аудио, изображение, переводы
  - `flashcard` — флэш-карточка с анимацией флипа: лицо (подсказка + поле ввода), обратная (слово + аудио + пример)
  - `multiple_choice` — вставить слово из банка в пропуски предложения
  - `fill_blank` — вписать слово в пропуск вручную
  - `mosaic` — собрать предложение из чипов
  - `translate_sentence` — перевести предложение текстом
  - `listen_pick` — выбрать вариант после прослушивания аудио
  - `voice_translate` — произнести перевод голосом (STT через `speech_to_text`) с текстовым fallback
  - Роутер: `ExerciseWidget` делегирует по `exercise.type`. Все виджеты получают `key: ValueKey(exercise.exId)` для гарантированного сброса состояния между упражнениями.
  - Общие виджеты: `ExerciseFeedbackBanner` (баннер правильно/неправильно + правильный ответ), `AudioPlayButton` (`shared/widgets/`) — воспроизведение через `just_audio`, disabled при `audioUrl == null`.
- **Экран завершения урока**: `_LessonCompleteStub` — заглушка (иконка + текст + кнопка). Статистика, баллы, проблемные моменты — после MVP.
- **Additional / подписка**: additional доступен через панель навигации (заглушка-диалог). Гейтинг по `subscription.plan` — после MVP.
- **`IUserProgressRepository` cross-feature**: `LessonNotifier` зависит от репозитория из `features/home/`. Допустимо для MVP (аналогично `UserRepository`). Пост-MVP: вынести в `shared/` или `core/`.
- **`BuildLessonUseCase` cross-feature**: UseCase в `features/lesson/domain/` использует `ILessonRepository` и `IUserProgressRepository` из `features/home/`. Долгосрочное решение: вынести общие интерфейсы в `shared/` или `core/`.
- **`LessonStepSummary` в `LessonCard`**: `progressPercent` теперь учитывает все шаги (theory + lexical + verbs). Если последний урок завершён (нет nextLesson), `lastLesson` остаётся на нём — карточка показывается как active с 100%. Пост-MVP: добавить явное поле `isFullyCompleted` в прогресс.
- **Генератор провайдера**: Riverpod 3.x для `@riverpod class LessonNotifier` генерирует `lessonProvider` (не `lessonNotifierProvider`) — суффикс `Notifier` убирается автоматически. Аналогично для других нотификаторов.

### Технический долг — виджеты упражнений (feature/exercise-widgets)

- **[TD-1] Debug Skip-кнопка (exercise_widget.dart)**: `ExerciseWidget` в debug-режиме оборачивает дочерний виджет в `Stack`, что ограничивает bounded height. `Spacer()` в виджетах упражнений заменён на `SizedBox` — краши устранены. Skip-кнопка теперь принимает `onSkip: VoidCallback?` и корректно выполняет переход; `onReady` больше не смешивается с навигацией. **Действие: убрать весь debug-блок (`if (!kDebugMode) return child` + `Stack`) перед релизом.**

- **[TD-2] Молчаливый пропуск сломанных документов Firestore (exercise_repository.dart)**: Если `fromJson` падает на документе с отсутствующим обязательным полем, в release-сборке исключение поглощается без логирования — упражнение пропадает из урока без ошибки в UI. **Действие: заменить `kDebugMode`-print на `logger.warning(...)` чтобы проблема видела в release-логах тоже.**

- **[TD-3] Пустое поле `form` в fill_blank (fill_blank_exercise_widget.dart)**: Если поле `form` в Firestore отсутствует или пустое, пользователь видит поле ввода без контекста предложения. **Действие: добавить guard — если `form` пустой, показывать заглушку или error-state вместо бессмысленного ввода.**

- **[TD-4] Уникальность ключа виджетов по `exId` (exercise_widget.dart)**: `key: ValueKey(exercise.exId)` — если два упражнения в уроке имеют одинаковый `ex_id` (ошибка данных в Firestore), Flutter переиспользует State и второе упражнение открывается уже заполненным. Надёжнее использовать `ValueKey(exercise.id)` (DocumentSnapshot.id, гарантированно уникальный). **Действие: сменить ключ на `ValueKey(exercise.id)` — требует убедиться что `id` всегда непустой во всех сценариях загрузки.**

- ~~**[TD-5]**~~ **ИСПРАВЛЕНО**: При ошибке сети `completeCurrentStep` теперь логирует через `AppLogger.e` и возвращает `state = AsyncData(current)` — экран урока остаётся, пользователь может нажать «Далее» ещё раз. Остаток: показывать SnackBar с ошибкой из UI (требует UI-callback или отдельного error-поля в `LessonState`).

### Фаза 5 (ProfileScreen + Settings + Achievements)

- **[TD-6] Инвалидация stepResults при изменении контента**: если админ заменяет содержимое theory-блока (th_id=2), старый результат `"1_theory_2"` в `stepResults` остаётся от предыдущего контента и показывается как зелёный. **Действие (пост-MVP):** добавить `contentVersion` в документы уроков; при изменении контента — инвалидировать соответствующие результаты в `stepResults`.
- **Миграция `oral_progress` / `grammar_progress` / `lexicon_progress` → `stats` map**: старые поля заменены на `stats` map с сырыми счётчиками correct/total по 4 навыкам. Существующие документы обновляются вручную. Код модели должен толерантно обрабатывать документы без `stats` (`@Default`).
- **`fl_chart` для radar-диаграммы**: пакет добавлен для ProfileScreen. Используется только в `_ProficiencyChart` виджете.
- **Light theme**: реализована как заглушка (`AppTheme.light`). Полная проработка цветов и контрастов — после MVP.
- **`speechSpeed` preference**: хранится в `public_user_info.preference.speechSpeed`. Используется в `just_audio` playback rate для `listen_pick` и `voice_translate` упражнений.
- **`UserRepository` без интерфейса**: единственный репозиторий без `IUserRepository` в `domain/repositories/`. Используется из нескольких фич. Пост-MVP: добавить интерфейс и вынести в `shared/`.
- **`ExerciseResult` не freezed**: используется только in-memory во время прохождения субпарта, не сериализуется. Допустимо для MVP.
- **`StreakRepository` и таймзоны**: `DateTime.now()` использует локальное время — при смене таймзоны стрик может ошибочно пропустить или удвоить день. Допустимо для MVP.

### Рефакторинг (ветка `refactor/lesson-progress`)

Полный аудит логики урока/прогресса/статистики. План из 4 волн, тесты в `test/domain/`.

**Волна 0 — страховочные тесты (готово):** сериализация моделей, `CheckAchievementUseCase`, стрик/проценты, сборка шагов урока.

**Волна 1 — критические баги (готово):**
- **Достижения (краш):** `AchievementRepository.updateAchievement` теперь пишет `type` внутрь документа; `_preprocessProgressData` подставляет `type` из ключа для старых записей. Раньше `AchievementModel.fromJson` падал на `$enumDecode(null)` → `getUserLanguageProgress` отдавал `UnknownError` → Home/Profile/Lesson в error (и старый `[homeProvider] ParallelWaitError`).
- **Прогресс глаголов:** восстановлено пер-глагольное сохранение через `recordVerbSubStep` (мёртвые `overrideStepKey`/`overrideSegmentType` удалены, `completeCurrentStep` разделён на `_persistCurrentResults` + продвижение прогресса).
- **Хрупкие модели:** некритичные поля `TheoryModel`/`LexicalSetModel`/`VerbModel`/`PrivateUserModel` стали терпимыми (`@Default`/`unknownEnumValue`); `LessonContentRepository._parseDocs` пропускает битый документ с логом (частично закрывает TD-2), не роняя урок.
- **Порядок уроков:** `getLessons` теперь с `orderBy('l_id')`.

**Волна 2 — ядро прогресса (готово):**
- **2-I:** три репозитория прогресса (`UserProgress` + `ExerciseResult` + `Achievement`) объединены в `UserProgressRepository`; инициализация документа языка дедуплицирована (`_initialLanguageDocument` + `_updateOrInit`).
- **2-II:** оркестрация завершения шага вынесена в `CompleteStepUseCase` (domain); `LessonNotifier` управляет только in-memory результатами и `state`. Мёртвая `_toAchievementMap` удалена.
- **Фикс `voice_translate`:** виджет не передавал `onResult` → голосовые упражнения не попадали в `stepResults`/`stats` (и verb-субпарт не сохранялся, speaking всегда 0). Добавлен `onResult`. Глагол без упражнений теперь отмечается пройденным (`saveSubStepResult(persistEmpty: true)`).
- **2-III (вариант +1 запрос):** `LessonStepType` получил `finalStep`; `getLessonStepSummaries` проверяет наличие `final`-упражнений (4·N вместо 3·N, +параметр `lessonLId`), карточка и экран считают шаги одинаково. Денормализация `steps_summary` отклонена как преждевременная (риск устаревания + правка админки).
- **2-IV:** `userId` унифицирован через `authProvider` (HomeNotifier больше не ходит в FirebaseAuth напрямую); краевой баг `lastParagraph` исправлен — переигровка пройденного шага (`viewIndex < progressIndex`) обновляет результаты/достижения, но не двигает прогресс урока (`execute` получил `viewIndex`).

**Волны 3–4 (план):** единый `ExercisePhaseWidget` (4 копии `_ExercisePhase`); типизированная `PreferenceModel` (отложена из 2-IV); чистка дублей маппинга `AchievementType`, `setUiLanguage`, мёртвого `_resultDotColor` в `lesson_card`, решение по `points`/`reward`.

**Заметки техдолга:**
- **Индекс для final-запроса**: `getLessonStepSummaries` фильтрует `exercises` по `course_id` + `lesson_id` + `segment_type` (3 equality, limit 1). Покрывается автоиндексом (проверено: Home открывается без ошибки индекса).
