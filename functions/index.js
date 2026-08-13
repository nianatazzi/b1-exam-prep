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
const LLM_CONFIG_PATH = 'b1_polish/pl/service/llmConfig';

// Анализирует транскрипт свободной практики (image_description, Фаза 2):
// находит неправильно использованные глаголы/существительные для
// последующей повторной тренировки (см. docs/FIRESTORE.md, freePractice.analysis).
//
// Основной провайдер — OpenAI. При ошибке квоты/rate-limit и включённом флаге
// b1_polish/pl/service/llmConfig.fallbackEnabled повторяет запрос через Anthropic
// (см. ARCHITECTURE.md §6.3).
exports.analyzeFreePractice = onCall(
  { secrets: [openaiApiKey, anthropicApiKey] },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError('unauthenticated', 'Sign-in required.');
    }

    const transcript = request.data?.transcript;
    const uiLanguage = request.data?.uiLanguage || 'en';

    if (typeof transcript !== 'string' || transcript.trim().length === 0) {
      throw new HttpsError('invalid-argument', 'transcript is required.');
    }

    const prompt = buildPrompt(transcript, uiLanguage);

    let raw;
    let provider = 'openai';
    try {
      raw = await callOpenAI(prompt);
    } catch (error) {
      logProviderError('OpenAI request failed', error);

      if (!isQuotaError(error)) {
        throw new HttpsError('internal', 'Analysis request failed.');
      }

      const fallbackEnabled = await isFallbackEnabled();
      if (!fallbackEnabled) {
        console.log('OpenAI quota exceeded, Anthropic fallback disabled (llmConfig.fallbackEnabled=false)');
        throw new HttpsError('internal', 'Analysis request failed.');
      }

      console.log('OpenAI quota exceeded, retrying via Anthropic fallback (ai-keys-shop)');
      try {
        raw = await callAnthropic(prompt);
        provider = 'ai-keys-shop-anthropic';
      } catch (fallbackError) {
        logProviderError('Anthropic fallback request failed', fallbackError);
        throw new HttpsError('internal', 'Analysis request failed.');
      }
    }

    console.log('analyzeFreePractice served', { provider });

    let parsed;
    try {
      parsed = JSON.parse(stripJsonFence(raw));
    } catch (error) {
      console.error('Failed to parse LLM response', raw, error);
      throw new HttpsError('internal', 'Failed to parse analysis result.');
    }

    return {
      misusedWords: sanitizeMisusedWords(parsed.misusedWords),
    };
  },
);

// Клиент маппит "type" в закрытый enum (verb/noun) и падает на любом другом
// значении — а модель иногда возвращает что-то вроде "adj/noun", когда не
// уверена в классификации. Отфильтровываем такие записи здесь, на границе с
// LLM, а не ослабляем enum на клиенте (см. CLAUDE.md — enum для закрытого
// списка значений).
function sanitizeMisusedWords(misusedWords) {
  if (!Array.isArray(misusedWords)) {
    return [];
  }
  return misusedWords.filter(
    (item) =>
      item &&
      (item.type === 'verb' || item.type === 'noun') &&
      typeof item.word === 'string' &&
      typeof item.userForm === 'string' &&
      typeof item.correctForm === 'string',
  );
}

async function callOpenAI(prompt) {
  const client = new OpenAI({ apiKey: openaiApiKey.value() });
  const completion = await client.chat.completions.create({
    model: OPENAI_MODEL,
    temperature: 0,
    response_format: { type: 'json_object' },
    messages: [{ role: 'user', content: prompt }],
  });
  return completion.choices?.[0]?.message?.content ?? '{}';
}

async function callAnthropic(prompt) {
  // Сторонний провайдер ждёт "Authorization: Bearer <key>" (authToken), а не
  // нативную для Anthropic "x-api-key" (apiKey) — иначе 401 invalid x-api-key.
  const client = new Anthropic({
    authToken: anthropicApiKey.value(),
    baseURL: ANTHROPIC_BASE_URL,
  });
  const message = await client.messages.create({
    model: ANTHROPIC_MODEL,
    max_tokens: 1024,
    messages: [{ role: 'user', content: prompt }],
  });
  const textBlock = message.content.find((block) => block.type === 'text');
  return textBlock?.text ?? '{}';
}

// У Anthropic messages API, в отличие от OpenAI response_format:'json_object',
// нет режима принудительно чистого JSON — модель иногда оборачивает ответ в
// markdown code fence (```json ... ```) несмотря на инструкцию в промпте.
// Снимаем fence перед JSON.parse, если он есть.
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

function buildPrompt(transcript, uiLanguage) {
  return `You are a Polish language teacher evaluating a B1-level student's spoken description of an image, transcribed via speech-to-text (so ignore missing punctuation/capitalization).

Find verbs and nouns the student used INCORRECTLY (wrong conjugation, wrong case/declension, or wrong word choice). Only include genuine grammar/vocabulary mistakes.

Respond with strict JSON only, no markdown formatting, in exactly this shape:
{
  "misusedWords": [
    {
      "word": "<dictionary/base form of the correct Polish word>",
      "type": "verb" or "noun",
      "userForm": "<the form the student actually used, in Polish>",
      "correctForm": "<the correct Polish form for this context>",
      "explanation": "<short explanation, written in language code '${uiLanguage}'>"
    }
  ]
}

If there are no mistakes, return {"misusedWords": []}.

Transcript:
"""
${transcript}
"""`;
}
