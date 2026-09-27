# ARCHITECTURE.md

> Главный ориентир при написании кодовой базы. Читать перед началом любой задачи.

---

## 1. Обзор проекта

Мобильное приложение для подготовки к устному экзамену B1, Lesson Matrix:
урок = пара «лексическая тема (Restauracja, Hotel…) × грамматическая тема
(Celownik, Tryb warunkowy…)». Внутри урока — шесть шагов подряд: три капа
упражнений по 10 (verb/noun/phrase, все на лексике урока), затем три устных
упражнения (image description / monologue / dialogue), каждое с таймером,
LLM-анализом (`analyzeSpeech`) и remedial review неправильно использованной
лексики. Платформы: Android, iOS.

**Изучаемый язык — один из пяти (pl/fr/es/en/de), не только польский**
(`StudyLanguage`, см. §12.1). Изначально был фиксирован на польском —
снято по явному запросу, чтобы поддержать тот же список языков, что и
linguobyte. Контент по языку без пары ещё не заведён — не блокирует код,
экран темы показывает пустое состояние, как и для уже пройденных
Restaurant/Hotel/School (см. `FIRESTORE.md`).

Роли: пользователь, администратор. Админ-панель — отдельное веб-приложение, не часть этого проекта.

Отдельное приложение от linguobyte (свой `applicationId`/bundle id, свой
Firestore-контент `b1_exam_content`/`b1_progress`), но использует тот же
Firebase-проект и общий профиль (`private_user_info`/`public_user_info`) —
см. §12 и `FIRESTORE.md`.

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
| LLM (анализ речи, диалог) | OpenAI API (`gpt-4o-mini`) — основной провайдер; Claude (`claude-haiku-4-5`) через сторонний Anthropic-совместимый провайдер — запасной, временно на этапе тестирования (см. §6.3). Оба вызываются только из Cloud Functions `analyzeSpeech`/`continueDialogue`, через общий `callLlm()` |

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
      data/            # LessonContentRepository, ExamExerciseRepository, ExamProgressRepository,
                       # SpeechAnalysisRepository, DialogueRepository
      domain/          # LessonModel/LexicalTopicModel/GrammarTopicModel/GrammarRuleModel/...,
                       # ExerciseModel/ExerciseResult (движок упражнений, форма не менялась),
                       # SpeechAnalysisModel, LessonStep, CheckB1AchievementUseCase,
                       # CompleteB1StepUseCase, SubmitOralStepUseCase, SubmitDialogueUseCase
      presentation/    # B1HomeScreen, LexicalTopicLessonsScreen, LessonScreen, DialogueScreen,
                       # ExerciseWidget + exercises/*
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
- **`AppRoutes.b1LexicalTopic`** (`/b1/topic/:lexicalTopicId`) — `LexicalTopicLessonsScreen`, список уроков одной лексической темы.
- **`AppRoutes.b1Lesson`** (`/b1/lesson/:lessonId`) — `LessonScreen`, флоу урока (6 шагов). См. раздел 6.1.
- **`AppRoutes.b1Dialogue`** (`/b1/lesson/:lessonId/dialogue`) — `DialogueScreen`, отдельный маршрут для шага диалога; `LessonScreen` пушит сюда и ждёт результат `pop`'ом. См. раздел 6.3.

---

## 6.1 Флоу урока (LessonScreen)

Урок (`LessonModel`) проходится одним экраном по фиксированной
последовательности из шести шагов: три капа упражнений (verb → noun →
phrase, каждый не больше `AppConstants.lessonBlockExerciseCap` = 10) → три
устных упражнения подряд (image → monologue → dialogue). Управляется
`LessonNotifier` (`LessonState.stepIndex`/`currentStep`), шаг — `LessonStep`
(domain, plain sealed class, не freezed — in-memory UI-состояние, тот же
паттерн, что был у удалённого `ImagePracticeStep`): `VerbBlockStep` /
`NounBlockStep` / `PhraseBlockStep` (упражнения по `ExerciseBlock`) и
`ImageStep` / `MonologueStep` / `DialogueStep` (соответствующее задание из
`LessonModel`).

- Все упражнения урока грузятся одним запросом (`course_id="b1_pl"`,
  `lesson_id=lesson.id`) и группируются/капаются в памяти по `block` —
  тот же паттерн загрузки, что был у старой схемы.
