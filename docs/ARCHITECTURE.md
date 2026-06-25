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

Урок — детерминированная последовательность `List<LessonStep>`, собираемая `BuildLessonUseCase` при открытии. Порядок фиксирован: **theory[] → lexical? → verbs? → final?** (lexical/verbs/final добавляются только если их данные непусты).

- **theory** — каждый блок (сортировка `th_id`) → `TheoryLessonStep` + его упражнения (`segment_type="theory"`, `linked_item_id=th_id`).
- **lexical_set** — один `LexicalLessonStep`: все блоки (`voc_id`) + упражнения (`segment_type="vocab"`).
- **verbs** — один `VerbsLessonStep` со списком `VerbSubStep` (`v_id`). Каждый глагол: таблица спряжения → его упражнения (`segment_type="verb"`). Суб-навигация — локальный стейт `VerbsStepWidget`; для прогресса вся пара — один шаг. Результат каждого глагола сохраняется отдельно (`recordVerbSubStep`, ключ `{lId}_verb_{vId}`, в т.ч. пустой при отсутствии упражнений — глагол считается пройденным); `progressIndex` двигается раз на последнем глаголе.
- **final** — `FinalLessonStep` с упражнениями `segment_type="final"`.
- **additional** — вне `List<LessonStep>`, в `LessonState.additional`; доступен через панель, не блокирует завершение.

Все упражнения урока грузятся одним запросом (`course_id="basic_{langId}"`, `lesson_id=lId`) и группируются в памяти.

**Два индекса в `LessonNotifier`:** `progressIndex` = `lastParagraph` (Firestore, завершённые шаги); `viewIndex` — просматриваемый шаг (навигация назад/через панель, без записи).

**Завершение шага** делегируется `CompleteStepUseCase` (domain): сохранить результаты субпарта (+stats), обновить стрик, проверить достижения, продвинуть прогресс. Переигровка пройденного шага (`viewIndex < progressIndex`) обновляет результаты/достижения, но прогресс не двигает.

**Поток внутри шага:** контент → упражнения по одному (общий `ExercisePhaseWidget`) → «Завершить». Завершение урока (`progressIndex >= steps.length`): `lastLesson=nextLesson.id`, `lastParagraph=0`, заглушка, возврат на Home.

**Навигационная панель:** прогресс-бар в AppBar (`progressIndex / steps.length`); тап → BottomSheet шагов. Завершённые и текущий тапабельны, залоченные — нет.

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
- `AppError` — `sealed class` (`core/errors/`): `NetworkError`, `AuthError`, `NotFoundError`, `UnknownError(message)`.
- Исключения Firestore маппятся в `AppError` на уровне `data`-слоя (`mapFirebaseException`). До `domain` исключения не доходят.
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
| `AppConstants` | Бизнес-пороги (например `passThresholdPercent` = 78%) |

Цвета и типографика — не константы, только `ThemeData`.

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
- Тестирование: страховочные unit-тесты (`test/domain/`) добавлены; widget/integration-тесты и CI/CD — после MVP
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
- **Новый пользователь**: полная инициализация документа (`updateLearningLanguage`) не вызывается — часть будущего онбординга. Для MVP не нужно: документ создаётся частично через `set(merge:true)`, модели терпимы к пропускам (`@Default`).
- **`activeIndex == -1`**: если `lastLesson` есть, но урок не найден — все карточки locked. Пост-MVP: кнопка сброса прогресса в `ProfileScreen`.
- **`getLessonStepSummaries` — 4·N чтений**: для N уроков `1` (уроки) + `1` (прогресс) + `4·N` (theory + lexical + verbs + final, по limit 1). Для MVP приемлемо (офлайн-кэш, ≤30 уроков). Денормализация `steps_summary` рассмотрена и **отклонена** (риск устаревания данных + правка админки).

### Lesson (Фаза 4)

- **`_LessonCompleteStub`**: экран завершения — заглушка. Баллы/проблемные моменты — после MVP.
- **Additional / подписка**: additional через панель (заглушка-диалог); гейтинг по `subscription.plan` — после MVP.
- **`isFullyCompleted`**: последний урок курса остаётся `active` с 100% (нет `nextLesson`, `lastLesson` не сдвигается). Пост-MVP: явное поле завершённости в прогрессе.
- **Переигровка шага — побочки stats/достижений**: при возврате на пройденный шаг через панель и повторном «Завершить» `CompleteStepUseCase` (при `isReplay`) прогресс урока корректно не двигает, но всё равно инкрементит `stats` (`FieldValue.increment` → инфляция счётчиков радара), выдаёт инкрементальные достижения (`vocabulary_master`/`master_conjugator` накручиваются) и сбрасывает `viewIndex` на `progressIndex` (выбрасывает на текущий шаг/stub). Требует продуктового решения по UX и поведению stats/достижений при переигровке — обсудить с командой, затем изолировать `isReplay` в `execute` (обновлять только `stepResults`).

- **[TD-1] Debug Skip-кнопка** (`exercise_widget.dart`): debug-блок (`if (!kDebugMode)` + `Stack`) — убрать перед релизом.
- **[TD-2] Молчаливый пропуск битых упражнений** (`exercise_repository.dart`): `fromJson` падает → упражнение пропадает без лога в release. Заменить `kDebugMode`-print на `AppLogger.w` (как уже сделано в `LessonContentRepository._parseDocs`).
- **[TD-3] Пустой `form` в fill_blank**: показать заглушку вместо поля ввода без контекста.
- **[TD-4] Ключ виджета по `exId`**: `ValueKey(exercise.exId)` — при дублях `ex_id` State переиспользуется. Сменить на `ValueKey(exercise.id)` (DocumentSnapshot.id).

### Profile / Settings (Фаза 5)

- **[TD-6] Инвалидация `stepResults` при смене контента**: при замене содержимого блока старый результат остаётся «зелёным». Пост-MVP: `contentVersion` в уроке.
- **Light theme**: `AppTheme.light` — заглушка, полная проработка после MVP.
- **`UserRepository` без полного интерфейса**: реализует только узкий `IStreakRepository` (для развязки `CompleteStepUseCase`); для профиль-методов интерфейса нет. Пост-MVP: добавить `IUserRepository` + вынести в `shared/`.
- **`ExerciseResult` не freezed**: in-memory во время субпарта, не сериализуется. Допустимо для MVP.
- **Стрик и таймзоны**: `UserRepository.updateStreak` использует локальное `DateTime.now()` — при смене таймзоны стрик может сбоить.
- **`PreferenceModel`**: `preference` — нетипизированная Map. Типизация (чтение) — низкий приоритет, запись остаётся dot-notation.
- **`points`/`reward`**: XP не начисляется (`reward` парсится, не используется; `points` всегда 0). Начисление — отдельная фича.

### Кросс-фичевые зависимости (допустимо для MVP)

- `UserRepository` (profile) используется в `HomeNotifier`.
- `BuildLessonUseCase` / `CompleteStepUseCase` (lesson/domain) зависят от интерфейсов других фич: `ILessonRepository`/`IUserProgressRepository` (home), `IStreakRepository` (profile). Пост-MVP: вынести общие интерфейсы в `shared/` или `core/`.

