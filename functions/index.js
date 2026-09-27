const { onCall, HttpsError } = require('firebase-functions/v2/https');
const { defineSecret } = require('firebase-functions/params');
const { initializeApp } = require('firebase-admin/app');
const { getFirestore } = require('firebase-admin/firestore');
const OpenAI = require('openai');
const Anthropic = require('@anthropic-ai/sdk');

initializeApp();

const openaiApiKey = defineSecret('OPENAI_API_KEY');
const anthropicApiKey = defineSecret('ANTHROPIC_API_KEY');

const OPENAI_MODEL = 'gpt-4o-mini';
const ANTHROPIC_MODEL = 'claude-haiku-4-5';
// Fallback идёт не напрямую в Anthropic, а через стороннего провайдера с
// Anthropic-совместимым API (тот же протокол /v1/messages, свой ключ) —
// временно, на этапе тестирования (см. ARCHITECTURE.md §6.3).
const ANTHROPIC_BASE_URL = 'https://api.ai-keys-shop.com';

// Контент теперь разложен по языку обучения (ARCHITECTURE.md §12.1) —
// b1_exam_content/{langId}/... (langId: pl/fr/es/en/de), раньше был жёстко
// b1_polish/pl/...
const B1_CONTENT_ROOT = 'b1_exam_content';
const SUPPORTED_LANG_IDS = ['pl', 'fr', 'es', 'en', 'de'];
const LANGUAGE_NAMES = {
  pl: 'Polish',
  fr: 'French',
  es: 'Spanish',
  en: 'English',
  de: 'German',
};

// llmConfig/llmQuota — отдельная root-коллекция b1_service (была
// подколлекцией b1_polish/pl/service/**): общие для всех языков, не
// привязаны ни к какому конкретному langId документу.
const LLM_CONFIG_PATH = 'b1_service/llmConfig';

// Квота на вызовы LLM (analyzeSpeech + continueDialogue вместе, по всем
// языкам сразу) — защита от абьюза/раскрутки счёта. Admin SDK-only, клиент
// не может прочитать/подменить свою квоту напрямую (в отличие от
// private_user_info/{userId}, который пользователь сам может читать и
// писать). Значение — плейсхолдер, подобрать по реальному использованию.
const LLM_QUOTA_COLLECTION = 'b1_service/llmQuota';
const DAILY_LLM_QUOTA = 100;

function validateLangId(langId) {
  if (!SUPPORTED_LANG_IDS.includes(langId)) {
    throw new HttpsError('invalid-argument', 'langId must be one of: ' + SUPPORTED_LANG_IDS.join(', '));
  }
}

// ---------------------------------------------------------------------------
// analyzeSpeech — расширенный анализ транскрипта устного шага урока
// (image/monologue/dialogue), заменяет более узкий analyzeFreePractice
// (Lesson Matrix §C, docs/FIRESTORE.md — b1_progress.lessonResults).
//
// Функция знает lessonId → читает его grammar_topic_id (+ правила) и
// lexical_topic_id (+ словарь) из Firestore, чтобы:
//   - попросить модель отдельно выделить ошибки в ЦЕЛЕВОЙ грамматике урока
//     (targetGrammarErrors) от прочих грамматических ошибок (otherGrammarErrors);
//   - самостоятельно (не решением LLM) сверить предложенные моделью кандидаты
//     словарных ошибок со словарём именно этой лексической темы —
//     lexicalErrors. Дешевле и проверяемее, чем просить модель саму знать
//     список слов урока.
exports.analyzeSpeech = onCall(
  { secrets: [openaiApiKey, anthropicApiKey] },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError('unauthenticated', 'Sign-in required.');
    }
    const userId = request.auth.uid;

    const langId = request.data?.langId;
    const lessonId = request.data?.lessonId;
    const oralStep = request.data?.oralStep;
    const transcript = request.data?.transcript;
    const uiLanguage = request.data?.uiLanguage || 'en';

    validateLangId(langId);
    if (typeof lessonId !== 'string' || lessonId.trim().length === 0) {
      throw new HttpsError('invalid-argument', 'lessonId is required.');
    }
    if (!['image', 'monologue', 'dialogue'].includes(oralStep)) {
      throw new HttpsError('invalid-argument', 'oralStep must be image, monologue, or dialogue.');
    }
    if (typeof transcript !== 'string' || transcript.trim().length === 0) {
      throw new HttpsError('invalid-argument', 'transcript is required.');
    }

    await enforceQuota(userId);

    const lesson = await fetchLesson(langId, lessonId);
    const [grammarTopic, lexicalVocabulary] = await Promise.all([
      fetchGrammarTopicWithRules(langId, lesson.grammar_topic_id),
      fetchLexicalVocabulary(langId, lesson.lexical_topic_id),
    ]);
    const taskPoints = extractTaskPoints(lesson, oralStep, uiLanguage);

    const prompt = buildAnalyzeSpeechPrompt({
      languageName: LANGUAGE_NAMES[langId],
      transcript,
      uiLanguage,
      grammarTopicTitle: grammarTopic.title,
      grammarRuleTitles: grammarTopic.rules.map((r) => r.title),
      taskPoints,
    });

    const raw = await callLlm([{ role: 'user', content: prompt }], {
      maxTokens: 2000,
      jsonMode: true,
    });

    let parsed;
    try {
      parsed = JSON.parse(stripJsonFence(raw));
    } catch (error) {
      console.error('Failed to parse analyzeSpeech LLM response', raw, error);
      throw new HttpsError('internal', 'Failed to parse analysis result.');
    }

    return {
      lemmas: sanitizeLemmas(parsed.lemmas),
      targetGrammarErrors: sanitizeErrors(parsed.targetGrammarErrors),
      otherGrammarErrors: sanitizeErrors(parsed.otherGrammarErrors),
      lexicalErrors: buildLexicalErrors(parsed, lexicalVocabulary),
      talkingPointsCovered: sanitizeTalkingPoints(parsed.talkingPointsCovered),
      coherenceScore: sanitizeCoherenceScore(parsed.coherenceScore),
    };
  },
);

