// Unfreeze API: one Vercel function routing every AI and voice call.
// Modes: ping (GET), explain / ask / photo_check / tts (JSON POST), stt (raw WAV POST, ?mode=stt).
// The app owns all fallbacks; this function only returns a clear status code when something fails.

const LIMITS = { json: 2 * 1024 * 1024, stt: 4 * 1024 * 1024 };
const PROVIDER_TIMEOUT_MS = 8000;

const LANGS = {
  en: { name: 'English', code: 'en-IN', speaker: 'shubh' },
  hi: { name: 'Hindi', code: 'hi-IN', speaker: 'shubh' },
  mr: { name: 'Marathi', code: 'mr-IN', speaker: 'shubh' },
};

// The hold date comes from the app (Fixtures.freezeDate), so every date has one source.
const context = (holdDate) =>
  'You are the assistant inside a payments app for Indian small merchants. ' +
  'The merchant is Bharti, a home baker in Nagpur. RBI requires every payment company to re-verify (re-KYC) ' +
  `its merchants. Her re-KYC is due. Her settlements are flowing normally today; they will be PUT ON HOLD from ${holdDate} only if re-KYC is not completed by then (never say they resume or start on that date). ` +
  'Nothing is wrong with her account. Remaining steps: confirm business details, PAN and Aadhaar via DigiLocker, ' +
  'and one photo of her shop or workspace; it takes about 90 seconds. Never promise approval or give legal or financial guarantees.';

const RISK_CONTEXT =
  'You are the assistant inside a payments app for Indian small merchants. ' +
  'The merchant is Bharti, a home baker in Nagpur. Rs 12,600 of her settlements is on hold for a routine risk review: ' +
  'two recent orders, #2271 (wedding cake, Rs 7,400, paid 2 Oct) and #2276 (custom hamper, Rs 5,200, paid 4 Oct), ' +
  'were larger than her usual orders. Her other payments keep settling normally and her account is not blocked. ' +
  'To release the hold she adds proof of delivery (delivery photos, WhatsApp chat screenshots or a courier receipt) ' +
  'from her gallery; a reviewer usually checks within 24 hours. Describe the reason only as "a routine check because the ' +
  'orders were larger than usual"; never mention fraud, fraud models, risk scores or internal signals. ' +
  'Say a reviewer usually checks within 24 hours; never say the money will arrive within 24 hours. ' +
  'Never promise release or give legal or financial guarantees.';

// Hindi and Marathi must come back in Devanagari: Gemini sometimes answers in Roman transliteration.
const langName = (lang) => (lang === 'en' ? 'English' : `${LANGS[lang].name}, written in Devanagari script (not Roman letters)`);

const contextFor = (body) => (body.topic === 'risk' ? RISK_CONTEXT : context(holdDateFrom(body)));

function holdDateFrom(body) {
  const d = typeof body.hold_date === 'string' ? body.hold_date.trim() : '';
  return /^[0-9]{1,2} [A-Za-z]{3}$/.test(d) ? d : '13 Feb';
}

export function json(status, body) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'content-type': 'application/json', 'cache-control': 'no-store' },
  });
}

function authorized(request) {
  const expected = process.env.APP_TOKEN;
  return Boolean(expected) && request.headers.get('x-app-token') === expected;
}

async function readLimited(request, limit) {
  const declared = Number(request.headers.get('content-length') || 0);
  if (declared > limit) return { tooLarge: true };
  const buf = Buffer.from(await request.arrayBuffer());
  return buf.length > limit ? { tooLarge: true } : { buf };
}

// New API keys can't use the 2.5 models (Sept 2026), so try current Flash IDs in order and
// remember the first one that answers. A 404 means "model not available to this key".
// Flash-Lite first: lowest latency for the 3 s ask budget. 503 (overloaded) also falls through.
const GEMINI_MODELS = [process.env.GEMINI_MODEL, 'gemini-3.5-flash-lite', 'gemini-3.1-flash-lite', 'gemini-3.6-flash'].filter(Boolean);
let workingModel = null;

