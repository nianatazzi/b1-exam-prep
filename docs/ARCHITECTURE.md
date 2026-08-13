# ARCHITECTURE.md

> Главный ориентир при написании кодовой базы. Читать перед началом любой задачи.

---

## 1. Обзор проекта

Мобильное приложение для подготовки к устному экзамену B1 (польский язык): три раздела экзамена (image_description / monologue / dialogue) → темы → уровни подготовки (vocabulary / grammar / phrases) → упражнения. Платформы: Android, iOS.

Роли: пользователь, администратор. Админ-панель — отдельное веб-приложение, не часть этого проекта.

Отдельное приложение от linguobyte (свой `applicationId`/bundle id, свой Firestore-контент `b1_polish`/`b1_progress`), но использует тот же Firebase-проект и общий профиль (`private_user_info`/`public_user_info`) — см. §12 и `FIRESTORE.md`. Изучаемый язык фиксирован (польский), пикера языков нет.

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
| Backend (LLM-вызовы) | Firebase Cloud Functions (Node.js, `functions/`) — единственное место, где живут внешние API-ключи (Secret Manager), клиент их не хранит и не хардкодит |
| LLM (анализ свободной практики) | OpenAI API (`gpt-4o-mini`) — основной провайдер; Claude (`claude-haiku-4-5`) через сторонний Anthropic-совместимый провайдер — запасной, временно на этапе тестирования (см. §6.3). Оба вызываются только из Cloud Function `analyzeFreePractice` |

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
    b1_exam/
      data/            # ExamContentRepository, ExamExerciseRepository, ExamProgressRepository
      domain/          # ExamSectionModel/ExamTopicModel/..., ExerciseModel/ExerciseResult (движок упражнений),
                       # CheckB1AchievementUseCase, CompleteB1StepUseCase
      presentation/    # B1HomeScreen, TopicDetailScreen, PracticeScreen, ExerciseWidget + exercises/*
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
- **`SplashScreen`** — только UI (spinner). Навигацию целиком берёт на себя `redirect` в GoRouter: пока auth загружается — остаётся на splash; когда auth определился — уходит на `/auth`, `/onboarding` или `/b1`.
- **Авторизация и онбординг:** `refreshListenable` + `redirect`. GoRouter слушает два провайдера — `authProvider` и `onboardingStatusProvider`:
  - Не авторизован → `/auth`
  - Авторизован, онбординг не пройден → `/onboarding`
  - Авторизован, онбординг пройден → `/b1` (`B1HomeScreen`)
- **`onboardingStatusProvider`** (`auth/presentation/`) читает `public_user_info/{userId}.onboardingComplete` из Firestore (legacy-юзеры без поля определяются по непустому `name`). Кэшируется Riverpod; `OnboardingNotifier` инвалидирует его после сохранения профиля — роутер уводит на `/b1`. Признак «онбординг нужен» хранится в Firestore, а не в RAM, поэтому работает при любом сценарии входа (email/Google) и переживает перезапуск.
- **PracticeScreen** — маршрут `AppRoutes.b1Practice` (`/b1/practice/:sectionId/:topicId/:prepLevel`). Внутри себя управляет фазой (контент → упражнения) через локальное состояние `PracticeNotifier`. См. раздел 6.1.

---

## 6.1 Логика прохождения уровня подготовки (PracticeScreen)

В отличие от linguobyte (последовательные уроки), в B1 темы доступны сразу — нет `lastLesson`/`lastParagraph`. Один `PracticeState.step` — пара «контент + упражнения» для одного `prepLevel` (`vocabulary` | `grammar` | `phrases`) одной темы, аналог `LessonStep` из linguobyte, но без последовательности и без suffix-структуры (theory/lexical/verbs/final).

- **VocabularyPrepStep** / **GrammarPrepStep** / **PhrasesPrepStep** — контент темы (`TopicVocabularyModel` / `GrammarRuleModel` / `PhrasePatternModel`) + упражнения, отфильтрованные по `segment_type == prepLevel`.
- Все упражнения темы грузятся одним запросом (`course_id="b1_pl"`, `lesson_id=topic.tId`) и фильтруются в памяти по `prepLevel`.
- **Поток внутри шага:** контент → упражнения по одному (общий `ExercisePhaseWidget`, переиспользован из бывшего `lesson`-движка, теперь в `b1_exam/presentation/widgets/`) → «Завершить».
- **Завершение шага** делегируется `CompleteB1StepUseCase` (domain, `b1_exam`): сохранить результат уровня подготовки (+stats), обновить стрик (общий `IStreakRepository` из `profile`), проверить достижения (`CheckB1AchievementUseCase`). Прогресс не последовательный — двигать нечего, в отличие от linguobyte's `CompleteStepUseCase`.
- `stepKey` = `"{sectionType}_{topicTId}_{prepLevel}"`, хранится в `b1_progress/{userId}.topicResults`.