// ---------------------------------------------------------------------------
// continueDialogue — один ход диалогового шага урока (дизайн диалога,
// Lesson Matrix). Без состояния на сервере: клиент присылает всю историю
// хода на каждый вызов, функция отвечает следующей репликой. Сценарий
// (dialogue_task) читается на сервере по lessonId, НЕ из payload — иначе
// системный промпт можно подменить с клиента ("Consequence to design for").
const MAX_DIALOGUE_TURNS = 30; // потолок сообщений в истории payload'а (не логических "ходов" студента) — защита от абьюза
const MAX_DIALOGUE_CHARS = 8000; // суммарно по всем turns
const MAX_MESSAGE_CHARS = 2000; // на одно сообщение

exports.continueDialogue = onCall(
  { secrets: [openaiApiKey, anthropicApiKey] },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError('unauthenticated', 'Sign-in required.');
    }
    const userId = request.auth.uid;

    const langId = request.data?.langId;
    const lessonId = request.data?.lessonId;
    const uiLanguage = request.data?.uiLanguage || 'en';

    validateLangId(langId);
    if (typeof lessonId !== 'string' || lessonId.trim().length === 0) {
      throw new HttpsError('invalid-argument', 'lessonId is required.');
    }

    const turns = sanitizeDialogueTurns(request.data?.turns);
    if (turns.length === 0) {
      throw new HttpsError('invalid-argument', 'turns is required.');
    }

    await enforceQuota(userId);

    const lesson = await fetchLesson(langId, lessonId);
    const scenario = lesson.dialogue_task || {};
    const maxTurns = typeof scenario.max_turns === 'number' ? scenario.max_turns : 10;

    // Серверный потолок хода — не доверяем клиенту даже количество уже
    // сделанных ходов, проверяем заново из присланной истории.
    const userTurnsCount = turns.filter((t) => t.role === 'user').length;
    if (userTurnsCount > maxTurns) {
      throw new HttpsError('resource-exhausted', 'max_turns exceeded.');
    }

    const systemPrompt = buildDialogueSystemPrompt(scenario, uiLanguage, LANGUAGE_NAMES[langId]);
    const messages = [
      { role: 'system', content: systemPrompt },
      ...turns.map((t) => ({
        role: t.role === 'user' ? 'user' : 'assistant',
        content: t.text,
      })),
    ];

    const raw = await callLlm(messages, { maxTokens: 300, temperature: 0.7 });
    const reply = stripJsonFence(raw).trim();

    const turnsLeft = Math.max(0, maxTurns - userTurnsCount);
    const shouldClose = turnsLeft <= 0;

    return { reply, turnsLeft, shouldClose };
  },
);

