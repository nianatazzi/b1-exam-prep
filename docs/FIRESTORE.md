# FIRESTORE.md

> Структура Firestore общего Firebase-проекта (`linguobyte`, см. `.firebaserc`).
> Этот репозиторий (b1-exam-prep) читает и пишет только часть коллекций — см.
> таблицу ниже. Коллекции, которые использует только linguobyte, описаны как
> справка: их актуальность этой кодовой базой не проверяется.
>
> Сверено с кодом: `lib/core/constants/firestore_paths.dart`, репозитории
> `features/*/data/`, `functions/index.js` — 2026-09-30.

## Firestore Structure

### Корневые коллекции

| Коллекция | Кто использует | Доступ клиента b1-exam-prep | Раздел |
|---|---|---|---|
| `b1_exam_content` | b1-exam-prep: клиент + Cloud Functions | read | §4 |
| `exercises` | общая: b1-exam-prep (`course_id: b1_*`) и linguobyte (`basic_*`) | read | §1, §4 |
| `private_user_info` | общая (контакты, подписка, стрик); b1-exam-prep пишет подколлекцию `b1_progress` | read + write (свой `userId`) | §2, §4 |
| `public_user_info` | общая (публичный профиль, `preference`) | read + write (свой `userId`) | §3 |
| `b1_service` | только Cloud Functions b1-exam-prep (Admin SDK) | нет | §4 |
| `llmQuota` | только Cloud Functions b1-exam-prep (Admin SDK) | нет | §4 |
| `basic` | только linguobyte | не используется | §1 |

**Обозначения:**
- `name/` — коллекция или документ-контейнер
- `{name}/` — документ с динамическим id
- `field: type` — поле документа
- `# comment` — пояснение

---

## 1. Учебный контент linguobyte (справка)

> b1-exam-prep эти коллекции не читает: `features/home`/`features/lesson`
> (логика linguobyte) удалены из репозитория. Исключение — **структура
> `type_data`** ниже: те же 8 виджетов упражнений живут в
> `features/b1_exam/presentation/widgets/exercises/` и читают B1-упражнения
> из общей коллекции `exercises` (см. §4 «B1 упражнения»).

```
basic/                                  # коллекция
  {langId}/                             # документ: en | es | fr | ru
    flag: string
    name: string

    lessons/                            # подколлекция
      {lessonId}/                       # документ
        l_id: number                    # порядковый номер
        theme: string

        theory/                         # подколлекция
          {theoryId}/                   # документ
            th_id: number               # порядковый номер
            lesson_id: number           # указатель на урок
            topic: string
            title: string
            text: string
            video: string | null        # ссылка на видео
            duration: number            # минуты
            reward: number              # очки за прохождение
            createdAt: timestamp
            updatedAt: timestamp

        additional/                     # подколлекция
          {additionalId}/               # документ
            type: string                # "vocabulary" | "tip"
            title: string
            content: string
            createdAt: timestamp
            updatedAt: timestamp

        lexical_set/                    # подколлекция "лексический запас, тематические слова"
          {vocabularySetID}/            # документ
            title: string
            translation: string
            transcription: string
            createdAt: timestamp
            updatedAt: timestamp
            duration: number
            voc_id: number              # порядковый номер
            lesson_id: number           # указатель на урок
            reward: number
            set_title: string           # название всей темы

        verbs/                          # подколлекция "матрица глаголов", спряжение
          {verbID}/                     # документ
            v_id: number                # порядковый номер
            lesson_id: number           # указатель на урок
            title: string
            type: string
            conjugation: map
            translation: map            # {en: string, ru: string, es: string, ...} — перевод на язык интерфейса
            transcription: map          # {en: string, ru: string, es: string, ...} — транскрипция для носителей разных языков

    theory_chunks/                      # подколлекция
      {theoryChunkId}/                  # документ (повторное использование теории)
        topic: string
        text: string
        usedInLesson: string            # id урока, где используется

    service/                            # подколлекция
      {basic_vocabulary}/               # документ
        words: array

      {AIPreference}/                   # документ (будущая фича, заглушка)
        model: string
        prompt: string

      {botSettings}/                    # документ (будущая фича, заглушка)
        enabled: boolean
        greeting: string


exercises/                              # коллекция (общая с b1-exam-prep, см. §4)
  {exerciseId}/                         # документ (одно упражнение)
    type: string                        # "wordcard" | "flashcard" | "multiple_choice" | "fill_blank" | "mosaic" | "translate_sentence" | "listen_pick" | "voice_translate"
    target_language: string
    course_id: string                   # указатель на курс (например: basic_fr)
    lesson_id: number                   # linguobyte: числовой l_id урока (у B1 — строка, см. §4)
    linked_item_id: number              # id подраздела урока (theory или verbs | lexical_set не имеет)
    segment_type: string                # linguobyte: "theory" | "vocab" | "verb" (у B1 вместо него block, см. §4)
    permission: string                  # платный или бесплатный контент
    difficulty: number
    grammar_types: array                # навыки для stats: grammar | vocabulary | listening | speaking (см. §4)
    image_url: string | null
    audio_url: string | null
    createdAt: timestamp
    updatedAt: timestamp
    type_data: map                      # данные, специфичные для типа упражнения (структура ниже)
    ex_id: number                       # порядковый номер
```

