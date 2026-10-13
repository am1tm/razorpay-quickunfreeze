# Solution 2: "Fight This Chargeback" in 2 Minutes from Your Phone

*Track 1 (FSB): Razorpay in Your Pocket · Candidate 2 of 4 · updated 12 Oct 2026 (social-sentiment evidence)*

**One-line job:** *"A customer disputed a payment. Before the deadline, help me prove I delivered, using the proof that's already on my phone."*

---

## 1. Problem

When a customer raises a chargeback, the bank gives the merchant **about 3 business days** to respond. **No response counts as accepting the dispute**, so the merchant loses the money and pays the cost. For a small merchant:
- The notice arrives by email or dashboard, and is easy to miss.
- The evidence lives **on their phone**: WhatsApp chats with the customer, delivery photos, courier SMS, a signed bill photo.
- The response flow is **dashboard-based**, and Razorpay no longer accepts responses over email.
- They don't know **which evidence matters** for each dispute reason (e.g., "product not received" vs "unauthorised transaction").

## 2. Evidence that the problem is real

| # | Evidence | What it shows | Source |
|---|---|---|---|
| 1 | Banks give **3 business days** to represent. Failure to respond "will increase the number of chargebacks lost", and if the merchant doesn't respond, the bank assumes the dispute is accepted | A hard, short deadline, with automatic loss if missed | [Razorpay — How Razorpay helps handle chargebacks](https://razorpay.com/blog/how-razorpay-helps-you-to-handle-chargebacks/), [Razorpay Chargebacks blog](https://razorpay.com/blog/chargebacks/) |
| 2 | "Razorpay has moved all dispute management correspondence to the Razorpay dashboard. Responses received via **email will not be considered**" | The response has to happen on a surface a small merchant may not have open | [Razorpay Docs — Contest a Dispute](https://razorpay.com/docs/api/disputes/contest/) |
| 3 | Chargebacks can cost merchants **up to 2–3% of international revenue**; globally, merchants lost ~**US$100B** to chargebacks in 2023 including fees and operations | High value | [Razorpay Chargebacks blog](https://razorpay.com/blog/chargebacks/), [Razorpay Settlement Transparency 2026](https://razorpay.com/blog/settlement-transparency-the-complete-merchant-playbook-for-questioning-your-payment-gateway-in-2026) |
| 4 | Razorpay launched a **Dispute Responder Agent** (Mar 2026) that collects evidence from Razorpay, Shopify and Shiprocket and drafts responses. It is "still in beta… automating 1000s of chargeback responses" | Razorpay itself treats this as a strategic pain. The agent depends on **integrations that SMEs often don't have** | [Razorpay Newsroom — FTX'26](https://razorpay.com/newsroom/razorpay-launches-the-worlds-first-ai-native-agent-studio-for-payments-at-ftx26-powered-by-anthropics-claude/), [Razorpay engineering lead on X](https://x.com/shashank_kr/status/2041168327939432616), [Razorpay on X](https://x.com/Razorpay/status/2053715073852637486) |
| 5 | Critics raise the risk of AI hallucination in dispute evidence | Merchant review and approval is required, which supports a human-in-the-loop design | [Medianama, Mar 2026](https://www.medianama.com/2026/03/223-razorpay-launches-ai-agent-studio-questions-loom-dark-patterns-price-discrimination/) |
| 6 | Reviewers say the chargeback process "can be difficult to track", and Trustpilot complaints cite disputes alongside holds | Current UX friction | [G2 Razorpay](https://g2.com/products/razorpay/reviews), [Xflow review](https://www.xflowpay.com/blog/razorpay-review) |
| 7 | NPCI changed UPI chargeback rules (Feb 2025: auto-accept/reject on TCC/RET; Jul 2025: banks can reprocess genuine disputes beyond limits) | Disputes are becoming faster and more automated, which shrinks the merchant's time to react | [Angel One](https://www.angelone.in/news/market-updates/npci-introduces-new-chargeback-rule-for-upi-transactions), [BW Businessworld](https://www.businessworld.in/article/npci-simplifies-upi-chargeback-rules-new-framework-effective-from-15-july-561146) |
| 8 | **97%** of MSMEs run on WhatsApp, and **70%** use the smartphone as their primary business device | The proof (chats, photos) is already on the phone | [PayNearby MSME Digital Index](https://india.entrepreneur.com/news-and-trends/whatsapp-and-whatsapp-business-dominate-msme-landscape-with/476232) |
| 9 | **Social data (Play + X, Jan 2025 to Oct 2026):** few merchant posts about disputes (~5 X accounts; one ₹38,838 chargeback on Trustpilot, Sep 2026). Those that exist back up the "missed alert" premise: *"I didn't know such a dispute mechanism exists… and I don't read every email from the payment gateway"*; *"is it wise to accept the dispute? Will it cause any problems in my account?"* | The pain is real but **quiet**, and the uncertainty is about consequences, not just effort | [X](https://x.com/saybwala/status/1888883547160625194), [X](https://x.com/vvdity/status/1948048281399148863), [`SOCIAL_SENTIMENT.md`](../SOCIAL_SENTIMENT.md) §3a |
| 10 | **Chargebacks trigger holds:** *"5 chargebacks total… out of tens of thousands of orders"* led to funds on hold; *"banned our international payments just because, in 10 years, 1 customer did a chargeback"* | A lost or ignored dispute can escalate into Solution 1's problem | [X](https://x.com/kes11av/status/1957734587661959484), [X, Oct 2026](https://x.com/ajay138/status/2108737575158718826) |

**Scoring:** Urgent ●●● · Frequent ●–●● (category-dependent: higher for D2C, travel, edtech, digital goods) · High-value ●●● · Mobile fit ●●● · Current app gap ●●● · **Social signal ● (few posts; but linked to holds)**

## 3. Merchant

**Arjun, 29, runs a small D2C brand selling handmade leather wallets from Jaipur** (~₹6L GMV a month on a Razorpay Payment Page plus Instagram DMs, shipping through a local courier). He sees 2–4 disputes a month, mostly "product not received" from customers who did receive the goods. He packs orders during the day, and his proof is in WhatsApp chats and courier tracking screenshots in his gallery.

## 4. Today's flow and friction
```
Email "Dispute raised: pay_XXXX" (may land in Promotions) → sees it on day 2
  → needs laptop → logs in to dashboard → reads reason code (jargon)
  → hunts for chat screenshots on phone → emails them to self → downloads → uploads
  → writes a free-text explanation → submits on day 3, or misses it → loses ₹2,400 + fee
```
Friction: **missed alert**, **jargon**, **evidence lives on a different device**, and **no guidance on what wins**.

## 5. Proposed solution (mobile, one task, under 2 minutes)

**A push notification with a countdown opens a guided "Respond" flow.**

1. **Alert with a countdown:** *"₹2,400 dispute: 'Product not received'. 2 days 14h left to respond."* Sent by push and WhatsApp, with escalating reminders.
2. **Plain-language reason:** *"Your customer says they didn't get the order. To win, show it was delivered."* The reason code becomes a checklist of evidence that wins for this reason.
3. **Auto-attached Razorpay evidence:** payment details, customer email and phone, IP and device data, plus the order or link details. Zero effort for the merchant.
4. **One-tap phone evidence:** pick from the gallery (delivery photo, courier screenshot), **share a WhatsApp chat into the app** through the Android share sheet or chat export, or paste a tracking ID to fetch status.
5. **AI-drafted response:** a short, structured rebuttal mapped to the reason code that cites the attached evidence. The merchant **reviews, edits, and approves**. Nothing is sent without a tap.
6. **Submit, then track:** *"Submitted → Under bank review → Won / Lost"*, with the money impact shown.

Alternatively the merchant can tap **"Accept and refund"** when the customer is right, which avoids a fight they'd lose.

**Where AI helps:** reading screenshots (extracting tracking IDs, delivery dates, chat lines such as "received, thanks!"), recommending which evidence fits the reason code, and drafting the response. The merchant stays in control, which addresses the hallucination concern.

**Positioning:** this is the **mobile, human-in-the-loop front end** for long-tail merchants who lack the Shopify or Shiprocket integrations the Dispute Responder Agent relies on. It complements Agent Studio rather than duplicating it.

## 6. Product decisions (and what we are not building)
| Decision | Why |
|---|---|
| A response countdown is the main element of the screen | The deadline is the problem, so it should be the first thing the merchant sees |
| Evidence checklist per reason code | Merchants don't know what wins, and guidance raises win rate |
| Human approval required before submit | Trust, legal accountability, and hallucination risk |
| WhatsApp/gallery import over integrations | SMEs keep their proof in WhatsApp, not in Shopify |
| **Not building:** pre-arbitration or arbitration stages, bulk dispute handling, or fraud prevention | Rare for SMEs, or a different job |
| **Not building:** an auto-submit agent | That already exists (Dispute Responder); SMEs need assisted response first |

## 7. Success metrics
- **Primary:** dispute response rate before the deadline (from X% to over 90%).
- Win rate on contested disputes; ₹ recovered per merchant per month.
- Median time from alert to submit (target: under 2 minutes of active effort, under 24h elapsed).
- Share of disputes handled entirely on mobile.
- Guardrail: rate of merchant edits to the AI draft, and rejected or incorrect evidence submissions.

## 8. Risks and assumptions to validate
- ⚠️ **Assumption:** the mobile app has no dispute-response flow today. **Verify** in the app.
- ⚠️ Dispute frequency for the long-tail segment is unknown. Digital goods, travel, edtech and D2C see more disputes than service providers. **Choose the segment deliberately.**
- WhatsApp chat import differs between iOS and Android, and so do the privacy implications (customer PII).
- No public India-specific SME chargeback rate data was found, so this needs Razorpay data or interviews.
- **Validation:** interview 5 D2C or Instagram sellers ("How many disputes last quarter? How many did you respond to? Where was the proof?").

## 9. Why this could win
- It builds directly on Razorpay's own strategic direction (Dispute Responder) and extends it to the **mobile, long-tail merchant** that the integration-based agent misses.
- The deadline and countdown give a clear, dramatic flow for a 90-second demo.
- Success is measurable in money recovered.
