# B1 Exam Prep

Flutter-приложение (Android/iOS) для подготовки к устному экзамену B1.
Урок = пара «лексическая тема × грамматическая тема» (Lesson Matrix): три
блока упражнений (verb/noun/phrase) и три устных шага (описание картинки,
монолог, диалог с ИИ) с LLM-анализом речи. Языки обучения: pl/fr/es/en/de
(контент пока только польский). Языки интерфейса: EN/RU/FR/ES.

Отдельное приложение от linguobyte (`com.linguobyte.b1exam`), но в общем
Firebase-проекте `linguobyte` и с общим профилем пользователя.

## Документация

- [`CLAUDE.md`](CLAUDE.md) — правила работы с кодовой базой
- [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) — архитектура, флоу, договорённости, техдолг
- [`docs/FIRESTORE.md`](docs/FIRESTORE.md) — структура Firestore, Security Rules, индексы
- [`docs/codebase-map.html`](docs/codebase-map.html) — карта файлов (открыть в браузере)
- [`aikeysshopgatewayintegration.md`](aikeysshopgatewayintegration.md) — особенности LLM-шлюза, используемого как fallback

## Запуск

1. Скопировать `.env.example` → `.env`, заполнить значения из Firebase Console.
2. Сгенерировать код: `dart run build_runner build --delete-conflicting-outputs`
   (локализация генерируется автоматически при сборке, `flutter: generate: true`).
3. Запустить с параметрами:

```
flutter run --dart-define-from-file=.env \
  --dart-define=GOOGLE_SERVER_CLIENT_ID=<web client id>
```

| `--dart-define` | Назначение |
|---|---|
| `FIREBASE_*` | Конфиг Firebase (`lib/firebase_options.dart`), см. `.env.example` |
| `GOOGLE_SERVER_CLIENT_ID` | Нужен для idToken Google Sign-In |
| `SHOW_SKIP_BUTTON=true` | Кнопка Skip в упражнениях в release/profile-сборках для тестеров (в debug видна всегда) |

Android дополнительно требует `android/app/google-services.json` (не коммитится).

## Проверки

```
flutter analyze
flutter test
flutter build apk --debug
```

## Cloud Functions

`functions/` — `analyzeSpeech` и `continueDialogue` (Node.js 20). Ключи
LLM-провайдеров — только в Secret Manager:

```
firebase functions:secrets:set OPENAI_API_KEY
firebase functions:secrets:set ANTHROPIC_API_KEY
firebase deploy --only functions
```

Fallback на Anthropic-совместимый шлюз включается флагом
`b1_service/llmConfig.fallbackEnabled` в Firestore (см. `docs/ARCHITECTURE.md` §6.3).
Firestore Security Rules и индексы в репозитории не хранятся — настраиваются
в Firebase Console (требования — `docs/FIRESTORE.md`).