### Структура `type_data` по типам упражнений

Ключи ниже — ровно те, что читают виджеты
`features/b1_exam/presentation/widgets/exercises/*`. Поля
`map<langCode, string>` выбираются по языку интерфейса с фолбэком на `en`
(у `voice_translate` — `ui → ru → en`).

```
# wordcard — карточка слова (только просмотр, результат не пишется в stats)
type_data:
  base_word: string                  # слово на изучаемом языке ("Bonjour")
  pronunciation: string              # транскрипция ("bɔ̃ʒuʁ")
  part_of_speech: string             # часть речи (не отображается в UI)
  article: map<langCode, string>     # описательный текст о слове (показывается под картинкой)
  translations: map<langCode, string> # переводы в виде строки: '"Вариант 1", "Вариант 2"'

# flashcard — флэш-карточка с флипом
type_data:
  base_word: string                  # слово на изучаемом языке (обратная сторона)
  translations: map<langCode, string> # переводы — подсказка (лицевая сторона)
  context_sentence: map<langCode, string>  # пример использования (обратная сторона)
  part_of_speech: string

# fill_blank — вписать слово в пропуск
type_data:
  title: map<langCode, string>       # инструкция
  prompts: map<langCode, string>     # перевод-подсказка
  form: string                       # предложение с пропуском: "The dog [] quickly"
                                     # пустой form — заглушки нет, показывается поле без контекста (TD-3)
  blanks: array
    - accepted: array<string>        # допустимые варианты ответа

# translate_sentence — перевести предложение текстом
type_data:
  title: map<langCode, string>       # инструкция
  question: string                   # исходное предложение (на изучаемом языке)
  correct_answer: map<langCode, string>  # правильный перевод
  correct_pattern: map<langCode, string> # regex для проверки (может отсутствовать)

# mosaic — собрать предложение из чипов
type_data:
  title: map<langCode, string>       # инструкция
  prompts: map<langCode, string>     # перевод-подсказка
  answer: string                     # правильное предложение (слова через пробел — из него строятся чипы)
  distractor_chunks: array<string>   # слова-обманки, показываются вперемешку с правильными в банке слов

# multiple_choice — заполнить пропуски словами из банка
type_data:
  title: map<langCode, string>       # инструкция
  prompts: map<langCode, string>     # перевод-подсказка
  form: string                       # предложение с пропусками: "She [] to [] school"
  blanks: array
    - variants: array<string>        # варианты для этого пропуска (один правильный, остальные — дистракторы)
      answer_index: number           # индекс правильного варианта в variants (по умолчанию 0)

# listen_pick — выбрать вариант после прослушивания (аудио — exercises.audio_url)
type_data:
  title: map<langCode, string>       # инструкция
  variants: array<string>            # варианты ответа (перемешиваются на клиенте)
  answer_index: number               # индекс правильного варианта (по умолчанию 0)
  transcript: string                 # текст аудио (показывается после проверки)

# voice_translate — произнести перевод голосом
type_data:
  title: map<langCode, string>       # инструкция
  prompts: map<langCode, string>     # фраза для перевода (на языке пользователя)
  correct_answer: string             # правильный ответ (на изучаемом языке)
  correct_pattern: string | null     # regex для проверки STT-результата
  accepted_answers: array<string> | null  # дополнительные допустимые варианты
  stt_language_code: string          # язык для STT ("pl-PL", "fr-FR"…); если нет — "en-US",
                                     # НЕ выводится из StudyLanguage
```

> ⚠️ **`answer_index`, не `correct_index`.** Прежние версии этого файла
> описывали `multiple_choice`/`listen_pick` с ключом `correct_index`, код
> всегда читал `answer_index`. Если контент/админ-панель пишет
> `correct_index` — клиент молча считает правильным вариант с индексом 0.
> Сверить с реальными документами (см. `ARCHITECTURE.md` §20).