async function gemini(parts, schema) {
  const candidates = workingModel
    ? [workingModel, ...GEMINI_MODELS.filter((m) => m !== workingModel)]
    : GEMINI_MODELS;
  let lastErr;
  for (const model of candidates) {
    try {
      const out = await geminiCall(model, parts, schema);
      workingModel = model;
      return out;
    } catch (err) {
      lastErr = err;
      if (err.upstream !== 404 && err.upstream !== 503) throw err;
    }
  }
  throw lastErr;
}

// Short answers don't need reasoning: ask for minimal thinking to cut latency. If a model rejects
// the setting (400), retry once without it.
async function geminiCall(model, parts, schema, minimalThinking = true) {
  const generationConfig = { responseMimeType: 'application/json', responseSchema: schema, temperature: 0.3 };
  if (minimalThinking) generationConfig.thinkingConfig = { thinkingLevel: 'minimal' };
  const res = await fetch(
    `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent`,
    {
      method: 'POST',
      headers: { 'content-type': 'application/json', 'x-goog-api-key': process.env.GEMINI_API_KEY || '' },
      body: JSON.stringify({ contents: [{ role: 'user', parts }], generationConfig }),
      signal: AbortSignal.timeout(PROVIDER_TIMEOUT_MS),
    },
  );
  if (res.status === 400 && minimalThinking) return geminiCall(model, parts, schema, false);
  if (!res.ok) throw Object.assign(new Error(`gemini ${res.status}`), { upstream: res.status });
  const data = await res.json();
  const text = data?.candidates?.[0]?.content?.parts?.find((p) => p.text && !p.thought)?.text;
  if (!text) throw new Error('gemini empty');
  return JSON.parse(text);
}

const TEXT_SCHEMA = { type: 'OBJECT', properties: { text: { type: 'STRING' } }, required: ['text'] };
const PHOTO_SCHEMA = {
  type: 'OBJECT',
  properties: { verdict: { type: 'STRING', enum: ['pass', 'retake'] }, reason: { type: 'STRING' } },
  required: ['verdict', 'reason'],
};

async function explain(lang, body) {
  const what = body.topic === 'risk' ? 'why part of her money is on hold and what will release it' : 'why her settlements will pause and what she needs to do';
  const out = await gemini(
    [{ text: `${contextFor(body)}\nExplain to Bharti in ${langName(lang)}, in at most 3 short, warm sentences, ${what}. Return JSON {"text": "..."}.` }],
    TEXT_SCHEMA,
  );
  return { text: out.text, lang };
}

async function ask(question, lang, body) {
  const out = await gemini(
    [{ text: `${contextFor(body)}\nBharti asks: "${question}"\nAnswer in ${langName(lang)}, in at most 2 short sentences and under 25 words (it is read aloud). If the question is unrelated, gently bring her back to the task (re-KYC, or adding proof of delivery for the held orders). Return JSON {"text": "..."}.` }],
    TEXT_SCHEMA,
  );
  return { text: out.text, lang };
}

async function photoCheck(imageBase64) {
  return gemini(
    [
      { text: 'You check a photo a small merchant submitted as their BUSINESS PREMISES picture for verification. ' +
          'Many merchants work from home, so a home workspace counts (for example a baking counter with equipment, ' +
          'a tailoring table, a packed-orders shelf), as do shops, storefronts and stalls. ' +
          'Return verdict "pass" if it is a reasonably clear photo of such a place. ' +
          'Return "retake" otherwise, with ONE short, specific, friendly reason (for example: too dark, blurry, strong glare, ' +
          'this looks like a document, this looks like a selfie, no workspace visible). For pass, reason is a short confirmation. ' +
          'Never mention approval of the account.' },
      { inline_data: { mime_type: 'image/jpeg', data: imageBase64 } },
    ],
    PHOTO_SCHEMA,
  );
}

async function stt(wav) {
  const form = new FormData();
  form.append('file', new Blob([wav], { type: 'audio/wav' }), 'question.wav');
  form.append('model', process.env.SARVAM_STT_MODEL || 'saaras:v3');
  form.append('mode', 'transcribe');
  form.append('language_code', 'unknown');
  const res = await fetch('https://api.sarvam.ai/speech-to-text', {
    method: 'POST',
    headers: { 'api-subscription-key': process.env.SARVAM_API_KEY || '' },
    body: form,
    signal: AbortSignal.timeout(PROVIDER_TIMEOUT_MS),
  });
  if (!res.ok) throw Object.assign(new Error(`sarvam stt ${res.status}`), { upstream: res.status });
  const data = await res.json();
  return { transcript: data.transcript || '', language_code: data.language_code || null };
}