---

## 6.2 Фиксированная последовательность image_description (ImagePracticeScreen)

В отличие от §6.1 (три независимых `PrepLevelCard`, любой порядок), топики `image_description` проходятся одним экраном по фиксированной последовательности: глаголы (спряжение) → существительные (склонение) → фразы → свободная практика. Отдельный маршрут `AppRoutes.b1ImagePractice`, не затрагивает `TopicDetailScreen`/`PracticeScreen` (те остаются для monologue/dialogue). `B1HomeScreen` ветвится на этот маршрут по `section.type == ExamSectionType.imageDescription`.

- **`ImagePracticeStep`** (domain, plain sealed class, не freezed — in-memory UI-состояние): `VerbConjugationStep`/`NounDeclensionStep`/`IntroPhrasesStep`. Глаголы/существительные — не отдельные модели, а `GrammarRuleModel` с `rule_type == conjugation`/`declension` соответственно; упражнения сопоставляются через `linked_item_id == rule.gId`.
- Оба грамматических шага пишутся под одним `prepLevel` `"grammar"` (см. `ImagePracticeStep.prepLevel`) — результаты накапливаются в `ImagePracticeNotifier` и сохраняются одним вызовом `CompleteB1StepUseCase` только когда следующий шаг относится к другому `prepLevel`.
- `image_description` не использует `prepLevel` `"vocabulary"` — поэтому `CompleteB1StepUseCase.execute()`/`CheckB1AchievementUseCase.check()` принимают `requiredPrepLevels` (какой набор уровней считается «темой пройдена полностью»), вместо захардкоженной тройки `vocabulary/grammar/phrases` (см. §20).
- После прохождения всех шагов — свободная практика (`isFreePractice` в `ImagePracticeState`), см. §6.3.

---

## 6.3 Анализ свободной практики (LLM)

Свободная практика (`FreePracticeView`): картинка темы + таймер 3 минуты + `speech_to_text` → транскрипт. По завершении (`SubmitFreePracticeUseCase`, domain `b1_exam`):

1. Транскрипт отправляется в Cloud Function `analyzeFreePractice` (`functions/index.js`) через `IFreePracticeAnalysisRepository`/`cloud_functions`. Функция вызывает OpenAI (`gpt-4o-mini`) с ключом из Secret Manager (`OPENAI_API_KEY`) — ключ никогда не попадает в клиент.
2. **Fallback-провайдер (Claude, `claude-haiku-4-5`, через стороннего провайдера):** если запрос к OpenAI падает с ошибкой квоты/rate-limit (`429` / `insufficient_quota`), функция читает флаг `b1_polish/pl/service/llmConfig.fallbackEnabled` (Firestore, Admin SDK) — при `true` тот же промпт повторно отправляется через `@anthropic-ai/sdk`, но с переопределённым `baseURL` (константа `ANTHROPIC_BASE_URL` в `functions/index.js`) — сейчас это `https://api.ai-keys-shop.com`, сторонний провайдер с Anthropic-совместимым API (`/v1/messages`), **временное решение на этапе тестирования**, не прямой контракт с Anthropic. Ключ — `ANTHROPIC_API_KEY` в Secret Manager. Флаг переключается вручную через Firebase Console (админ-панели у проекта нет — см. §1); отсутствие документа или ошибка чтения трактуется как `false` (fail closed). Сбой fallback-провайдера не отличается от сбоя OpenAI — попадает в тот же best-effort путь (см. п.3).
3. Анализ — **best-effort**: ошибка (сеть, оба провайдера недоступны) не должна ронять сохранение транскрипта, тот же паттерн что у streak/достижений в `CompleteB1StepUseCase`. При сбое `analysis` сохраняется как `null`.
4. Сохранение в Firestore (`saveFreePracticeResult`) — тоже **best-effort**, с таймаутом 15с (`ExamProgressRepository`): `update()`/`set()` кладут мутацию в офлайн-кэш `cloud_firestore` сразу же, но их `Future` не завершается до подтверждения сервером — при "подвисшей" (не оборванной явно) сети это может держать экран результата бесконечно. По таймауту `SubmitFreePracticeUseCase` не ретраит и не ждёт — запись уже стоит в очереди SDK и досинкается сама при восстановлении сети.
5. Результат (`FreePracticeAnalysisModel.misusedWords` — список неправильно использованных глаголов/существительных с `userForm`/`correctForm`/`explanation`) сохраняется вместе с транскриптом в `b1_progress/{userId}.freePractice.{sectionType}_{topicTId}.analysis` (см. `FIRESTORE.md`) и показывается пользователю на экране завершения.
6. `misusedWords` — задел на будущее: список конкретных слов для повторной тренировки (сама повторная тренировка — отдельная фаза, не реализована).