---

## 2. Приватные данные пользователя

```
private_user_info/                      # коллекция (общая для всех приложений)
  {userId}/                             # документ
    deviceId: string                    # b1-exam-prep пишет '' при регистрации
    email: string
    phone: string                       # b1-exam-prep пишет '' при регистрации
    subscription: map                   # данные подписки
      plan: string                      # "free" | "premium" (неизвестное значение читается как free)
      expiresAt: timestamp | null       # null для free
    lastActiveDate: timestamp           # дата последней активности (для стрика), полночь ЛОКАЛЬНОГО дня клиента
    currentStreak: number               # текущий стрик (дни подряд)
    bestStreak: number                  # рекорд стрика
                                        # стрик-поля появляются при первом завершённом блоке упражнений
                                        # (UserRepository.updateStreak, set merge:true)

    b1_progress/                        # подколлекция — прогресс b1-exam-prep, см. §4
      {langId}/

    friends/                            # подколлекция (linguobyte, справка)
      {friendId}/                       # документ
        userId: string
        addedAt: timestamp

    languages/                          # подколлекция — прогресс linguobyte (справка, b1-exam-prep не читает)
      {langId}/                         # документ: en | es | fr
        lastLesson: string              # id документа последнего урока (например "lesson_01")
        lastParagraph: number           # индекс последней завершённой пары "контент+упражнения" в последовательности шагов урока

        stats: map                      # агрегированная статистика по навыкам (для radar-диаграммы)
          grammar: map
            correct: number
            total: number
          vocabulary: map
            correct: number
            total: number
          listening: map
            correct: number
            total: number
          speaking: map
            correct: number
            total: number

        stepResults: map                # результаты по субпартам уроков
          "{lessonLId}_{segmentType}_{linkedItemId}": map   # например "1_theory_1"
            correct: number
            total: number
            firstAttempt: boolean
            completedAt: timestamp
            incorrectExerciseIds: array<string>

        achievements: map               # достижения пользователя по языку
          # Ключ map = тип достижения. Внутри обязательно дублируется поле type
          # (= ключ): AchievementModel.fromJson десериализует enum через type,
          # иначе $enumDecode падает на null и роняет загрузку всего прогресса.
          master_conjugator: {type, level, updatedAt}   # level: 0 = не получено, I=1, II=2...
          first_step: {type, level, updatedAt}
          focused_learner: {type, level, updatedAt}
          interested_learner: {type, level, updatedAt}
          vocabulary_master: {type, level, updatedAt}

        user_vocabulary/                # подколлекция
          {wordId}/                     # документ
            word: string
            translation: string
            learnedAt: timestamp

        personalized_courses/           # подколлекция (заглушка для будущих курсов)
          {courseId}/                   # документ
            title: string
            lessons: array              # список id уроков
            createdAt: timestamp
```

---

## 3. Публичный профиль пользователя

```
public_user_info/                       # коллекция (общая для всех приложений)
  {userId}/                             # документ
    name: string                        # '' при регистрации, заполняется на онбординге
    surname: string
    avatar: string | null               # id пресета ("avatar_01") ИЛИ url (Firebase Storage, будущее); null при регистрации
    points: number                      # всегда 0 — начисление XP не реализовано
    onboardingComplete: boolean         # пройден ли онбординг (имя/фамилия/аватар). Роутер ведёт на /onboarding пока false
                                        # legacy-документы без поля: онбординг считается пройденным при непустом name
    preference: map                     # {} при регистрации; все поля опциональны, пишутся dot-notation update()
      uiLanguage: string                # язык интерфейса: en | ru | fr | es
      selectedLanguage: string          # язык обучения, ОБЩИЙ для всех приложений аккаунта:
                                        #   linguobyte пишет en | es | fr | ru,
                                        #   b1-exam-prep пишет pl | fr | es | en | de (StudyLanguage).
                                        #   Значение вне набора StudyLanguage b1-exam-prep читает как «не выбран»
      theme: string                     # "dark" | "light" — сохраняется, но пока ни на что не влияет (ARCHITECTURE.md §13)
      speechSpeed: number               # 0.5–2.0, default 1.0 — сохраняется, но пока ни на что не влияет
```

Документы `public_user_info`/`private_user_info` создаёт клиент при
регистрации (`AuthRepository._createUserDocuments`, одним batch) — техдолг,
см. `ARCHITECTURE.md` §20. Если документ `public_user_info` отсутствует при
записи, `UserRepository._updateOrCreate` создаёт его с теми же дефолтами.

