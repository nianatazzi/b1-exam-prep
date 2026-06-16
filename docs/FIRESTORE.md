# Architecture

## Firestore Structure

Три корневых коллекции: `basic`, `private_user_info`, `public_user_info`.

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
        id: number
        theme: string

        theory/                         # подколлекция
          {theoryId}/                   # документ
            th_id: number
            lesson_id: number
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
            voc_id: number
            lesson_id: number
            reward: number
            set_title: string           # название всей темы


        verbs/                          # подколлекция "матрица глаголов", спряжение
          {verbID}/                     # документ
            v_id: number
            lesson_id: number
            title: string
            type: string
            conjugation: map
            translation: string
            transcription: string


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
    type: string                    # "wordcard" | "flashcard" | "multiple_choice" | "fill_blank" | "mosaic" | "translate" | "listen_pick" | "voice_translate"
      target_language: string
      course_id: string
      lesson_id: number               # id урока, к которому относится упражнение
      linked_item_id: number          # id подраздела урока
      segment_type: string            # тип подраздела
      permission: string              # платный или бесплатный контент
      difficulty: number
      grammar_types: array            # список грамматических тем
      image_url: string | null
      audio_url: string | null
      createdAt: timestamp
      updatedAt: timestamp
      type_data: map                  # данные, специфичные для типа упражнения
      ex_id: number
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

    friends/                            # подколлекция
      {friendId}/                       # документ
        userId: string
        addedAt: timestamp

    languages/                          # подколлекция
      {langId}/                         # документ: en | es | fr
        lastLesson: string              # id документа последнего урока (например "lesson_01")
        lastParagraph: number           # индекс последней завершённой пары "контент+упражнения" в последовательности шагов урока (не номер блока theory/lexical_set/verbs напрямую). Блок считается завершённым только после прохождения его упражнений.
        oral_progress: number           # прогресс разговорной части (0–100)
        grammar_progress: number        # прогресс грамматики (0–100)
        lexicon_progress: number        # прогресс лексики (0–100)
        progress: map                   # детальный прогресс (заглушка для расширения)

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
    avatar: string                      # url
    points: number
    preference: map                     # {theme, notifications, ...}
      uiLanguage: string              # язык интерфейса (en | ru | fr | es)
      selectedLanguage: string        # id языка обучения (en | es | fr | ru)
```

---

## Security Rules

**Версия:** `rules_version = '2'` — единственная актуальная версия. Версии 3 не существует.

### Матрица доступа

| Коллекция | Администратор | Авторизованный пользователь |
|---|---|---|
| `basic/**` | read + write | read |
| `private_user_info/{userId}/**` | read + write | read + write (только свой `userId`) |
| `public_user_info/{userId}` | read + write | read (все) / write (только свой `userId`) |

### Правило доработки

> При добавлении новой коллекции или подколлекции в этот файл — **сразу** добавить для неё правило в Firestore Console. Не оставлять на потом.

Новое правило добавляется по шаблону:
- Контент (читают все пользователи): `allow read: if request.auth != null;`
- Данные пользователя (только свои): `allow read, write: if request.auth != null && request.auth.uid == userId;`
- Плюс всегда: `allow read, write: if isAllowed();` для администраторов

---

## Ключевые решения

| Решение | Причина |
|---|---|
| Контент (`basic`) отделён от данных пользователя | Контент обновляется независимо от прогресса пользователей |
| Приватные и публичные данные в разных коллекциях | Безопасность: публичный профиль читают все, приватный — только владелец |
| `theory_chunks` вынесены на уровень языка | Блоки теории могут переиспользоваться в нескольких уроках и используются при слабых результатах в упражнениях |
| Прогресс хранится внутри `private_user_info/{userId}/languages/{langId}` | Один запрос — весь прогресс по языку |
| `exercises` — отдельная корневая коллекция | Привязка к языку через `course_id` (`{courseType}_{langId}`), к уроку через `lesson_id`, к блоку через `segment_type` + `linked_item_id` |
| Порядок уроков, блоков теории/лексики и упражнений — по полю `id`, без отдельного поля `position` | Перестановки контента не планируются; не плодим лишние поля |
| `subscription` — map с `plan` и `expiresAt` | Позволяет хранить тип подписки и дату истечения; легко расширяется (например, `autoRenew`) |
| `exercises` расширены полями из Eraiser-модели | Поддержка медиа, сложности, грамматических тегов и гибкого `type_data` для разных типов упражнений |
| `oral_progress`, `grammar_progress`, `lexicon_progress` — отдельные числа | Простота чтения и обновления на MVP; `progress: map` оставлен как заглушка для детального трекинга |
| `personalized_courses` — заглушка | Зарезервировано для персональных курсов (например, подготовка к просмотру фильмов) |
| `AIPreference`, `botSettings` — заглушки в `service` | Будущие фичи после MVP |
