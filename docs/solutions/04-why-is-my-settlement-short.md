# Solution 4: "Why Is My Settlement Short?": Today's Settlement, Explained and Settled

*Track 1 (FSB): Razorpay in Your Pocket · Candidate 4 of 4 · added 5 Oct 2026 · updated 12 Oct 2026 (social-sentiment evidence; Razorpay's RAY assistant)*

**One-line job:** *"₹11,639 just landed in my bank. I sold ₹14,000. Show me where the ₹2,361 went, tell me if anything is wrong, and let me sort it out, on my phone, in under 2 minutes."*

---

## 1. Problem

Every working day, a Razorpay merchant gets **one lump-sum bank credit** covering many payments. That credit is **net of** the 2% platform fee, 18% GST on the fee, refunds (often for orders from *previous* weeks), chargebacks, and sometimes partial settlements or channel-wise splits. From **15 Oct 2026** it is also net of the new **0.4% UPI MDR**, which applies only to UPI payments above ₹2,000 and is a flat ₹5 in some categories.

The owner-operator has no finance team and no accounting software. They:
1. See a bank SMS for an amount that **doesn't match** what they think they sold.
2. Can't tell whether the gap is **normal** (fees, refunds) or **wrong** (a missed payment, a surprise deduction, an unexpected hold).
3. Are told by Razorpay to **download the Settlement Reconciliation Report**, a CSV with columns like `entity_id`, `fee`, `tax` and `settlement_id`. That's a desktop, accountant-style task.
4. End up either ignoring it ("trust and hope") or raising a ticket, which feeds the support backlog.

This is the **most frequent money moment** in a Razorpay merchant's week, and the MDR makes it harder to understand two days after the submission deadline.

## 2. Evidence that the problem is real

| # | Evidence | What it shows | Source |
|---|---|---|---|
| 1 | A Razorpay settlement "lands in the merchant bank account as a **single lumped NEFT credit covering hundreds of orders**, net of 2% MDR, 18% GST on MDR, and refund deductions". A ₹10,000 payment settles as ₹9,764 | The bank credit can't be read without unpacking it | [Terra Insight](https://www.terra-insight.com/insights/razorpay-settlement-reconciliation/) |
| 2 | Fees are **not returned on refunds**, and refund deductions hit settlements 5–7 working days later: *"a March order refund frequently reduces an April settlement"*. Razorpay names this as **common merchant confusion** | Razorpay itself recognises the timing confusion | [Razorpay — Refunds and MDR](https://razorpay.com/blog/refunds-and-mdr-in-payment-gateways/), [Razorpay Balances docs](https://razorpay.com/docs/payments/dashboard/account-settings/balances/) |
| 3 | Razorpay's FAQ answer to "How do I reconcile settlements with transactions?" is to **download daily or monthly Settlement Reconciliation Reports**. For blocked or failed settlements it says to check your email or contact support | The official path is a CSV plus email, not a mobile answer | [Razorpay Settlement FAQs](https://razorpay.com/docs/payments/settlements/faqs/) |
| 4 | More moving parts: **partial settlements** when the balance is low; **separate balances** for online, in-person (POS) and international, each settled separately; POS rental deducted from the POS balance; long-weekend delays; T+2 domestic and T+7 international | One "settlement" is really a calculation with many inputs | [Razorpay Settlement FAQs](https://razorpay.com/docs/payments/settlements/faqs/), [About Settlements](https://razorpay.com/docs/payments/settlements/) |
| 5 | **UPI MDR from 15 Oct 2026:** 0.4% on P2M UPI above ₹2,000 (cap ₹300); ₹5 flat for railways, telecom, insurance, fuel and utilities; special treatment for education; AutoPay and credit-on-UPI excluded; **no pass-through to customers** | A new deduction that varies payment by payment | [Ministry of Finance FAQ (15 Sep 2026)](https://financialservices.gov.in/sites/default/files/2026-09/FAQs---Merchant-Discount-Rate--MDR--on-Select-UPI--P2M--Transactions_0.pdf) |
| 6 | Razorpay: *"The 0.4% is separate from your gateway's platform fee… Most merchants pay **both, stacked, plus 18% GST**"* | Razorpay merchants will see an extra deduction line | [Razorpay blog, 22 Sep 2026](https://razorpay.com/blog/lowest-upi-mdr-india-2026-what-merchants-actually-pay-per-payment-gateway) |
| 7 | **41%** of merchants won't bear *any* UPI MDR and only **17%** accept 0.4% (LocalCircles, 32,796 responses, 242 districts) | Merchants will notice and push back on this deduction, and many will want to see it itemised | [LocalCircles merchant survey](https://www.localcircles.com/a/press/page/upi-merchant-survey) |
| 8 | Complaints about *"hidden charges"* and *"held my fund however they are deducting their commission"*. Razorpay's own settlement-transparency guide lists **"Hidden Fees & Net-Only Reporting"** as a top merchant pain | Unclear deductions damage trust | [ConsumerComplaints.in](https://www.consumercomplaints.in/razorpay-b115695), [Razorpay Settlement Transparency 2026](https://razorpay.com/blog/settlement-transparency-the-complete-merchant-playbook-for-questioning-your-payment-gateway-in-2026) |
| 9 | Only **29%** of MSMEs use accounting software, and **70%** use the smartphone as their primary business device | The person reading the settlement is an owner on a phone, not an accountant | [PayNearby MSME Digital Index](https://india.entrepreneur.com/news-and-trends/whatsapp-and-whatsapp-business-dominate-msme-landscape-with/476232) |
| 10 | Razorpay chose **"match my bank statement to settlements"** as a headline Agentic Dashboard capability. It is early access and web-dashboard framed | Razorpay validates the pain, but its current answer targets finance teams on a desktop | [Razorpay Agentic Platform](https://razorpay.com/blog/razorpay-agentic-platform/), [FTX'26 newsroom](https://razorpay.com/newsroom/razorpay-launches-the-worlds-first-ai-native-agent-studio-for-payments-at-ftx26-powered-by-anthropics-claude/) |
| 11 | Silent payment failures (~1.8% of digital payments; 2.2–3.4% of UPI) mean some payments the merchant *thinks* happened aren't in the settlement, and vice versa | Some gaps are real and need action, not just explanation | [IBS Intelligence](https://ibsintelligence.com/ibsi-news/silent-payment-failures-emerge-as-hidden-drain-on-indias-d2c-profits-study-shows/) |
| 12 | On X: *"Razorpay: no way to check in dashboard what you are charged for various kinds of payments"* (Jul 2026). On the Play Store: *"It is difficult to clearly understand the final deductions… fee structure very confusing"* (Jul 2026). On Trustpilot: *"pricing shown publicly differs from the deductions made"* (Aug 2026) | Merchants name fee visibility as a gap, in so many words | [X](https://x.com/IronyMeter/status/2075465873280864507), [`SOCIAL_SENTIMENT.md`](../SOCIAL_SENTIMENT.md) §3 |
| 13 | **Weekend and bank-holiday settlement gaps** on X: *"My settlements are paused for 3 days… 26th, 27th, 28th June"*; *"figure out your holiday / weekend settlement cycles. On normal days, the twice a day settlement is magic"*; instant settlement *"throws an error that your quota has been used… only 60% you can draw"* | The question "when will it land?" sits next to "why is it short?" | [X, Jun 2026](https://x.com/PranavDate/status/2070144058333245456), [X, Aug 2026](https://x.com/saybwala/status/2086016070499074320), [X](https://x.com/saybwala/status/2076196746175397966) |
| 14 | Size of the signal: fees or deductions appear in **~5%** and settlement delays in **~6%** of merchants' one-star Play reviews since 2025. PissedConsumer lists "disputes over transaction charges and settlement delays" among its top five categories | It's real but **quieter** than holds, KYC or support (12–18% each) | [`SOCIAL_SENTIMENT.md`](../SOCIAL_SENTIMENT.md) §3, [PissedConsumer](https://razorpay.pissedconsumer.com/review.html) |

**Counter-evidence (to state honestly in the pitch):** a mid-market CFO on Capterra says Razorpay's *"reporting section helps manage transaction tracking and reconciliation efficiently"* ([Capterra](https://www.capterra.com/p/179263/Razorpay/reviews/)). The pain is concentrated among **owner-operators without a finance person**, which is exactly this track's merchant. PhonePe Business already shows per-settlement details and UTR in its app ([PhonePe help](https://cms.phonepe.com/en/mx/merchant-help/settlements/know-more-about-settlements/how-settlement-works/how-do-i-track-my-settlements/)), so a list of settlements is table stakes. The difference has to be the **explanation and the resolution**.

**New competitor inside Razorpay (Jul–Sep 2026):** Razorpay's **RAY** assistant on the dashboard **and WhatsApp** answers *"How much did I collect today?"*, *"Why are my UPI payments failing?"* and *"When is my next settlement due?"*. It formats replies for chat, and its write actions (refund, settlement, KYC change) need merchant approval ([X](https://x.com/Razorpay/status/2075152799709716883), [X](https://x.com/Razorpay/status/2097916649903186231), [X](https://x.com/Razorpay/status/2097681561416323151)). **Conversational settlement Q&A is now Razorpay's own territory.** This solution can't be "ask about your settlement". It has to be the **push-triggered, itemised waterfall, the anomaly flag and the one-tap resolution**, which RAY isn't shown doing.

**Scoring:** Urgent ●● (rises from 15 Oct) · Frequent ●●● (every working day) · High-value ●● (fees are ~2.4–2.6% of revenue; the bigger cost is trust and time) · Mobile fit ●●● for one settlement · Current app gap ●● (the app lists settlements; whether it explains them is unverified; RAY covers Q&A) · **Social signal ●● (real but quieter than holds and KYC)**

## 3. Merchant

**Meera, 38, runs a boutique tailoring and ethnic-wear studio in Coimbatore.** She takes orders on WhatsApp, collects through Razorpay Payment Links and a Razorpay QR at the counter (~₹4–5L a month), and sees more and more UPI payments above ₹2,000 for bridal orders. Her CA visits once a quarter. She checks her bank SMS every morning, and when the number "feels low" she has no way to check it short of waiting for the CA.

## 4. Today's flow and friction
```
Bank SMS: "₹11,638.92 credited — RAZORPAY" → "but I sold ₹14,000 on Friday?"
  → opens Razorpay app → Settlements → taps it → sees amount/UTR (breakdown? ⚠️ verify)
  → refund from 10 days ago? chargeback? new UPI charge? → can't tell
  → asks CA (next visit: 2 months) / raises ticket / gives up
```
Friction: **mismatch shock**, **no explanation**, **timing confusion** (old refunds), **jargon** (MDR, GST on fee), and **no next step**.

## 5. Proposed solution (mobile, one task, under 2 minutes)

**Push notification when the settlement is credited → "Settlement explained" screen → resolve or confirm.**

**Worked example** (one settlement, after 15 Oct):

| Line | Amount |
|---|---|
| You sold (4 payments) | **₹14,000.00** |
| ↳ UPI ₹4,000 · UPI ₹1,500 · UPI ₹2,500 · Credit card ₹6,000 | |
| Razorpay fee (2%) | −₹280.00 |
| **New UPI charge (0.4% on 2 payments above ₹2,000)** | −₹26.00 |
| GST on fees (18%) | −₹55.08 |
| Refund to customer: order of 24 Sep | −₹1,200.00 |
| Chargeback: order of 19 Sep (disputed) | −₹800.00 |
| **Credited to your bank (UTR …4417)** | **₹11,638.92** |

1. **A one-line answer first:** *"₹2,361 less than you sold: ₹361 fees and taxes (2.6%), ₹1,200 for an old refund, ₹800 for a chargeback. Everything checks out."* Or, if not: *"1 thing needs your attention."*
2. **The waterfall** (above): gross → each deduction → net, in plain language (English, Hindi or a regional language). Old refunds and chargebacks are **linked to the original order date**, which removes the timing confusion.
3. **MDR made visible:** the new UPI charge appears as its own line with a one-tap "why?": *"From 15 Oct, UPI payments above ₹2,000 carry a 0.4% network charge set by NPCI. Payments up to ₹2,000 stay free."* The point is transparency, not avoidance.
4. **Anomaly flags** (where AI helps): compare each settlement with the merchant's usual pattern and expected fees. Flag *a fee above the contracted rate*, *a payment captured but not in any settlement*, *a hold or partial settlement*, or *a refund the merchant doesn't recognise*.
5. **Resolve from the same screen**, so the task ends with something done:
   - ✅ **"Looks right"** marks the settlement as checked (a daily habit loop).
   - ⚠️ **Chargeback line** → "Respond" (links into [Solution 2](02-chargeback-on-mobile.md)).
   - ⚠️ **Hold or partial settlement** → "Why is money held?" (links into [Solution 1](01-unfreeze-settlements.md)).
   - ❓ **"Something's wrong"** opens a support query **pre-filled** with the settlement ID, UTR and the flagged line, so the merchant doesn't have to explain it from scratch.
   - 📤 **"Send to my CA"** sends a WhatsApp-ready summary or PDF (gross, fees, GST for input-tax credit, refunds).
6. **"When does the next one land?"** A holiday-aware line: *"Next settlement Tuesday (banks are closed Sat–Mon). ₹38,400 is pending."* If the merchant wants it sooner, it shows the instant-settlement option and how much can be drawn now. This answers the weekend and holiday complaint (row 13) without building a new product.

**Where AI helps:** turning settlement data into a plain-language narrative in the merchant's language, spotting anomalies against the merchant's own history, and answering follow-ups ("why was ₹26 charged on the ₹2,500 payment but not the ₹1,500 one?"). **All numbers come from Razorpay's ledger, not from the model.** AI only explains and flags.

**Positioning against Razorpay's Agentic Dashboard:** that product is **finance-team, bulk, desktop** (upload a bank statement, reconcile many UTRs). This is **owner-facing, one settlement, mobile, push-triggered**, and it ends in an action. The two are complementary.

**Positioning against RAY:** RAY answers when the merchant *asks*. This *tells* the merchant at the moment the bank credit lands, with the full breakdown already worked out and an action to take. Framed this way, it is a proactive card that RAY could show in the future, not a rival chatbot.

## 6. Product decisions (and what we are not building)
| Decision | Why |
|---|---|
| One settlement at a time, triggered by the bank-credit moment | That's when the question comes up; bulk reconciliation is a different job and a crowded space |
| One-line answer first, details on tap | The owner wants "is it right?" in 5 seconds |
| Refunds and chargebacks linked to their original order date | Removes the most common confusion, which Razorpay itself names |
| MDR shown as its own line, labelled as an NPCI charge | Transparency builds trust, and merchants will look for it after 15 Oct |
| Every screen ends in an action (confirm, respond, escalate, share with CA) | It's a task, not an information-only dashboard, which the brief explicitly warns against |
| Ledger is the source of truth; AI only explains and flags | Explaining money with the wrong number destroys trust |
| **Not building:** bank-statement upload or multi-gateway reconciliation | That is the Agentic Dashboard's job, and a crowded idea among builders |
| **Not building:** MDR-avoidance nudges (split under ₹2,000, push cash, surcharge) | Pass-through is prohibited, and splitting games the rule. This fails on product judgement and regulation |
| **Not building:** full GST filing or accounting | Out of scope; "Send to CA" is the hand-off |

## 7. Success metrics
- **Primary:** share of settlements the merchant opens and marks "looks right" or resolves within 24h of credit.
- Fewer support tickets tagged settlement amount, deductions or "hidden charges" (especially after 15 Oct).
- Time from push to verdict (target: under 10 seconds to the one-line answer, under 2 minutes for any resolution).
- Anomaly precision: share of flags the merchant confirms as real, which should stay high to avoid alert fatigue.
- Trust proxy: NPS or CSAT on "I understand what Razorpay charges me", plus churn among merchants with high UPI volume above ₹2,000 after 15 Oct.

## 8. Risks and assumptions to validate
- ⚠️ **App gap:** the Razorpay app already lists settlements, and the docs don't say whether it shows a breakdown. **Audit the app first.** If it already shows the waterfall, the pitch shifts to *explanation + anomaly + resolution*.
- ⚠️ **MDR presentation:** how will Razorpay itemise the MDR (a separate line, or inside "fee")? Which category gets the ₹5 flat or education treatment? This is new, so the prototype needs to state an assumption.
- ⚠️ **Exemption reading:** Razorpay merchants (P2M via a payment aggregator) are *not* P2PM-exempt according to the MoF FAQ. Confirm with Razorpay.
- **Urgency is lower** than holds or chargebacks. The pitch has to rest on **frequency + MDR timing + trust**. Social data agrees: fee and settlement complaints are ~5–6% of merchants' one-star reviews, against 12–18% each for holds, KYC and support.
- ⚠️ **RAY overlap:** Razorpay's assistant already answers settlement questions on WhatsApp. If judges see this as "RAY with a nicer screen", it loses. Lead with the push-triggered waterfall and the resolution, not the chat.
- **Crowding:** judges may have seen reconciliation demos (there was a "finance controller" track in an earlier Razorpay buildathon). The owner, mobile and resolution angle has to be obvious in the first 10 seconds of the video.
- **Validation:** ask 5 merchants to show their last bank credit from Razorpay and explain it (time it, and note where they get stuck); ask a CA how often clients ask "why is this amount less?"; after 15 Oct, compare a real settlement against this waterfall.

## 9. Why this could win
- It is the **most frequent** money moment (every working day) and directly tied to a **regulatory change that goes live during the pitches**.
- It closes Razorpay's "hidden charges / net-only reporting" trust gap at the moment it is most likely to grow.
- It acts as the **hub** for Solutions 1 and 2: a hold or a chargeback first shows up as a short settlement. That gives a strong v2 story without expanding v1's scope.
- The demo is simple: SMS arrives → a waterfall that explains the gap → one tap to resolve.
