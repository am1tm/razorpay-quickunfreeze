# Solution Candidates: FSB Track

Selected from the pain-point matrix in [`../RESEARCH_FINDINGS.md`](../RESEARCH_FINDINGS.md) §3.2. Each doc has its own evidence table with sources. Social evidence (Play Store, X, Trustpilot) is in [`../SOCIAL_SENTIMENT.md`](../SOCIAL_SENTIMENT.md).

*Updated 12 Oct 2026: social-sentiment evidence added; re-KYC deadline reportedly extended to 15 Mar 2027; Razorpay's RAY assistant now answers settlement questions on WhatsApp.*

| # | Candidate | Merchant job | Urgent | Frequent | Value | Mobile fit | App gap | Social signal | Biggest risk |
|---|---|---|---|---|---|---|---|---|---|
| 1 | [QuickUnfreeze: clear a settlement hold](01-unfreeze-settlements.md) | "My money stopped. Why, and what do you need?" | ●●● | ● | ●●● | ●●● | ●●● | ●●● | Re-KYC wave moved to ~Feb–Mar 2027 (reported); hold reasons are sensitive |
| 2 | [Fight this chargeback on mobile](02-chargeback-on-mobile.md) | "Prove I delivered, before the deadline" | ●●● | ●–●● | ●●● | ●●● | ●●● | ● | SME dispute frequency unknown; overlaps the Dispute Responder Agent |
| 3 | [Paisa Aaya?: payment confirmation](03-did-i-get-paid.md) | "Customer says they paid. Did they?" | ●●● | ●●● | ●● | ●●● | ●● | ●–●● | Fake screenshots are mostly an offline problem, where Razorpay is weaker |
| 4 | [Why is my settlement short?](04-why-is-my-settlement-short.md) | "₹14,000 sold, ₹11,639 credited. Where did it go, and is it right?" | ●● (rises from 15 Oct) | ●●● | ●● | ●●● | ●● | ●● | RAY covers settlement Q&A; app may already show a breakdown; reconciliation is crowded |

## Score out of 10: fit with the Buildathon mandate

The mandate: *one merchant task, done end to end on mobile, ideally in under 2 minutes, that is urgent, frequent or high-value.* Each criterion is scored 0–10, then weighted.

| Criterion (weight) | What it asks | #1 QuickUnfreeze | #2 Chargeback | #3 Paisa Aaya | #4 Settlement explained |
|---|---|---|---|---|---|
| **Problem strength (30%)** | The best of urgent, frequent and high-value, plus how strongly the others back it up | **9**: urgent and high-value (money stopped); rare per merchant | **8**: 3-day deadline, high value; frequency depends on category | **8**: customer waiting, daily; low value per event | **7**: daily; medium value; urgency only rises with the MDR |
| **Mobile-native (20%)** | Is the phone the *natural* place for this? (camera, push, WhatsApp, away from a desk) | **9**: camera for documents, DigiLocker, push early warnings | **9**: the evidence is on the phone and in WhatsApp | **10**: at the counter, from a screenshot, in seconds | **8**: push when money lands, read at a glance |
| **Done end to end in under 2 minutes (15%)** | Can the merchant *finish* the task in the session? | **7**: submission yes; release waits on review (a tracker closes the loop) | **7**: AI draft plus review is doable; the bank decides later | **10**: verdict in about 15 seconds | **10**: verdict in about 10 seconds, resolve in under 2 minutes |
| **Evidence the problem is real (20%)** | Research, the social data, and Razorpay's own signals | **10**: the top 3 complaint themes; most-upvoted review; ~45 X accounts | **4**: few merchant posts; Razorpay built an agent for it | **4**: merchant asks for alerts, but complaints are mostly from consumers | **6**: real but quieter (~5–6% of complaints); a clear quote on fee visibility |
| **Differentiation and Razorpay gap (15%)** | Not already solved by the Razorpay app, RAY, the Agentic Dashboard or competitors | **9**: none of Razorpay's 2026 AI launches covers this; flows are dashboard-only | **6**: Dispute Responder exists (integration-based, desktop) | **4**: soundboxes and PhonePe own "did I get paid"; the app lists payments | **5**: RAY answers settlement Q&A; the app lists settlements |
| **Weighted score** | | **8.9** | **7.0** | **7.3** | **7.2** |

**How to read the scores:**
- **#1 QuickUnfreeze leads clearly (8.9).** It's the only candidate that scores high on *both* problem strength and evidence, and Razorpay hasn't touched it. Its weak spot is the end-to-end test: the merchant submits in under 2 minutes, but Razorpay's review releases the money later. The pitch should define the task as *"from 'my money stopped' to 'submitted, here's when it comes back'"*.
- **#3, #4 and #2 are close together (7.0–7.3).** The gaps are within the error of these judgements, so they shouldn't decide the order on their own:
  - **#3** scores highest on mobile-native and speed, but fits Razorpay's online base worst.
  - **#4** has the most frequent trigger and works as a hub linking to #1 and #2, a strength the score doesn't capture. It loses points because of RAY.
  - **#2** has a strong flow but the weakest evidence.
- If the app audit shows Razorpay already supports re-KYC or hold resolution on mobile, #1's gap score drops. It would still score about 8.

## Recommendation

**Build #1 QuickUnfreeze.** Non-technical product brief (journey map, pain points, KPIs): [`01-unfreeze-product-brief.md`](01-unfreeze-product-brief.md). Use #4 as the v2 story ("a short settlement is often the first sign of a hold"), and mention #2 as another way into #1 ("a lost chargeback can trigger a hold").

**Before committing**, do these checks:
1. **App audit:** install the Razorpay Payments app. Can re-KYC, holds and disputes be handled on mobile? Does a settlement show a fee, GST and refund breakdown? This is the one check that could change the ranking.
2. **Re-KYC circular:** confirm the 15 Mar 2027 extension from an RBI source, then set the early-warning dates in the prototype.
3. **Merchant interviews:** talk to 3–5 merchants. Ask whether they've ever had a hold or a KYC rejection, and what they did.