- **Поток блока упражнений:** упражнения по одному (общий
  `ExercisePhaseWidget`, не менялся) → «Завершить блок» → следующий шаг.
- **Завершение блока** делегируется `CompleteB1StepUseCase` (domain,
  `b1_exam`): сохранить результат (+stats), обновить стрик (общий
  `IStreakRepository` из `profile`), проверить достижения
  (`CheckB1AchievementUseCase`). `stepKey` = `"{lessonId}_{block}"`
  (`block`: verb/noun/phrase), хранится в `b1_progress/{userId}.topicResults`.
  Урок всегда состоит ровно из трёх блоков — параметра, аналогичного
  старому `requiredPrepLevels`, больше не нужно (§20 старый техдолг снят).
- **Достижения** (`CheckB1AchievementUseCase`) рекеены на `lessonId`/`block`:
  Master Conjugator — блок `verb` завершён и урок полностью пройден;
  First Step — первый ЛЮБОЙ урок, пройденный полностью целиком (раньше
  был жёстко привязан к `t_id==1`, у уроков нет порядкового номера);
  Vocabulary Master — переопределено: весь урок (все три блока) пройден и
  всё правильно с первой попытки — прежний отдельный уровень
  "vocabulary" из новой схемы блоков ушёл, решение продукта при рефакторинге.
- **Оба устных шага image/monologue** используют один и тот же виджет
  `FreePracticeView` (см. §6.2), параметризованный заданием — картинкой
  (`ImageTaskModel`) или текстовым промптом (`FreePracticeTaskModel`).
  Диалог — отдельный экран, см. §6.3.
- По завершении всех шести шагов — итоговый экран урока: счёт (0-100) и
  remedial review неправильно использованной лексики по каждому устному
  шагу (`SpeechAnalysisModel.targetGrammarErrors`/`otherGrammarErrors`/
  `lexicalErrors`).

---

## 6.2 Устные шаги image/monologue (FreePracticeView)

`FreePracticeView` — общий шаблон для image/monologue (dialogue — отдельный
флоу, см. §6.3): опциональная картинка + текст задания + список пунктов
для раскрытия + таймер (`LessonModel.durationSeconds`, дефолт
`AppConstants.oralStepDurationSeconds` = 180с, если в контенте не задано) +
`speech_to_text` → транскрипт. Раньше был жёстко привязан к
`ExamTopicModel` (только image_description) — генерализован под Lesson
Matrix, принимает `imageUrl`/`promptText`/`pointsToDescribe`/
`durationSeconds` напрямую, картинка и промпт-текст теперь оба опциональны
(monologue задание — без картинки).

По завершении (`LessonNotifier.submitOralStep`, делегирует
`SubmitOralStepUseCase`, domain `b1_exam`):

1. Транскрипт отправляется в Cloud Function `analyzeSpeech`
   (`functions/index.js`) через `ISpeechAnalysisRepository`/`cloud_functions`
   — контракт и провайдер-fallback описаны в §6.3 (общий для image/monologue/dialogue).
2. Анализ — **best-effort**: сбой не должен ронять сохранение транскрипта,
   тот же паттерн что у streak/достижений в `CompleteB1StepUseCase`. При
   сбое `analysis` сохраняется как `null`.
3. Оценка (`calculateSpeechScore`, domain `b1_exam`) считается на клиенте из
   `SpeechAnalysisModel` по рубрике `AppConstants.speechScore*` (task
   coverage 25 / grammar 35 / vocabulary 25 / coherence 15, ошибки в
   целевой грамматике урока весят вдвое) — **явный плейсхолдер**, не
   финальные критерии B1-экзамена, вынесен в именованные константы, чтобы
   пересмотр был конфигом, а не правкой кода.
4. Сохранение в Firestore (`saveLessonStepResult`) — тоже **best-effort**, с
   таймаутом 15с (`ExamProgressRepository`), тот же паттерн офлайн-очереди
   `cloud_firestore`, что был у `saveFreePracticeResult`.
5. Результат сохраняется в `b1_progress/{userId}.lessonResults.{lessonId}_{oralStep}`
   (см. `FIRESTORE.md`) и показывается на итоговом экране урока (§6.1).