---

## 7. Экраны MVP

- `SplashScreen`
- `AuthorizationScreen` (вход, регистрация, восстановление пароля)
- `OnboardingScreen` — первичная настройка профиля (аватар, имя, фамилия) сразу после регистрации. Язык обучения не выбирается — всегда польский. Маршрут по флагу `onboardingComplete` из Firestore. Лежит в `features/auth/presentation/` (часть auth-потока, проходится один раз).
- `B1HomeScreen` — разделы экзамена → темы, прогресс по каждой теме.
- `TopicDetailScreen` — уровни подготовки (vocabulary/grammar/phrases) для темы.
- `PracticeScreen` — прохождение одного уровня подготовки. См. раздел 6.1.
- `ProfileScreen`
- `SettingsScreen` — настройки (тема, язык интерфейса, скорость речи). Открывается из `ProfileScreen`.

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
  - **Язык обучения** — фиксирован (польский), пикера нет. `OnboardingNotifier` пишет `'pl'` в `public_user_info/{userId}.preference.selectedLanguage` при завершении онбординга — только для совместимости поля, общего с linguobyte на одном аккаунте; сам b1-exam-prep это поле не читает.
    - Прогресс хранится в `private_user_info/{userId}/b1_progress/pl` — изолирован от `languages/{langId}` (linguobyte). См. `FIRESTORE.md` §4.
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
| Файлы | `snake_case` | `exam_progress_repository.dart` |
| Экраны | `PascalCase` + `Screen` | `B1HomeScreen` |
| Модели | `PascalCase` + `Model` | `ExamTopicModel` |
| Репозитории | `PascalCase` + `Repository` | `ExamProgressRepository` |
| UseCase | `PascalCase` + `UseCase` | `CompleteB1StepUseCase` |
| Классы нотификаторов | `PascalCase` | `PracticeNotifier` |
| Провайдеры | `camelCase` + `Provider` | `practiceProvider` |
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

- **`AuthRepository.signUp` создаёт Firestore-документы** (`data/auth_repository.dart`): регистрация делает сразу два дела — создаёт Firebase Auth аккаунт и пишет профиль в Firestore. Если Firebase Auth прошёл, а Firestore упал — сейчас делаем откат (удаляем Auth аккаунт), но это ненадёжно: удаление тоже может упасть. _Когда закрывать_: при подключении Cloud Functions. Триггер `onCreate` на стороне сервера создаёт документы атомарно и надёжнее любого клиентского отката.

- **Запоминание входа** (`AuthorizationScreen`): поля email/пароль не сохраняются между сессиями. _Когда закрывать_: пост-MVP, при работе над UX онбординга.

### B1 exam prep (после переноса движка упражнений из linguobyte)

> `features/home` и `features/lesson` (уроки, теория/лексика/глаголы, `HomeScreen`) удалены целиком — это была логика linguobyte, к B1 (разделы → темы → уровни подготовки) не относится. Общий движок упражнений (`ExerciseModel`, `ExerciseResult`, `ExerciseWidget`, `ExercisePhaseWidget`, 8 виджетов типов) перенесён в `features/b1_exam`. Технический долг из старых фаз 3–4, привязанный к удалённому коду, снят вместе с ним.

