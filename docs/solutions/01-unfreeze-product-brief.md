# QuickUnfreeze: Product Brief

*Track 1 (FSB): Razorpay in Your Pocket · Solution 1 · Non-technical brief · 12 Oct 2026*
*Evidence: [`../RESEARCH_FINDINGS.md`](../RESEARCH_FINDINGS.md), [`../SOCIAL_SENTIMENT.md`](../SOCIAL_SENTIMENT.md). Earlier, superseded solution note: [`01-unfreeze-settlements.md`](01-unfreeze-settlements.md). Build design: [`../designs/unfreeze-design.md`](../designs/unfreeze-design.md). Prototype: [rzp-unfreeze.vercel.app](https://rzp-unfreeze.vercel.app) and an Android APK. Submission set: [`../submission/`](../submission/).*

> **One line:** When a merchant's settlements are about to be put on hold, QuickUnfreeze tells them in plain language (in their own language) what will happen, why, and exactly what to do. They clear it from their phone in about 90 seconds, and then see an honest status until it's done.

### How this brief answers the challenge

| The submission should show… | Short answer | Section |
|---|---|---|
| **Who the merchant is and what they're trying to do** | Bharti, a home baker in Nagpur who runs her business from one Android phone. She wants to *keep her settlements flowing* while the RBI re-KYC deadline approaches. | [§2](#2-who-the-merchant-is-and-what-theyre-trying-to-do) |
| **How they handle it today and where the friction is** | She finds out from a missing bank credit, gets no reason, has to borrow a laptop for the dashboard, hunts for documents, then waits on tickets. There are 5 friction points and 10 pain points. | [§3](#3-how-they-handle-it-today-and-where-the-friction-is) |
| **Why mobile is the right surface** | The phone is her only business device. Push reaches her in time, DigiLocker's OTP comes to the same phone, the camera takes the one photo needed, and voice works in Marathi. Every alternative surface is part of today's problem. | [§4](#4-why-mobile-is-the-right-surface) |
| **A clear flow that finishes the task in under 2 minutes** | Notification → home card → confirm details → DigiLocker → workspace photo → Submitted. About 90 s. | [§5](#5-the-flow-done-in-under-2-minutes) |
| **The key product decisions and what we chose not to build** | 10 decisions, each with the alternative we rejected, plus 9 things deliberately left out | [§6](#6-key-product-decisions-and-what-we-chose-not-to-build) |
| **How we'd know it works** | North Star: hold-days (median days a merchant's money sits on hold, target ≤ 1). Also a KPI tree, guardrails, a staggered rollout and a 5-merchant prototype test | [§7](#7-how-we-would-measure-whether-it-works) |
| *Buildathon FAQ: "state your assumptions and how you would validate them"* | 12 assumptions, each with a validation step using real data | [§8](#8-assumptions-and-how-we-would-validate-them) |

---

## 1. The problem in one paragraph

Small merchants run their business on the money that settles into their bank every day or two. When that money is put **on hold**, whether because re-KYC is due or because a payment was flagged for review, their working capital stops. Today they usually find out late, from a missing bank credit. They aren't told **why** the money is held, **what** will release it, or **when**. The fix sits on a desktop dashboard and support is ticket-only. On Razorpay's own Play Store listing, the three loudest merchant complaints are exactly these: support can't be reached (18% of 1–2★ reviews), KYC or onboarding rejected without a reason (18%, and the most upvoted), and accounts disabled or funds held (12%). KYC/onboarding is the most upvoted *theme* (508 👍 in total), and the single most-upvoted *review* (266 👍) is a hold story. Those complaints are about risk holds and rejections. Re-KYC is the same "money stops, no reason" fear arriving for the whole base on a known date, which makes it the one instance we can **prevent**.

A predictable wave is also coming. RBI requires every payment aggregator to re-KYC all existing merchants, with the deadline reportedly moved to **15 Mar 2027**. Razorpay's own rule holds settlements **30 days before** that deadline, which puts the hold date around **13 Feb 2027** for anyone who hasn't finished. Before the extension, payment aggregators expected only about 80% of merchants to finish, and 30–35% of small informal merchants were at risk of missing the deadline.

**Why this task meets the brief:** it is **urgent** (a hard date, and money stops), **high-value** (about a week of settlements, ₹88,250 for our persona, stops until it's fixed). It is not frequent per merchant: re-KYC comes once. It is huge in aggregate, though: payment aggregators expected ~20% of merchants to miss the original deadline. The same flow then serves the frequent cases, risk holds and KYC rejections.

## 2. Who the merchant is and what they're trying to do

Each persona's first initial matches their occupation, which makes them easy to remember.

### Primary persona: Bharti the Baker · home baker, Nagpur (Tier 2) · re-KYC pending
| | |
|---|---|
| **Business** | Custom cakes and hampers. Takes orders on Instagram and WhatsApp and collects advances through Razorpay Payment Links (~₹3–4 lakh/month) |
| **Device** | Her Android phone is her only business device. There's no laptop at the kitchen counter and no CA on retainer |
| **Money habits** | Settlement money buys next week's ingredients. She has no working-capital buffer |
| **Language** | Marathi at home, Hindi with suppliers, English for official forms |
| **What she fears** | "My money stops and nobody tells me why." |

**What she's trying to accomplish (the job to be done):**
> *"When Razorpay needs something from me to keep paying me, tell me early, tell me in words I understand, and let me finish it from my phone between orders, so my settlements never stop."*

**Done, from her point of view:** "I've submitted everything, nothing will be held, and I know what happens next." The actual verification is a human review that finishes later, and the status tracker closes that loop.

### Secondary persona: Gaurav the Garment-seller · Instagram apparel seller, Lucknow · settlement already on hold
He ships ~40 orders a week through a courier. Two orders were flagged for a **risk review**, and ₹12,600 is already on hold and grows as new payments come in. His proof of delivery is in his phone gallery and WhatsApp chats. **His job:** *"Show them the orders were delivered and get my money released."* (To keep the demo to one continuous story, the prototype shows this risk-hold card on Bharti's demo account.)

### Future persona (v2): Tanvi the Tutor · freelance tutor, Indore · onboarding/KYC rejected
Her KYC was rejected with *"Not aligning terms"* and no next step, after she paid the ₹199 review fee. This is as loud in the data as holds (18% of merchant 1–2★ reviews and the most upvoted theme), and it follows the same pattern: *blocked, no reason, no next step*. QuickUnfreeze's "diagnose → what's needed → re-submit → track" flow extends to her in v2.

### Who else is affected
- **The merchant's customers:** a merchant whose settlements are held may delay orders or ask customers to pay outside Razorpay.
- **Razorpay's support and risk teams:** every unclear hold becomes a ticket, a callback and often a 1★ review.
- **Razorpay's business:** held merchants move to competitors. Reviews name Cashfree, PhonePe, PayU and Stripe as alternatives.

## 3. How they handle it today and where the friction is

### Today's workaround, step by step
```
Re-KYC email arrives (unread) ─► Tuesday's bank credit doesn't arrive ─► opens the Razorpay app: balance shows, no clear reason
  ─► searches email, asks a friend or CA ─► finds "complete re-KYC on the dashboard" ─► borrows a laptop
  ─► hunts for PAN, Aadhaar and address files, scans them ─► uploads (the dashboard flow alone is 5–10 min)
  ─► no status, no ETA ─► raises a ticket, tweets at support ─► templated reply ─► days later: released, or "one more document"
```
**Total today:** several days of money held, at least two devices, and several support contacts. **Target:** no hold at all, one device, about 90 seconds and no support contact.

### Where the friction is
| Stage | Friction | Pain points |
|---|---|---|
| **Discovery** | Finds out late, from a missing credit, because email is the only warning | P1, P9 |
| **Diagnosis** | No reason, no document list, English only, and it feels like a penalty | P2, P3, P8, P10 |
| **Action** | Desktop dashboard, physical PAN card, scanning files | P4, P5 |
| **Closure** | No status or ETA, can't reach a person, tickets closed with generic replies | P6, P7 |
| **Aftermath** | Trust damaged and the merchant thinks about switching | P10 |

### Pain points (current experience)
Ranked by how often merchants raise them and how much they hurt. Sources are in `SOCIAL_SENTIMENT.md`.

| # | Pain point | What the merchant says | Severity | Frequency |
|---|---|---|---|---|
| P1 | **Finds out too late:** the first signal is a missing bank credit | *"Settlement stopped 3 days after launch"* | High | Every hold |
| P2 | **No reason given** | *"Reason cannot be shared with you"*; *"'Not aligning terms' is too vague to solve"* | High | Most holds and rejections |
| P3 | **Doesn't know what to do or what documents are needed** | *"didn't tell us which documents is missing"* | High | Most holds |
| P4 | **The fix is desktop-only** (dashboard upload) | *"needs laptop"*, *"open documentation… switch tab to dashboard"* | Medium–High | Every re-KYC |
| P5 | **Physical-card and camera friction** (video KYC needs the original PAN card) | *"Video KYC requires the physical PAN card"* | Medium | Many re-KYCs |
| P6 | **Can't reach a human; tickets closed with generic replies** | *"Even their customer service is an artificial entity"* | High | #1 complaint overall |
| P7 | **No ETA or status after submitting**, and the status can be wrong | *"KYC under review for 3 working days, now 3 weeks"* | High | Most cases |
| P8 | **Language barrier:** official explanations only in English | In a PayNearby survey of (assisted-retail) merchants, 48% preferred a language other than English. Razorpay's online SME base is likely more English-comfortable: an assumption to test (A8) | Medium | Long tail |
| P9 | **The cost keeps growing while held**, and nobody shows it | *"Now they say settlement would take 120 days"* | High | Risk holds |
| P10 | **Feels like a penalty, not a process:** merchants assume fraud or a scam | *"Razorpay should rename itself to HoldYourMoneyPay"* | High (trust) | Common |

### Journey map: Bharti the Baker today, a re-KYC hold without QuickUnfreeze

| Stage | 1. Trigger | 2. Discovery | 3. Understanding | 4. Action | 5. Waiting | 6. Resolution | 7. Afterwards |
|---|---|---|---|---|---|---|---|
| **What happens** | Re-KYC is due; an email may be sent | Bank credit doesn't arrive on Tuesday | Searches email, opens the app: balance shown, no clear reason | Needs the dashboard on a laptop; hunts for PAN, GST and address files | Submits; no status; raises a ticket | Days later the hold is lifted, or more documents are asked for | Money arrives late |
| **Doing** | Nothing (doesn't see the email) | Checks the bank app repeatedly | Calls a friend or CA, searches online | Borrows a laptop, scans documents | Follows up by email, tweets at support | Re-uploads | Considers switching gateways |
| **Thinking** | — | "Did the customer not pay?" | "Is my account blocked? Did I do something wrong?" | "Which document do they want?" | "Is anyone even looking at this?" | "Why did this take a week?" | "This could happen again" |
| **Feeling** | 😐 unaware | 😟 anxious | 😨 scared | 😤 frustrated | 😠 ignored | 😮‍💨 relieved but bitter | 😒 distrustful |
| **Pain points** | P1 | P1, P9 | P2, P8, P10 | P3, P4, P5 | P6, P7 | P7 | P10 |
| **Touchpoints** | Email | Bank SMS | Razorpay app, Google | Web dashboard | Support ticket, X/Twitter | Email | Play Store review |

**The emotional low point is stage 3 (Understanding):** money has stopped and nothing explains why.

## 4. Why mobile is the right surface

Mobile isn't just a convenient extra channel for this task. Each step works better on the phone, and the desktop route is itself one of the pain points (P4).

| What the task needs | Why the phone wins | Desktop or other channels today |
|---|---|---|
| **Reach the merchant in time** | Push notification and a home-screen card, on the device she checks dozens of times a day | Email goes unread. The first signal today is a missing bank credit (P1) |
| **Be where the merchant is** | For a home baker or Instagram seller, the phone *is* the business: orders, payment links and customer chats all live there | The dashboard needs a laptop she doesn't have at the counter (P4) |
| **Prove identity without paperwork** | For most owner-operators the Aadhaar-linked mobile is the business phone (A6), so DigiLocker's OTP arrives **on the same phone** and auto-fills, then fetches PAN and Aadhaar with one consent tap. No physical card and no scanning | Uploading scans on desktop; video KYC needs the original PAN card (P5) |
| **Capture the one photo needed** | The camera takes the shop or workspace photo on the spot, and the quality check runs before submitting, so a bad photo doesn't bounce back days later | Find a photo, move it to the laptop, upload it, and wait to learn it was rejected |
| **Explain in her language** | Hold the mic and ask in Marathi or Hindi, and hear the answer spoken back. Voice is natural on a phone and awkward on a dashboard | English-only text and help docs (P8) |
| **Close the loop** | Status tracker, push on each change, share the confirmation on WhatsApp, and a one-tap "Talk to a person" with the case attached | Ticket emails with no status (P6, P7) |
| **Fit into a working day** | About 90 seconds between two orders, with no setup | One session needing a laptop, files and 5–10 minutes of focus |

**So what:** mobile turns re-KYC from an errand that needs a laptop and a free afternoon into a short tap-through that a merchant finishes between orders.

## 5. The flow: done in under 2 minutes

**The task, start to finish:** from the warning notification to *"Submitted ✓ Review usually done well before 13 Feb."* (If Razorpay agrees to treat a submitted re-KYC as compliant for hold purposes, A4, this becomes *"No settlement hold while we review."*)

### Timed walkthrough (as built in the prototype)

| Clock | Screen | What the merchant does | What the product does |
|---|---|---|---|
| 0:00 | **Push notification** | Taps *"Settlements on hold from 13 Feb · Your re-KYC is due. Complete it in about 90 seconds to avoid the hold."* | Opens the app straight on Home |
| 0:05 | **Home: "Action needed" card** | Sees *"N days left"* and *"₹88,250 · a week of settlements would be held"* shown as a block of ice, then taps **Complete re-KYC** | Shows the full amount at stake and the date |
| 0:15 | **Ask why, in your language** | Taps a question chip, or holds the mic and asks *"मेरा पैसा क्यों रुकेगा?"* (why will my money stop?) | AI answers in Hindi, Marathi or English and reads it aloud: an RBI rule for every merchant, nothing wrong with her account. There's no wall of text: she asks, so her attention is on the answer |
| 0:30 | **Step 1 · Confirm business details** | Checks the details and taps **Looks right**, or taps a row to edit it | Pre-filled from her account. No retyping. ⅓ of the ice melts |
| 0:45 | **Step 2 · PAN & Aadhaar via DigiLocker** | Approves the OTP (auto-filled from SMS), then consents to share | Fetches the PAN verification record and masked Aadhaar. No physical card. ⅔ melted |
| 1:15 | **Step 3 · Shop or workspace photo** | Takes one photo of her shop, stall or, as a home baker, her baking counter | AI checks for blur, glare, or the wrong subject (such as a selfie or a document) in a few seconds. If it suggests a retake, the merchant can retake it or tap **"Submit anyway, a person will review"** |
| 1:30 | **Submit re-KYC** | Taps Submit | The ice is fully melted and the money is free |
| 1:35 | **Re-KYC status** | Sees *"Submitted ✓ Review usually done well before 13 Feb"* with a reference number | Tracker: Submitted → Under review (usually 24 h) → Verified. She can also book a verification visit, share on WhatsApp, or tap *Talk to a person (case pre-filled)* |

**Time to submit:** about **90 seconds** in the prototype (our walkthrough; the 5-merchant test in §7 measures it properly). In the recorded demo it took about 50 s, including a voice question. A real DigiLocker hand-off adds an estimated 20–40 s, so it stays under 2 minutes. There are 3 steps, 0 fields to type, and no physical documents. *Scope note:* this covers a proprietor whose business proof is already on file. If a business document (Udyam, GST or shop licence) is missing, a fourth step asks for it.

**Built so the flow can't fail on stage:** every AI and voice call has a time limit and a ready answer it falls back to (canned text and a pre-recorded clip in the chosen language). On bad Wi-Fi, the merchant still finishes in the same time.

### The signature moment
The held money is shown as a **block of ice**. Each completed step melts a third of it, and on Submit it's free. The merchant *sees* their money being protected instead of filling in a compliance form. The wording stays plain ("on hold", never "frozen"), and the amount shown is always the full figure.

### Journey map: Bharti the Baker with QuickUnfreeze, preventing the hold

| Stage | 1. Early warning | 2. Understanding | 3. Action (~90 s) | 4. Submitted | 5. Review | 6. Resolution |
|---|---|---|---|---|---|---|
| **What happens** | Push notification months before the date (from 120 days out): *"Settlements on hold from 13 Feb · Your re-KYC is due. Complete it in about 90 seconds to avoid the hold."* | Home card shows the date, days left and the amount that would be held | Three steps on the phone: confirm pre-filled details → PAN & Aadhaar via DigiLocker → shop or workspace photo | *"Submitted ✓ Review usually done well before 13 Feb"* with a reference number | Honest tracker: Submitted → Under review (usually 24 h) → Verified | Push when verified; settlements keep flowing |
| **Doing** | Taps the notification | Taps a question or asks by voice in Hindi or Marathi, and hears the answer | Taps "Looks right", approves DigiLocker consent, snaps one photo | Shares the confirmation on WhatsApp if needed | Checks the tracker if curious; books a visit slot if one is required | Nothing to do |
| **Thinking** | "OK, there's a date and it's quick" | "Nothing is wrong with my account; it's a rule for everyone" | "That was easy. No PAN card hunt." | "I have proof I did it" | "I know where it stands" | "They warned me in time" |
| **Feeling** | 🙂 informed | 😌 reassured | 🙂 in control | 😊 relieved | 😐 calm | 😀 trusting |
| **Pain points removed** | P1 | P2, P8, P10 | P3, P4, P5 | P7 | P6, P7 | P10 |
| **Touchpoints** | Push / in-app banner | Home card, AI explanation, voice | Flow screens, DigiLocker, camera | Status screen, WhatsApp share | Tracker, visit booking, "Talk to a person (case pre-filled)" | Push |

### Second path: Gaurav the Garment-seller, a risk hold that has already happened

| Stage | Discovery | Understanding | Action (~30 s) | Resolution |
|---|---|---|---|---|
| **Experience** | Home shows *"₹12,600 on hold · risk review"* | Plain reason, from the **same live voice explainer** as re-KYC, in Marathi, Hindi or English: two named orders were larger than usual and are held for a routine check; her other payments keep settling. She can ask *"पैसे कधी मिळतील?"* (when will I get it?) and hear the answer. The AI is told never to mention fraud models or promise release | Picks delivery photos, chat screenshots or courier receipts from the gallery | *"Proof submitted ✓ A reviewer will check it, usually within 24 hours. New payments keep settling."* |
| **Pain points removed** | P1, P9 | P2, P3, P8, P10 | P4 | P6, P7 |

## 6. Key product decisions and what we chose not to build

### The decisions that shaped the product

| # | Decision | What we chose | What we rejected | Why |
|---|---|---|---|---|
| 1 | **Prevent, then cure** | The main flow acts *before* the hold (re-KYC due on 13 Feb). Risk holds that have already happened are a second path | Building only for merchants already on hold | Almost nobody is held for re-KYC before Feb 2027, and preventing a hold is far cheaper than releasing one. The promise becomes "your money never stops" |
| 2 | **Define "done" honestly** | Done means *submitted, nothing held, and you know what happens next*. Release follows a human review, shown in a tracker | Promising "instant unfreeze" | Verification needs a person (and sometimes a visit). Overpromising is exactly the trust problem we're fixing |
| 3 | **Confirm, don't retype** | Details Razorpay already has are pre-filled for a one-tap check | A fresh form | Retyping is where people drop off, and the data already exists |
| 4 | **DigiLocker before the camera** | PAN and Aadhaar come from DigiLocker with one consent tap | Photographing the PAN card, or video KYC | It removes the physical-card hunt (P5), and DigiLocker documents are as valid as the originals |
| 5 | **AI in exactly two moments** | (a) spoken answers to her questions, in her language, from an **extended R.A.Y.** inside the flow. Today R.A.Y. is a text Q&A assistant on the dashboard and WhatsApp; QuickUnfreeze adds voice in Hindi and Marathi, her case context (why this hold, what's needed) and follow-up "why" questions; (b) instant photo-quality check | A separate general chatbot | Razorpay has announced RAY on the dashboard and WhatsApp (A11). Bringing RAY *into the moment*, with the case context and voice, answers the question where it arises. A separate chatbot adds turns to the task, while these two moments remove steps from it |
| 6 | **AI advises, a person decides** | After a retake, **"Submit anyway, a person will review"** is always offered. AI never approves or rejects KYC | Letting the AI block submission | Regulatory and trust reasons: merchants must never feel a machine rejected them |
| 7 | **Her language, by voice** | English, Hindi and Marathi. Hold the mic, ask, and hear the answer. The language she picks wins over auto-detection | English-only text, or typed chat | P8, and many merchants are more comfortable speaking than typing |
| 8 | **Money first** | The amount at stake (the ice block) is the main element on screen, always shown in full, and each step visibly frees part of it | A compliance checklist UI | Merchants care about the money, not the form. It makes the progress felt |
| 9 | **A reason category, not model details** | *"Two orders flagged for delivery proof"* | Showing the risk score or signals | Gives an actionable answer without revealing how fraud is detected |
| 10 | **Inside the app merchants already use** | A home-screen card and flow in the Razorpay merchant app, matching its look and navigation | A separate app, or a WhatsApp-only bot | No new install or login. Camera, DigiLocker and push need the native app |

### What we chose not to build (and why)

| Not building | Why not |
|---|---|
| **Appeals for account termination**, or changes to Razorpay's risk rules | These are policy decisions, not a mobile task. We change how a hold is *communicated and resolved*, not who gets held |
| **Live chat or a support chatbot** | RAY is Razorpay's Q&A assistant. We add a **"Talk to a person"** button that arrives with the case already attached, which addresses the real complaint (P6) |
| **AI approval or rejection of KYC** | Regulated decision; the human review stays |
| **Instant-settlement upsells inside the flow** | Selling to someone whose money is about to be held would destroy trust |
| **Video KYC on the phone** | It needs the physical PAN card and a live agent slot. DigiLocker avoids both |
| **The full risk-hold flow** (prototype shows the case with the live voice explainer; the proof upload and review are mocked) | Re-KYC is the predictable, high-volume case. Risk holds reuse the same pattern next |
| **The KYC-rejection flow** (Tanvi) | v2: the same "diagnose → fix → track" pattern, after re-KYC is proven |
| **WhatsApp reminders and more languages** | The production plan warns by push, in-app card and WhatsApp from 120 days before the hold date, then at 60, 30, 14 and 7 days, plus more Indian languages. The prototype shows push and three languages |
| **A real KYC backend in the prototype** | DigiLocker, the review and the merchant data are mocked. The two AI moments (explanation/voice and photo check) are live |

## 7. How we would measure whether it works

### Headline set: one for every hold type (used in the product note)
| Metric | Definition | Target |
|---|---|---|
| **North Star: hold-days** | Median days a merchant's money is on hold, per hold case (a prevented re-KYC hold counts as 0) | ≤ 1 day (re-KYC 0; risk holds < 2 days), from days to weeks today |
| Self-serve resolution | Holds resolved in the app with no support ticket | ≥ 80% |
| Time to act | Alert → *Submitted*, any hold type | < 2 min |
| Guardrail | KYC fraud and losses on released holds | No increase |

*The hold-prevention rate below is the re-KYC driver of the North Star. The detailed tree is the diagnostic view.*


### Re-KYC driver: hold-prevention rate
**Hold-prevention rate:** the share of merchants due for re-KYC who complete it **before** their hold date. Each prevented hold counts as 0 hold-days, so this is what moves the North Star for re-KYC.
*Why it matters:* it captures the re-KYC promise (warned in time, fixed easily, money never stops) in one number that Razorpay, the merchant and the regulator all want to go up.

### KPI tree

| Layer | Metric | Definition | Baseline (assumed / to measure) | Target (first 90 days) |
|---|---|---|---|---|
| **Outcome** | Hold-prevention rate (re-KYC driver of hold-days) | Merchants with re-KYC completed before the hold date ÷ merchants due | PAs expected ~80% overall completion; 30–35% of small informal merchants at risk (industry estimates) | ≥ 90% overall; ≥ 80% for small merchants |
| Outcome | Re-KYC-related holds per 1,000 active merchants | Count of settlement holds caused by pending re-KYC | To measure | −50% vs. control group |
| Outcome | Median time from hold to release (risk holds) | From hold placed to settlement released | "Days to weeks"; 120-day holds reported | < 48 h when proof is complete |
| **Task** | Median time to submit | From opening the flow to tapping Submit | Desktop flow ~5–10 min plus document hunting | **< 2 min** (target ~90 s) |
| Task | Flow completion rate | Merchants who submit ÷ merchants who open the flow | To measure | ≥ 85% |
| Task | First-time-right rate | Submissions accepted without a re-upload request | To measure | ≥ 90% |
| Task | Mobile share of re-KYC completions | Completions on the phone ÷ all completions | ~0% (re-KYC is documented only on the web dashboard; A10) | ≥ 60% for small merchants |
| **Engagement** | Warning-to-open rate | Merchants who open the flow within 7 days of the first warning | — | ≥ 60% |
| Engagement | Days-before-deadline at completion | Median days left when merchants finish | — | ≥ 30 days |
| Engagement | Language and voice use | Share of sessions using Hindi/Marathi or a voice question | — | Track; expect ≥ 30% non-English for small merchants |
| **Support** | Hold/KYC tickets per 1,000 merchants | Support tickets tagged settlement hold, KYC or re-KYC | Top complaint theme today | −40% |
| Support | "Talk to a person" requests | Callback requests from the flow, and how fast they're handled | — | Track; callback within 4 working hours |
| **Trust** | Post-submission CSAT | "How easy was this?" (1–5) right after Submit | — | ≥ 4.3 |
| Trust | Share of 1–2★ Play reviews mentioning hold/KYC | Text-coded monthly from Play Store reviews | 12% of merchant 1–2★ reviews today (holds) | Below 6% within 2 quarters (KYC-rejection reviews tracked separately until v2) |
| **Business** | GMV kept flowing | Settlement value that would have been held but wasn't (prevented holds × avg. weekly settlement) | — | Report monthly |
| Business | 90-day retention of merchants due for re-KYC | Active 90 days after the hold date | To measure | +5 pts vs. control |

### Guardrails (must not get worse)

| Guardrail | Why it matters | Threshold |
|---|---|---|
| KYC false-accept / fraud rate | Speed must not let bad actors through | No increase vs. desktop flow |
| AI photo-check false rejections | A good photo marked "retake" frustrates honest merchants | "Submit anyway" overrides later approved ≤ 10% |
| AI fallback rate | Shows how often merchants get canned instead of live answers | ≤ 10% of AI requests |
| Verification-visit no-shows | Booking must be real and convenient | ≤ 15% |
| Wrong-language responses | A Hindi answer to a Marathi question breaks trust | ≤ 2% (sampled) |
| Notification opt-outs | Warnings must feel helpful, not spammy | ≤ 3% per campaign |

### Leading indicators to watch weekly
Warning-to-open rate · step-level drop-off (details → DigiLocker → photo) · DigiLocker failure rate · photo retake rate · time-to-first-review after submit.

### How we'd measure it
- **Experiment design:** nobody is left without a warning, because a held settlement is real harm. **Everyone** gets the early warning and the mobile flow. What we test: (a) a **staggered rollout** by cohort (week 1: 10%, then 50%, then 100%), comparing early cohorts with merchants not yet reached, and (b) a **randomised test of the extras only**: voice and plain-language AI vs. a plain-text version, and warning cadence A vs. B. Compare hold-prevention rate, holds per 1,000, tickets and retention.
- **Funnel events:** warning sent → opened → each step completed → submitted → verified, plus language, voice and AI-fallback flags.
- **Voice of the merchant:** a one-question CSAT after Submit, and the same monthly Play Store review coding we used for this research.

### For the hackathon prototype (what we can show now)
| Metric | How | Target |
|---|---|---|
| Task success | 5 merchants try the prototype on a phone, unaided | ≥ 4 of 5 submit |
| Time to submit | Stopwatch from notification tap | < 2 min |
| Comprehension | Ask: "What happens on 13 Feb, and what did you just do?" | ≥ 4 of 5 answer correctly |
| Perceived ease | "How easy was this?" (1–5) | ≥ 4 |
| Language moment | A Marathi or Hindi speaker asks a question by voice | Answer understood and in the right language |

## 8. Assumptions and how we would validate them

The buildathon allows reasonable assumptions, public information and synthetic data. **All merchant data in the prototype is synthetic** (Bharti, her payments and her settlements). These are the assumptions the product rests on, and how we'd check each one with Razorpay's real data.

| # | Assumption | What it rests on today | How we'd validate it with real data |
|---|---|---|---|
| A1 | Re-KYC deadline 15 Mar 2027, with settlements held 30 days earlier (13 Feb) | One news report (NewsBytes citing Pine Labs) plus Razorpay's documented 30-day rule. Another report says Dec 2026 | The RBI circular and Razorpay's compliance team. The date is one setting in the app |
| A2 | Merchants miss re-KYC mainly because of **friction and late awareness**, not unwillingness | Pattern in 3,538 Play reviews and 1,812 X posts; PAs expect ~80% completion | Funnel data from the current dashboard re-KYC: where do merchants drop off, and how many never open it? |
| A3 | Small merchants are **phone-first**, with no laptop at hand | Track brief; industry reports; reviews saying "needs laptop" | Share of the Razorpay merchant app's sessions vs. the dashboard's, by merchant size |
| A4 | Razorpay can treat **"submitted"** as compliant for hold purposes while the review runs | Our proposal, not current policy | Compliance and risk sign-off. Without it, the status says "Review usually done well before 13 Feb" |
| A5 | A proprietor's re-KYC needs only: confirmed details, PAN and Aadhaar, and one premises photo. A missing business proof adds one step | Razorpay re-KYC docs and RBI PA guidelines (business identity, ownership, nature of business) | Razorpay's KYC operations checklist for the merchant's constitution type |
| A6 | The Aadhaar-linked mobile is usually the merchant's business phone | Owner-operator profile | DigiLocker OTP success rate on first attempt, from the pilot |
| A7 | One week of settlements is about ₹88k for our persona (₹3–4 lakh/month) | Synthetic persona data | Distribution of weekly settlement value for merchants due for re-KYC |
| A8 | A meaningful share of merchants prefer Hindi or a regional language, and voice helps | PayNearby survey (assisted retail, 48% non-English); our persona | Language setting and voice use in the pilot; CSAT by language |
| A9 | The AI photo check helps more than it hurts | Prototype: Gemini Flash-Lite with a "submit anyway" override | Compare the AI verdict with the human reviewer's decision on the first 1,000 photos (false-retake rate ≤ 10%) |
| A10 | Re-KYC isn't possible in the Razorpay merchant app today | **Checked against Razorpay's docs (12 Oct):** the re-KYC banner and the file upload are documented only under the web *Dashboard* ([Re-KYC](https://razorpay.com/docs/payments/dashboard/re-kyc/)). The [Payments Mobile App docs](https://razorpay.com/docs/payments/mobile-app/) cover payments, settlements, refunds and first-time KYC (including Aadhaar eKYC), but no re-KYC or hold resolution | Confirm with Razorpay's product team. *Bonus finding:* the app already runs first-time KYC with Aadhaar eKYC, so QuickUnfreeze reuses capability that already exists in the app |
| A11 | RAY (Razorpay's Q&A assistant) covers general questions, so we don't build a chatbot | Razorpay announcements on X (2026) | Confirm RAY availability and scope with Razorpay |
| A12 | Merchants complete in under 2 minutes | Our walkthrough (~90 s) | The 5-merchant prototype test (§7), then median time-to-submit in the pilot |
| A13 | The public complaints reflect our segment (home and Instagram sellers on Payment Links) | Public reviews rarely say what kind of merchant wrote them: only 14 of 538 recent 1–2★ reviews self-identify as a small business, freelancer, MSME or Payment Links user, though those 14 include the 266 👍 hold review | Cut hold, KYC and ticket data by merchant segment and product (Payment Links vs. gateway) |

**Decision rules: what would change the design**
- **A2 fails** (funnel data shows most merchants never open the dashboard re-KYC, rather than dropping off inside it): the warning and its cadence matter more than the 3-step flow. Invest first in reminders, WhatsApp and the home card.
- **A4 is refused** ("submitted" doesn't stop the hold): the status copy stays "Review usually done well before 13 Feb", and the re-KYC target becomes *completion ≥ 14 days before the hold date*, so reviews finish in time.
- **A9 fails** (false-retake rate > 10% against reviewers): turn the photo check into a silent signal for reviewers, not a prompt to the merchant.
- **A10 fails** (the app already has re-KYC): QuickUnfreeze becomes an upgrade of that flow. Keep the early warning, the plain-language and voice explanation, DigiLocker and the honest status; drop the parts the app already does.

## 9. Risks and open questions (non-technical)

- **Deadline uncertainty:** the 15 Mar 2027 extension comes from one news report (another says Dec 2026), and the 30-day early hold is Razorpay's documented rule, assumed to carry over. Every date in the app, including the AI's answers, comes from one setting, so a new date is a one-line change.
- **Sensitive reasons:** risk-hold reasons can't always be fully disclosed. We show a reason *category* ("two orders flagged for delivery proof"), never fraud-model details.
- **Physical verification:** RBI requires in-person verification by the payment aggregator's staff. Booking slots only help if there's capacity behind them.
- **Already-solved check:** if Razorpay's app adds mobile re-KYC before launch, the differentiators become the early warning, the plain-language and voice explanation, and honest status.
- **Trust in AI:** merchants must never feel an AI rejected them. That's why the "submit anyway, a person will review" path and the clear prototype notices exist.

## 10. Why this wins

- It goes after **Razorpay's biggest trust problem**, backed by data: the most frequent and most upvoted complaints.
- It's **a true phone task**: notification, camera, DigiLocker, voice, under two minutes.
- It turns a compliance chore into a **moment of reassurance**: the merchant watches their money being protected.
- Each KPI ties to something Razorpay already cares about: fewer held settlements, fewer tickets, better reviews, merchants who stay.