function sanitizeDialogueTurns(turns) {
  if (!Array.isArray(turns)) return [];
  const capped = turns
    .filter((t) => t && (t.role === 'user' || t.role === 'ai') && typeof t.text === 'string')
    .slice(0, MAX_DIALOGUE_TURNS)
    .map((t) => ({ role: t.role, text: t.text.slice(0, MAX_MESSAGE_CHARS) }));

  let totalChars = 0;
  const result = [];
  for (const t of capped) {
    totalChars += t.text.length;
    if (totalChars > MAX_DIALOGUE_CHARS) break;
    result.push(t);
  }
  return result;
}

function buildDialogueSystemPrompt(scenario, uiLanguage, languageName) {
  const situation = localizedField(scenario.situation, uiLanguage);
  const aiRole = localizedField(scenario.ai_role, uiLanguage);
  const goal = localizedField(scenario.goal, uiLanguage);

  return `You are role-playing as a character in a ${languageName} B1 speaking-exam dialogue practice.

Situation: ${situation}
Your role: ${aiRole}
Conversation goal: ${goal}

Rules:
- Stay in character at all times.
- Reply ONLY in ${languageName}, at a B1 register (simple, natural sentences).
- Keep each reply to 1-3 sentences.
- NEVER correct the student's ${languageName}, even if they make mistakes — mistakes are analyzed separately after the conversation, not during it. Just respond naturally as your character would.
- When the conversation goal is reached, close the conversation politely in your next reply.

Respond with ONLY your next line of dialogue in ${languageName} — no explanations, no formatting, no quotes.`;
}

// ---------------------------------------------------------------------------
// Квота

async function enforceQuota(userId) {
  const db = getFirestore();
  const docRef = db.doc(`${LLM_QUOTA_COLLECTION}/${userId}`);
  const today = new Date().toISOString().slice(0, 10); // YYYY-MM-DD, UTC

  await db.runTransaction(async (tx) => {
    const snap = await tx.get(docRef);
    const data = snap.exists ? snap.data() : null;

    if (!data || data.date !== today) {
      tx.set(docRef, { date: today, count: 1 });
      return;
    }

    if (data.count >= DAILY_LLM_QUOTA) {
      throw new HttpsError(
        'resource-exhausted',
        'Daily AI analysis limit reached. Try again tomorrow.',
      );
    }

    tx.update(docRef, { count: data.count + 1 });
  });
}

// ---------------------------------------------------------------------------
// Контент урока (Admin SDK, обходит security rules — то же, что и чтение
// llmConfig)

async function fetchLesson(langId, lessonId) {
  const snap = await getFirestore()
    .doc(`${B1_CONTENT_ROOT}/${langId}/lessons/${lessonId}`)
    .get();
  if (!snap.exists) {
    throw new HttpsError('not-found', 'Lesson not found.');
  }
  return snap.data();
}

async function fetchGrammarTopicWithRules(langId, grammarTopicId) {
  const db = getFirestore();
  const topicSnap = await db
    .doc(`${B1_CONTENT_ROOT}/${langId}/grammar_topics/${grammarTopicId}`)
    .get();
  const rulesSnap = await db
    .collection(`${B1_CONTENT_ROOT}/${langId}/grammar_topics/${grammarTopicId}/rules`)
    .get();
  return {
    title: topicSnap.exists ? topicSnap.get('title') || '' : '',
    rules: rulesSnap.docs.map((d) => ({ title: d.get('title') || '' })),
  };
}

async function fetchLexicalVocabulary(langId, lexicalTopicId) {
  const snap = await getFirestore()
    .collection(`${B1_CONTENT_ROOT}/${langId}/lexical_topics/${lexicalTopicId}/vocabulary`)
    .get();
  return snap.docs.map((d) => (d.get('word') || '').toString());
}

function extractTaskPoints(lesson, oralStep, uiLanguage) {
  if (oralStep === 'image') {
    return localizedFieldList(lesson.image_task?.points_to_describe, uiLanguage);
  }
  if (oralStep === 'monologue') {
    return localizedFieldList(lesson.monologue_task?.points, uiLanguage);
  }
  // dialogue: раскрытие пунктов не применимо так же, как к image/monologue —
  // там оценивается достижение goal сценария, не список пунктов.
  return [];
}

function localizedField(map, uiLanguage) {
  if (!map || typeof map !== 'object') return '';
  return (map[uiLanguage] || map.en || '').toString();
}

function localizedFieldList(list, uiLanguage) {
  if (!Array.isArray(list)) return [];
  return list.map((m) => localizedField(m, uiLanguage)).filter((s) => s.length > 0);
}

// ---------------------------------------------------------------------------
// Промпт и санитайзеры analyzeSpeech

