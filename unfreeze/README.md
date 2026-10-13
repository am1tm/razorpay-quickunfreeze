# QuickUnfreeze: concept prototype

The Flutter app (web + Android) and its Vercel API. See the [main README](../README.md) for the product.

- **Live web:** https://rzp-unfreeze.vercel.app (best at phone width)
- **Android APK:** https://rzp-unfreeze.vercel.app/unfreeze.apk
- **What's live:** Gemini Flash-Lite answers and photo-quality check; Sarvam speech-to-text and text-to-speech (Hindi, Marathi, English)
- **What's mocked:** all merchant data (synthetic), DigiLocker, the KYC review and the visit booking

## Run it
```bash
flutter pub get
flutter run --dart-define=APP_TOKEN=<token>        # app (Android or Chrome)
npm test && flutter test                           # API and app tests
```
`api/index.js` is one Vercel function. It needs the `GEMINI_API_KEY`, `SARVAM_API_KEY`, `APP_TOKEN` and (for Android analytics) `GA_API_SECRET` environment variables. Every AI call has a timeout and a canned fallback (`lib/api.dart`, `lib/fixtures.dart`).

## Layout
- `lib/main.dart`, `lib/screens/`: home, the re-KYC flow, the status screen, and the risk-hold teaser
- `lib/fixtures.dart`: synthetic data, canned answers and the one hold-date setting
- `api/index.js`: the AI and voice proxy
- `scripts/eval_photo_check.mjs`: photo-check eval

Product docs live in `../docs/` (brief, research and the submission set).