async function tts(text, lang) {
  const res = await fetch('https://api.sarvam.ai/text-to-speech', {
    method: 'POST',
    headers: { 'content-type': 'application/json', 'api-subscription-key': process.env.SARVAM_API_KEY || '' },
    body: JSON.stringify({
      text: String(text).slice(0, 2500),
      language_code: LANGS[lang].code,
      model: 'bulbul:v3',
      speaker: LANGS[lang].speaker,
      speech_sample_rate: 22050,
      output_audio_codec: 'wav',
    }),
    signal: AbortSignal.timeout(PROVIDER_TIMEOUT_MS),
  });
  if (!res.ok) throw Object.assign(new Error(`sarvam tts ${res.status}`), { upstream: res.status });
  const data = await res.json();
  const audio = data?.audios?.[0];
  if (!audio) throw new Error('sarvam tts empty');
  return { audio_base64: audio, mime: 'audio/wav' };
}

// Android analytics: forward one app event to GA4 via the Measurement Protocol.
// The API secret (GA_API_SECRET) stays here; the web build uses gtag.js directly.
const GA_ID = 'G-9LW1SVXX76';
async function forwardEvent(body) {
  const secret = process.env.GA_API_SECRET;
  const name = String(body.name || '');
  if (!secret || !/^[a-z][a-z0-9_]{0,39}$/.test(name)) return { ok: false };
  const params = {};
  for (const [k, v] of Object.entries(body.params || {}).slice(0, 25)) {
    if (/^[a-z][a-z0-9_]{0,39}$/.test(k) && ['string', 'number', 'boolean'].includes(typeof v)) {
      params[k] = typeof v === 'string' ? v.slice(0, 100) : v;
    }
  }
  const res = await fetch(`https://www.google-analytics.com/mp/collect?measurement_id=${GA_ID}&api_secret=${secret}`, {
    method: 'POST',
    body: JSON.stringify({
      client_id: String(body.client_id || 'anon').slice(0, 60),
      user_properties: { surface: { value: 'android_app' } },
      events: [{ name, params }],
    }),
    signal: AbortSignal.timeout(4000),
  });
  return { ok: res.ok };
}

function providerError(err) {
  // 429 from a provider is passed through so the app can tell "quota" from "broken"; everything else is 502.
  const status = err?.upstream === 429 ? 429 : 502;
  return json(status, { error: String(err?.message || err) });
}

export async function GET(request) {
  if (!authorized(request)) return json(401, { error: 'unauthorized' });
  const mode = new URL(request.url).searchParams.get('mode');
  if (mode === 'ping') return json(200, { ok: true });
  return json(400, { error: 'unknown mode' });
}

export async function POST(request) {
  if (!authorized(request)) return json(401, { error: 'unauthorized' });
  const mode = new URL(request.url).searchParams.get('mode');

  try {
    if (mode === 'stt') {
      const { tooLarge, buf } = await readLimited(request, LIMITS.stt);
      if (tooLarge) return json(413, { error: 'audio too large' });
      return json(200, await stt(buf));
    }

    const { tooLarge, buf } = await readLimited(request, LIMITS.json);
    if (tooLarge) return json(413, { error: 'body too large' });
    let body;
    try {
      body = JSON.parse(buf.toString('utf8'));
    } catch {
      return json(400, { error: 'invalid json' });
    }
    const lang = LANGS[body.lang] ? body.lang : 'hi';

    switch (body.mode) {
      case 'explain':
        return json(200, await explain(lang, body));
      case 'ask':
        if (!body.question) return json(400, { error: 'question required' });
        return json(200, await ask(String(body.question).slice(0, 500), lang, body));
      case 'photo_check':
        if (!body.image) return json(400, { error: 'image required' });
        return json(200, await photoCheck(body.image));
      case 'tts':
        if (!body.text) return json(400, { error: 'text required' });
        return json(200, await tts(body.text, lang));
      case 'event':
        return json(200, await forwardEvent(body));
      default:
        return json(400, { error: 'unknown mode' });
    }
  } catch (err) {
    return providerError(err);
  }
}
