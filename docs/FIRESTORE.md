# Architecture

## Firestore Structure

Четыре корневых коллекции: `basic`, `exercises`, `private_user_info`, `public_user_info`.

**Обозначения:**
- `name/` — коллекция или документ-контейнер
- `{name}/` — документ с динамическим id
- `field: type` — поле документа
- `# comment` — пояснение

---

## 1. Учебный контент

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

        lexical_set/                      # подколлекция "лексический запас, тематические слова"
          {vocabularySetID}/             # документ
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
      {basic_vocabulary}/                 # документ
        words: array

      {AIPreference}/                     # документ (будущая фича, заглушка)
        model: string
        prompt: string

      {botSettings}/                      # документ (будущая фича, заглушка)
        enabled: boolean
        greeting: string


exercises/                          # коллекция
  {exerciseId}/                     # документ (одно упражнение)
    type: string                    # "wordcard" | "flashcard" | "multiple_choice" | "fill_blank" | "mosaic" | "translate_sentence" | "listen_pick" | "voice_translate"
      target_language: string
      course_id: string             # указатель на какой курс (например: basic_fr) 
      lesson_id: number               # id урока, к которому относится упражнение
      linked_item_id: number          # id подраздела урока (theory или verbs | lexical_set не имеет)
      segment_type: string            # значение упражнения: "theory" | "vocab" | "verb" — указывает на блок theory / lexical_set / verbs соответственно
      permission: string              # платный или бесплатный контент
      difficulty: number
      grammar_types: array            # список грамматических тем
      image_url: string | null
      audio_url: string | null
      createdAt: timestamp
      updatedAt: timestamp
      type_data: map                  # данные, специфичные для типа упражнения (структура ниже)
      ex_id: number                   # порядковый номер 
```

### Структура `type_data` по типам упражнений

```
# wordcard — карточка слова
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
  blanks: array
    - accepted: array<string>        # допустимые варианты ответа

# translate_sentence — перевести предложение текстом
type_data:
  title: map<langCode, string>       # инструкция
  question: string                   # исходное предложение (на изучаемом языке)
  correct_answer: map<langCode, string>  # правильный перевод
  correct_pattern: map<langCode, string> # regex для проверки (может быть null)

# mosaic — собрать предложение из чипов
type_data:
  title: map<langCode, string>       # инструкция
  prompts: map<langCode, string>     # перевод-подсказка
  answer: string                     # правильное предложение (слова через пробел)

# multiple_choice — заполнить пропуски словами из банка
type_data:
  title: map<langCode, string>       # инструкция
  prompts: map<langCode, string>     # перевод-подсказка
  form: string                       # предложение с пропусками: "She [] to [] school"
  blanks: array
    - variants: array<string>        # варианты для этого пропуска (один правильный, остальные — дистракторы)
      correct_index: number          # индекс правильного варианта в variants

# listen_pick — выбрать вариант после прослушивания
type_data:
  title: map<langCode, string>       # инструкция
  variants: array<string>            # варианты ответа
  correct_index: number              # индекс правильного варианта
  transcript: string                 # текст аудио (показывается после проверки)

# voice_translate — произнести перевод голосом
type_data:
  title: map<langCode, string>       # инструкция
  prompts: map<langCode, string>     # фраза для перевода (на языке пользователя)
  correct_answer: string             # правильный ответ (на изучаемом языке)
  correct_pattern: string | null     # regex для проверки STT-результата
  accepted_answers: array<string> | null  # дополнительные допустимые варианты
  stt_language_code: string          # язык для STT ("fr-FR", "en-US" и т.д.)