---

## 6.3 Диалог (DialogueScreen) и анализ речи (LLM)

### Диалог

Отдельный маршрут (`AppRoutes.b1Dialogue`), не встроен в `LessonScreen`
напрямую — `LessonScreen` пушит сюда и получает результат `pop`'ом
(`OralStepOutcome`), затем зовёт `LessonNotifier.completeDialogueStep`.

- **Состояние хранится на клиенте** (`DialogueNotifier`), функция
  `continueDialogue` — без состояния: клиент присылает всю историю хода на
  каждый вызов. Диалог B1 — 8-12 ходов по несколько сотен токенов,
  пересылка всей истории стоит копейки, а функция остаётся простой.
- **Сценарий читается на сервере по `lessonId`** (`lesson.dialogue_task`),
  не из payload — иначе системный промпт можно подменить с клиента.
  Сервер также ограничивает количество сообщений в истории, суммарную
  длину символов, `max_tokens` и жёстко проверяет `max_turns` заново из
  присланной истории (не доверяет клиентскому счётчику).
- **STT запускается/останавливается на каждый ход**, не работает
  непрерывно как в `FreePracticeView` — микрофон включён только пока
  студент формулирует ответ.
- Системный промпт (собирается в `functions/index.js` из `dialogue_task`):
  оставаться в роли, отвечать только по-польски (регистр B1, 1-3
  предложения), **никогда не исправлять ошибки студента прямо в диалоге**
  (это ломает ролевую игру и выдаёт ответ раньше `analyzeSpeech`) — при
  достижении цели или `max_turns` вежливо завершить разговор.
- **Голос ответа ИИ:** только текст в первой версии — ни on-device
  (`flutter_tts`), ни cloud TTS пока не подключены (осознанно, из-за
  задержки хода: finish speaking → STT → callable round-trip → генерация
  → (TTS) → воспроизведение, реалистично 2-5с тишины на каждый ход;
  первая версия просто честно это показывает — typing indicator, реплика
  текстом пока не загрузился бы TTS).
- **Завершение** (`DialogueNotifier.finish`, делегирует
  `SubmitDialogueUseCase`, domain `b1_exam`): анализируется речь СТУДЕНТА
  (реплики ИИ не передаются в `analyzeSpeech`, иначе разбор считал бы их
  ошибки/лексику пользователя), оценка и сохранение — тот же best-effort
  паттерн, что у §6.2, ключ `lessonResults.{lessonId}_dialogue`, поле
  `turns` вместо `transcript`.

### Анализ речи (`analyzeSpeech`)

Общая Cloud Function для всех трёх устных шагов (замена узкого
`analyzeFreePractice`) — контракт:

```
in   { lessonId, oralStep, transcript, uiLanguage }
out  {
  lemmas: [{ surfaceForm, lemma, partOfSpeech }],
  targetGrammarErrors: [{ word, userForm, correctForm, explanation }],
  otherGrammarErrors: [ … та же форма … ],
  lexicalErrors: [ … та же форма … ],
  talkingPointsCovered: [{ point, covered: boolean }],
  coherenceScore: number   // 0-15
}
```

Контракт с версии StudyLanguage дополнительно принимает `langId`
(`in { lessonId, langId, oralStep, transcript, uiLanguage }`) — путь урока
в Firestore теперь `b1_exam_content/{langId}/lessons/{lessonId}`
(см. `FIRESTORE.md` §4), без `langId` функция не знает, в каком языковом
документе искать урок. Промпт также интерполирует название языка
(`LANGUAGE_NAMES` в `functions/index.js`: pl→Polish, fr→French, es→Spanish,
en→English, de→German) вместо жёсткого "Polish" везде в тексте промпта.

Функция знает `lessonId`/`langId` → читает `grammar_topic_id` (+ правила) и
`lexical_topic_id` (+ словарь) из Firestore (Admin SDK), поэтому промпт
может явно попросить модель отдельно выделить ошибки в ЦЕЛЕВОЙ грамматике
урока (`targetGrammarErrors`) от прочих (`otherGrammarErrors`).
**Лемматизация — внутри этого же LLM-вызова**, отдельного морфологического
анализатора (Morfeusz2/spaCy для польского и т.п.) не заводили ни для
одного из пяти языков: у каждого своя морфология (польский — 7 падежей,
немецкий — 4 падежа + грамматический род, и т.д.), но дообучать/разворачивать
новую инфраструктуру под каждый язык ради этого не стали — дверь для
отдельного анализатора остаётся открытой, если оценка покажет, что
лемматизация LLM недостаточно точна для конкретного языка.

