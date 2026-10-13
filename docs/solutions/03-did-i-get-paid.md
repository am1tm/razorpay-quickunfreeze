# Solution 3: "Paisa Aaya?": Instant, Trustworthy Payment Confirmation

*Track 1 (FSB): Razorpay in Your Pocket · Candidate 3 of 4 · updated 12 Oct 2026 (social-sentiment evidence)*

**One-line job:** *"My customer says they've paid. In 10 seconds, tell me for certain whether the money is mine, pending, or never arrived, and what to tell them."*

---

## 1. Problem

The most frequent moment of payment anxiety for a small merchant comes when the customer says **"I've paid"** and the merchant has to decide whether to hand over the goods, start the work, or confirm the booking. Today:
- **Silent failures:** the customer's account is debited but the merchant gets no confirmation. These show up as "failed" or "pending" and later reverse or succeed.
- **Fake screenshots:** fraudsters show edited "Payment Successful" screens. NPCI's advice is to *verify in your own app*, which is slow with a customer waiting.
- **Matching:** with many payments of similar amounts, finding *this* customer's payment in a list is hard.
- When something is wrong, the merchant can't tell the customer **what happens next** (auto-refund? how long?).

## 2. Evidence that the problem is real

| # | Evidence | What it shows | Source |
|---|---|---|---|
| 1 | **~1.8%** of digital payments fall into a reconciliation gap where the customer is debited but the merchant isn't notified (Phi Commerce study). Other estimates: **2.2–3.4%** of UPI payments fail silently | A meaningful share of real payments are ambiguous | [IBS Intelligence](https://ibsintelligence.com/ibsi-news/silent-payment-failures-emerge-as-hidden-drain-on-indias-d2c-profits-study-shows/) |
| 2 | Case: a fashion brand saw **402 "failed"** payments in a sale, of which **74 were actually successful debits** | "Failed" doesn't reliably mean failed | [IBS Intelligence](https://ibsintelligence.com/ibsi-news/silent-payment-failures-emerge-as-hidden-drain-on-indias-d2c-profits-study-shows/) |
| 3 | UPI processed **24.51 billion transactions** in Aug 2026 (~₹29.8 lakh crore), and fake-payment scams have grown alongside, hitting "shopkeepers, delivery agents and small online sellers hardest" | Frequency and fraud exposure | [PhonePe Business — fake UPI scams](https://business.phonepe.com/articles/fake-upi-payment-scams-how-to-identify-and-prevent-fraud), [Whalesbook](https://www.whalesbook.com/news/English/tech/Fake-UPI-Scams-Trick-Merchants-Costing-Millions-with-Fake-Proof/69e8a6cdbca97ee1069f7d22) |
| 4 | Real cases: a Ghaziabad kirana lost **₹2,400** after accepting a fake PhonePe screen (Mar 2026); a jeweller in Muvattupuzha lost **₹16,000** of jewellery (Sep 2026); in Basti, two people were arrested over a fake **₹9,090** SBI YONO screenshot (Sep 2026) | A recurring, current, real loss | [Onmanorama, 1 Sep 2026](https://www.onmanorama.com/news/kerala/2026/09/01/google-pay-scam-jewelry-theft-muvattupuzha.html), [ScamShield case study](https://scamshieldai.in/blog/case-study-fake-upi-payment-screenshot-scam), [Indian Pay Calculator](https://www.indianpaycalculator.in/govt-news/fake-upi-payment-screenshot-scam-shopkeepers-verify-2026) |
| 5 | NPCI advises merchants to verify credits **in their own bank or UPI app**, not screenshots or payer-shown SMS | The fix is "check your own ledger", which needs to be fast and certain | [PhonePe Business guide](https://business.phonepe.com/articles/fake-upi-payment-scams-how-to-identify-and-prevent-fraud) |
| 6 | Merchants will **pay rent** for this certainty: Paytm has **~7M+ soundboxes** and PhonePe sells SmartSpeaker voice alerts | Proven willingness to pay for "did I get paid?" confirmation | [Paytm Soundbox](https://business.paytm.com/soundbox), [PhonePe SmartSpeaker](https://www.phonepe.com/business-solutions/offline-merchant/smartspeaker/) |
| 7 | Razorpay reviews: *"Most payments get stuck, payment link does not work"*; *"Razorpay doesn't refund money even on transaction reversal"* | Razorpay merchants feel this today | [Trustpilot](https://www.trustpilot.com/review/razorpay.com), [PissedConsumer](https://razorpay.pissedconsumer.com/review.html) |
| 8 | "Delays in the reversal of failed transactions" is among the most common complaints to RBI ombudsman offices, and ~42% of complaints (2021-22) related to digital payments | A systemic, long-running pain | [Business Standard editorial](https://www.business-standard.com/amp/opinion/editorial/addressing-grievances-124031401222_1.html), [Moneylife](https://www.moneylife.in/article/194-lakh-banking-ombudsman-complaints-044-percentage-compensation-payout-complaints-against-private-banks-surge-past-psbs/79029.html) |
| 9 | **Social data (Play + X, 2025–26):** merchants ask for **instant payment alerts and a live transaction view**: *"When we receive any payment. We dont get notification in app"* (Play, Jun 2025); *"no option for live transactions. No option to see yesterday's transaction"* (Play, May 2026); payment *"deducted from users… no update/webhook… nothing visible on dashboard"* (X, May 2026). But most "debited but failed" posts come from **consumers**, not merchants | The merchant-side signal is moderate. The loudest voices are consumers | [`SOCIAL_SENTIMENT.md`](../SOCIAL_SENTIMENT.md) §4, [X](https://x.com/stockmock_in/status/2054414319811752172) |

**Scoring:** Urgent ●●● (customer waiting) · Frequent ●●● (daily) · High-value ●● (small per event, large in aggregate) · Mobile fit ●●● · Current app gap ●● · **Social signal ●–●● (alerts requested; complaints mostly consumer-side)**

## 3. Merchant

**Rahul, 41, runs a coaching institute and a stationery counter in Indore.** Parents pay fees through a Razorpay QR or Payment Link, often ₹2,000–15,000, sometimes at the counter and sometimes from home. Several times a week a parent says "I paid yesterday, it's showing debited". Rahul scrolls through the app's payment list looking for the amount, can't find it, and either trusts them (and risks the money) or argues (and risks the relationship).

## 4. Today's flow and friction
```
Customer: "Paid ho gaya" (shows screenshot) → merchant opens app → payments list
  → scrolls/filters by amount (many ₹5,000s) → not found / shows "failed"
  → is it fake? pending? failed-but-debited? → no answer, no next step
  → trust blindly, or argue, or ask customer to pay again (double-debit risk)
```

## 5. Proposed solution (mobile, one task, under 2 minutes, usually under 15 seconds)

**A "Verify payment" action, one tap from the home screen.**

1. **Three ways in:** (a) **upload or share the customer's screenshot**, (b) type the amount plus an approximate time, or (c) enter the customer's phone number or the UTR.
2. **Screenshot reading:** extract the UTR/transaction ID, amount, time and payee from the screenshot, then **match it against Razorpay's ledger**.
3. **A clear verdict:**
   - ✅ **Received**: "₹5,000 from Sunita S., 10:42 today. Settles to your bank on 7 Oct."
   - ⏳ **Pending at bank**: "The bank hasn't confirmed yet. Usually resolves within X hours. Don't hand over goods yet." Auto-notify the merchant when it resolves.
   - ↩️ **Failed and auto-refunding**: "Customer's money returns to their account by DD/MM." Share a ready message with the customer.
   - ⚠️ **No matching payment**: "This screenshot doesn't match any payment to you. The UTR or payee differs." A fraud warning, with no accusation.
4. **Share with the customer:** a one-tap WhatsApp message containing a receipt or status explanation in the customer's language.

**Where AI helps:** OCR and understanding of screenshots from many UPI apps and banks, fuzzy matching (amount, time window, payer name or VPA), and **detecting mismatches** (wrong payee VPA, impossible timestamp, a UTR that doesn't exist). The verdict is always backed by Razorpay's ledger, never by AI guesswork alone.

## 6. Product decisions (and what we are not building)
| Decision | Why |
|---|---|
| One verdict, with four states only | The merchant has seconds to decide; give a clear answer rather than more data |
| Ledger is the source of truth; AI only parses and matches | Avoids false "Received" verdicts, which are the costliest error |
| A "what to tell the customer" message for every state | The relationship is half the problem |
| Pending → auto-notify on resolution | Removes the need to keep re-checking |
| **Not building:** a soundbox, hardware, or full reconciliation | A different job; Razorpay's Agentic Dashboard already covers bulk reconciliation |
| **Not building:** verification of payments made to *other* PSPs | We can only verify Razorpay's own ledger |

## 7. Success metrics
- **Primary:** median time to a verdict (target: under 15 seconds).
- Share of verifications resolved with a definitive verdict (not "unknown").
- Fewer support tickets about payment status, failed-but-debited payments, or "customer says paid".
- Fake screenshots caught (merchant-reported losses avoided).
- Weekly active use of Verify per merchant (frequency).
- Guardrail: false "Received" rate, which must be near zero.

## 8. Risks and assumptions to validate
- ⚠️ **Fit with Razorpay's base:** fake screenshots are mostly an **offline/QR** problem, where PhonePe and Paytm dominate. The online and link merchant mainly has the **silent failure / pending** problem. **Choose the segment** (e.g., tuition, clinics, service businesses on Razorpay QR or links) and frame it accordingly.
- ⚠️ Razorpay's app may already show payment status well. **Audit** search and filter by UTR or phone.
- Screenshot formats vary a lot by app and bank, so parsing accuracy needs testing.
- Smaller per-event value than Solutions 1 and 2. The pitch relies on **frequency**.
- **Validation:** shadow 2–3 counter merchants for an hour, count the "I paid" moments, and test 30 real screenshots for parsing accuracy.

## 9. Why this could win
- It is the **most frequent** of the three tasks, a daily habit-forming loop, and it fits the under-2-minute bar easily.
- The demo is clear: customer screenshot → verdict in seconds.
- Its weakness is a less direct fit with Razorpay's online-first merchant base, which needs careful segment framing.
