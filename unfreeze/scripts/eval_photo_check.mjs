// 6-photo eval for the photo_check AI moment (eng review D8).
// Usage: APP_TOKEN=... node scripts/eval_photo_check.mjs <folder>
// Name each JPEG by its expected verdict: pass_*.jpg or retake_*.jpg (e.g. pass_counter.jpg, retake_selfie.jpg).
// Prints a markdown table for the AI build log.

import { readdir, readFile } from 'node:fs/promises';
import { join } from 'node:path';

const dir = process.argv[2];
const base = process.env.API_BASE || 'https://rzp-unfreeze.vercel.app';
if (!dir || !process.env.APP_TOKEN) {
  console.error('usage: APP_TOKEN=... node scripts/eval_photo_check.mjs <folder>');
  process.exit(1);
}

const files = (await readdir(dir)).filter((f) => /^(pass|retake)_.*\.jpe?g$/i.test(f)).sort();
const rows = [];
let correct = 0;
for (const f of files) {
  const expected = f.toLowerCase().startsWith('pass') ? 'pass' : 'retake';
  const image = (await readFile(join(dir, f))).toString('base64');
  const t = Date.now();
  const res = await fetch(`${base}/api`, {
    method: 'POST',
    headers: { 'content-type': 'application/json', 'x-app-token': process.env.APP_TOKEN },
    body: JSON.stringify({ mode: 'photo_check', image }),
  });
  const ms = Date.now() - t;
  const out = res.ok ? await res.json() : { verdict: `HTTP ${res.status}`, reason: '' };
  if (out.verdict === expected) correct++;
  rows.push(`| ${f} | ${expected} | ${out.verdict} | ${out.verdict === expected ? '✓' : '✗'} | ${(ms / 1000).toFixed(1)} s | ${out.reason} |`);
}

console.log('| Photo | Expected | AI verdict | Match | Latency | AI reason |\n|---|---|---|---|---|---|');
console.log(rows.join('\n'));
console.log(`\n**${correct}/${files.length} correct.**`);