**`lexicalErrors` — серверная сверка, не решение LLM**: модель возвращает
кандидатов словарных ошибок, функция (`functions/index.js`,
`buildLexicalErrors`) оставляет только те, чьё слово совпадает со словарём
ИМЕННО `lexical_topic_id` этого урока — дешевле и проверяемее, чем просить
модель саму знать список слов урока.

**Провайдеры** (общий `callLlm()` в `functions/index.js`, используется и
`analyzeSpeech`, и `continueDialogue`): основной — OpenAI (`gpt-4o-mini`),
ключ `OPENAI_API_KEY` из Secret Manager, никогда не попадает в клиент.
**Fallback (Claude, `claude-haiku-4-5`, через стороннего провайдера):** при
ошибке квоты/rate-limit (`429`/`insufficient_quota`) и включённом флаге
`b1_service/llmConfig.fallbackEnabled` (Admin SDK) — тот же промпт повторно
отправляется через `@anthropic-ai/sdk` с переопределённым `baseURL`
(константа `ANTHROPIC_BASE_URL`) — сейчас `https://api.ai-keys-shop.com`,
сторонний Anthropic-совместимый провайдер, **временное решение на этапе
тестирования**. Ключ — `ANTHROPIC_API_KEY`. Отсутствие документа/ошибка
чтения флага = `false` (fail closed). `llmConfig`/`llmQuota` живут в
отдельной root-коллекции `b1_service` (не под `b1_exam_content/{langId}`) —
это не языковой контент, а серверная конфигурация, общая для всех пяти
языков, ей не нужен языковой документ-якорь.

**Квота** (`enforceQuota` в `functions/index.js`): суточный лимит вызовов
`analyzeSpeech`+`continueDialogue` на пользователя (общий по всем языкам,
не отдельно на каждый — `DAILY_LLM_QUOTA`, плейсхолдер, подобрать по
реальному использованию), хранится в `b1_service/llmQuota/{userId}` — под
Admin SDK-only путём, тем же, что и `llmConfig`, чтобы пользователь не мог
читать/сбрасывать свою квоту напрямую (см. `FIRESTORE.md`).

---

## 7. Экраны MVP

- `SplashScreen`
- `AuthorizationScreen` (вход, регистрация, восстановление пароля)
- `OnboardingScreen` — первичная настройка профиля (аватар, имя, фамилия) сразу после регистрации. Язык обучения не выбирается — всегда польский. Маршрут по флагу `onboardingComplete` из Firestore. Лежит в `features/auth/presentation/` (часть auth-потока, проходится один раз).
- `B1HomeScreen` — тайлы лексических тем (тайл первого уровня, Lesson Matrix §A), прогресс.
- `LexicalTopicLessonsScreen` — уроки одной лексической темы (пары с грамматическими темами).
- `LessonScreen` — флоу урока (6 шагов). См. раздел 6.1.
- `DialogueScreen` — шаг диалога, отдельный маршрут. См. раздел 6.3.
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
  - **Язык интерфейса** — выбирается пользователем в `SettingsScreen` (секция "Interface language", `_LanguageTile`). Хранится в `public_user_info/{userId}.preference.uiLanguage`. Управляется через `AppLocaleNotifier` (`core/locale/`) и `SettingsNotifier.setUiLanguage`. `MaterialApp.locale` берёт значение из этого провайдера. Языки интерфейса — EN/RU/FR/ES, независимый список от языков обучения ниже.
  - **Язык обучения** — см. §12.1.
- Все строки интерфейса — только через ARB. Хардкод строк запрещён.

---

## 12.1 Язык обучения (StudyLanguage)

Изначально был фиксирован на польском — снято по явному запросу пользователя
(параллель с linguobyte/cinephile: если человек учит французский в одном
приложении, `b1-exam-prep` должен сразу предлагать французский, не
спрашивать заново).

