# QuickUnfreeze *for Razorpay*
*Product Note · Amit Mishra*

Prototype: [rzp-unfreeze.vercel.app](https://rzp-unfreeze.vercel.app) · Android: [rzp-unfreeze.vercel.app/unfreeze.apk](https://rzp-unfreeze.vercel.app/unfreeze.apk)

> **"My money stopped and nobody told me why" is the loudest complaint in Razorpay's Play Store reviews, across holds and KYC blocks. QuickUnfreeze turns it into a 90-second fix on the phone, starting with re-KYC, the hold every merchant will face.**

### 1 · Who the merchant is
**A no-code micro merchant who runs the business from one phone.**
- Owner-run, 1–10 people, Payment Links or QR, Tier 1–3 cities, ~₹0.5–5 lakh a month, local vernacular first.
- Settlements are their working capital, and MSMEs already have **₹8.1 lakh crore** stuck in delayed payments.¹
- **Bharti**, the baker in Nagpur (Tier 2): "Tell me **early**, in **my language**, and let me **fix it** between orders."

### 2 · Today and the friction
**She finds out from a missing bank credit, with no reason and a desktop-only fix.**
- Top themes in 498 merchant 1–2/5 Play Store reviews: unreachable support (18%), KYC rejected with no reason (18%), held funds (12%, including the top review, with 266 upvotes).
- > *"They said my account is fully activated… now they say settlement would take 120 days."* (most-upvoted review, 266 upvotes)
- Re-KYC holds start around 13 Feb\*, and **30–35%** of small merchants may miss it.²

### 3 · Why mobile
**Every step of the fix is native to the phone. The laptop route is the problem.**
- **71% of MSMEs** (84% of women entrepreneurs) run the business mainly on a smartphone.³
- **Push** reaches her months ahead, on the phone she checks all day.
- The **DigiLocker OTP** lands on the same phone and fills itself in.
- The **camera** checks the one photo before it's sent.
- **Voice:** she asks in Hindi or Marathi and hears the answer.

### 4 · The flow, under 2 minutes
**Alert → ask why → 3 steps → *Submitted ✓* in about 90 seconds.**

| 0:00 | 0:15 | 0:30 | 0:45 | 1:15 |
|---|---|---|---|---|
| Alert | Ask R.A.Y. | Confirm details | DigiLocker | Photo → Submit |

- **QuickUnfreeze, via R.A.Y.,** answers her by **voice in Hindi or Marathi**, **knows her case** (why this hold, what's needed), and handles **follow-up "why" questions**, right inside the flow.
- ₹88,250 (a week of settlements) never goes on hold. A risk hold follows the same pattern, with proof of delivery uploaded from the gallery.

### 5 · Decisions and what I didn't build
**Warn early, resolve fast; AI advises, a person decides.**
- **One pattern for every hold.** AI is used only for R.A.Y.'s answers and the photo check.

**What I didn't build, and why:**
- ✕ **AI releasing holds or approving KYC:** decisions about money and compliance need a person.
- ✕ **R.A.Y. in a side panel or a separate chat:** it sits deliberately inside the hold flow, in context, so she never leaves the task.
- ✕ **AI blocking the photo:** after one retake she can "submit anyway", and a person reviews it.
- ✕ **Exact fraud-check triggers:** they would teach fraudsters how to get past the checks. She sees a plain reason instead ("orders larger than usual") and what she needs to do.

### 6 · How I'll measure it
**One North Star for every hold: how many days the money sits on hold.**

| Metric | Target |
|---|---|
| **North Star: hold-days per case** | ≤ 1 day |
| Self-serve resolution (no support ticket) | ≥ 80% |
| Time to act (alert → Submitted) | < 2 min |
| Guardrail: fraud, losses on released holds | no rise |

**Assumptions, and how I'd validate them:**

| Assumption | How I'd validate it |
|---|---|
| The hold starts around 13 Feb | The RBI circular, and Razorpay's compliance team |
| Merchants miss re-KYC because of friction | Drop-off in the dashboard re-KYC funnel |
| "Submitted" counts as compliant | Sign-off from Razorpay's risk team. If not, the target becomes finishing at least 14 days early |
| It takes about 90 s on a phone | Five merchants, unaided, timed with a stopwatch |

**Sources:**
- Razorpay Play Store reviews (498 merchant 1–2★)
- ¹ Economic Survey 2026
- ² BusinessToday, Sep 2026
- ³ PayNearby MSME Digital Index 2025

\* This assumes the reported 15 Mar 2027 deadline holds.