---

## Security Rules

**Версия:** `rules_version = '2'` — единственная актуальная версия. Версии 3 не существует.

> ⚠️ Файлов `firestore.rules`/`firestore.indexes.json` в репозитории нет
> (`firebase.json` деплоит только `functions`). Правила и индексы живут
> только в Firebase Console — матрица ниже описывает **требуемое** состояние;
> фактическое этой кодовой базой не проверяется.

### Матрица доступа

| Коллекция | Администратор | Авторизованный пользователь |
|---|---|---|
| `basic/**` | read + write | read |
| `exercises/**` | read + write | read |
| `private_user_info/{userId}/**` (включая `b1_progress/{langId}`) | read + write | read + write (только свой `userId`) |
| `public_user_info/{userId}` | read + write | read (все) / write (только свой `userId`) |
| `b1_exam_content/**` | read + write | read |
| `b1_service/**` | read + write | нет доступа — читает только Cloud Function через Admin SDK (обходит правила) |
| `llmQuota/{userId}` | read + write | **нет доступа** — иначе пользователь сбросит свою суточную квоту LLM; пишет только Cloud Function |

> **Две новые root-коллекции без правил по умолчанию:** `b1_service`
> (была подколлекцией `b1_polish/pl/service/**`) и `llmQuota` (была
> невалидным путём `b1_service/llmQuota/{userId}`, см. §4). Никакое
> существующее правило их автоматически не покрывает — нужно явно завести
> обе записи, admin-only, без исключений для клиента. `b1_exam_content/**`
> наследует статус бывшего `b1_polish/**` — тоже не подтверждено.

### Индексы

| Коллекция | Поля | Кто запрашивает |
|---|---|---|
| `exercises` | `course_id` ASC, `lesson_id` ASC, `ex_id` ASC (композитный) | `ExamExerciseRepository.getExercisesForLesson` — без индекса запрос падает с `failed-precondition` |

Остальные запросы (`orderBy` по одному полю внутри подколлекции) покрываются
автоматическими индексами.

### Правило доработки

> При добавлении новой коллекции или подколлекции в этот файл — **сразу** добавить для неё правило в Firestore Console. Не оставлять на потом.

Новое правило добавляется по шаблону:
- Контент (читают все пользователи): `allow read: if request.auth != null;`
- Данные пользователя (только свои): `allow read, write: if request.auth != null && request.auth.uid == userId;`
- Серверные данные (только Cloud Functions): клиентских `allow` нет вообще
- Плюс всегда: `allow read, write: if isAllowed();` для администраторов

---

## 4. B1 Exam Prep — Lesson Matrix + StudyLanguage

Урок = пара «лексическая тема × грамматическая тема» (`ARCHITECTURE.md` §6.1),
внутри ОДНОГО языка обучения (`ARCHITECTURE.md` §12.1). Контент изначально
был только польским (`b1_polish`) — переименовано в `b1_exam_content` и
разложено по `{langId}` (pl/fr/es/en/de), тем же способом, что linguobyte
раскладывает `basic/{langId}`. Старая схема `sections/{sectionId}/topics/{topicId}`
выведена из употребления — image_description/monologue/dialogue это три
устных шага ОДНОГО урока, не параллельные разделы.

Все пути — `FirestorePaths` (`b1LexicalTopics`, `b1LexicalVocabulary`,
`b1GrammarTopics`, `b1GrammarTopicRules`, `b1Lessons`, `b1Lesson`,
`b1Progress`, `b1CourseId`). Cloud Functions собирают те же пути строками в
`functions/index.js` (`B1_CONTENT_ROOT`, `LLM_CONFIG_PATH`,
`LLM_QUOTA_COLLECTION`) — при переименовании менять в обоих местах.