function buildAnalyzeSpeechPrompt({
  languageName,
  transcript,
  uiLanguage,
  grammarTopicTitle,
  grammarRuleTitles,
  taskPoints,
}) {
  const pointsBlock = taskPoints.length
    ? `\nThe task asked the student to cover these points:\n${taskPoints
        .map((p, i) => `${i + 1}. ${p}`)
        .join('\n')}\n`
    : '';

  return `You are a ${languageName} language teacher evaluating a B1-level student's spoken response, transcribed via speech-to-text (so ignore missing punctuation/capitalization).

This lesson's target grammar topic is: "${grammarTopicTitle}"${
    grammarRuleTitles.length ? ` (rules: ${grammarRuleTitles.join(', ')})` : ''
  }.
${pointsBlock}
Analyze the transcript and respond with strict JSON only, no markdown formatting, in exactly this shape:
{
  "lemmas": [ { "surfaceForm": "<word as used>", "lemma": "<dictionary form>", "partOfSpeech": "<noun/verb/adjective/etc>" } ],
  "targetGrammarErrors": [ { "word": "<dictionary form>", "userForm": "<form used>", "correctForm": "<correct form>", "explanation": "<in language '${uiLanguage}'>" } ],
  "otherGrammarErrors": [ same shape as targetGrammarErrors, for grammar mistakes NOT related to the target topic above ],
  "vocabularyErrorCandidates": [ same shape, for word-choice mistakes (wrong word used, independent of grammar correctness) ],
  "talkingPointsCovered": [ { "point": "<the task point, verbatim>", "covered": true or false } ],
  "coherenceScore": <integer 0-15, holistic judgment of how coherent/well-structured the response is>
}

- targetGrammarErrors: ONLY errors related to "${grammarTopicTitle}".
- otherGrammarErrors: any OTHER grammar mistakes (verb conjugation, case usage, etc. unrelated to the target topic).
- vocabularyErrorCandidates: wrong word choices, independent of grammar correctness.
- talkingPointsCovered: one entry per task point listed above, in the same order — omit the array entirely if no points were given.
- If there are no mistakes in a category, return an empty array for it.

Transcript:
"""
${transcript}
"""`;
}

function sanitizeLemmas(lemmas) {
  if (!Array.isArray(lemmas)) return [];
  return lemmas
    .filter((item) => item && typeof item.lemma === 'string')
    .map((item) => ({
      surfaceForm: typeof item.surfaceForm === 'string' ? item.surfaceForm : '',
      lemma: item.lemma,
      partOfSpeech: typeof item.partOfSpeech === 'string' ? item.partOfSpeech : '',
    }));
}

// Общая форма для targetGrammarErrors/otherGrammarErrors/vocabularyErrorCandidates.
function sanitizeErrors(errors) {
  if (!Array.isArray(errors)) return [];
  return errors
    .filter(
      (item) =>
        item &&
        typeof item.word === 'string' &&
        typeof item.userForm === 'string' &&
        typeof item.correctForm === 'string',
    )
    .map((item) => ({
      word: item.word,
      userForm: item.userForm,
      correctForm: item.correctForm,
      explanation: typeof item.explanation === 'string' ? item.explanation : '',
    }));
}

function sanitizeTalkingPoints(points) {
  if (!Array.isArray(points)) return [];
  return points
    .filter((item) => item && typeof item.point === 'string')
    .map((item) => ({ point: item.point, covered: item.covered === true }));
}

function sanitizeCoherenceScore(score) {
  const n = Number(score);
  if (!Number.isFinite(n)) return 0;
  return Math.max(0, Math.min(15, Math.round(n)));
}

// lexicalErrors — серверная сверка (не решение LLM): модель предлагает
// кандидатов словарных ошибок (vocabularyErrorCandidates), функция оставляет
// только те, чьё "word" совпадает со словарём ИМЕННО этой лексической темы
// урока (см. Lesson Matrix §C).
function buildLexicalErrors(parsed, lessonVocabulary) {
  const vocabSet = new Set(lessonVocabulary.map((w) => w.toLowerCase()));
  const candidates = sanitizeErrors(parsed.vocabularyErrorCandidates);
  return candidates.filter((item) => vocabSet.has(item.word.toLowerCase()));
}

// ---------------------------------------------------------------------------
// LLM-вызов — общий для analyzeSpeech и continueDialogue. OpenAI основной
// провайдер, Anthropic (через стороннего провайдера, см. ANTHROPIC_BASE_URL)
// — fallback при квоте/rate-limit и включённом флаге llmConfig.fallbackEnabled.