```

---

## 2. Приватные данные пользователя

```
private_user_info/                      # коллекция
  {userId}/                             # документ
    deviceId: string
    email: string
    phone: string
    subscription: map                   # данные подписки
      plan: string                      # "free" | "premium"
      expiresAt: timestamp | null       # null для free
    lastActiveDate: timestamp           # дата последней активности (для стрика)
    currentStreak: number               # текущий стрик (дни подряд)
    bestStreak: number                  # рекорд стрика

    friends/                            # подколлекция
      {friendId}/                       # документ
        userId: string
        addedAt: timestamp

    languages/                          # подколлекция
      {langId}/                         # документ: en | es | fr
        lastLesson: string              # id документа последнего урока (например "lesson_01")
        lastParagraph: number           # индекс последней завершённой пары "контент+упражнения" в последовательности шагов урока (не номер блока theory/lexical_set/verbs напрямую). Блок считается завершённым только после прохождения его упражнений.

        stats: map                      # агрегированная статистика по типам навыков (для radar-диаграммы)
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

        stepResults: map                # результаты по субпартам уроков (для цветов кругов на HomeScreen)
          "{lessonLId}_{segmentType}_{linkedItemId}": map   # например "1_theory_1"
            correct: number             # кол-во правильных ответов
            total: number               # кол-во упражнений
            firstAttempt: boolean       # все ли правильно с первой попытки
            completedAt: timestamp
            incorrectExerciseIds: array<string>  # id упражнений с ошибками (для повторения)

        achievements: map               # достижения пользователя по языку
          # Ключ map = тип достижения. Внутри обязательно дублируется поле type
          # (= ключ): AchievementModel.fromJson десериализует enum через type,
          # иначе $enumDecode падает на null и роняет загрузку всего прогресса.
          master_conjugator: map
            type: string                # = ключ ("master_conjugator")
            level: number               # 0 = не получено, I=1, II=2...
            updatedAt: timestamp
          first_step: map
            type: string
            level: number
            updatedAt: timestamp
          focused_learner: map
            type: string
            level: number
            updatedAt: timestamp
          interested_learner: map
            type: string
            level: number
            updatedAt: timestamp
          vocabulary_master: map
            type: string
            level: number
            updatedAt: timestamp

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
public_user_info/                       # коллекция
  {userId}/                             # документ
    name: string
    surname: string
    avatar: string                      # id пресета ("avatar_01") ИЛИ url (Firebase Storage, будущее)
    points: number
    onboardingComplete: boolean         # пройден ли онбординг (имя/аватар/язык). Роутер ведёт на /onboarding пока false
    preference: map
      uiLanguage: string              # язык интерфейса (en | ru | fr | es)
      selectedLanguage: string        # id языка обучения (en | es | fr | ru)
      theme: string                   # "dark" | "light"
      speechSpeed: number             # скорость воспроизведения аудио (0.5–2.0, default 1.0)