```
b1_exam_content/                          # корневая коллекция (была b1_polish)
  {langId}/                                # документ-якорь: pl | fr | es | en | de (полей не требует)
    lexical_topics/                        # подколлекция: лексические темы (в контексте языка langId)
      {lexicalTopicId}/
        lt_id: number                      # порядковый номер (orderBy на клиенте)
        title: string
        description: string                # опционально, по умолчанию ''

        vocabulary/                        # подколлекция: слова по теме
          {vocId}/
            voc_id: number                  # порядковый номер
            word: string                    # слово на изучаемом языке (langId);
                                            # analyzeSpeech сверяет lexicalErrors с этим полем (без учёта регистра)
            translation: map<langCode, string>  # перевод на язык ИНТЕРФЕЙСА (не путать с langId)
            transcription: string
            gender: string | null           # "m" | "f" | "n" — применимо не ко всем языкам, null где неприменимо
            example_sentence: map<langCode, string>
            audio_url: string | null

    grammar_topics/                        # подколлекция: грамматические темы (в контексте языка langId)
      {grammarTopicId}/
        gt_id: number                      # порядковый номер (orderBy на клиенте)
        title: string                      # подставляется в промпт analyzeSpeech как «целевая грамматика урока»
        description: string                # опционально

        rules/                             # подколлекция: правила
          {ruleId}/
            g_id: number                    # порядковый номер; на него ссылается exercises.linked_item_id
            title: string                   # заголовки правил тоже уходят в промпт analyzeSpeech
            rule_type: string               # "declension" | "conjugation" | "case_usage" | "mood" | "degree"
            paradigm: map                   # таблица парадигмы (гибкая структура)
            explanation: map<langCode, string>
            examples: array<map>            # [{pl: "...", en: "...", ru: "..."}, ...] — примеры на langId + перевод интерфейса

    lessons/                               # подколлекция: уроки — пара лексической + грамматической темы
      {lessonId}/                          # без порядкового поля — список уроков приходит в порядке id документов
        lexical_topic_id: string            # id документа lexical_topics (в этом же langId), обязательно
        grammar_topic_id: string            # id документа grammar_topics (в этом же langId), обязательно
        duration_seconds: number | null     # таймер ОБОИХ шагов image/monologue; null = AppConstants.oralStepDurationSeconds (180с)

        image_task: map                     # задание шага "описание картинки", обязательно
          image_url: string
          points_to_describe: array<map<langCode, string>>  # в клиент НЕ мапится (не показывается студенту),
                                                            # читает только analyzeSpeech для talkingPointsCovered

        monologue_task: map                 # задание шага "монолог" (FreePracticeTaskModel), обязательно
          prompt: map<langCode, string>     # текст задания, показывается студенту
          points: array<map<langCode, string>> # в клиент НЕ мапится, читает только analyzeSpeech
          duration_seconds: number | null   # мапится в модель, но клиентом НЕ используется
          think_seconds: number | null      #   (таймер берётся из lessons.duration_seconds) — зарезервировано

        dialogue_task: map                  # сценарий шага "диалог", обязательно
          situation: map<langCode, string>  # → системный промпт continueDialogue; студенту не показывается
          user_role: map<langCode, string>  # мапится в модель, но нигде не используется (ни в UI, ни в промпте)
          ai_role: map<langCode, string>    # → системный промпт continueDialogue
          goal: map<langCode, string>       # → системный промпт continueDialogue
          opening_line: string              # первая реплика ИИ, на языке langId; показывается в чате первым сообщением
          max_turns: number                 # потолок реплик студента, дефолт 10; проверяется и на сервере
          points: array<map<langCode, string>> # пункты, которые студент должен раскрыть в разговоре —
                                             # той же формы, что monologue_task.points; в клиент НЕ мапится,
                                             # читает только analyzeSpeech (oralStep=dialogue)

b1_service/                                # root-коллекция, Admin SDK-only (была подколлекцией b1_polish/pl/service/**)
  llmConfig/                               # документ
    fallbackEnabled: boolean               # вкл/выкл fallback-провайдера (Anthropic-совместимый) в analyzeSpeech/continueDialogue.
                                            # Переключается вручную через Firebase Console, читается на каждый fallback.
                                            # Отсутствие документа/ошибка чтения = false (fail closed)

llmQuota/                                  # ОТДЕЛЬНАЯ root-коллекция (НЕ подколлекция b1_service) — квота вызовов
                                            # LLM на пользователя, общая по всем языкам. b1_service/llmQuota/{userId}
                                            # был невалидным путём документа (3 сегмента) — enforceQuota падал
                                            # синхронно на каждом вызове, анализ речи молча не работал (исправлено в a32d137)
  {userId}/                                # документ, пишется/читается только Cloud Functions (Admin SDK), в транзакции
    date: string                           # "YYYY-MM-DD" (UTC) — квота суточная, сбрасывается в полночь UTC
    count: number                          # сколько вызовов analyzeSpeech + continueDialogue уже сделано за date
                                            # (лимит DAILY_LLM_QUOTA = 100, плейсхолдер)
```

> `FirestorePaths.b1LlmConfig`/`b1LlmQuota` в клиенте — мёртвые константы
> (клиент эти документы не читает), причём `b1LlmQuota` до сих пор
> указывает на старый невалидный путь `b1_service/llmQuota/{userId}`.
> Источник истины для серверных путей — `functions/index.js`.

