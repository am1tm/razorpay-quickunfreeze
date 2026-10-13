# Solution 1: "Unfreeze": Clear a Settlement Hold from Your Phone

> **Superseded (12 Oct 2026):** an earlier solution note. The current version is [`01-unfreeze-product-brief.md`](01-unfreeze-product-brief.md); figures here (for example ₹48,200 "on hold") are out of date.

*Track 1 (FSB): Razorpay in Your Pocket · Candidate 1 of 4 · updated 12 Oct 2026 (social-sentiment evidence; re-KYC deadline extension)*

> Product brief with journey map, pain points and KPIs: [`01-unfreeze-product-brief.md`](01-unfreeze-product-brief.md). Build design: [`../designs/unfreeze-design.md`](../designs/unfreeze-design.md).

**One-line job:** *"My money has stopped coming. Tell me why, tell me exactly what you need, and let me give it to you right now from my phone."*

---

## 1. Problem

When Razorpay holds a merchant's settlements, whether for pending **re-KYC**, a risk flag, a documentation gap or a volume spike, the merchant's working capital stops. Today the merchant:
1. Notices late, usually when the bank credit doesn't arrive (settlement is T+2 by default).
2. Isn't told clearly **why** or **what document** will release the hold.
3. Is directed to the **desktop dashboard** or told to **"contact support"**, which is ticket-only, slow and template-driven.
4. Has no **ETA** and no status after submitting.

The most predictable trigger is **regulatory re-KYC**. Under Razorpay's own rules, settlements go on hold **30 days *before*** the re-KYC deadline if it is incomplete.

**Timing update (12 Oct 2026):** the RBI has reportedly **extended the merchant re-KYC deadline by six months, from 15 Sep 2026 to 15 Mar 2027**. This was said by Pine Labs at GFF 2026 and reported by NewsBytes; I haven't found an RBI circular yet. If Razorpay keeps its 30-day rule, the **re-KYC hold wave moves to around 13 Feb 2027**. That's after the pitch, which is still a good moment to launch a prevention flow. The case for this solution no longer rests on the deadline anyway: social data (§2, rows 10–13) shows holds, account suspensions and KYC rejections **all year round**.

## 2. Evidence that the problem is real