- **Общее поле аккаунта**: `public_user_info/{userId}.preference.selectedLanguage`
  — **то же поле, что уже пишет linguobyte** для своего списка языков обучения
  (en/es/fr/ru, см. `FIRESTORE.md` §2). Осознанное решение: НЕ заводить
  отдельное поле для b1-exam-prep, а разделять текущий язык обучения между
  всеми приложениями на одном аккаунте — так переключение языка в одном
  приложении сразу видно в других. Компромисс: b1-exam-prep не может
  проверить, что linguobyte/cinephile (отдельные кодовые базы) одинаково
  аккуратно обрабатывают значение языка вне их собственного набора — со
  стороны b1-exam-prep обработано защитно (см. ниже), поведение остальных
  приложений не проверялось в рамках этой кодовой базы.
- **Поддерживаемый набор b1-exam-prep — `StudyLanguage`** (domain, closed
  enum): `pl | fr | es | en | de`. Если `preference.selectedLanguage`
  содержит код вне этого набора (например `ru`, который поддерживает
  linguobyte, но не b1-exam-prep) — приложение не падает, показывает то же
  пустое состояние "content coming soon", что и для лексической темы без
  уроков (см. `B1HomeScreen`, `FIRESTORE.md` §4).
- **Чтение**: `StudyLanguageNotifier` (`core/locale/` или `profile/`, см.
  реализацию) читает `preference.selectedLanguage` из `profileProvider`,
  маппит в `StudyLanguage?` (`null` — язык не выбран ИЛИ вне поддерживаемого
  набора).
- **Онбординг**: раньше безусловно писал `'pl'` в `selectedLanguage` при
  каждой регистрации (`kB1SelectedLanguage`, `OnboardingNotifier`) — теперь
  пишет язык по умолчанию, ТОЛЬКО если поле у аккаунта ещё вообще не
  установлено (первое приложение на аккаунте). Если поле уже установлено
  (пользователь пришёл из linguobyte/cinephile с уже выбранным языком) —
  онбординг его не трогает, уважает существующий выбор.
- **Переключение**: `SettingsScreen`, новая секция "Study language" (по
  аналогии с "Interface language" — свой `_LanguageTile`-подобный пикер),
  `SettingsNotifier.setStudyLanguage` (тот же паттерн, что `setUiLanguage`)
  пишет `preference.selectedLanguage` в Firestore. Меняет язык и для
  linguobyte/cinephile на том же аккаунте — ожидаемое поведение, не баг.
- **STT-локаль** — раньше жёстко `pl-PL` в `FreePracticeView`/`DialogueScreen`,
  теперь выводится из `StudyLanguage` (`pl→pl-PL`, `fr→fr-FR`, `es→es-ES`,
  `en→en-US`, `de→de-DE`) и передаётся параметром в оба виджета.
- **Прогресс, контент, упражнения, Cloud Functions** — все ключуются/фильтруются
  по `langId` (`StudyLanguage.name`), подробности в `FIRESTORE.md` §4 и §6.3.

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

> `features/home` и `features/lesson` (уроки, теория/лексика/глаголы, `HomeScreen`) удалены целиком — это была логика linguobyte, к B1 не относится. Общий движок упражнений (`ExerciseModel`, `ExerciseResult`, `ExerciseWidget`, `ExercisePhaseWidget`, 8 виджетов типов) перенесён в `features/b1_exam`, форма не менялась ни разу, включая переход на Lesson Matrix. Технический долг из старых фаз 3–4, привязанный к удалённому коду, снят вместе с ним.

> **Lesson Matrix — старая sections/topics-схема retired.** `ExamSectionModel`/`ExamTopicModel`/`ExamSectionType`, `PracticeScreen`/`TopicDetailScreen`/`ImagePracticeScreen`, `PrepStep`/`PrepLevelCard`/`SectionCard`/`TopicTile`, `ExamContentRepository`, `FreePracticeAnalysisModel`/`MisusedWordModel`/`FreePracticeResultModel`, `analyzeFreePractice` — удалены целиком, заменены на `LessonModel`/`LexicalTopicModel`/`GrammarTopicModel`, `LessonScreen`/`LexicalTopicLessonsScreen`/`DialogueScreen`, `LessonContentRepository`, `SpeechAnalysisModel`, `analyzeSpeech`/`continueDialogue` (см. §6.1–§6.3). Ниже — техдолг уже под новой схемой; пункты, привязанные к удалённому коду (старый `requiredPrepLevels`-костыль достижений), сняты вместе с ним.