**Обязательность полей урока.** `LessonModel.fromJson` требует
`lexical_topic_id`, `grammar_topic_id`, `image_task`, `monologue_task`,
`dialogue_task` — документ урока без любого из них роняет загрузку **всего
списка уроков** языка (`getLessons` не пропускает битые документы, в отличие
от упражнений). Если `lexical_topic_id`/`grammar_topic_id` указывают на
несуществующий документ — падает экран темы/урока (`firstWhere`).

**Launch-контент** (§F плана редизайна) — четыре польских урока, а не полная
матрица ни для одного языка: Restaurant×Dative, Restaurant×Conditional,
Hotel×Dative, School×Superlative, все под `b1_exam_content/pl/...`.
Остальные языки (fr/es/en/de) уроков не имеют — `B1HomeScreen` показывает
пустое состояние. Лексические темы без уроков (например Doctor) остаются в
списке и открывают пустой экран темы. Контент авторится вручную в отдельной
админ-панели (`ARCHITECTURE.md` §1). `scripts/seed/` этот контент **не**
создаёт — скрипт написан под старую схему `b1_polish/pl/sections/...` и
устарел (см. `ARCHITECTURE.md` §20).

### B1 упражнения

Используется общая коллекция `exercises/` с фильтрацией по `course_id`.
`lesson_id`, `block` и `course_id` (был жёстко `"b1_pl"`) — сознательные
breaking changes схемы (безопасно: на момент смены не было реальных
пользователей).

```
exercises/
  {exerciseId}/
    course_id: string                   # "b1_{langId}" — "b1_pl" | "b1_fr" | "b1_es" | "b1_en" | "b1_de"
    lesson_id: string                   # id документа lessons/{lessonId} (не число, в отличие от linguobyte)
    ex_id: number                       # порядок внутри урока (orderBy); он же уходит в incorrectExerciseIds
    block: string                       # "verb" | "noun" | "phrase" — обязательно (заменил segment_type)
    linked_item_id: number | null       # GrammarRuleModel.g_id для verb/noun; для phrase обычно null
                                        # (допустимо TopicVocabularyModel.voc_id). Клиент поле читает, но не использует
    type: string                        # один из 8 типов §1; неизвестный тип — заглушка с авто-разблокировкой «Далее»
    type_data: map                      # структура по типу — см. §1
    grammar_types: array<string>        # навыки для stats: grammar | vocabulary | listening | speaking
                                        # (без учёта регистра); прочие значения игнорируются
    audio_url: string | null
    image_url: string | null
```

Документ, который не парсится в `ExerciseModel` (нет `ex_id`/`type`/`block`
или `block` вне списка), пропускается с warning-логом — урок не падает, но
упражнение молча исчезает.

Каждый блок урока показывает не более `AppConstants.lessonBlockExerciseCap`
(10) упражнений — капается на клиенте при загрузке (`LessonNotifier`), не в
самом запросе: все упражнения урока грузятся одним
`where(course_id==..., lesson_id==...).orderBy(ex_id)` (нужен композитный
индекс, см. «Индексы») и группируются/капаются в памяти.

### B1 прогресс пользователя