async function callLlm(messages, { maxTokens = 1024, jsonMode = false, temperature = 0 } = {}) {
  let raw;
  let provider = 'openai';
  try {
    raw = await callOpenAI(messages, maxTokens, jsonMode, temperature);
  } catch (error) {
    logProviderError('OpenAI request failed', error);

    if (!isQuotaError(error)) {
      throw new HttpsError('internal', 'LLM request failed.');
    }

    const fallbackEnabled = await isFallbackEnabled();
    if (!fallbackEnabled) {
      console.log('OpenAI quota exceeded, Anthropic fallback disabled (llmConfig.fallbackEnabled=false)');
      throw new HttpsError('internal', 'LLM request failed.');
    }

    console.log('OpenAI quota exceeded, retrying via Anthropic fallback (ai-keys-shop)');
    try {
      raw = await callAnthropic(messages, maxTokens, temperature);
      provider = 'ai-keys-shop-anthropic';
    } catch (fallbackError) {
      logProviderError('Anthropic fallback request failed', fallbackError);
      throw new HttpsError('internal', 'LLM request failed.');
    }
  }

  console.log('callLlm served', { provider });
  return raw;
}

async function callOpenAI(messages, maxTokens, jsonMode, temperature) {
  const client = new OpenAI({ apiKey: openaiApiKey.value() });
  const completion = await client.chat.completions.create({
    model: OPENAI_MODEL,
    temperature,
    max_tokens: maxTokens,
    ...(jsonMode ? { response_format: { type: 'json_object' } } : {}),
    messages,
  });
  return completion.choices?.[0]?.message?.content ?? '';
}

async function callAnthropic(messages, maxTokens, temperature) {
  // Сторонний провайдер ждёт "Authorization: Bearer <key>" (authToken), а не
  // нативную для Anthropic "x-api-key" (apiKey) — иначе 401 invalid x-api-key.
  const client = new Anthropic({
    authToken: anthropicApiKey.value(),
    baseURL: ANTHROPIC_BASE_URL,
  });

  const systemMessage = messages.find((m) => m.role === 'system');
  const conversationMessages = messages
    .filter((m) => m.role !== 'system')
    .map((m) => ({
      role: m.role === 'assistant' ? 'assistant' : 'user',
      content: m.content,
    }));

  const message = await client.messages.create({
    model: ANTHROPIC_MODEL,
    max_tokens: maxTokens,
    temperature,
    ...(systemMessage ? { system: systemMessage.content } : {}),
    messages: conversationMessages,
  });
  const textBlock = message.content.find((block) => block.type === 'text');
  return textBlock?.text ?? '';
}

// У Anthropic messages API, в отличие от OpenAI response_format:'json_object',
// нет режима принудительно чистого JSON — модель иногда оборачивает ответ в
// markdown code fence (```json ... ```) несмотря на инструкцию в промпте.
// Снимаем fence перед JSON.parse, если он есть. Для continueDialogue (не
// JSON, обычный текст) применение безвредно — fence там взяться неоткуда.
function stripJsonFence(raw) {
  const trimmed = raw.trim();
  const match = trimmed.match(/^```(?:json)?\s*([\s\S]*?)\s*```$/);
  return match ? match[1] : trimmed;
}

// Транспортные ошибки SDK (APIConnectionError и т.п.) заворачивают исходную
// причину в error.cause — обычный console.error(error) её не разворачивает,
// и в логах остаётся бесполезное "Connection error." без деталей.
function logProviderError(label, error) {
  console.error(label, error);
  if (error?.cause) {
    console.error(`${label} — cause:`, error.cause);
  }
}

// Квота/rate-limit OpenAI: 429 (rate_limit_exceeded) или code === 'insufficient_quota'.
// Только для таких ошибок имеет смысл переключаться на fallback-провайдера —
// прочие сбои (сеть, невалидный запрос) fallback не решит.
function isQuotaError(error) {
  return error?.status === 429 || error?.code === 'insufficient_quota';
}

async function isFallbackEnabled() {
  try {
    const snapshot = await getFirestore().doc(LLM_CONFIG_PATH).get();
    return snapshot.exists && snapshot.get('fallbackEnabled') === true;
  } catch (error) {
    // Fail closed: ошибка чтения флага не должна включать fallback без явного разрешения.
    console.error('Failed to read llmConfig, defaulting fallbackEnabled=false', error);
    return false;
  }
}