- **Рубрика оценки устного шага — плейсхолдер**: `AppConstants.speechScore*` (25/35/25/15, target-grammar ошибки весят вдвое) — явно не финальные критерии B1-экзамена, подобраны без реальной калибровки. Вынесено в именованные константы намеренно, чтобы пересмотр был конфигом. Пересмотреть, когда появится обратная связь от реальных прохождений.
- **Суточная квота LLM — плейсхолдер**: `DAILY_LLM_QUOTA` в `functions/index.js` (сейчас 100 вызовов `analyzeSpeech`+`continueDialogue` в сутки на пользователя) не откалибрована по реальной нагрузке/стоимости. Подобрать после запуска.
- **Диалог — только текст, без голоса ИИ**: осознанное решение первой версии (см. §6.3, "Голос ответа ИИ") — латентность хода (STT → callable → LLM → TTS → воспроизведение) реалистично 2-5с, добавление TTS до измерения реальных времён ходов не оправдано. Следующая итерация — `flutter_tts` (on-device) с фолбэком на текст при отсутствии голоса выбранного `StudyLanguage` на устройстве (актуально для всех пяти языков, не только польского).
- **`Vocabulary Master` — продуктовое решение при рефакторинге, не проверено на реальных пользователях**: переопределено с "все vocabulary-упражнения темы верно" (нет эквивалента в новой схеме блоков) на "весь урок (verb+noun+phrase) пройден, все с первой попытки" — см. `check_b1_achievement_use_case.dart`. Пересмотреть при реальной обратной связи.
- **Переигровка блока упражнений — побочки stats/достижений**: как и в linguobyte, повторное прохождение уже пройденного блока инкрементит `stats` и достижения заново (`FieldValue.increment`, `master_conjugator`/`vocabulary_master` накручиваются). Решение то же, что и для linguobyte — не реализовано, требует продуктового решения.
- **[TD-1] Skip-кнопка для тестеров** (`exercise_widget.dart`): видна в debug всегда, в release/profile — по флагу сборки `--dart-define=SHOW_SKIP_BUTTON=true` (`AppConstants.showSkipButton`). Обычный прод-билд (App Store, без флага) кнопку не содержит. TestFlight/ad-hoc билды для тестеров собирать с флагом.
- **[TD-3] Пустой `form` в fill_blank**: показать заглушку вместо поля ввода без контекста.
- **Нет тестов для usecase-слоя Lesson Matrix**: `CheckB1AchievementUseCase`/`CompleteB1StepUseCase` (рекеены на `lessonId`/`block`) и новые `SubmitOralStepUseCase`/`SubmitDialogueUseCase`/`calculateSpeechScore` не покрыты тестами — не запрошено явно (см. CLAUDE.md «Открытые пункты»).
- **`b1_service/**` — новая root-коллекция, правило в Console не добавлено этой кодовой базой**: в отличие от `b1_exam_content/**` (наследует статус бывшего `b1_polish/**`, тоже не подтверждено), `b1_service` — это НОВАЯ отдельная root-коллекция (`llmConfig`, `llmQuota/{userId}`), никакое существующее правило её не покрывает автоматически. Нужно явно добавить `match /b1_service/{document=**} { allow read, write: if isAllowed(); }` (admin) без клиентского доступа вообще — см. `FIRESTORE.md` §Security Rules.
- **`preference.selectedLanguage` — общее поле с linguobyte/cinephile, не проверено с их стороны**: b1-exam-prep теперь читает/пишет то же Firestore-поле, что и эти два приложения (см. §12.1) — со стороны b1-exam-prep обработка значений вне своего набора (`StudyLanguage`) защитная (пустое состояние, не краш), но нет доступа к их кодовым базам, чтобы подтвердить, что они так же аккуратно обрабатывают языки, которые поддерживает b1-exam-prep, но не поддерживают они (`pl`/`de`). Стоит проверить отдельно.

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

