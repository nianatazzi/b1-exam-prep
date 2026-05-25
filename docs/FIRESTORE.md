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
        id: string
        theme: string

        theory/                         # подколлекция
          {theoryId}/                   # документ
            id: string
            number: number              # порядок блока
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

    exercises/                          # подколлекция
      {exerciseId}/                     # документ (одно упражнение)
        type: string                    # "multiple_choice" | "fill_blank" | "translate"
        target_language: string
        course_id: string
        lesson_id: string               # id урока, к которому относится упражнение
        subpart_id: string
        set_id: string
        position: number                # порядок в уроке
        difficulty: number
        grammar_types: array            # список грамматических тем
        image_url: string | null
        audio_url: string | null
        createdAt: timestamp
        updatedAt: timestamp
        type_data: map                  # данные, специфичные для типа упражнения

    theory_chunks/                      # подколлекция
      {theoryChunkId}/                  # документ (повторное использование теории)
        topic: string
        text: string
        usedInLesson: string            # id урока, где используется

    service/                            # подколлекция
      basic_vocabulary/                 # документ
        words: array

      AIPreference/                     # документ (будущая фича, заглушка)
        model: string
        prompt: string

      botSettings/                      # документ (будущая фича, заглушка)
        enabled: boolean
        greeting: string
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
        lastLesson: string              # id последнего урока
        lastParagraph: number           # последний просмотренный блок
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
```

---

## Ключевые решения

| Решение | Причина |
|---|---|
| Контент (`basic`) отделён от данных пользователя | Контент обновляется независимо от прогресса пользователей |
| Приватные и публичные данные в разных коллекциях | Безопасность: публичный профиль читают все, приватный — только владелец |
| `theory_chunks` вынесены на уровень языка | Блоки теории могут переиспользоваться в нескольких уроках и используются при слабых результатах в упражнениях |
| Прогресс хранится внутри `private_user_info/{userId}/languages/{langId}` | Один запрос — весь прогресс по языку |
| `exercises` вынесены на уровень языка (`{langId}`) | Упражнения могут использоваться в разных уроках; `lesson_id` внутри документа указывает на принадлежность |
| `subscription` — map с `plan` и `expiresAt` | Позволяет хранить тип подписки и дату истечения; легко расширяется (например, `autoRenew`) |
| `exercises` расширены полями из Eraiser-модели | Поддержка медиа, сложности, грамматических тегов и гибкого `type_data` для разных типов упражнений |
| `oral_progress`, `grammar_progress`, `lexicon_progress` — отдельные числа | Простота чтения и обновления на MVP; `progress: map` оставлен как заглушка для детального трекинга |
| `personalized_courses` — заглушка | Зарезервировано для персональных курсов (например, подготовка к просмотру фильмов) |
| `AIPreference`, `botSettings` — заглушки в `service` | Будущие фичи после MVP |