```
private_user_info/
  {userId}/
    b1_progress/                        # подколлекция
      {langId}/                         # документ: pl | fr | es | en | de — прогресс изолирован по языку,
                                          # тот же паттерн, что languages/{langId} у linguobyte.
                                          # Создаётся при первой записи (_updateOrInit: update → not-found → set
                                          # с пустыми topicResults/stats/achievements/lessonResults → update)
        topicResults: map               # результаты трёх капов упражнений урока
          "{lessonId}_{block}": map     # block: verb | noun | phrase; перезаписывается при повторе
            correct: number
            total: number               # число упражнений с ответом (wordcard и пропущенные через Skip не считаются)
            firstAttempt: boolean       # true, если ни одной ошибки в блоке
            completedAt: timestamp      # serverTimestamp
            incorrectExerciseIds: array<string>  # СТРОКОВЫЕ ex_id (не id документов) упражнений с ошибками
        stats: map                      # та же форма, что и languages/{langId}.stats в linguobyte —
          grammar: {correct, total}     # общий ProfileScreen отображает оба приложения одинаково.
          vocabulary: {correct, total}  # FieldValue.increment по exercises.grammar_types каждого отвеченного
          listening: {correct, total}   # упражнения; повтор блока инкрементит заново.
          speaking: {correct, total}    # Устные шаги (image/monologue/dialogue) в stats НЕ попадают
        achievements: map               # та же форма, что и languages/{langId}.achievements
          # Ключ map = тип достижения, дублируется в поле type (см. §2, то же требование)
          master_conjugator: {type, level, updatedAt}
          first_step: {type, level, updatedAt}
          focused_learner: {type, level, updatedAt}
          interested_learner: {type, level, updatedAt}   # не начисляется (пост-MVP)
          vocabulary_master: {type, level, updatedAt}
        lessonResults: map               # три устных шага урока — только последняя попытка каждого
          "{lessonId}_{oralStep}": map   # oralStep: image | monologue | dialogue
            transcript: string | null    # заполнено для image/monologue; null для dialogue (см. turns)
            turns: array<map>            # dialogue: [{role: "user"|"ai", text: string}, ...] (включая opening_line ИИ);
                                         # [] для image/monologue
            durationSeconds: number      # image/monologue — длительность таймера задания (не фактическое время);
                                         # dialogue — фактическое время на экране диалога
            completedAt: timestamp       # serverTimestamp
            score: number | null         # 0-100, рубрика AppConstants.speechScore* (плейсхолдер); null если анализ упал
            analysis: map | null         # результат analyzeSpeech, null если анализ не запускался/упал
              lemmas: array              # [{surfaceForm, lemma, partOfSpeech}, ...] — лемматизация внутри того же LLM-вызова
              targetGrammarErrors: array # [{word, userForm, correctForm, explanation}, ...] — ошибки в grammar_topic_id урока
              otherGrammarErrors: array  # та же форма — прочие грамматические ошибки
              lexicalErrors: array       # та же форма — серверная сверка (не решение LLM) со словарём lexical_topic_id урока
              talkingPointsCovered: array # [{point, covered: boolean}, ...] — по points_to_describe / points задания
              coherenceScore: number     # 0-15, холистическая оценка LLM
```

`topicResults`/`lessonResults` сейчас только **пишутся**: ни один экран их не
читает (`B1HomeScreen` грузит прогресс, но не отображает). Из всего документа
в UI попадают только `stats` и `achievements` (ProfileScreen).

`stats`/`achievements` заполняются `ExamProgressRepository` по тем же
правилам, что `UserProgressRepository` у linguobyte: `stats` — инкременты
по `ExerciseResult.grammarTypes` (не по `block`); `achievements` —
`CheckB1AchievementUseCase` после каждого завершённого блока упражнений.
«Урок пройден» = есть все три ключа `{lessonId}_verb|noun|phrase` в
`topicResults` (устные шаги не учитываются). Триггеры: Master Conjugator —
только что завершён блок `verb` И урок пройден (level +1); First Step — первый
пройденный урок (одноразово, level 1); Focused Learner — каждые 7 дней стрика;
Vocabulary Master — урок пройден и все три блока с `firstAttempt` (level +1).
Известные проблемы триггеров — `ARCHITECTURE.md` §20.

---

## Ключевые решения

