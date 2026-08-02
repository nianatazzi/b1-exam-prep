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
| `b1_polish/**` | read + write | read |

### Правило доработки

> При добавлении новой коллекции или подколлекции в этот файл — **сразу** добавить для неё правило в Firestore Console. Не оставлять на потом.

Новое правило добавляется по шаблону:
- Контент (читают все пользователи): `allow read: if request.auth != null;`
- Данные пользователя (только свои): `allow read, write: if request.auth != null && request.auth.uid == userId;`
- Плюс всегда: `allow read, write: if isAllowed();` для администраторов

---

## 4. B1 Polish Exam Prep

```
b1_polish/                                # корневая коллекция
  pl/                                      # документ языка (единственный на сейчас)
    sections/                              # подколлекция: 3 раздела устного экзамена
      {sectionId}/                         # "image_description" | "monologue" | "dialogue"
        s_id: number                       # порядковый номер
        type: string                       # "image_description" | "monologue" | "dialogue"
        title: string
        description: string
        icon: string                       # идентификатор иконки

        topics/                            # подколлекция: темы внутри раздела
          {topicId}/
            t_id: number                   # порядковый номер
            title: string
            description: string
            image_url: string | null       # изображение для раздела image_description

            vocabulary/                    # подколлекция: слова по теме
              {vocabId}/
                voc_id: number
                word: string                # слово на польском
                translation: map<langCode, string>
                transcription: string
                gender: string | null       # "m" | "f" | "n"
                example_sentence: map<langCode, string>
                audio_url: string | null

            grammar/                       # подколлекция: грамматические правила
              {grammarId}/
                g_id: number
                title: string
                rule_type: string           # "declension" | "conjugation" | "case_usage"
                paradigm: map               # таблица парадигмы (гибкая структура)
                explanation: map<langCode, string>
                examples: array<map>        # [{pl: "...", en: "...", ru: "..."}, ...]

            phrases/                       # подколлекция: полезные фразы и паттерны
              {phraseId}/
                p_id: number
                phrase: string              # фраза на польском
                translation: map<langCode, string>
                usage_context: map<langCode, string>
                category: string            # "opening" | "transition" | "opinion" | "conclusion" | "description"
                audio_url: string | null
```

### B1 упражнения

Используется общая коллекция `exercises/` с фильтрацией по `course_id: "b1_pl"`.

```
exercises/
  {exerciseId}/
    course_id: "b1_pl"                  # отличает B1-упражнения от basic_
    lesson_id: number                   # = t_id темы (topic)
    segment_type: string                # "vocabulary" | "grammar" | "phrases" (= уровень подготовки)
    linked_item_id: number | null       # ссылка на конкретный элемент контента
    type: string                        # стандартные типы: flashcard, fill_blank, mosaic и т.д.
    type_data: map                      # данные упражнения (стандартная структура)
    ...остальные поля как в основных exercises
```

### B1 прогресс пользователя

```
private_user_info/
  {userId}/
    b1_progress/                        # подколлекция
      pl/                               # документ
        topicResults: map
          "{sectionType}_{topicTId}_{prepLevel}": map
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
        freePractice: map                # свободная практика (image_description) — только последняя попытка
          "{sectionType}_{topicTId}": map
            transcript: string           # текст, распознанный speech_to_text за сессию таймера
            durationSeconds: number      # фактическая длительность записи
            completedAt: timestamp
            analysis: map | null         # результат LLM-анализа (Фаза 2, analyzeFreePractice Cloud Function).
                                          # null если анализ не запускался или упал — не критично для завершения топика
              misusedWords: array
                - word: string           # словарная форма правильного польского слова
                  type: string           # "verb" | "noun"
                  userForm: string       # форма, которую использовал пользователь
                  correctForm: string    # правильная форма в этом контексте
                  explanation: string    # объяснение на языке интерфейса пользователя
```

`stats`/`achievements` заполняются `ExamProgressRepository` по тем же правилам, что `UserProgressRepository` для linguobyte: `stats` — инкременты по `ExerciseResult.grammarTypes` (не по `prepLevel`/`segment_type`); `achievements` — `CheckB1AchievementUseCase`, триггеры адаптированы под структуру B1 (раздел→тема→уровень подготовки, нет уроков/суб-шагов глаголов) — см. `ARCHITECTURE.md` §20.

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
| `b1_polish` — отдельная корневая коллекция | B1 exam prep — отдельное приложение с собственной структурой контента (секции → темы → vocab/grammar/phrases) |
| B1 exercises в общей коллекции `exercises` | Переиспользование существующих типов упражнений; `course_id: "b1_pl"` отделяет от `basic_*` |
| `segment_type` для B1 = уровень подготовки | "vocabulary" / "grammar" / "phrases" — аналог "theory" / "vocab" / "verb" из linguobyte |
| B1 прогресс в `b1_progress/pl` | Изолирован от `languages/{langId}` — разные приложения, разный прогресс. `stats`/`achievements` намеренно повторяют форму linguobyte (не изолированы по смыслу) — общий `ProfileScreen` показывает то и другое одинаково |
| `basic`/`exercises` (`course_id: basic_*`)/`languages/{langId}` не используются кодом b1-exam-prep | `features/home`/`features/lesson` (linguobyte-логика) удалены из этого репозитория целиком. Коллекции описаны здесь только как справка по структуре общего Firebase-проекта — их пишет/читает только linguobyte |