- **`CheckB1AchievementUseCase` — эвристическая адаптация**: 5 достижений те же, что в linguobyte, но триггеры адаптированы под структуру B1 (нет уроков/суб-шагов глаголов): `master_conjugator` триггерится завершением `grammar`-уровня темы при полностью пройденной теме, `first_step` — первая тема (`t_id==1`) полностью пройдена. «Полностью пройдена» — `requiredPrepLevels` (параметр `check()`/`CompleteB1StepUseCase.execute()`) вместо захардкоженной тройки `vocabulary/grammar/phrases`: image_description не использует `vocabulary` (существительные — через `grammar`/declension, см. `ImagePracticeStep`), поэтому набор обязательных уровней передаётся вызывающей стороной (`['vocabulary','grammar','phrases']` для generic-потока, `['grammar','phrases']` для image_description). Продуктово не подтверждено — пересмотреть, когда появится реальный B1-контент и обратная связь.
- **Переигровка уровня подготовки — побочки stats/достижений**: как и в linguobyte, повторное прохождение уже пройденного уровня подготовки инкрементит `stats` и достижения заново (`FieldValue.increment`, `master_conjugator`/`vocabulary_master` накручиваются). Решение то же, что и для linguobyte — не реализовано, требует продуктового решения.
- **[TD-1] Debug Skip-кнопка** (`exercise_widget.dart`): debug-блок (`if (!kDebugMode)` + `Stack`) — убрать перед релизом.
- **[TD-3] Пустой `form` в fill_blank**: показать заглушку вместо поля ввода без контекста.
- **[TD-4] Ключ виджета по `exId`**: `ValueKey(exercise.exId)` — при дублях `ex_id` State переиспользуется. Сменить на `ValueKey(exercise.id)` (DocumentSnapshot.id).
- **Нет тестов для `CheckB1AchievementUseCase`/`CompleteB1StepUseCase`**: старые `check_achievement_use_case_test.dart`/`complete_step_use_case_test.dart` тестировали linguobyte-версии и удалены вместе с ними. Тесты для B1-версий не написаны — не запрошено явно (см. CLAUDE.md «Открытые пункты»).

### Profile / Settings (Фаза 5)

- **[TD-6] Инвалидация `stepResults` при смене контента**: при замене содержимого блока старый результат остаётся «зелёным». Пост-MVP: `contentVersion` в уроке.
- **Light theme**: `AppTheme.light` — заглушка, полная проработка после MVP.
- **`UserRepository` без полного интерфейса**: реализует только узкий `IStreakRepository` (для развязки `CompleteStepUseCase`); для профиль-методов интерфейса нет. Пост-MVP: добавить `IUserRepository` + вынести в `shared/`.
- **`ExerciseResult` не freezed**: in-memory во время субпарта, не сериализуется. Допустимо для MVP.
- **Стрик и таймзоны**: `UserRepository.updateStreak` использует локальное `DateTime.now()` — при смене таймзоны стрик может сбоить.
- **`PreferenceModel`**: `preference` — нетипизированная Map. Типизация (чтение) — низкий приоритет, запись остаётся dot-notation.
- **`points`/`reward`**: XP не начисляется (`reward` парсится, не используется; `points` всегда 0). Начисление — отдельная фича.

### Кросс-фичевые зависимости (допустимо для MVP)

- `UserRepository` (profile) используется в онбординге (`auth`) и в `CompleteB1StepUseCase` (`b1_exam`, через узкий интерфейс `IStreakRepository`) — стрик общий для аккаунта, не привязан к языку/приложению.
- `AchievementModel`/`AchievementType`/`ExerciseStatsModel`/`StepResultModel` (profile/domain) используются `b1_exam` (`TopicProgressModel`, `CheckB1AchievementUseCase`) — одна и та же форма stats/achievements для общего `ProfileScreen`, при полностью изолированных Firestore-документах (`b1_progress` vs. несуществующий теперь `languages/{langId}`). `AchievementUpdate` вынесен в отдельный файл `profile/domain/achievement_update.dart`, чтобы `b1_exam` не тянул удалённый linguobyte-специфичный `CheckAchievementUseCase`.
- Движок упражнений (`ExerciseModel`/`ExerciseResult`/`ExerciseWidget`/`ExercisePhaseWidget`/`exercises/*`) раньше был общим между `home`/`lesson` и `b1_exam`; после удаления `lesson` живёт целиком в `b1_exam` — больше не кросс-фичевая зависимость.