| Решение | Причина |
|---|---|
| Контент (`basic`, `b1_exam_content`, `exercises`) отделён от данных пользователя | Контент обновляется независимо от прогресса пользователей |
| Приватные и публичные данные в разных коллекциях | Безопасность: публичный профиль читают все, приватный — только владелец |
| `theory_chunks` вынесены на уровень языка (linguobyte) | Блоки теории могут переиспользоваться в нескольких уроках и используются при слабых результатах в упражнениях |
| Прогресс linguobyte — `private_user_info/{userId}/languages/{langId}` | Один запрос — весь прогресс по языку |
| `exercises` — отдельная корневая коллекция | Привязка к курсу через `course_id` (`{courseType}_{langId}`: `basic_fr`, `b1_pl`), к уроку через `lesson_id` (linguobyte — числовой `l_id`, B1 — строковый id документа урока), к блоку через `segment_type` (linguobyte) / `block` (B1) + `linked_item_id`. Все упражнения урока загружаются одним запросом и группируются в памяти |
| Порядок: linguobyte lesson — `l_id`, theory — `th_id`, lexical_set — `voc_id`, verbs — `v_id`; B1 lexical_topics — `lt_id`, grammar_topics — `gt_id`, vocabulary — `voc_id`, rules — `g_id`; exercise — `ex_id` | У B1 `lessons` порядкового поля нет — уроки группируются по лексической теме в памяти |
| `subscription` — map с `plan` и `expiresAt` | Позволяет хранить тип подписки и дату истечения; легко расширяется (например, `autoRenew`) |
| `stats` map вместо отдельных `*_progress` полей | Один источник правды: сырые счётчики correct/total по 4 навыкам (grammar, vocabulary, listening, speaking). Проценты вычисляются на клиенте. Приходит вместе с документом прогресса за 0 дополнительных reads |
| `stepResults`/`topicResults` map в документе прогресса | Результаты субпартов в том же документе — 0 дополнительных reads |
| `achievements` map в документе прогресса | 5 типов достижений = 5 ключей. Map читается вместе с документом за 0 reads. Подколлекция потребовала бы +1 read |
| `incorrectExerciseIds` в результатах блока | Для будущего flow повторения. Firestore `whereIn` поддерживает до 30 значений за запрос. ⚠️ B1 сейчас пишет туда `ex_id`, а не id документа |
| Streak (`lastActiveDate`, `currentStreak`, `bestStreak`) в корне `private_user_info` | Стрик не привязан к языку и приложению — общий для пользователя |
| `personalized_courses` — заглушка | Зарезервировано для персональных курсов (например, подготовка к просмотру фильмов) |
| `AIPreference`, `botSettings` — заглушки в `basic/{langId}/service` | Будущие фичи linguobyte после MVP |
| `b1_exam_content` — отдельная корневая коллекция (была `b1_polish`) | B1 exam prep — отдельное приложение с собственной структурой контента (лексические темы × грамматические темы → уроки, Lesson Matrix), по пяти языкам обучения (`{langId}`) |
| B1 exercises в общей коллекции `exercises` | Переиспользование существующих типов упражнений; `course_id: "b1_{langId}"` отделяет от `basic_*` и от других языков b1 |
| `block` для B1 = капанное упражнение урока | "verb" / "noun" / "phrase" — заменяет старый `segment_type` (vocabulary/grammar/phrases), три капа по 10 упражнений на лексике урока |
| B1 прогресс в `b1_progress/{langId}` (раньше жёстко `pl`) | Изолирован от `languages/{langId}` linguobyte (разные приложения, разный прогресс), но сам разложен по языку тем же способом — переключение `StudyLanguage` (ARCHITECTURE.md §12.1) сразу показывает прогресс по нужному языку без миграции данных. `stats`/`achievements` намеренно повторяют форму linguobyte — общий `ProfileScreen` показывает то и другое одинаково |
| `b1_service` — отдельная root-коллекция (была подколлекцией `b1_polish/pl/service/**`) | `llmConfig` общий для всех пяти языков — не имеет смысла держать его под каким-то одним `{langId}`; требует отдельного Admin SDK-only правила в Console |
| `llmQuota/{userId}` — отдельная root-коллекция, Admin SDK-only, а не поле в `private_user_info/{userId}` и не `b1_service/llmQuota/{userId}` | `private_user_info/{userId}` даёт владельцу read+write — квоту там пользователь сбросил бы прямым Firestore-запросом. `b1_service/llmQuota/{userId}` — невалидный путь документа (нечётное число сегментов). Отдельная коллекция закрывается своим admin-only правилом |
| `b1_service/llmConfig.fallbackEnabled` вместо переменной окружения Cloud Function | Читается на лету (Admin SDK) без передеплоя функции — переключается вручную через Firebase Console |
| `preference.selectedLanguage` переиспользуется для StudyLanguage b1-exam-prep, не заводится отдельное поле | То же поле, что уже пишет linguobyte — консистентный UX между приложениями на одном аккаунте (ARCHITECTURE.md §12.1). Компромисс: b1-exam-prep не может проверить обработку этого поля со стороны linguobyte/cinephile |
| `lexical_topics`/`grammar_topics` — раздельные коллекции, не полная матрица | Урок — пара тем, авторится вручную в админ-панели; раздельные оси избегают заведения N×M документов, когда реально нужна лишь горстка пар (Lesson Matrix §F) |
| `lessonResults` вместо `freePractice`, ключ `{lessonId}_{oralStep}` | Единый паттерн для всех трёх устных шагов; `transcript`/`turns` — взаимоисключающие поля одной формы вместо двух параллельных документных форм |
| Пункты заданий (`points_to_describe`, `points`, `dialogue_task.points`) не мапятся в клиентские модели | Студенту не показываются (решение a32d137) — их читает только `analyzeSpeech` через Admin SDK для `talkingPointsCovered` |
| `basic`/`exercises` (`course_id: basic_*`)/`languages/{langId}` не используются кодом b1-exam-prep | `features/home`/`features/lesson` (linguobyte-логика) удалены из этого репозитория. Коллекции описаны здесь только как справка по структуре общего Firebase-проекта |
