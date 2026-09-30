# ARCHITECTURE.md

> Главный ориентир при написании кодовой базы. Читать перед началом любой задачи.
>
> Последняя сверка с кодом — 2026-09-30 (после `a32d137`, PR #8). Карта
> файлов — `docs/codebase-map.html`, структура данных — `docs/FIRESTORE.md`.

---

## 1. Обзор проекта

Мобильное приложение для подготовки к устному экзамену B1, Lesson Matrix:
урок = пара «лексическая тема (Restauracja, Hotel…) × грамматическая тема
(Celownik, Tryb warunkowy…)». Внутри урока — шесть шагов подряд: три капа
упражнений по 10 (verb/noun/phrase, все на лексике урока), затем три устных
упражнения (image description / monologue / dialogue), каждое с
LLM-анализом (`analyzeSpeech`), оценкой 0-100 и списком ошибок на итоговом
экране урока. Платформы: Android, iOS.

**Изучаемый язык — один из пяти (pl/fr/es/en/de), не только польский**
(`StudyLanguage`, см. §12.1). Изначально был фиксирован на польском —
снято по явному запросу, чтобы поддержать тот же список языков, что и
linguobyte. Контент заведён только для польского (4 урока, см.
`FIRESTORE.md` §4) — для остальных языков главный экран показывает пустое
состояние, код от этого не зависит.

Роли: пользователь, администратор. Админ-панель — отдельное веб-приложение, не часть этого проекта.

Отдельное приложение от linguobyte (свой `applicationId`/bundle id
`com.linguobyte.b1exam`, свой Firestore-контент `b1_exam_content`/`b1_progress`),
но использует тот же Firebase-проект (`linguobyte`, `.firebaserc`) и общий
профиль (`private_user_info`/`public_user_info`) — см. §12 и `FIRESTORE.md`.

---

## 2. Стек

| Область | Инструмент |
|---|---|
| Фреймворк | Flutter + Dart (SDK `^3.10.7`) |
| База данных | Firestore (`cloud_firestore`) |
| Авторизация | Firebase Auth: email/пароль + Google Sign-In (`google_sign_in` 7.x) |
| Хранилище медиа | Медиа грузится по URL из контента (`image_url`/`audio_url`). Пакет `firebase_storage` подключён, но в коде не используется |
| Мониторинг | Firebase Crashlytics, Firebase Analytics (сбор выключен в debug, события не настроены) |
| State management | Riverpod 3.x с code generation (`@riverpod`) |
| Навигация | GoRouter |
| Сериализация | `freezed` + `json_serializable` |
| Изображения | `cached_network_image` |
| Аудио | `just_audio` |
| STT (голосовые упражнения, устные шаги) | `speech_to_text` (нативный движок Android/iOS) |
| Графики | `fl_chart` (радар навыков в ProfileScreen) |
| Шрифты | `google_fonts` (Geologica, в `AppTheme`) |
| Локализация | `flutter_localizations` + `intl` + ARB-файлы |
| Логирование | `logger` через абстракцию `AppLogger` |
| Shimmer | `shimmer` |
| Backend (LLM-вызовы) | Firebase Cloud Functions v2 (Node.js 20, `functions/`, `onCall`) — единственное место, где живут внешние API-ключи (Secret Manager), клиент их не хранит и не хардкодит. Клиент вызывает через `cloud_functions` |
| LLM (анализ речи, диалог) | OpenAI API (`gpt-4o-mini`, пакет `openai`) — основной провайдер; Claude (`claude-haiku-4-5`) через сторонний Anthropic-совместимый провайдер (`@anthropic-ai/sdk` с `baseURL`) — запасной, временно на этапе тестирования (см. §6.3). Оба вызываются только из Cloud Functions `analyzeSpeech`/`continueDialogue`, через общий `callLlm()` |

> Подключены, но не используются в коде: `firebase_storage`, `flutter_svg`.
> Видеоплеер и видеохостинг — открытый пункт, решается отдельно.
> Не подключать новые пакеты без явного указания.

---

## 3. Архитектурный паттерн

**Clean Architecture** (слои `data` / `domain` / `presentation`) + **MVVM** в `presentation`-слое.

Направление зависимостей: `presentation` → `domain` ← `data`. Зависимости направлены только внутрь. `domain` не зависит ни от чего.

### Развязка слоёв через интерфейсы

Если UseCase или domain-класс нуждается в данных из репозитория — он зависит только от **абстрактного интерфейса** (`IExamProgressRepository`), объявленного в `domain/repositories/`. Конкретная реализация (`ExamProgressRepository`) живёт в `data/` и реализует этот интерфейс. Riverpod-провайдер служит DI-мостом: создаёт конкретную реализацию и передаёт её туда, где ожидается интерфейс.

```
domain/repositories/i_exam_progress_repository.dart   ← абстракция (domain)
data/repositories/exam_progress_repository.dart        ← реализация (data, implements IExamProgressRepository)
domain/usecases/complete_b1_step_use_case.dart         ← класс UseCase использует IExamProgressRepository
                @riverpod completeB1StepUseCase(ref)   ← DI: передаёт ExamProgressRepository как IExamProgressRepository
```

> **Как сейчас устроено в коде:** `@riverpod`-функция DI-провайдера UseCase
> лежит в том же файле, что и класс UseCase (`domain/usecases/*.dart`), и
> импортирует `data/repositories/*` (а через них — `cloud_firestore`/
> `cloud_functions`). Сам класс UseCase зависит только от интерфейсов, но
> файлы domain транзитивно тянут data и Firebase. Отклонение от правила
> «domain не зависит ни от чего» — зафиксировано в §20.

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

Текущие UseCase (`features/b1_exam/domain/usecases/`): `CompleteB1StepUseCase`,
`CheckB1AchievementUseCase` (чистая логика, без DI-провайдера — создаётся
внутри `CompleteB1StepUseCase`), `SubmitOralStepUseCase`,
`SubmitDialogueUseCase`. Общая чистая функция оценки —
`domain/calculate_speech_score.dart`.

### Когда использовать Riverpod
Только для глобального состояния, асинхронных данных и dependency injection.

- Простые виджеты без состояния — `StatelessWidget`
- Локальное UI-состояние (анимации, фокус, раскрытый элемент, таймеры, STT-сессия) — `StatefulWidget`
- Не оборачивать в провайдер то, что не нужно за пределами виджета

---

## 4. Структура папок

```
lib/
  main.dart                     # инициализация Firebase/Crashlytics/Analytics/GoogleSignIn, ProviderScope, MaterialApp.router
  firebase_options.dart         # конфиг Firebase из --dart-define (FIREBASE_*), без хардкода
  features/
    auth/
      data/                     # AuthRepository (Firebase Auth + создание профиля при регистрации)
      domain/                   # UserModel
      presentation/             # AuthNotifier, AuthorizationScreen, OnboardingNotifier/Screen,
                                # onboardingStatusProvider
    b1_exam/
      data/repositories/        # LessonContentRepository, ExamExerciseRepository, ExamProgressRepository,
                                # SpeechAnalysisRepository, DialogueRepository (последние два — Cloud Functions)
      domain/
        models/                 # LessonModel/LexicalTopicModel/GrammarTopicModel/GrammarRuleModel/
                                # TopicVocabularyModel, ImageTaskModel/FreePracticeTaskModel/DialogueScenarioModel,
                                # ExerciseModel/ExerciseResult (движок упражнений), LessonStep/OralStep,
                                # SpeechAnalysisModel (+ Lemma/SpeechError/TalkingPointCoverage),
                                # DialogueMessage/DialogueTurnResult, TopicProgressModel/LessonStepResultModel
        repositories/           # интерфейсы I*Repository
        usecases/               # CompleteB1StepUseCase, CheckB1AchievementUseCase,
                                # SubmitOralStepUseCase, SubmitDialogueUseCase
        calculate_speech_score.dart
      presentation/
        providers/              # B1HomeNotifier, LexicalTopicLessonsNotifier, LessonNotifier,
                                # DialogueNotifier, OralStepOutcome
        screens/                # B1HomeScreen, LexicalTopicLessonsScreen, LessonScreen, DialogueScreen
        widgets/                # ExerciseWidget, ExercisePhaseWidget, FreePracticeView, exercises/* (8 типов)
    profile/
      data/                     # UserRepository (профиль + стрик)
      domain/                   # PublicUserModel, PrivateUserModel, AchievementModel, AchievementUpdate,
                                # ExerciseStatsModel, StatEntryModel, StepResultModel, StreakModel,
                                # repositories/IStreakRepository
      presentation/             # ProfileNotifier/Screen, SettingsNotifier/Screen
  core/
    constants/                  # FirestorePaths, AppRoutes, AppSpacing, AppSizes, AppConstants, AvatarPresets
    errors/                     # AppError, mapFirebaseException
    locale/                     # AppLocaleNotifier (язык интерфейса), studyLanguageProvider (язык обучения)
    logger/                     # AppLogger, LoggingProviderObserver
    router/                     # GoRouter конфиг + SplashScreen
    theme/                      # AppTheme, AppColors (ThemeExtension)
    utils/                      # normalizeAnswer/stripDiacritics, localizedText, deepStringKeyedMap
  shared/
    widgets/                    # AudioPlayButton, AvatarPickerGrid, ErrorView
    models/                     # StudyLanguage (+ LessonStepSummary — мёртвый код linguobyte, §20)
  l10n/                         # ARB (en/ru/fr/es) + сгенерированные AppLocalizations
functions/                      # Cloud Functions: analyzeSpeech, continueDialogue (index.js)
scripts/seed/                   # разовый seed-скрипт (устарел, см. §20)
test/domain/                    # страховочные unit-тесты сериализации и streak/stats
```

**Правила:**
- Всё, что используется более чем в одной фиче — в `core/` (инфраструктура) или `shared/` (виджеты, модели)
- Циклические импорты между фичами запрещены

> Факт: `core/` импортирует фичи — `core/router` (экраны всех фич),
> `core/locale/study_language_provider.dart` (`authProvider`,
> `userRepositoryProvider`). Для роутера это неизбежно; для
> `studyLanguageProvider` — отклонение, см. §20.

---

## 5. State Management (Riverpod)

- Использовать Riverpod 3.x с `@riverpod` code generation
- `AsyncNotifier` — основной ViewModel для экранов с асинхронными данными
- `ref.watch` — в синхронных провайдерах и в `build()` для **реактивных** провайдеров (чьё изменение должно перезапустить build)
- `ref.read` — в обработчиках событий (`onPressed` и т.п.), а также в `async build()` для **сервисных** провайдеров (репозитории, UseCase): `ref.watch` после `await` вызывает бесконечный rebuild-цикл, потому что Riverpod отменяет текущий `build()` при каждой переоценке зависимостей
- `StreamBuilder` без кэширования не использовать — лишние reads Firestore
- UI-состояние — локально в виджете, не в провайдере
- После мутации данных для перезагрузки использовать `ref.invalidateSelf()` — **не вызывать `build()` напрямую**: прямой вызов обходит систему отслеживания зависимостей Riverpod

> **Паттерн в коде** (`SettingsNotifier`, e0e303b): autoDispose-нотификатор,
> который только `ref.read(...notifier)`-ится и никем не `watch`-ится,
> уничтожается во время `await`, и последующий `ref.invalidate(...)` молча
> не выполняется. Поэтому методы `SettingsNotifier` держат
> `final link = ref.keepAlive();` на время операции и закрывают в `finally`.
>
> keepAlive-провайдеры: `authProvider`, `routerProvider`, `appLocaleProvider`.
> Остальные — autoDispose (в т.ч. `lessonProvider`: выход с экрана урока
> сбрасывает прохождение).

---

## 6. Навигация (GoRouter)

- Все маршруты декларативные, пути — константы в `AppRoutes`
- **`SplashScreen`** — только UI (spinner). Навигацию целиком берёт на себя `redirect` в GoRouter: пока auth загружается — остаётся на splash; когда auth определился — уходит на `/auth`, `/onboarding` или `/b1`.
- **Авторизация и онбординг:** `refreshListenable` + `redirect`. GoRouter слушает два провайдера — `authProvider` и `onboardingStatusProvider`:
  - Не авторизован → `/auth`
  - Авторизован, онбординг не пройден → `/onboarding`
  - Авторизован, онбординг пройден → `/b1` (`B1HomeScreen`)
- **`onboardingStatusProvider`** (`auth/presentation/`) читает `public_user_info/{userId}.onboardingComplete` из Firestore (legacy-юзеры без поля определяются по непустому `name`). Кэшируется Riverpod; `OnboardingNotifier` инвалидирует его после сохранения профиля — роутер уводит на `/b1`. Признак «онбординг нужен» хранится в Firestore, а не в RAM, поэтому работает при любом сценарии входа (email/Google) и переживает перезапуск.

| Константа | Путь | Экран |
|---|---|---|
| `AppRoutes.splash` | `/` | `SplashScreen` |
| `AppRoutes.auth` | `/auth` | `AuthorizationScreen` |
| `AppRoutes.onboarding` | `/onboarding` | `OnboardingScreen` |
| `AppRoutes.b1Home` | `/b1` | `B1HomeScreen` |
| `AppRoutes.b1LexicalTopic` | `/b1/:langId/topic/:lexicalTopicId` | `LexicalTopicLessonsScreen` |
| `AppRoutes.b1Lesson` | `/b1/:langId/lesson/:lessonId` | `LessonScreen` (6 шагов, §6.1) |
| `AppRoutes.b1Dialogue` | `/b1/:langId/lesson/:lessonId/dialogue` | `DialogueScreen` (§6.3); `LessonScreen` пушит сюда и ждёт `OralStepOutcome` через `pop` |
| `AppRoutes.profile` | `/profile` | `ProfileScreen` (push из AppBar `B1HomeScreen`) |
| `AppRoutes.settings` | `/settings` | `SettingsScreen` (push из `ProfileScreen`) |

- **`langId` в пути B1-маршрутов** (`StudyLanguage.name`): гарантирует, что `lexicalTopicId`/`lessonId` читаются из того же языкового документа, что и на экране, откуда сделан переход, даже если язык обучения сменили посреди навигации. Строить пути только через `AppRoutes.b1*Path(langId, id)`. Экраны урока/диалога делают `StudyLanguage.fromCode(langId)!` — невалидный `langId` в диплинке уронит экран.

---

## 6.1 Флоу урока (LessonScreen)

Урок (`LessonModel`) проходится одним экраном по фиксированной
последовательности из шести шагов: три капа упражнений (verb → noun →
phrase, каждый не больше `AppConstants.lessonBlockExerciseCap` = 10) → три
устных упражнения подряд (image → monologue → dialogue). Управляется
`LessonNotifier` (family `(langId, lessonId)`, `LessonState.stepIndex`/
`currentStep`), шаг — `LessonStep` (domain, plain sealed class, не freezed —
in-memory UI-состояние): `VerbBlockStep` / `NounBlockStep` /
`PhraseBlockStep` (упражнения по `ExerciseBlock`) и `ImageStep` /
`MonologueStep` / `DialogueStep` (соответствующее задание из `LessonModel`).

- **Загрузка** (`LessonNotifier.build`) — параллельно: урок, все лексические
  темы, все грамматические темы (ради заголовка AppBar «лексика · грамматика»)
  и все упражнения урока одним запросом (`course_id = "b1_{langId}"`,
  `lesson_id = lesson.id`, `orderBy ex_id`), группировка/кап по `block` — в памяти.
- **Прохождение не сохраняется между заходами:** провайдер autoDispose,
  урок всегда начинается с блока verb; сохранённые `topicResults`/
  `lessonResults` при открытии урока не читаются.
- **Поток блока упражнений:** упражнения по одному (общий
  `ExercisePhaseWidget`) → кнопка «Завершить блок» → `finishBlockStep` →
  следующий шаг. Пустой блок показывает текст «нет упражнений» (без кнопки
  продолжения — см. §20).
- **Завершение блока** делегируется `CompleteB1StepUseCase`: сохранить
  результат (+stats), обновить стрик (общий `IStreakRepository` из
  `profile`, сбой не блокирует), проверить достижения
  (`CheckB1AchievementUseCase`, сбой не блокирует). `stepKey` =
  `"{lessonId}_{block}"`, хранится в `b1_progress/{userId}/{langId}.topicResults`.
  Урок всегда состоит ровно из трёх блоков.
- **Достижения** (`CheckB1AchievementUseCase`) рекеены на `lessonId`/`block`,
  «урок пройден» = все три блока есть в `topicResults` (устные шаги не
  учитываются): Master Conjugator — только что завершён блок `verb` и урок
  пройден; First Step — первый пройденный урок; Focused Learner — каждые 7
  дней стрика; Vocabulary Master — урок пройден и все три блока с первой
  попытки. Interested Learner не начисляется. Известные дефекты — §20.
- **Оба устных шага image/monologue** используют один и тот же виджет
  `FreePracticeView` (см. §6.2). Диалог — отдельный экран, см. §6.3.
- По завершении всех шести шагов — итоговый экран урока
  (`_LessonSummaryView`): по каждому устному шагу счёт `N/100` (если анализ
  прошёл) и список ошибок `userForm → correctForm` из
  `targetGrammarErrors` + `otherGrammarErrors` + `lexicalErrors`
  (объяснения не показываются); при `analysis == null` — «анализ недоступен».

---

## 6.2 Устные шаги image/monologue (FreePracticeView)

`FreePracticeView` — общий `StatefulWidget` для image/monologue (dialogue —
отдельный флоу, см. §6.3). Параметры: `imageUrl` (опционально),
`promptText`, `durationSeconds`, `sttLocaleId`, `isSubmitting`, `onSubmit`.

- **image**: картинка `image_task.image_url`, текст задания — заголовок шага
  из ARB (`b1ImageDescription`).
- **monologue**: без картинки, текст — `monologue_task.prompt` на языке
  интерфейса (`localizedText`, фолбэк `en`).
- **Пункты задания студенту не показываются** (с a32d137): `points_to_describe`/
  `points` не мапятся в клиентские модели, их читает только `analyzeSpeech`.
- **Таймер** — `LessonModel.durationSeconds` для обоих шагов (дефолт
  `AppConstants.oralStepDurationSeconds` = 180с). `monologue_task.duration_seconds`/
  `think_seconds` в модели есть, но не используются.
- **STT** — `speech_to_text`, `ListenMode.dictation`, локаль из
  `StudyLanguage.sttLocaleId`. Сессия распознавания перезапускается после
  каждого final result и после ошибки движка (Android/iOS обрывают сессию
  раньше таймера) — транскрипт склеивается. «Стоп» или истечение таймера →
  экран с транскриптом → «Завершить» → `onSubmit`.
- Виджет ключуется `ValueKey(oralStep)` — иначе image и monologue делили бы
  один `State` (транскрипт/стадия переезжали в следующий шаг).

По завершении (`LessonNotifier.submitOralStep`, делегирует
`SubmitOralStepUseCase`, domain `b1_exam`):

1. Транскрипт отправляется в Cloud Function `analyzeSpeech`
   (`functions/index.js`) через `ISpeechAnalysisRepository`/`cloud_functions`
   — контракт и провайдер-fallback описаны в §6.3 (общий для image/monologue/dialogue).
2. Анализ — **best-effort**: сбой (в т.ч. пустой транскрипт, который
   функция отклоняет `invalid-argument`, или исчерпанная квота) не роняет
   сохранение. При сбое `analysis`/`score` сохраняются как `null`.
3. Оценка (`calculateSpeechScore`, domain `b1_exam`) считается на клиенте из
   `SpeechAnalysisModel` по рубрике `AppConstants.speechScore*` (task
   coverage 25 / grammar 35 / vocabulary 25 / coherence 15; списание 5 баллов
   за ошибку, ошибки в целевой грамматике весят вдвое; нет пунктов задания →
   полные 25 за coverage) — **явный плейсхолдер**, не финальные критерии
   B1-экзамена, вынесен в именованные константы, чтобы пересмотр был
   конфигом, а не правкой кода.
4. Сохранение в Firestore (`saveLessonStepResult`) — тоже **best-effort**, с
   таймаутом 15с (`ExamProgressRepository`): мутация уже стоит в офлайн-очереди
   `cloud_firestore`, таймаут лишь не держит экран в ожидании подтверждения сервера.
5. Результат сохраняется в `b1_progress/{userId}/{langId}.lessonResults.{lessonId}_{oralStep}`
   (см. `FIRESTORE.md` §4) и показывается на итоговом экране урока (§6.1).
   `durationSeconds` = длительность таймера, не фактическое время записи.

---

## 6.3 Диалог (DialogueScreen) и анализ речи (LLM)

### Диалог

Отдельный маршрут (`AppRoutes.b1Dialogue`), не встроен в `LessonScreen`
напрямую — `LessonScreen` пушит сюда и получает результат `pop`'ом
(`OralStepOutcome`), затем зовёт `LessonNotifier.completeDialogueStep`.
Если выйти с экрана диалога без завершения — шаг не засчитывается, урок
остаётся на шаге dialogue.

- **Состояние хранится на клиенте** (`DialogueNotifier`, family
  `(langId, lessonId)`), функция `continueDialogue` — без состояния: клиент
  присылает всю историю на каждый вызов (включая `opening_line` ИИ первым
  сообщением). Диалог B1 — 8-12 ходов по несколько сотен токенов, пересылка
  всей истории стоит копейки, а функция остаётся простой.
- **Только голос** (a32d137): текстового ввода нет. Кнопка микрофона
  запускает STT на один ход, ход отправляется автоматически по final result
  или по «Стоп». Пока ждём ответ — `LinearProgressIndicator`, микрофон заблокирован.
- **Ошибка хода** (сеть, квота, таймаут): реплика студента откатывается из
  истории, под чатом показывается ошибка (`errorNetwork`/`errorGeneric`),
  ход можно повторить.
- **Сценарий читается на сервере по `lessonId`** (`lesson.dialogue_task`),
  не из payload — иначе системный промпт можно подменить с клиента.
  Сервер также ограничивает историю (`MAX_DIALOGUE_TURNS` = 30 сообщений,
  `MAX_MESSAGE_CHARS` = 2000 на сообщение, `MAX_DIALOGUE_CHARS` = 8000
  суммарно — лишнее молча отрезается), `max_tokens` = 300 и жёстко проверяет
  `max_turns` заново из присланной истории (не доверяет клиентскому счётчику;
  превышение → `resource-exhausted`).
- **Студенту не показываются** `situation`/`user_role`/`goal` сценария —
  только реплики. `user_role` не используется и в промпте (§20).
- **Завершение диалога** — только по `shouldClose`, а сервер выставляет его
  исключительно когда `turnsLeft <= 0` (исчерпан `max_turns`). Промпт просит
  ИИ вежливо закрыть разговор по достижении цели, но кнопка «Завершить»
  появится всё равно только после `max_turns` реплик студента (§20).
- Системный промпт (`buildDialogueSystemPrompt` в `functions/index.js`, из
  `situation`/`ai_role`/`goal` на языке интерфейса): оставаться в роли,
  отвечать только на изучаемом языке (`LANGUAGE_NAMES[langId]`, регистр B1,
  1-3 предложения), **никогда не исправлять ошибки студента прямо в диалоге**
  (это ломает ролевую игру и выдаёт ответ раньше `analyzeSpeech`), по
  достижении цели вежливо завершить разговор. `temperature` = 0.7.
- **Голос ответа ИИ:** только текст в первой версии — ни on-device
  (`flutter_tts`), ни cloud TTS пока не подключены (осознанно, из-за
  задержки хода: finish speaking → STT → callable round-trip → генерация
  → (TTS) → воспроизведение, реалистично 2-5с тишины на каждый ход).
- **Финал** (`DialogueNotifier.finish`, делегирует `SubmitDialogueUseCase`,
  domain `b1_exam`): анализируется речь СТУДЕНТА (реплики ИИ не передаются в
  `analyzeSpeech`, иначе разбор считал бы их ошибки/лексику пользователя;
  реплики студента склеиваются через пробел), оценка и сохранение — тот же
  best-effort паттерн, что у §6.2, ключ `lessonResults.{lessonId}_dialogue`,
  поле `turns` (вся история, включая ИИ) вместо `transcript`,
  `durationSeconds` — фактическое время на экране.

Контракт `continueDialogue`:

```
in   { langId, lessonId, turns: [{ role: "user"|"ai", text }], uiLanguage }
out  { reply: string, turnsLeft: number, shouldClose: boolean }
```

### Анализ речи (`analyzeSpeech`)

Общая Cloud Function для всех трёх устных шагов (замена узкого
`analyzeFreePractice`) — контракт:

```
in   { langId, lessonId, oralStep: "image"|"monologue"|"dialogue", transcript, uiLanguage }
out  {
  lemmas: [{ surfaceForm, lemma, partOfSpeech }],
  targetGrammarErrors: [{ word, userForm, correctForm, explanation }],
  otherGrammarErrors: [ … та же форма … ],
  lexicalErrors: [ … та же форма … ],
  talkingPointsCovered: [{ point, covered: boolean }],
  coherenceScore: number   // 0-15
}
```

`langId` (pl/fr/es/en/de, иначе `invalid-argument`) обязателен: путь урока
— `b1_exam_content/{langId}/lessons/{lessonId}` (см. `FIRESTORE.md` §4).
Промпт интерполирует название языка (`LANGUAGE_NAMES`: pl→Polish,
fr→French, es→Spanish, en→English, de→German); объяснения ошибок — на
`uiLanguage` (дефолт `en`). `max_tokens` = 2000, JSON-режим OpenAI.

Функция знает `lessonId`/`langId` → читает `grammar_topic_id` (заголовок
темы + заголовки правил) и `lexical_topic_id` (словарь) из Firestore (Admin
SDK), поэтому промпт может явно попросить модель отдельно выделить ошибки в
ЦЕЛЕВОЙ грамматике урока (`targetGrammarErrors`) от прочих
(`otherGrammarErrors`). Пункты задания для `talkingPointsCovered` — из
`image_task.points_to_describe` / `monologue_task.points` /
`dialogue_task.points` по `oralStep`.
**Лемматизация — внутри этого же LLM-вызова**, отдельного морфологического
анализатора (Morfeusz2/spaCy для польского и т.п.) не заводили ни для
одного из пяти языков — дверь для отдельного анализатора остаётся открытой,
если оценка покажет, что лемматизация LLM недостаточно точна для
конкретного языка.

**`lexicalErrors` — серверная сверка, не решение LLM**: модель возвращает
кандидатов словарных ошибок (`vocabularyErrorCandidates`), функция
(`buildLexicalErrors`) оставляет только те, чьё `word` совпадает (без учёта
регистра) со словарём ИМЕННО `lexical_topic_id` этого урока — дешевле и
проверяемее, чем просить модель саму знать список слов урока. Все массивы
ответа санитизируются (`sanitize*`), `coherenceScore` клампится в 0-15.

**Провайдеры** (общий `callLlm()`, используется и `analyzeSpeech`, и
`continueDialogue`): основной — OpenAI (`gpt-4o-mini`), ключ
`OPENAI_API_KEY` из Secret Manager, никогда не попадает в клиент.
**Fallback (Claude, `claude-haiku-4-5`, через стороннего провайдера):**
только при ошибке квоты/rate-limit OpenAI (`status 429` или
`code === 'insufficient_quota'`) и включённом флаге
`b1_service/llmConfig.fallbackEnabled` (Admin SDK) — тот же промпт повторно
отправляется через `@anthropic-ai/sdk` с `baseURL` = `ANTHROPIC_BASE_URL`
(`https://api.ai-keys-shop.com`, сторонний Anthropic-совместимый
провайдер, **временное решение на этапе тестирования**), авторизация
`Authorization: Bearer` (`authToken`, не `x-api-key`), ключ
`ANTHROPIC_API_KEY`. Прочие ошибки OpenAI (таймаут, 5xx, auth) в fallback
**не** уходят → `internal`. Отсутствие документа/ошибка чтения флага =
`false` (fail closed). Ответ Anthropic может прийти в markdown-fence —
`stripJsonFence` снимает его перед `JSON.parse`. Особенности этого шлюза
(fence, `max_tokens` обязателен, периодически битый JSON, маскировка
причины в `APIConnectionError`) описаны в `aikeysshopgatewayintegration.md`
(гайд написан для Python, но ограничения шлюза те же).

**Таймауты:** `LLM_TIMEOUT_MS` = 20с на каждую попытку (OpenAI и fallback,
встроенные ретраи SDK выключены — `maxRetries: 0`), `timeoutSeconds` = 60
на весь `onCall`, клиентский `HttpsCallableOptions.timeout` = 65с.

**Квота** (`enforceQuota`): суточный (UTC) лимит вызовов
`analyzeSpeech`+`continueDialogue` на пользователя, общий по всем языкам —
`DAILY_LLM_QUOTA` = 100 (плейсхолдер). Хранится в root-коллекции
**`llmQuota/{userId}`** (`{date, count}`, транзакция) — Admin SDK-only, чтобы
пользователь не мог читать/сбрасывать свою квоту напрямую (см.
`FIRESTORE.md`). Раньше путь был `b1_service/llmQuota/{userId}` —
невалидный (нечётное число сегментов), из-за чего анализ речи не работал ни
для одного шага (исправлено в a32d137). Превышение → `resource-exhausted`.
Квота списывается до вызова LLM, в т.ч. если сам вызов потом упадёт.

**Секреты и деплой:** `firebase functions:secrets:set OPENAI_API_KEY` /
`ANTHROPIC_API_KEY`, `firebase deploy --only functions`. Регион —
дефолтный (`us-central1`), клиент вызывает `FirebaseFunctions.instance`
без указания региона.

---

## 7. Экраны MVP

- `SplashScreen`
- `AuthorizationScreen` (вход, регистрация, восстановление пароля, Google Sign-In)
- `OnboardingScreen` — первичная настройка профиля (аватар, имя*, фамилия) сразу после регистрации. Пикера языка обучения нет: `OnboardingNotifier` пишет `kDefaultStudyLanguage` (`pl`) в `preference.selectedLanguage`, **только если** поле ещё не установлено другим приложением (§12.1). Маршрут по флагу `onboardingComplete` из Firestore. Лежит в `features/auth/presentation/` (часть auth-потока, проходится один раз).
- `B1HomeScreen` — список лексических тем выбранного языка (тайл первого уровня, Lesson Matrix §A), переход в профиль. Пустые состояния: язык вне `StudyLanguage` (`b1LanguageNotAvailable`), нет тем (`b1LessonsComingSoon`). Прогресс грузится, но не отображается (§20).
- `LexicalTopicLessonsScreen` — уроки одной лексической темы (пары с грамматическими темами), пустое состояние `b1TopicNoLessonsYet`.
- `LessonScreen` — флоу урока (6 шагов) + итоговый экран. См. раздел 6.1.
- `DialogueScreen` — шаг диалога, отдельный маршрут. См. раздел 6.3.
- `ProfileScreen` — аватар/имя (редактирование в bottom sheet), очки, стрик-карточка, радар навыков (`stats`), достижения — по текущему языку обучения.
- `SettingsScreen` — язык интерфейса, язык обучения, тема, скорость речи, выход из аккаунта. Открывается из `ProfileScreen`.

---

## 8. Firebase / Firestore

- `persistenceEnabled: true` — указано явно в `main.dart`
- **Security Rules** настроить с первого дня (матрица — `FIRESTORE.md` §Security Rules):
  - `basic`, `exercises`, `b1_exam_content` — чтение для всех авторизованных пользователей
  - `private_user_info/{userId}` — только владелец
  - `b1_service`, `llmQuota` — только Cloud Functions (клиенту закрыто)
- Правила и индексы в репозитории **не хранятся** (нет `firestore.rules`/`firestore.indexes.json`, `firebase.json` деплоит только functions) — настраиваются в Console. Для `exercises` нужен композитный индекс `course_id + lesson_id + ex_id`.
- Все пути к коллекциям — только через `FirestorePaths`. Строки напрямую в коде запрещены. Исключение — `functions/index.js` (Node, свои константы `B1_CONTENT_ROOT`/`LLM_CONFIG_PATH`/`LLM_QUOTA_COLLECTION`).
- **`update()` для вложенных полей через dot-notation** (`'topicResults.$stepKey'`, `'stats.$category.correct'`, `'preference.uiLanguage'`). `set(merge: true)` с dot-notation ключами создаёт плоские поля с точками в имени вместо вложенных map — использовать только для top-level полей.
- Роль пользователя проверяется в Security Rules или Cloud Functions. Проверка только на клиенте запрещена.
- Структура коллекций описана в `FIRESTORE.md`.

> **Паттерны в коде:**
> - Документ может ещё не существовать — «`update()` → при `not-found`
>   `set()` дефолтов → повторный `update()`»
>   (`ExamProgressRepository._updateOrInit`, `UserRepository._updateOrCreate`).
> - Офлайн `Future` записи Firestore не завершается, пока сервер не
>   подтвердит запись. `saveLessonStepResult` поэтому обёрнут в
>   `.timeout(15с)` → `NetworkError` (запись остаётся в офлайн-очереди);
>   `saveStepResult`/`updateStreak`/`updateAchievement` — без таймаута (§20).

---

## 9. Модели данных

- Все модели — `freezed` + `json_serializable`
- Обязательно: `fromJson`, `toJson`, `copyWith`
- `id` — из `DocumentSnapshot.id` (`{...doc.data(), 'id': doc.id}`), в `toJson()` не попадает (`@JsonKey(includeToJson: false)`)
- `Timestamp` → ISO-строка конвертируется в data-слое (`_preprocess*Data`) — domain-модели не зависят от `cloud_firestore`
- Ответы Cloud Functions приводятся `deepStringKeyedMap` (`core/utils/cloud_functions_json.dart`) перед `fromJson` — на Android вложенные map приходят как `Map<Object?, Object?>`
- In-memory UI-состояние (`LessonStep`, `ExerciseResult`, `LessonState`, `DialogueState`, `OralStepOutcome`) — plain-классы, не freezed (§20)
- `AppError` — `sealed class` (`core/errors/`): `NetworkError`, `AuthError(AuthErrorCode?)`, `NotFoundError`, `UnknownError(message)`. `AuthErrorCode`: `wrongPassword`, `userNotFound`, `emailAlreadyInUse`, `weakPassword`, `requiresRecentLogin`.
- Исключения Firestore/Functions маппятся в `AppError` на уровне `data`-слоя (`mapFirebaseException`; `FirebaseFunctionsException` — подкласс `FirebaseException`). До `domain` исключения не доходят.
- `catch` без маппинга в `AppError` запрещён.

---

## 10. Обработка ошибок

- `AsyncValue` (Riverpod) — основной механизм состояний `loading` / `data` / `error` в UI
- Для MVP: одно сообщение об ошибке + кнопка Retry (`shared/widgets/ErrorView`)
- Детальные сообщения для разных типов ошибок — после MVP (исключение: `DialogueScreen` различает `NetworkError`)
- Сбой LLM-анализа, стрика, достижений, сохранения устного шага — best-effort: логируется `AppLogger.e`, флоу продолжается
- `LoggingProviderObserver` (`core/logger/`) — печатает ошибки любых провайдеров в консоль через `debugPrint`. Подключается в `main.dart` только в debug (`kDebugMode`), в release не используется.
- В release `FlutterError.onError` и `PlatformDispatcher.onError` уходят в Crashlytics (fatal). Необработанные ошибки async-колбэков (например, `onComplete` блока упражнений) попадают туда же, пользователь их не видит.

---

## 11. Loading state

| Ситуация | Компонент |
|---|---|
| Действие (кнопка, отправка формы) | `CircularProgressIndicator` |
| Загрузка контента (списки, карточки) | `Shimmer` (пакет `shimmer`) |

> Факт: `Shimmer` используется только в `ProfileScreen`. B1-экраны
> (`B1HomeScreen`, `LexicalTopicLessonsScreen`, `LessonScreen`,
> `DialogueScreen`) показывают `CircularProgressIndicator` при загрузке
> контента, ожидание ответа ИИ в диалоге — `LinearProgressIndicator`.

---

## 12. Локализация

- `flutter_localizations` + `intl`, ARB-файлы с первого дня
- Расположение: `lib/l10n/app_en.arb` (шаблон), `app_ru.arb`, `app_fr.arb`, `app_es.arb`
- Язык интерфейса по умолчанию: английский (факт: пока пользователь не выбрал язык, `AppLocaleNotifier` = `null` и `MaterialApp` берёт язык устройства, если он среди поддерживаемых; иначе — английский)
- Языки интерфейса MVP: EN, RU, FR, ES
- **Язык интерфейса** и **язык обучения** — разные сущности, не смешивать:
  - **Язык интерфейса** — выбирается пользователем в `SettingsScreen` (секция "Interface language", `_LanguageTile`). Хранится в `public_user_info/{userId}.preference.uiLanguage`. Управляется через `AppLocaleNotifier` (`core/locale/`, keepAlive) и `SettingsNotifier.setUiLanguage`. `MaterialApp.locale` берёт значение из этого провайдера. Восстанавливается из Firestore в `ProfileNotifier.build` — т.е. только когда открыт Profile/Settings; на холодном старте до этого используется язык устройства (§20). Языки интерфейса — EN/RU/FR/ES, независимый список от языков обучения ниже.
  - **Язык обучения** — см. §12.1.
- `uiLanguage`, который клиент передаёт в Cloud Functions, — `Localizations.localeOf(context).languageCode` (фактическая локаль экрана).
- Все строки интерфейса — только через ARB. Хардкод строк запрещён.

---

## 12.1 Язык обучения (StudyLanguage)

Изначально был фиксирован на польском — снято по явному запросу пользователя
(параллель с linguobyte/cinephile: если человек учит французский в одном
приложении, `b1-exam-prep` должен сразу предлагать французский, не
спрашивать заново).

- **Общее поле аккаунта**: `public_user_info/{userId}.preference.selectedLanguage`
  — **то же поле, что уже пишет linguobyte** для своего списка языков обучения
  (en/es/fr/ru, см. `FIRESTORE.md` §3). Осознанное решение: НЕ заводить
  отдельное поле для b1-exam-prep, а разделять текущий язык обучения между
  всеми приложениями на одном аккаунте — так переключение языка в одном
  приложении сразу видно в других. Компромисс: b1-exam-prep не может
  проверить, что linguobyte/cinephile (отдельные кодовые базы) одинаково
  аккуратно обрабатывают значение языка вне их собственного набора — со
  стороны b1-exam-prep обработано защитно (см. ниже), поведение остальных
  приложений не проверялось в рамках этой кодовой базы.
- **Поддерживаемый набор b1-exam-prep — `StudyLanguage`**
  (`shared/models/study_language.dart`, closed enum): `pl | fr | es | en | de`.
  Если `preference.selectedLanguage` содержит код вне этого набора (например
  `ru`, который поддерживает linguobyte, но не b1-exam-prep) — приложение не
  падает: `B1HomeScreen` показывает пустое состояние `b1LanguageNotAvailable`,
  `ProfileScreen` — пустой прогресс.
- **Чтение**: `studyLanguageProvider` (`core/locale/study_language_provider.dart`,
  функциональный autoDispose `@riverpod`) — `watch`-ит `authProvider`,
  читает профиль напрямую `UserRepository.getPublicProfile` (не через
  тяжёлый `profileProvider`), маппит `StudyLanguage.fromCode` в
  `StudyLanguage?` (`null` — язык не выбран ИЛИ вне поддерживаемого набора).
  `B1HomeNotifier` `watch`-ит его — смена языка перезагружает главный экран.
  `ProfileNotifier` читает то же поле из уже загруженного профиля сам.
- **Онбординг**: пишет язык по умолчанию `kDefaultStudyLanguage` (`pl`,
  `onboarding_notifier.dart`), ТОЛЬКО если поле у аккаунта ещё вообще не
  установлено (первое приложение на аккаунте). Если поле уже установлено
  (пользователь пришёл из linguobyte/cinephile с уже выбранным языком) —
  онбординг его не трогает, уважает существующий выбор (даже если это язык
  вне `StudyLanguage` — тогда пустое состояние).
- **Переключение**: `SettingsScreen`, секция "Study language"
  (`_StudyLanguageTile`, bottom sheet со всеми `StudyLanguage.values`),
  `SettingsNotifier.setStudyLanguage` → `UserRepository.saveSelectedLanguage`
  (dot-notation `preference.selectedLanguage`) → инвалидирует
  `studyLanguageProvider` и `profileProvider`. Меняет язык и для
  linguobyte/cinephile на том же аккаунте — ожидаемое поведение, не баг.
- **STT-локаль** выводится из `StudyLanguage.sttLocaleId` (`pl→pl-PL`,
  `fr→fr-FR`, `es→es-ES`, `en→en-US`, `de→de-DE`) и передаётся в
  `FreePracticeView`/используется в `DialogueScreen`. Исключение —
  упражнение `voice_translate`: локаль из `type_data.stt_language_code`
  (дефолт `en-US`).
- **Маршруты** несут `langId` в пути (§6), **прогресс, контент, упражнения,
  Cloud Functions** — все ключуются/фильтруются по `langId`
  (`StudyLanguage.name`), подробности в `FIRESTORE.md` §4 и §6.3.

---

## 13. Тема оформления

- Вся тема — через `AppTheme` и `ThemeData`
- Хардкод цветов, размеров и отступов в виджетах запрещён
- Определить до написания первого экрана: primary / secondary / error цвета, стили текста, `AppSpacing`, `AppSizes`
- Цвета и типографика — в `ThemeData`; цвета вне `ColorScheme` (success, textMuted, surfaceOverlay…) — `AppColors` (`ThemeExtension`, `theme.extension<AppColors>()!`)
- Отступы и размеры — в константах `AppSpacing` / `AppSizes`
- Шрифт — Geologica (`google_fonts`, грузится по сети при первом запуске)

> Факт: есть только `AppTheme.dark`; `main.dart` жёстко ставит
> `theme: AppTheme.dark, themeMode: ThemeMode.dark`. Переключатель темы в
> `SettingsScreen` пишет `preference.theme`, но ни на что не влияет;
> `AppColors.lightPreview` — временная заготовка (§20).

---

## 14. Именование

| Сущность | Стиль | Пример |
|---|---|---|
| Файлы | `snake_case` | `exam_progress_repository.dart` |
| Экраны | `PascalCase` + `Screen` | `B1HomeScreen` |
| Модели | `PascalCase` + `Model` | `LessonModel` |
| Репозитории | `PascalCase` + `Repository` | `ExamProgressRepository` |
| Интерфейсы репозиториев | `I` + `PascalCase` + `Repository` | `IExamProgressRepository` |
| UseCase | `PascalCase` + `UseCase` | `CompleteB1StepUseCase` |
| Классы нотификаторов | `PascalCase` | `LessonNotifier` |
| Провайдеры | `camelCase` + `Provider` | `lessonProvider` |
| Коллекции Firestore | `camelCase` | `privateUserInfo` |

> Провайдеры в `camelCase` — не исключение из правил, а поведение генератора `@riverpod`. Класс нотификатора (`LessonNotifier`) — `PascalCase`. Провайдер (`lessonProvider`) генерируется автоматически в `camelCase`. Riverpod 3.x убирает суффикс `Notifier` из имени провайдера.
>
> **Факт (расхождение с таблицей, не решено):** все реальные коллекции
> Firestore названы в `snake_case` (`private_user_info`, `b1_exam_content`,
> `b1_progress`, `llmQuota` — исключение); `camelCase` — только имена
> Dart-констант в `FirestorePaths` (`FirestorePaths.privateUserInfo`). Поля
> документов: контент — `snake_case` (`lexical_topic_id`), прогресс/профиль/
> ответы функций — `camelCase` (`topicResults`, `onboardingComplete`).
> Интерфейсы репозиториев в коде — префикс `I` (`IExamProgressRepository`).

---

## 15. Константы

| Класс | Содержимое |
|---|---|
| `FirestorePaths` | Все пути Firestore (статические строки + методы для динамических путей). `b1LlmConfig`/`b1LlmQuota` — мёртвые (клиент их не читает, `b1LlmQuota` указывает на старый невалидный путь) |
| `AppRoutes` | Все маршруты GoRouter + билдеры путей `b1LexicalTopicPath`/`b1LessonPath`/`b1DialoguePath` |
| `AppSpacing` | Отступы (`xs`=4 … `x4l`=64) |
| `AppSizes` | Размеры UI-элементов. Часть констант — наследие linguobyte и не используется (`lessonCardWidth/Height`, `timelineDot`, `timelineLineWidth`, `profileIconSize`, `progressBarHeight`, `completionIconSize`) |
| `AppConstants` | Бизнес-пороги и флаги: `showSkipButton` (`--dart-define=SHOW_SKIP_BUTTON`), `lessonBlockExerciseCap` = 10, `oralStepDurationSeconds` = 180, рубрика `speechScore*` (25/35/25/15, штраф 5, вес целевой грамматики ×2). `passThresholdPercent` = 78 — не используется |
| `AvatarPresets` | id пресет-аватаров (`avatar_01`…`avatar_12`), `defaultId`, `pathOf(id)` |

Цвета и типографика — не константы, только `ThemeData` / `AppColors`.

Параметры сборки (`--dart-define`): `FIREBASE_*` (см. `.env.example`),
`GOOGLE_SERVER_CLIENT_ID` (нужен для idToken Google Sign-In на Android),
`SHOW_SKIP_BUTTON` (Skip в упражнениях для тестовых сборок).

---

## 16. Медиа

- **Изображения:** `cached_network_image`. Настроить `maxCacheSize` и `maxCacheAge` (не сделано — используется дефолтный кэш-менеджер).
- **Аудио:** `just_audio` для MVP (`shared/widgets/AudioPlayButton`). Миграция на `audio_service` (фоновое воспроизведение) — при необходимости в будущем, без переписывания логики. Настройка `preference.speechSpeed` к плееру не применяется.
- **Видео:** открытый пункт, решается после выбора хранилища.

---

## 17. Инициализация (до написания первого экрана)

- **Crashlytics** — подключён (release: `FlutterError.onError`/`PlatformDispatcher.onError`)
- **Firebase Analytics** — подключён, сбор выключен в debug, события настраивать позже
- **`AppLogger`** — абстракция над `logger`. В release отключён (`Level.off`).
- **Переменные окружения** (Firebase конфиг, ключи) — через `--dart-define` или `.env`. Хардкод в коде запрещён. `firebase_options.dart` читает `String.fromEnvironment('FIREBASE_*')`.
- `Firebase.initializeApp` обёрнут в `try` с игнором `duplicate-app` (Android регистрирует `[DEFAULT]` нативно раньше `main()`).
- `GoogleSignIn.instance.initialize(serverClientId: GOOGLE_SERVER_CLIENT_ID)` — до `runApp`.

---

## 18. Офлайн

- Встроенный кэш Firestore (`persistenceEnabled: true`) — достаточно для MVP
- LLM-шаги (анализ речи, диалог) требуют сети; при её отсутствии анализ сохраняется как `null`, ход диалога возвращает ошибку
- Предзагрузка контента и офлайн-доступ к медиа — за пределами MVP

---

## 19. Открытые пункты

- Видеоплеер и видеохостинг — решается после выбора хранилища
- Тестирование: страховочные unit-тесты (`test/domain/`: сериализация моделей, достижения, streak/stats) добавлены; widget/integration-тесты и CI/CD — после MVP
- Детальная обработка ошибок с разными сообщениями — после MVP
- Офлайн-предзагрузка медиа — после MVP

---

## 20. Технический долг

Фиксируется здесь. Решается до постMVP-итерации или при выходе на соответствующую фазу.

### Фазы 1–2 (Auth + Profile)

- **`AuthRepository.signUp`/`signInWithGoogle` создают Firestore-документы** (`data/auth_repository.dart`): регистрация делает сразу два дела — создаёт Firebase Auth аккаунт и пишет профиль в Firestore. Если Firebase Auth прошёл, а Firestore упал — при email-регистрации делаем откат (удаляем Auth аккаунт), но это ненадёжно: удаление тоже может упасть; у Google-входа отката нет вовсе. _Когда закрывать_: Cloud Functions уже подключены (`functions/`) — триггер `onCreate` на стороне сервера создаёт документы атомарно и надёжнее любого клиентского отката.
- **Запоминание входа** (`AuthorizationScreen`): поля email/пароль не сохраняются между сессиями. _Когда закрывать_: пост-MVP, при работе над UX онбординга.
- **Нет удаления аккаунта**: в `SettingsScreen` только «Выйти». App Store (Guideline 5.1.1(v)) требует удаления аккаунта в приложении, где его можно создать. `AuthErrorCode.requiresRecentLogin` уже заведён под этот сценарий. _Когда закрывать_: до публикации в App Store. Учесть, что аккаунт общий с linguobyte/cinephile.

### B1 exam prep (после переноса движка упражнений из linguobyte)

> `features/home` и `features/lesson` (уроки, теория/лексика/глаголы, `HomeScreen`) удалены целиком — это была логика linguobyte, к B1 не относится. Общий движок упражнений (`ExerciseModel`, `ExerciseResult`, `ExerciseWidget`, `ExercisePhaseWidget`, 8 виджетов типов) перенесён в `features/b1_exam`. Технический долг из старых фаз 3–4, привязанный к удалённому коду, снят вместе с ним.

> **Lesson Matrix — старая sections/topics-схема retired.** `ExamSectionModel`/`ExamSectionType`, `PracticeScreen`/`TopicDetailScreen`/`ImagePracticeScreen`, `PrepStep`/`PrepLevelCard`/`SectionCard`/`TopicTile`, `ExamContentRepository`, `FreePracticeAnalysisModel`/`MisusedWordModel`/`FreePracticeResultModel`, `analyzeFreePractice` — удалены, заменены на `LessonModel`/`LexicalTopicModel`/`GrammarTopicModel`, `LessonScreen`/`LexicalTopicLessonsScreen`/`DialogueScreen`, `LessonContentRepository`, `SpeechAnalysisModel`, `analyzeSpeech`/`continueDialogue` (см. §6.1–§6.3). **Остаток:** `domain/models/exam_topic_model.dart` (`ExamTopicModel`) в репозитории остался и нигде не используется — удалить.

- **Рубрика оценки устного шага — плейсхолдер**: `AppConstants.speechScore*` (25/35/25/15, target-grammar ошибки весят вдвое) — явно не финальные критерии B1-экзамена, подобраны без реальной калибровки. Вынесено в именованные константы намеренно, чтобы пересмотр был конфигом. Побочка: баллы только списываются за ошибки, длина/объём ответа не учитываются — пара слов без ошибок получает ~85-100. `lexicalErrors` — лишь ошибки в словах из словаря урока, поэтому vocabulary почти всегда 25/25. Пересмотреть, когда появится обратная связь от реальных прохождений.
- **Суточная квота LLM — плейсхолдер**: `DAILY_LLM_QUOTA` в `functions/index.js` (сейчас 100 вызовов `analyzeSpeech`+`continueDialogue` в сутки на пользователя) не откалибрована по реальной нагрузке/стоимости. Один урок тратит до ~13 вызовов (2 анализа + до 10 ходов диалога + анализ диалога). Подобрать после запуска.
- **Диалог — только текст, без голоса ИИ**: осознанное решение первой версии (см. §6.3, "Голос ответа ИИ"). Следующая итерация — `flutter_tts` (on-device) с фолбэком на текст при отсутствии голоса выбранного `StudyLanguage` на устройстве (актуально для всех пяти языков). Шлюз ai-keys-shop TTS не поддерживает.
- **`Vocabulary Master` — продуктовое решение при рефакторинге, не проверено на реальных пользователях**: переопределено на "весь урок (verb+noun+phrase) пройден, все с первой попытки" — см. `check_b1_achievement_use_case.dart`. Пересмотреть при реальной обратной связи.
- **Переигровка блока упражнений — побочки stats/достижений**: повторное прохождение уже пройденного блока инкрементит `stats` и достижения заново (`FieldValue.increment`; `master_conjugator`/`vocabulary_master` +1 при каждом завершении любого блока уже пройденного урока). Требует продуктового решения.
- **[TD-1] Skip-кнопка для тестеров** (`exercise_widget.dart`): видна в debug всегда, в release/profile — по флагу сборки `--dart-define=SHOW_SKIP_BUTTON=true` (`AppConstants.showSkipButton`). Обычный прод-билд (App Store, без флага) кнопку не содержит. TestFlight/ad-hoc билды для тестеров собирать с флагом. Подпись 'Skip' и `fontSize: 11` захардкожены (не ARB/тема) — допустимо только пока кнопка тестовая.
- **[TD-3] Пустой `form` в fill_blank**: показать заглушку вместо поля ввода без контекста. Не сделано.
- **Нет тестов для usecase-слоя Lesson Matrix**: `CheckB1AchievementUseCase`/`CompleteB1StepUseCase` и `SubmitOralStepUseCase`/`SubmitDialogueUseCase`/`calculateSpeechScore` не покрыты тестами — не запрошено явно (см. CLAUDE.md «Открытые пункты»). Cloud Functions (`functions/index.js`) — тоже без тестов и без линтера.
- **`b1_service/**` и `llmQuota/**` — правила в Console не подтверждены этой кодовой базой**: обе — новые root-коллекции, никакое существующее правило их не покрывает. Нужно явно добавить admin-only записи без клиентского доступа — см. `FIRESTORE.md` §Security Rules. Правила/индексы вообще не версионируются в репозитории — стоит завести `firestore.rules`/`firestore.indexes.json` и деплоить через `firebase.json`.
- **`preference.selectedLanguage` — общее поле с linguobyte/cinephile, не проверено с их стороны**: со стороны b1-exam-prep обработка значений вне `StudyLanguage` защитная (пустое состояние, не краш), но нет доступа к их кодовым базам, чтобы подтвердить, что они так же аккуратно обрабатывают `pl`/`de`. Стоит проверить отдельно.
- **Fallback LLM срабатывает только на квоту OpenAI** (`isQuotaError`: 429/`insufficient_quota`). Таймаут, 5xx, ошибка авторизации/сети OpenAI → сразу `internal`, хотя fallback закрыл бы и их (рекомендация `aikeysshopgatewayintegration.md` §5). Битый JSON от модели не пересэмплируется (там же §3.4), `finish_reason == length` не проверяется.
- **`scripts/seed/` устарел**: пишет старую схему (`b1_polish/pl/sections/topics`, упражнения с числовым `lesson_id` и `segment_type` без `block` — такие упражнения клиент пропускает). Переписать под `b1_exam_content/{langId}` + `block` или удалить, если контент ведётся только через админ-панель.

### Известные баги и расхождения (аудит 2026-09-30)

Найдено при сверке документации с кодом; не исправлено (задача была только в документации).

- **Master Conjugator не выдаётся при первом прохождении урока.** Условие — «только что завершён блок `verb` И урок пройден», но `verb` — первый блок, в момент его завершения `noun`/`phrase` ещё не пройдены. Достижение срабатывает только при повторном прохождении урока (урок всегда начинается с `verb`). `check_b1_achievement_use_case.dart`.
- **Пустой блок упражнений блокирует урок.** Если у урока нет упражнений какого-то блока (или все отфильтрованы при парсинге), `_BlockExerciseView` показывает «нет упражнений» без кнопки продолжения — до устных шагов не дойти. `lesson_screen.dart`.
- **«Завершить блок» без защиты и обработки ошибок.** `finishBlockStep` передаётся как `VoidCallback`: нет индикатора, повторный тап сохраняет блок дважды (двойной инкремент `stats`/достижений), ошибка сохранения — необработанное исключение (в release → Crashlytics), пользователь остаётся на блоке без сообщения. Офлайн `saveStepResult`/`updateStreak` без таймаута — `await` висит до появления сети (у `saveLessonStepResult` таймаут есть).
- **`multiple_choice`/`listen_pick`: код читает `answer_index`, прежняя документация описывала `correct_index`.** Если контент пишет `correct_index`, правильным молча считается вариант 0. Сверить реальные документы/админ-панель. Там же: `multiple_choice` строит `ExerciseResult.correctAnswer` из несуществующего `sentence_form` (UI — из `form`); `fill_blank` берёт `question` из несуществующего `sentence` — сейчас безвредно, эти поля нигде не сохраняются.
- **`incorrectExerciseIds` хранят `ex_id`, а не id документа** (`ExerciseResult.exerciseId = exId.toString()` во всех виджетах). `ex_id` — порядковый номер внутри урока, для будущего flow повторения неоднозначен.
- **Диалог нельзя завершить раньше `max_turns`.** `shouldClose` = `turnsLeft <= 0`; ИИ по промпту закрывает разговор при достижении цели, но кнопка «Завершить» появляется только после 10 (по умолчанию) реплик студента.
- **Студент не видит сценарий диалога.** `situation`/`user_role`/`goal` не показываются на `DialogueScreen` — только реплика ИИ; `user_role` не используется и в промпте сервера.
- **Прогресс не отображается.** `topicResults`/`lessonResults` пишутся, но ни один экран их не читает: на главной и в списке уроков нет отметок «пройдено»/оценок, `B1HomeState.progress` загружается впустую.
- **Правила/лексика урока не показываются.** `getGrammarRules`/`getLexicalVocabulary` реализованы, но не вызываются — урок начинается сразу с упражнений, без теории и словаря.
- **Язык интерфейса не восстанавливается на старте.** `preference.uiLanguage` применяется только в `ProfileNotifier.build` — до открытия профиля/настроек приложение на языке устройства.
- **Настройки темы и скорости речи ни на что не влияют.** `preference.theme` игнорируется (`ThemeMode.dark` захардкожен, `AppTheme.light` не существует — есть только `AppColors.lightPreview`); `preference.speechSpeed` не передаётся в `AudioPlayButton`.
- **Мёртвый код и пакеты:** `ExamTopicModel`, `shared/models/lesson_step_summary.dart` (`LessonStepSummary`), `FirestorePaths.b1LlmConfig`/`b1LlmQuota` (последний — старый невалидный путь), неиспользуемые `AppSizes.lessonCard*`/`timeline*`/`profileIconSize`/`progressBarHeight`/`completionIconSize`, `AppConstants.passThresholdPercent`, пакеты `firebase_storage`/`flutter_svg`, `ILessonContentRepository.getGrammarRules`/`getLexicalVocabulary` (не вызываются).
- **Устаревшие комментарии в коде** ссылаются на удалённые сущности (`saveFreePracticeResult`, `FreePracticeAnalysisModel`, `getTopics()`, «opening_line всегда на польском», «B1 Polish exam prep» в `TopicProgressModel`, «HomeScreen» в `AppSizes`).
- **Хардкод размеров/радиусов** вопреки §13: `DialogueScreen` (`BorderRadius.circular(12)`, `20`), `LessonScreen` (иконка `80` при наличии `AppSizes.completionIconSize`), `FreePracticeView` (высота картинки `220`), `ExerciseWidget` (заглушка `120`).
- **`ExerciseModel.type` — строка**, хотя список типов закрытый (правило CLAUDE.md «Enum вместо строк»).
- **Урок/тема с битой ссылкой роняют экран**: `LessonModel` требует все пять полей — один неполный документ урока роняет весь список уроков языка; `firstWhere` по `lexical_topic_id`/`grammar_topic_id` без `orElse` бросает `StateError` (не `AppError`).
- **README.md** — шаблон `flutter create` с названием linguobyte (обновлён вместе с этим аудитом).

### Profile / Settings (Фаза 5)

- **[TD-6] Инвалидация `topicResults` при смене контента**: при замене упражнений блока старый результат остаётся «зелёным». Пост-MVP: `contentVersion` в уроке.
- **Light theme**: `AppTheme.light` не существует (только `AppColors.lightPreview` с пометкой «ВРЕМЕННО»), `themeMode` захардкожен на dark. Полная проработка после MVP.
- **`UserRepository` без полного интерфейса**: реализует только узкий `IStreakRepository` (для развязки `CompleteB1StepUseCase`); для профиль-методов интерфейса нет. Пост-MVP: добавить `IUserRepository` + вынести в `shared/`.
- **In-memory модели не freezed**: `ExerciseResult`, `LessonStep`, `LessonState`, `DialogueState`, `OralStepOutcome` — не сериализуются, живут только во время прохождения. Допустимо для MVP.
- **Стрик и таймзоны**: `UserRepository.updateStreak` использует локальное `DateTime.now()` — при смене таймзоны стрик может сбоить (квота LLM при этом считается по UTC).
- **`PreferenceModel`**: `preference` — нетипизированная Map. Типизация (чтение) — низкий приоритет, запись остаётся dot-notation.
- **`points`/`reward`**: XP не начисляется (`points` всегда 0, но показывается в профиле). Начисление — отдельная фича.

### Кросс-фичевые зависимости (допустимо для MVP)

- `UserRepository` (profile) используется в онбординге (`auth`), в `studyLanguageProvider`/`onboardingStatusProvider` и в `CompleteB1StepUseCase` (`b1_exam`, через узкий интерфейс `IStreakRepository`) — стрик общий для аккаунта, не привязан к языку/приложению.
- `ProfileNotifier` (profile) читает `ExamProgressRepository`/`TopicProgressModel` (`b1_exam`) — ProfileScreen показывает stats/achievements B1.
- `AchievementModel`/`AchievementType`/`ExerciseStatsModel`/`StepResultModel` (profile/domain) используются `b1_exam` (`TopicProgressModel`, `CheckB1AchievementUseCase`) — одна и та же форма stats/achievements для общего `ProfileScreen`, при полностью изолированных Firestore-документах (`b1_progress` vs. `languages/{langId}` linguobyte). `AchievementUpdate` вынесен в отдельный файл `profile/domain/achievement_update.dart`.
- **Domain → data/Firebase транзитивно**: DI-провайдеры UseCase (`@riverpod` в `domain/usecases/*.dart`) импортируют `data/repositories/*` и `profile/data/user_repository.dart` (§3). Вынести DI-функции в `presentation/providers/` или отдельный `di/`-файл, если потребуется строгая изоляция domain.
- **`core/` → features**: `core/locale/study_language_provider.dart` зависит от `features/auth` и `features/profile/data`. Кандидат на перенос в `profile/presentation/` или `shared/`.
- Движок упражнений (`ExerciseModel`/`ExerciseResult`/`ExerciseWidget`/`ExercisePhaseWidget`/`exercises/*`) живёт целиком в `b1_exam` — не кросс-фичевая зависимость.