| # | Evidence | What it shows | Source |
|---|---|---|---|
| 1 | RBI PA Master Directions (15 Sep 2025) require **full re-KYC and due diligence for all existing merchants**, including physical verification by PA employees. Deadline: **15 Sep 2026, reportedly extended to 15 Mar 2027** | A one-time regulatory obligation that applies to every merchant (plus periodic re-KYC afterwards) | [Khaitan & Co summary](https://www.khaitanco.com/sites/default/files/2025-10/ERGO%20-%20PA%20Master%20Directions%20-%203%20Oct%202025.pdf), [Mondaq](https://www.mondaq.com/india/financial-services/1726232/rbi-master-directions-2025-compliance-and-operational-challenges-for-payment-aggregators) |
| 2 | PAs asked the RBI for an extension. They expect only **~80%** completion, and **30–35% of small informal merchants** may miss the deadline. "Most of the affected merchants are small and informal". The RBI reportedly granted **six more months (to 15 Mar 2027)** | The pain is concentrated in the SME long tail, which is this track's user. The extension delays the wave but doesn't remove it | [BusinessToday, 4 Sep 2026](https://www.businesstoday.in/latest/corporate/story/payment-aggregators-seek-more-time-from-rbi-to-complete-merchant-re-kyc-report-553334-2026-09-04), [Free Press Journal](https://www.freepressjournal.in/business/payment-aggregators-seek-rbi-extension-for-merchant-re-kyc-deadline), [VARINDIA](https://varindia.com/news/rbi-kyc-deadline-likely-to-disrupt-upi-payments-for-millions-of-small-merchants), [NewsBytes: extended to 15 Mar 2027](https://www.newsbytesapp.com/news/business/rbi-extends-merchant-re-kyc-deadline-to-march-15-2027/tldr) |
| 3 | Razorpay's re-KYC policy: **settlements on hold 30 days before the deadline**, account moves to "Live Disabled" at 30 days past it, and is disabled at 60 days. The flow is done **on the dashboard** (5–10 min: details, PAN, business type, uploads) | Money stops *before* the merchant is out of compliance, and the fix sits on a desktop surface | [Razorpay Re-KYC docs](https://razorpay.com/docs/payments/dashboard/re-kyc/) |
| 4 | Razorpay docs: if a settlement is held for risk reasons, merchants "should **contact the support team**" | No self-serve route to resolve a hold | [Razorpay Settlements docs](https://razorpay.com/docs/us/payments/settlements/dashboard) |
| 5 | Trustpilot **1.4/5** (450+ reviews, 73% one-star), dominated by "accounts limited during compliance reviews, settlements held for weeks or months, and templated replies" | Holds are the top driver of trust damage | [Trustpilot](https://www.trustpilot.com/review/razorpay.com), [Xflow review 2026](https://www.xflowpay.com/blog/razorpay-review) |
| 6 | Merchant quotes: *"Settlement stopped 3 days after launch"*; *"account permanently disabled citing ToS violation without specific reasons"*; a founder on r/indianstartups called it *"a complete disaster for my business… funds blocked while Razorpay demanded documentation"* | The pain is felt and voiced in the merchants' own words | [PissedConsumer (1.7/5)](https://razorpay.pissedconsumer.com/review.html), [Xflow review](https://www.xflowpay.com/blog/razorpay-review) |
| 7 | Support is ticket-only: *"no way of reaching their team on call or chat"*; *"raised more than 12 complaint tickets"* | The current fallback channel is the bottleneck | [Trustpilot](https://www.trustpilot.com/review/razorpay.com), [Capterra](https://www.capterra.com/p/179263/Razorpay/reviews/) |
| 8 | **70%** of retail MSMEs use the smartphone as their primary business device, and **97%** use WhatsApp | The fix has to work on the phone | [PayNearby MSME Digital Index](https://india.entrepreneur.com/news-and-trends/whatsapp-and-whatsapp-business-dominate-msme-landscape-with/476232) |
| 9 | ₹8.1 lakh crore is stuck in delayed MSME payments, against a 73-day average cycle | SMEs have no working-capital buffer, so a held settlement hurts immediately | [Business Standard](https://www.business-standard.com/budget/news/delayed-payments-continue-to-hit-msmes-8-1-trillion-stuck-eco-survey-126012901139_1.html) |
| 10 | **Play Store (our coding of 887 reviews since Jan 2025):** the top three merchant complaints are **support unreachable (18%)**, **onboarding/KYC rejected without a reason (18%; most upvoted, 508 👍)** and **account disabled or funds held (12%)**. Together they make up the bulk of merchants' one-star reviews | This is the loudest pain in Razorpay's own app store, not a niche one | [`SOCIAL_SENTIMENT.md`](../SOCIAL_SENTIMENT.md) §3, [Play listing](https://play.google.com/store/apps/details?id=com.razorpay.payments.app) |
| 11 | The **most-upvoted review in the dataset (266 👍)** is a hold story: *"they said my account is fully activated and as soon as the payment was received, they just turned my account down. Now they say settlement would take 120 days."* Another: *"Reason cannot be shared with you"* | Other merchants recognise this exact experience | Play Store, Jul and Oct 2025 ([dataset](../data/play_reviews_razorpay_payments.csv)) |
| 12 | **X, Jan 2025 to Oct 2026:** ~17 merchant accounts posted about holds or suspensions, and ~28 about KYC being stuck or rejected. *"suspended for 'suspicious activity' with zero proof… money is stuck for 120 days"*; *"5 chargebacks… out of tens of thousands of orders… losing lakhs of rev a day"*; *"Application rejection without any specific reason… 'Not aligning terms' is too vague to solve"* | The same pain shows up on a second channel, from founders and D2C owners | [X, Dec 2025](https://x.com/AswinAswin1111/status/1999024857368162535), [X](https://x.com/kes11av/status/1957734587661959484), [X, May 2026](https://x.com/krishnan_pandya/status/2055195456465150019) |
| 13 | The top **requests** across Play and X are the reverse of these complaints: **(1) a reachable human, (2) a specific reason plus a way forward when frozen, (4) KYC errors that say what's wrong, with a re-apply option**. One reviewer said *"Amazon… gives options to recover account"*. Video KYC *"requires the physical PAN card"* | Merchants are asking for the diagnose → act → track flow this solution provides | [`SOCIAL_SENTIMENT.md`](../SOCIAL_SENTIMENT.md) §4, [X, Aug 2026](https://x.com/Gourav_jain_7/status/2085950513317839068) |

**Scoring:** Urgent ●●● · Frequent ● (rare per merchant, but large in aggregate, especially in the re-KYC wave now expected around Feb–Mar 2027) · High-value ●●● · Mobile fit ●●● · Current app gap ●●● · **Social signal ●●● (loudest and most upvoted complaint cluster)**

## 3. Merchant

**Bharti, 34, runs a home-baking and cake-order business in Pune.** She takes orders on Instagram and WhatsApp, collects advances through Razorpay Payment Links (~₹3–4L a month), and uses the money to buy ingredients the same week. She has no laptop at the kitchen counter and no CA on retainer. She finds out about the hold when Tuesday's settlement doesn't arrive.

## 4. Today's flow and friction
```
Bank credit missing → opens app: balance shows but "on hold" (maybe)
  → no reason / no doc list → searches email for Razorpay mail
  → finds "complete re-KYC on dashboard" → needs laptop, finds PAN/GST/address proof as files
  → uploads → no status, no ETA → raises ticket → waits days → templated reply
```
Friction: **discovery** (late), **diagnosis** (no reason), **action** (desktop plus document hunting), **closure** (no tracker).

## 5. Proposed solution (mobile, one task, under 2 minutes)

**"Unfreeze" is a guided, camera-first resolution flow that opens from a push notification or a red banner on the home screen.**

1. **Early warning (before the hold).** Push and WhatsApp messages at T−45, T−35 and T−31 days: *"Your settlements will pause on 13 Feb unless you update KYC. Takes 2 minutes."* Prevention beats cure.
2. **Plain-language diagnosis.** *"₹48,200 is on hold because your re-KYC is pending. We need 2 things."* The screen shows the amount, the reason, and the exact items needed. The reason maps from internal hold codes to a short list of merchant-readable causes.
3. **Pre-filled checklist.** Details Razorpay already has (name, PAN, bank, business type) are shown for **confirm or edit**, not retyping.
4. **Camera-first evidence.** Snap PAN, address proof or the shop front. On-device checks for blur, glare and crop, plus document-type detection. Where possible, fetch through **DigiLocker / Aadhaar eKYC** instead of a photo.
5. **Submit, then live tracker.** *"Submitted 11:42 → Under review (usually 24h) → Settlement released."* Push notifications at each step. The ETA reflects actual review SLAs.
6. **If physical verification is needed**, book a visit slot in the app. RBI requires PA employees to do it in person.

**Where AI helps:** document classification and quality checks (reducing rejection loops), and translating internal hold reasons into plain language in English, Hindi or a regional language. AI is **not** used to decide the hold or approve the KYC; compliance stays with humans and existing systems.

## 6. Product decisions (and what we are not building)
| Decision | Why |
|---|---|
| Re-KYC is the first and best-supported hold reason; other reasons get diagnosis and a doc request only | Highest volume, predictable, and the required documents are standardised |
| Pre-fill and confirm, never retype | Most data already exists, and retyping is where people drop off |
| Show a reason **category**, not risk-model details | Avoids revealing fraud signals while still giving the merchant an answer |
| Tracker with an honest ETA | The anxiety comes as much from silence as from the hold itself |
| **Not building:** appeals for account *termination*, a support chat, or a redesign of the KYC back office | Out of scope; these are policy decisions, not a mobile task |
| **Not building:** instant-settlement upsells inside the flow | Selling to someone whose money is frozen would destroy trust |

## 7. Success metrics
- **Primary:** median time from hold to settlement release (target: days → under 48h for re-KYC holds).
- Share of at-risk merchants who finish re-KYC **before** the hold starts (prevention rate).
- Flow completion rate, and time to submit (target: under 2 minutes).
- First-time-right rate (submissions not rejected for doc quality).
- Fewer support tickets tagged "settlement on hold" / "KYC".
- Guardrails: no rise in fraud or KYC false-accepts; merchant churn after a hold.

## 8. Risks and assumptions to validate
- ⚠️ **Assumption:** the current mobile app has no full re-KYC or hold-resolution flow. **Verify** by installing the app; the docs only describe the dashboard.
- ⚠️ **Deadline reportedly extended to 15 Mar 2027** (one source; confirm the RBI circular). This changes urgency, not whether the problem exists. Periodic re-KYC continues every 2 years for high-risk merchants and every 8 years for others, and non-KYC holds and suspensions happen all year. **Pitch framing:** lead with the year-round hold and suspension pain from the social data, and present the Feb 2027 re-KYC wave as the launch window.
- **Adjacent pain, out of scope for v1:** onboarding rejections with no reason given are as loud as holds (18% of Play complaints, ~28 X accounts). It's the same "diagnose → what's needed → re-submit → track" pattern, so it's a natural v2.
- Hold reasons other than KYC may be legally sensitive to disclose.
- DigiLocker and eKYC consent flows add steps, so they need a UX test.
- **Validation:** ✅ review-mining tally done (Play + X + Trustpilot, see [`SOCIAL_SENTIMENT.md`](../SOCIAL_SENTIMENT.md)). Still to do: 5–8 merchant interviews ("Have you had settlements held? What happened?") and an attempt to complete re-KYC on a phone.

## 9. Why this could win
- It goes after **Razorpay's #1 trust problem**, which is backed by data. Holds, suspensions and KYC rejections are the most frequent and most upvoted merchant complaints on the Play Store and X. It also lines up with the **re-KYC wave expected around Feb–Mar 2027**.
- None of Razorpay's 2026 AI launches (RAY, Vulcan, Dispute Responder, Smart AML Screener) addresses the "I'm blocked, tell me why and what to do" moment.
- It is clearly a mobile task: camera, notifications, and a merchant who is away from a desk.
- The judges can see judgement in what it deliberately leaves out.
