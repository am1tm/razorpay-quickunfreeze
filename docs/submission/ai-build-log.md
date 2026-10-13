# AI Build Log: QuickUnfreeze

*Prototype: [rzp-unfreeze.vercel.app](https://rzp-unfreeze.vercel.app) · APK: [rzp-unfreeze.vercel.app/unfreeze.apk](https://rzp-unfreeze.vercel.app/unfreeze.apk)*

**In one line:** I used Claude Code as a research analyst, product sparring partner, engineer and QA tester.
- It took me from a blank folder to:
  - a problem choice backed by evidence
  - a reviewed design
  - a working Flutter app, delivered as a web link and an Android APK, with live AI and voice in multiple languages
- It took about 12 hours of working sessions. Research ran on 28 Sep, 5 Oct and 9 Oct; the build, the docs and both reviews all happened on 12 Oct.
- The engineering review estimated about 6 days for a human team. Every product call was mine. The AI did the legwork, and argued with me.

---

## 1. AI tools and models used

| Tool / model | Role |
|---|---|
| **Claude Code**, running **Claude Opus/Sonnet** in the terminal | Main collaborator: research, review scraping and coding, solution scoring, design and engineering reviews, all the Flutter and API code, builds, deploys, on-device QA |
| **gstack**  | Structured workflows: `office-hours` (problem framing and premise challenges), `plan-eng-review` (architecture decision ledger D1–D10), `browse` / `scrape` (headless browser for research and web QA), `setup-browser-cookies` (my logged-in X session for collecting posts) |
| **Claude subagents** | (a) a cold-read "second opinion" on the design; (b) two **independent judge** runs against the published judging criteria and the challenge PDF |
| **Google Gemini 3.x Flash-Lite**, free tier (falls back to Flash if Lite is unavailable) | *Inside the product:* spoken answers to the merchant's questions, and the photo-quality check |
| **Sarvam AI**: Saaras v3 (speech-to-text) and Bulbul v3 (text-to-speech) | *Inside the product:* voice questions and spoken answers in Hindi, Marathi and English |
| **Frontend-slides** (skill) | Used to create the demo video presentation slides|

**Other external services and data:**
- Flutter 3.38, Vercel (serverless function and hosting), and Android SDK tools.
- Public data only:
  - 3,538 Google Play reviews of the Razorpay Payments app (in `docs/data/`)
  - 1,812 public X posts
  - Trustpilot and PissedConsumer ratings
  - news reports and Razorpay's public docs
- I tried Reddit, but it blocked automated access, so it isn't in the data. I did read a few threads on merchants' top concerns by hand, and they matched what the Play Store reviews showed.
- DigiLocker is a **mock**.

## 2. Key prompts, workflows and agent setup

**Setup**
- Claude Code session in the project folder.
- A global instruction sends all web browsing through gstack's headless browser, so my own Chrome stays out of it.
- API keys live only in Vercel environment variables. The app carries only a build-time token.
- Claude drove a Pixel phone over USB to install builds, trigger notifications, tap through the flow and take screenshots.

**Workflow:** research → voice of the merchant → choosing the problem → design (`office-hours`) → engineering review (`plan-eng-review`) → build → on-device QA → look and feel → docs → independent review → fixes → second review.

**Key prompts (verbatim)**

| Stage | My prompt |
|---|---|
| Research | *"Razorpay company research - what it does, products, merchants, what do they target, etc. I need you to do research for indian merchant pain points. What is something that is: urgent, frequent or high value. Do a competitive landscape analysis - how merchants are different for these competitors, what are the different product lines, etc. NOTE: DONT JUMP TO SOLUTIONING"* |
| Research | *"what about the MDR kicking in for UPI, anything worth there?"* → *"Update research and add the 4th candidate."* |
| Voice of the merchant | *"run a sentiment analysis and find what's the top 10 most complained and requested feature for razorpay on twitter and other social media"* |
| Choosing the problem | *"Out of 10, score each solution which best fits the Buildathon mandate of solving a merchant problem on mobile natively (urgent, frequent or high value)."* |
| Design | *"/gstack brainstorm the #1 solution - unfreeze/clear a settlement hold"* |
| Design | *"instead of claude API, I'll use gemini 3.5 lite to validate the photo"* · *"We do something with speech? Like using sarvam ai to cater in local languages"* |
| Look and feel | *"the text around the melting ice graphic should be fixed. I want the look and feel of the app to match the real Razorpay app. Check the screenshot and ensure the look and feel, menu etc all look exactly like Razorpay"* |
| Review | *"create an independent agent to review my solution"*, with the track brief and judging criteria pasted in |
| Review | *"go through the buildathon pdf and ensure we are aligning to everything"* |

## 3. One AI output I rejected, and why

**The AI's time limit broke the voice feature.**
- **What happened:** the AI gave Sarvam's speech-to-text a 2.5 s time limit. Real spoken questions from my phone ran past it, so the app skipped Gemini and played a saved answer every time, with no error shown.
- **What I found:** when I timed each stage live, both services worked and returned correct Hindi, so the fault was the limit itself.

| Stage | Live time | Limit before |
|---|---|---|
| Sarvam speech-to-text | 1.0–2.5 s for a short clip, longer for a real question from a phone | **2.5 s**, too tight |
| Gemini answer | ~0.9 s | 5 s |
| Sarvam text-to-speech | 2.4–3.5 s | within a 9 s answer budget |

- **Why I rejected it:** the tests used short clips, so the limit passed every one of them. On a real phone it turned R.A.Y.'s voice feature into a canned reply.
- **What changed:** the speech-to-text limit is now 5 s, and voice questions get live answers on the phone.

**Other outputs I overrode or corrected**

*Ice-metaphor copy:* the first build said settlements would "freeze" ("QuickUnfreeze now"). I rejected it: *"the ice thingy looks a bit too childish and doesn't convey in simple language the product feature, it should say your settlement can be on hold."* All copy now says *"on hold"*. Only the ice visual stayed.

*Three engineering-review recommendations*

| Decision | AI recommended | I chose | Why |
|---|---|---|---|
| D2: hold explanation | Bundled text, to save free-tier quota | **Live Gemini** | The live AI moment is part of the demo |
| D3: rate limiting | A per-IP limit | **None**; a token check plus fallbacks | Not worth the build time in a prototype |
| D6: voice question length | 8 s | **15 s** | Real merchants ramble, so I accepted the fallback risk |

*R.A.Y. badging:* I asked for the voice answers to carry Razorpay's R.A.Y. assistant badge (text only, no logo). Section 4 covers what the extended version adds.

*Auto-explanation removed:* the AI-written paragraph explaining the hold was accurate, but I cut it. It was a wall of text, and it pulled attention from what I wanted merchants to try: tapping a question or asking by voice, then hearing the answer in their language.

*Persona naming:* the AI first made "Ray the Registered"-style names. I corrected the rule so the initial matches the *occupation*: Bharti the Baker, Gaurav the Garment-seller, Tanvi the Tutor.

*What the independent judge caught*
- **First run:**
  - the held amount was today's balance, not a week of settlements
  - a home baker was being asked for a shop-front photo
  - dates were hard-coded in 10 places
  - a 50/50 holdout would have left half of merchants exposed to a hold
  - there was no assumptions list
- **Second run:**
  - the app promised *"No settlement hold while we review"*, a Razorpay policy that hasn't been agreed
  - the demo's default language didn't match the persona


## 4. What AI did vs. what I decided or built

**The AI's first plan for clearing a hold** (`docs/solutions/01-unfreeze-settlements.md`)
- The merchant finds out after the money has stopped: *"₹48,200 is on hold because your re-KYC is pending. We need 2 things."*
- A text explanation, mapped from internal hold codes, with an English/Hindi toggle.
- A camera-first checklist: snap PAN, address proof and a shop-front photo, with AI checking each image.
- Submit, then a tracker.

**How I changed it**

| What I changed | From the AI's plan | To what's built | Why |
|---|---|---|---|
| **Merchant's language, by voice** | English/Hindi text toggle | Hold the mic and ask in Hindi or Marathi; Sarvam turns speech into text, Gemini answers from the merchant's case, Sarvam speaks it back. The app opens in Hindi, Marathi is one tap away, and the language the merchant picks wins over auto-detection | A home baker in Nagpur is more at home speaking Hindi or Marathi than reading English. My prompt: *"We do something with speech? Like using sarvam ai to cater in local languages"* |
| **The merchant asks, the AI answers** | An AI paragraph explaining the hold, shown up front | No paragraph. The merchant taps a question chip or asks by voice, and follow-up "why" questions work too | Merchants skip a wall of text. When they ask, their attention is on the answer |
| **R.A.Y., extended** | A standalone "Why this is happening" card | Answers carry Razorpay's R.A.Y. badge, extended with voice, the merchant's case and follow-ups, inside the hold flow | R.A.Y. already exists on the dashboard and WhatsApp; a new chatbot would be one more thing to learn |
| **Warn early** | Main scenario: money already on hold; warnings only 45 days ahead | The main flow is prevention: a push months before the 13 Feb hold date, cleared in ~90 s | Proposed by the AI's cold-read reviewer; I accepted it, since no one is held for re-KYC yet |
| **One pattern for every hold** | Re-KYC only; other holds got a reason and a document request | The ₹12,600 risk hold uses the same voice explainer in the merchant's language, then proof of delivery from the gallery | Re-KYC is predictable, risk holds aren't, and both cause the same "money stopped, no reason" fear |
| **Plain words** | "Freeze" and ice copy | "On hold" everywhere, with the app restyled to match the real Razorpay app | Serious language for a moment about the merchant's money |


**Who did what, stage by stage**

| Stage | AI did | I decided or did |
|---|---|---|
| Research | 67 web searches and 37 page reads; a sourced pain-point matrix across ~12 problems | Told it not to jump to solutions; cut a meaningless competitor row; pushed it to look at UPI MDR, which became candidate #4 |
| Voice of the merchant | Scraped and coded 3,538 Play Store reviews and 1,812 X posts into themes, with counts, upvotes and quotes | Asked for it; gave it my X session cookies |
| Choosing the problem | Four solution briefs, scored out of 10: QuickUnfreeze 8.9, Paisa Aaya 7.3, Settlement explained 7.2, Chargeback 7.0 | Chose #1: clear a settlement hold |
| Design | Forcing questions, premise challenges, a wireframe, and a subagent second opinion | Ice visual plus a mock Razorpay app (web and APK); re-KYC as the main flow; AI in only two moments; Gemini for the photo check; Sarvam for voice; accepted the challenge that made the main flow *prevention* |
| Engineering review | 10 architecture decisions, each with a recommendation | Decided all 10; overrode 3 |
| Build | ~5,100 lines: the Flutter app (17 files), the API function, 9 tests (4 API, 5 app). Android toolchain set up without admin rights; Vercel deploy; installed on my Pixel | Tested on my phone; supplied keys via Vercel; chose Flash-Lite and raised the voice time budget after live measurements |
| Look and feel, docs | Restyled to match my recordings of the real app; wrote the brief, note and video script; designed the logo | Recorded the reference videos; rejected the copy; set the persona rule; kept Razorpay's logo and my real account data out |
| Review | Two independent judge runs | Asked for them; chose which findings to act on |

## 5. Known limitations, risks and verification steps

### 5a. AI limitations and risks

**AI inside the product**
- **Gemini can say something wrong with confidence.** In testing, a Hindi answer about the risk hold implied the money would arrive within 24 hours, when it's the review that usually takes 24 hours. The prompt now says a reviewer usually checks within 24 hours, never promises release, and never says settlements resume on the hold date.
- **Wrong script or language.** Gemini once answered Marathi in Roman letters. The prompt now asks for Devanagari, and the language the merchant picks overrides what speech-to-text detects.
- **Saying too much.** For the risk hold, the AI is told to describe the reason only as "a routine check because the orders were larger than usual" and never to mention fraud models, risk scores or internal signals.
- **The photo check can be wrong.** It could ask an honest merchant to retake. It never blocks: *"Submit anyway, a person will review"* always appears after one retake. AI never approves KYC or releases a hold.
- **Quota and latency.** Gemini and Sarvam run on free or credit-limited plans with no rate limit (my choice, D3). If quota runs out on judging day, every AI moment falls back to canned text or a pre-recorded clip. The app labels these "saved answer", so nothing is hidden.

**AI in how I built it**
- **Research and review coding.** The AI ran the web research and coded the 3,538 Play Store reviews and 1,812 X posts into themes. The theme shares (18%, 18%, 12%) come from its coding.
- **Same model, both sides.** Claude wrote the code and Claude subagents judged the submission, so the review isn't fully independent.
- **Defaults that pass tests can fail on a phone.** The 2.5 s speech-to-text limit passed every test and still broke voice on my Pixel (section 3).
- **Estimates.** The ~6-day human-team estimate and the ~90 s time to submit come from the AI's review and my own walkthrough, with no timed user tests.

### 5b. How I verified the AI's work

- **Automated tests:** 4 API tests and 5 app tests. They cover:
  - fallbacks when the AI or speech calls fail
  - oversized audio returning 413
  - the chosen language overriding the detected one
  - the transcript being shown back
  - the risk-hold case falling back to its own clip in the chosen language
- **Live latency, measured on 12 Oct (Marathi speech is the slowest):**

  | Call | Time |
  |---|---|
  | ask (Gemini) | 1–8 s at first; **1.1–2 s** after switching to minimal thinking |
  | speech-to-text | ~2.1 s |
  | text-to-speech | 3.7–5.0 s |

  This led to a combined answer-and-speech budget of 9 s and answers capped at 25 words. With the speech-to-text limit later raised to 5 s (section 3), a voice question gets 14 s in total.
- **On a real device (Pixel 6a, 12 Oct):**
  - notification tap → flow
  - a question chip answered live and spoken in Marathi, with the question shown
  - details → DigiLocker → photo: the live AI said *"too dark"* for a dark frame, then I used *submit anyway* → Submitted
  - risk hold: three question chips about the ₹12,600 hold answered live in Marathi (1.1–1.3 s for the answer step)
- **On the web:** the same flow in a headless browser at phone size, including the in-app alert banner and editable details. On desktop, the web build shows a phone mockup with a side panel explaining the demo, a QR code and the APK link.
- **Checking the AI's research claims:** "Re-KYC isn't in the Razorpay app today" was checked against Razorpay's public docs on 12 Oct. Re-KYC (the banner and the upload) is documented only under the web Dashboard; the mobile app docs list first-time KYC (with Aadhaar eKYC) but no re-KYC.
- **Two independent judge runs**, with the findings listed in section 3.

**Problems that live testing found (and the fixes)**
- Voice answers were falling back to saved clips without any error, because speech generation took 3.7–5 s against a 3.5 s budget. Fix: one shared 9 s budget for the answer and speech, and answers capped at 25 words.
- Gemini sometimes took up to 8 s for a short answer, because the Gemini 3 models "think" by default. Fix: request minimal thinking, which brought it to 1.1–2 s, with a retry without the setting if a model rejects it.

### 5c. Prototype limitations

- **No merchant interviews yet.** What I know about merchants comes from public reviews and posts. The "today" journey for a re-KYC hold is inferred, because the wave hasn't hit yet.
- **Mocked parts:** DigiLocker, the KYC review, visit booking and the status tracker, which never advances to "Verified".
- **The hold date (13 Feb 2027) is derived:** one news report gives the 15 Mar 2027 deadline, and Razorpay's 30-day rule is assumed to carry over. Another report says Dec 2026.
- **Policy dependency:** the experience works best if Razorpay treats a *submitted* re-KYC as compliant for hold purposes (brief assumption A4). The app says *"Review usually done well before 13 Feb"* and doesn't promise no hold.
- **Time to submit (~90 s)** is from my walkthrough. The recorded demo took about 50 s from alert to Submitted, including a voice question.

*Evidence trail:*
- research: `docs/RESEARCH_FINDINGS.md`, `docs/SOCIAL_SENTIMENT.md`
- options: `docs/solutions/README.md`
- design and decision ledger: `docs/designs/unfreeze-design.md`
- code: `unfreeze/`
