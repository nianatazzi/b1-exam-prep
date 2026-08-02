const { onCall, HttpsError } = require('firebase-functions/v2/https');
const { defineSecret } = require('firebase-functions/params');
const OpenAI = require('openai');

const openaiApiKey = defineSecret('OPENAI_API_KEY');

const MODEL = 'gpt-4o-mini';

// Анализирует транскрипт свободной практики (image_description, Фаза 2):
// находит неправильно использованные глаголы/существительные для
// последующей повторной тренировки (см. docs/FIRESTORE.md, freePractice.analysis).
exports.analyzeFreePractice = onCall(
  { secrets: [openaiApiKey] },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError('unauthenticated', 'Sign-in required.');
    }

    const transcript = request.data?.transcript;
    const uiLanguage = request.data?.uiLanguage || 'en';

    if (typeof transcript !== 'string' || transcript.trim().length === 0) {
      throw new HttpsError('invalid-argument', 'transcript is required.');
    }

    const client = new OpenAI({ apiKey: openaiApiKey.value() });

    let completion;
    try {
      completion = await client.chat.completions.create({
        model: MODEL,
        temperature: 0,
        response_format: { type: 'json_object' },
        messages: [{ role: 'user', content: buildPrompt(transcript, uiLanguage) }],
      });
    } catch (error) {
      console.error('OpenAI request failed', error);
      throw new HttpsError('internal', 'Analysis request failed.');
    }

    const raw = completion.choices?.[0]?.message?.content ?? '{}';
    let parsed;
    try {
      parsed = JSON.parse(raw);
    } catch (error) {
      console.error('Failed to parse OpenAI response', raw, error);
      throw new HttpsError('internal', 'Failed to parse analysis result.');
    }

    return {
      misusedWords: Array.isArray(parsed.misusedWords) ? parsed.misusedWords : [],
    };
  },
);

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