```

---

## Security Rules

**Версия:** `rules_version = '2'` — единственная актуальная версия. Версии 3 не существует.

### Матрица доступа

| Коллекция | Администратор | Авторизованный пользователь |
|---|---|---|
| `basic/**` | read + write | read |
| `exercises/**` | read + write | read |
| `private_user_info/{userId}/**` | read + write | read + write (только свой `userId`) |
| `public_user_info/{userId}` | read + write | read (все) / write (только свой `userId`) |
| `b1_exam_content/**` | read + write | read |
| `b1_service/**` | read + write | нет доступа — читает только Cloud Function через Admin SDK, обходит правила |

> **Lesson Matrix + StudyLanguage:** `b1_polish` переименован в `b1_exam_content/{langId}/...` (`langId`: pl/fr/es/en/de) — многоязычный контент вместо только польского, см. §4. `b1_exam_content/{langId}/lexical_topics/**`/`grammar_topics/**`/`lessons/**` попадают под `b1_exam_content/**` наравне с остальным контентом. **`b1_service` — НОВАЯ отдельная root-коллекция** (была подколлекцией `b1_polish/pl/service/**`, теперь `llmConfig`/`llmQuota` не привязаны ни к какому языковому документу, т.к. общие для всех пяти языков) — правило `b1_polish/**` её больше не покрывает автоматически, нужно явно завести `b1_service/**` как отдельную запись, admin-only, без исключений для клиента.

### Правило доработки

> При добавлении новой коллекции или подколлекции в этот файл — **сразу** добавить для неё правило в Firestore Console. Не оставлять на потом.

Новое правило добавляется по шаблону:
- Контент (читают все пользователи): `allow read: if request.auth != null;`
- Данные пользователя (только свои): `allow read, write: if request.auth != null && request.auth.uid == userId;`
- Плюс всегда: `allow read, write: if isAllowed();` для администраторов

---

## 4. B1 Exam Prep — Lesson Matrix + StudyLanguage

Урок = пара «лексическая тема × грамматическая тема» (`ARCHITECTURE.md` §6.1),
внутри ОДНОГО языка обучения (`ARCHITECTURE.md` §12.1). Контент изначально
был только польским (`b1_polish`) — переименовано в `b1_exam_content` и
разложено по `{langId}` (pl/fr/es/en/de), тем же способом, что linguobyte
раскладывает `basic/{langId}`. Старая схема `sections/{sectionId}/topics/{topicId}`
(3 раздела экзамена × 33 темы каждый) выведена из употребления ещё на шаге
Lesson Matrix — image_description/monologue/dialogue это три устных шага
ОДНОГО урока, не параллельные разделы.

```
b1_exam_content/                          # корневая коллекция (была b1_polish)
  {langId}/                                # документ: pl | fr | es | en | de
    lexical_topics/                        # подколлекция: лексические темы (в контексте языка langId)
      {lexicalTopicId}/
        lt_id: number                      # порядковый номер
        title: string
        description: string

        vocabulary/                        # подколлекция: слова по теме (форма не менялась)
          {vocabId}/
            voc_id: number
            word: string                    # слово на изучаемом языке (langId)
            translation: map<langCode, string>  # перевод на язык ИНТЕРФЕЙСА (не путать с langId)
            transcription: string
            gender: string | null           # "m" | "f" | "n" — применимо не ко всем языкам (например en), null где неприменимо
            example_sentence: map<langCode, string>
            audio_url: string | null

    grammar_topics/                        # подколлекция: грамматические темы (в контексте языка langId)
      {grammarTopicId}/
        gt_id: number
        title: string
        description: string

        rules/                             # подколлекция: правила (форма не менялась)
          {ruleId}/
            g_id: number
            title: string
            rule_type: string               # "declension" | "conjugation" | "case_usage" | "mood" | "degree"
            paradigm: map                    # таблица парадигмы (гибкая структура)
            explanation: map<langCode, string>
            examples: array<map>             # [{pl: "...", en: "...", ru: "..."}, ...] — примеры на langId + перевод интерфейса

    lessons/                               # подколлекция: уроки — пара лексической + грамматической темы
      {lessonId}/
        lexical_topic_id: string            # ссылка на документ lexical_topics (в этом же langId)
        grammar_topic_id: string            # ссылка на документ grammar_topics (в этом же langId)
        duration_seconds: number | null     # общая длительность устных шагов; null = дефолт из AppConstants (180с)

        image_task: map                     # задание шага "описание картинки"
          image_url: string
          points_to_describe: array<map<langCode, string>>

        monologue_task: map                 # задание шага "монолог" (FreePracticeTaskModel, форма с 15d3caa)
          prompt: map<langCode, string>
          points: array<map<langCode, string>>
          duration_seconds: number | null
          think_seconds: number | null

        dialogue_task: map                  # сценарий шага "диалог"
          situation: map<langCode, string>
          user_role: map<langCode, string>
          ai_role: map<langCode, string>
          goal: map<langCode, string>
          opening_line: string              # первая реплика ИИ, на языке langId
          max_turns: number                 # потолок реплик студента, дефолт 10

b1_service/                                # НОВАЯ отдельная root-коллекция, Admin SDK-only
                                            # (была подколлекцией b1_polish/pl/service/** — вынесена
                                            # наружу, т.к. общая для всех пяти языков, не привязана
                                            # к конкретному langId)
  llmConfig/                               # документ
    fallbackEnabled: boolean               # вкл/выкл fallback-провайдера (Anthropic) в analyzeSpeech/continueDialogue.
                                            # Переключается вручную через Firebase Console. Отсутствие документа = false (fail closed)

  llmQuota/                                # подколлекция: квота вызовов LLM на пользователя (общая по всем языкам)
    {userId}/                              # документ, пишется/читается только Cloud Functions (Admin SDK)
      date: string                         # "YYYY-MM-DD" (UTC) — квота суточная
      count: number                        # сколько вызовов analyzeSpeech/continueDialogue уже сделано за date
```

Launch-контент (§F плана редизайна) — четыре польских урока, а не полная
матрица 33×N ни для одного языка: Restaurant×Dative, Restaurant×Conditional,
Hotel×Dative, School×Superlative, все под `b1_exam_content/pl/...`.
Остальные четыре языка (fr/es/en/de) на момент этого изменения схемы не
имеют ни одного урока — `B1HomeScreen` для них покажет то же пустое
состояние "content coming soon", что уже показывалось для лексических тем
без пары (например Doctor). Контент по всем языкам авторится вручную в
отдельной админ-панели (`ARCHITECTURE.md` §1), не полным перебором.

### B1 упражнения

Используется общая коллекция `exercises/` с фильтрацией по `course_id`.
`lesson_id`, `block` и теперь `course_id` (был жёстко `"b1_pl"`) —
сознательные breaking changes схемы (безопасно: на момент смены не было
реальных пользователей).

```
exercises/
  {exerciseId}/
    course_id: string                   # "b1_{langId}" — "b1_pl" | "b1_fr" | "b1_es" | "b1_en" | "b1_de" (раньше жёстко "b1_pl")
    lesson_id: string                   # id документа lessons/{lessonId} (раньше — числовой t_id темы)
    block: string                       # "verb" | "noun" | "phrase" (раньше segment_type: vocabulary/grammar/phrases)
    linked_item_id: number | null       # ссылка на GrammarRuleModel.g_id (verb/noun) или PhrasePatternModel.p_id (phrase)
    type: string                        # стандартные типы: flashcard, fill_blank, mosaic и т.д.
    type_data: map                      # данные упражнения (стандартная структура)
    ...остальные поля как в основных exercises
```

Каждый блок урока показывает не более `AppConstants.lessonBlockExerciseCap`
(10) упражнений — капается на клиенте при загрузке (`LessonNotifier`), не в
самом запросе: все упражнения урока грузятся одним
`where(course_id==..., lesson_id==...)` и группируются/капаются в памяти,
тот же паттерн, что был у старой схемы (`ARCHITECTURE.md` §6.1).

### B1 прогресс пользователя

```
private_user_info/
  {userId}/
    b1_progress/                        # подколлекция
      {langId}/                         # документ: pl | fr | es | en | de — прогресс изолирован по языку,
                                          # тот же паттерн, что languages/{langId} у linguobyte
        topicResults: map               # результаты трёх капов упражнений урока
          "{lessonId}_{block}": map     # block: verb | noun | phrase (раньше "{sectionType}_{topicTId}_{prepLevel}")
            correct: number
            total: number
            firstAttempt: boolean
            completedAt: timestamp
            incorrectExerciseIds: array<string>
        stats: map                      # та же форма, что и languages/{langId}.stats в linguobyte —
          grammar: {correct, total}     # общий ProfileScreen отображает оба приложения одинаково
          vocabulary: {correct, total}
          listening: {correct, total}
          speaking: {correct, total}
        achievements: map               # та же форма, что и languages/{langId}.achievements
          # Ключ map = тип достижения, дублируется в поле type (см. §2, то же требование)
          master_conjugator: {type, level, updatedAt}
          first_step: {type, level, updatedAt}
          focused_learner: {type, level, updatedAt}
          interested_learner: {type, level, updatedAt}
          vocabulary_master: {type, level, updatedAt}
        lessonResults: map               # три устных шага урока — только последняя попытка каждого
          "{lessonId}_{oralStep}": map   # oralStep: image | monologue | dialogue (заменяет старый freePractice)
            transcript: string | null    # заполнено для image/monologue; null для dialogue (см. turns)
            turns: array<map> | []       # заполнено для dialogue: [{role: "user"|"ai", text: string}, ...]; [] для image/monologue
            durationSeconds: number
            completedAt: timestamp
            score: number | null         # 0-100, рубрика AppConstants.speechScore* (Lesson Matrix §D, плейсхолдер)
            analysis: map | null         # результат analyzeSpeech Cloud Function, null если анализ не запускался/упал
              lemmas: array              # [{surfaceForm, lemma, partOfSpeech}, ...] — лемматизация внутри analyzeSpeech, без отдельного морфологического анализатора
              targetGrammarErrors: array # [{word, userForm, correctForm, explanation}, ...] — ошибки в grammar_topic_id ЭТОГО урока
              otherGrammarErrors: array  # та же форма — прочие грамматические ошибки
              lexicalErrors: array       # та же форма — серверная сверка (не решение LLM) со словарём lexical_topic_id урока
              talkingPointsCovered: array # [{point, covered: boolean}, ...] — раскрытие пунктов image_task/monologue_task
              coherenceScore: number     # 0-15, холистическая оценка LLM
```

`stats`/`achievements` заполняются `ExamProgressRepository` по тем же
правилам, что `UserProgressRepository` для linguobyte: `stats` — инкременты
по `ExerciseResult.grammarTypes` (не по `block`); `achievements` —
`CheckB1AchievementUseCase`, триггеры на `lessonId`/`block` вместо
`sectionType`/`topicTId`/`prepLevel`: Master Conjugator — блок `verb` +
урок полностью пройден; First Step — первый ЛЮБОЙ урок, пройденный
полностью (раньше был привязан к `t_id==1`, у уроков нет порядкового
номера); Vocabulary Master — переопределено под новую схему: весь урок
(все три блока) пройден и все с первой попытки, не отдельный уровень
"vocabulary" (его в новой схеме блоков нет).

---

## Ключевые решения

| Решение | Причина |
|---|---|
| Контент (`basic` и `exercises`) отделён от данных пользователя | Контент обновляется независимо от прогресса пользователей |
| Приватные и публичные данные в разных коллекциях | Безопасность: публичный профиль читают все, приватный — только владелец |
| `theory_chunks` вынесены на уровень языка | Блоки теории могут переиспользоваться в нескольких уроках и используются при слабых результатах в упражнениях |
| Прогресс хранится внутри `private_user_info/{userId}/languages/{langId}` | Один запрос — весь прогресс по языку |
| `exercises` — отдельная корневая коллекция | Привязка к языку через `course_id` (`{courseType}_{langId}`, например `basic_fr`), к уроку через `lesson_id` (= числовой `l_id` документа урока, не строка id), к блоку через `segment_type` + `linked_item_id`. Все упражнения урока загружаются одним запросом и группируются в памяти. |
| Порядок lesson - по полю `l_id`, theory - по полю `th_id`, lexical_set - по полю `voc_id`, verbs - по полю `v_id`, exercise — по полю `ex_id`|
| `subscription` — map с `plan` и `expiresAt` | Позволяет хранить тип подписки и дату истечения; легко расширяется (например, `autoRenew`) |
| `stats` map вместо отдельных `*_progress` полей | Один источник правды: сырые счётчики correct/total по 4 навыкам (grammar, vocabulary, listening, speaking). Проценты вычисляются на клиенте. Приходит вместе с документом `languages/{langId}` за 0 дополнительных reads |
| `stepResults` map в документе `languages/{langId}` | Результаты субпартов хранятся в том же документе что и прогресс — 0 дополнительных reads для HomeScreen (цвета кругов) и ProfileScreen (достижения) |
| `achievements` map в документе `languages/{langId}` | 5 типов достижений = 5 ключей. Map читается вместе с документом за 0 reads. Подколлекция потребовала бы +1 read |
| `incorrectExerciseIds` в `stepResults` | Хранит id упражнений с ошибками для будущего flow повторения. Firestore `whereIn` поддерживает до 30 значений за запрос |
| Streak (`lastActiveDate`, `currentStreak`, `bestStreak`) в корне `private_user_info` | Стрик не привязан к языку — общий для пользователя |
| `personalized_courses` — заглушка | Зарезервировано для персональных курсов (например, подготовка к просмотру фильмов) |
| `AIPreference`, `botSettings` — заглушки в `service` | Будущие фичи после MVP |
| `b1_exam_content` — отдельная корневая коллекция (была `b1_polish`) | B1 exam prep — отдельное приложение с собственной структурой контента (лексические темы × грамматические темы → уроки, Lesson Matrix), теперь по пяти языкам обучения (`{langId}`), не только польскому |
| B1 exercises в общей коллекции `exercises` | Переиспользование существующих типов упражнений; `course_id: "b1_{langId}"` отделяет от `basic_*` и от других языков b1 |
| `block` для B1 = капанное упражнение урока | "verb" / "noun" / "phrase" — заменяет старый `segment_type` (vocabulary/grammar/phrases), три капа по 10 упражнений на лексике урока |
| B1 прогресс в `b1_progress/{langId}` (раньше жёстко `pl`) | Изолирован от `languages/{langId}` linguobyte (разные приложения, разный прогресс), но сам разложен по языку тем же способом — переключение `StudyLanguage` (§12.1 ARCHITECTURE.md) сразу показывает прогресс по нужному языку без миграции данных. `stats`/`achievements` намеренно повторяют форму linguobyte — общий `ProfileScreen` показывает то и другое одинаково |
| `b1_service` — отдельная root-коллекция (была подколлекцией `b1_polish/pl/service/**`) | `llmConfig`/`llmQuota` общие для всех пяти языков — не имеет смысла держать их под каким-то одним `{langId}` документом; вынесены на верхний уровень, требует отдельного Admin SDK-only правила в Console (см. Security Rules) |
| `preference.selectedLanguage` переиспользуется для StudyLanguage b1-exam-prep, не заводится отдельное поле | То же поле, что уже пишет linguobyte — осознанное решение для консистентного UX между приложениями на одном аккаунте (см. ARCHITECTURE.md §12.1). Компромисс: b1-exam-prep не может проверить обработку этого поля со стороны linguobyte/cinephile |
| `lexical_topics`/`grammar_topics` — раздельные коллекции, не полная матрица | Урок — пара тем, авторится вручную в админ-панели; раздельные оси избегают заведения N×M документов, когда реально нужна лишь горстка пар (Lesson Matrix §F) |
| `lessonResults` вместо `freePractice`, ключ `{lessonId}_{oralStep}` | Единый паттерн для всех трёх устных шагов (image/monologue/dialogue), а не только image_description; `transcript`/`turns` — взаимоисключающие поля одной формы вместо двух параллельных документных форм |
| `llmQuota` под `service/` (Admin SDK-only), а не в `private_user_info/{userId}` | `private_user_info/{userId}` даёт владельцу read+write — квоту, лежащую там, пользователь мог бы сбросить прямым Firestore-запросом. `service/**` уже закрыт для клиента тем же правилом, что и `llmConfig` |
| `basic`/`exercises` (`course_id: basic_*`)/`languages/{langId}` не используются кодом b1-exam-prep | `features/home`/`features/lesson` (linguobyte-логика) удалены из этого репозитория целиком. Коллекции описаны здесь только как справка по структуре общего Firebase-проекта — их пишет/читает только linguobyte |
| `service/llmConfig.fallbackEnabled` вместо переменной окружения Cloud Function | Читается на лету (Admin SDK) без передеплоя функции — переключается вручную через Firebase Console; переменная окружения потребовала бы `firebase deploy --only functions` на каждое включение/выключение |
