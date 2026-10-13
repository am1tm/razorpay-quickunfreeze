// Required proofs from the eng review: D4 (token check) and D6 (stt upload limit).
import { test, beforeEach, afterEach } from 'node:test';
import assert from 'node:assert/strict';
import { GET, POST } from '../api/index.js';

const realFetch = globalThis.fetch;
const BASE = 'https://unfreeze.test/api';

beforeEach(() => {
  process.env.APP_TOKEN = 'test-token';
  process.env.GEMINI_API_KEY = 'g';
  process.env.SARVAM_API_KEY = 's';
});
afterEach(() => {
  globalThis.fetch = realFetch;
});

const jsonReq = (body, headers = {}) =>
  new Request(BASE, { method: 'POST', headers: { 'content-type': 'application/json', ...headers }, body: JSON.stringify(body) });

test('rejects requests without the app token (401)', async () => {
  assert.equal((await POST(jsonReq({ mode: 'explain', lang: 'hi' }))).status, 401);
  assert.equal((await GET(new Request(`${BASE}?mode=ping`))).status, 401);
});

test('rejects requests with a wrong app token (401)', async () => {
  const res = await POST(jsonReq({ mode: 'explain', lang: 'hi' }, { 'x-app-token': 'nope' }));
  assert.equal(res.status, 401);
});

test('accepts the right token and returns the provider answer (200)', async () => {
  globalThis.fetch = async () =>
    new Response(JSON.stringify({ candidates: [{ content: { parts: [{ text: '{"text":"ठीक है"}' }] } }] }), { status: 200 });
  const res = await POST(jsonReq({ mode: 'explain', lang: 'hi' }, { 'x-app-token': 'test-token' }));
  assert.equal(res.status, 200);
  assert.deepEqual(await res.json(), { text: 'ठीक है', lang: 'hi' });
});

test('stt upload over 4 MB returns 413 without calling Sarvam', async () => {
  let called = false;
  globalThis.fetch = async () => {
    called = true;
    return new Response('{}');
  };
  const big = new Uint8Array(4 * 1024 * 1024 + 1);
  const res = await POST(
    new Request(`${BASE}?mode=stt`, {
      method: 'POST',
      headers: { 'content-type': 'application/octet-stream', 'x-app-token': 'test-token' },
      body: big,
    }),
  );
  assert.equal(res.status, 413);
  assert.equal(called, false);
});
