# Razorpay Build Challenge — FSB Track: Research Findings

*Compiled 28 Sep 2026 · updated 5 Oct 2026 (UPI MDR, verified against the Ministry of Finance FAQ; settlement-explanation evidence) · updated 12 Oct 2026 (social-sentiment analysis of 3,538 Play reviews and 1,812 X posts, in [`SOCIAL_SENTIMENT.md`](SOCIAL_SENTIMENT.md); re-KYC deadline extension; Razorpay's RAY assistant). Research only. Solution candidates live in [`solutions/`](solutions/README.md).*

**Track recap (Track 1, "Razorpay in Your Pocket"):** a mobile experience that lets an **Indian SME merchant** finish **one** important business task end to end, ideally in **under 2 minutes**. The task should be **frequent, urgent, or high-value**. Judges score: problem importance, depth of merchant understanding, prioritisation, AI-assisted build, and communication.

> **Confidence note:** third-party "stats" sites give conflicting figures for Razorpay (merchant counts range from 5M to 12M+). Where numbers conflict I show the range and prefer primary or reputable press sources. Anything marked ⚠️ needs verification before it goes on a slide.

---

## 1. Razorpay — Company Snapshot

### 1.1 Key numbers
| Metric | Value | Source quality |
|---|---|---|
| FY25 revenue | ~₹3,783 Cr (+65% YoY); gross profit ₹1,277 Cr (+41%) | Press (Medianama, Samco) |
| FY25 net result | Loss of ~₹1,206 Cr, driven by one-off ESOP/redomiciling costs | Press |
| Annualised TPV | ~US$180B | Multiple secondary sources |
| Businesses served | Claims range from "50 lakh+" (Razorpay's own listings) to 8M+ and "12M+ onboarded" ⚠️ | Conflicting |
| RazorpayX Payroll | 40,000+ businesses | Secondary |
| Razorpay Capital | ~US$620M+ disbursed ⚠️ | Secondary |
| Status | Redomiciled to India; preparing for an IPO | Press |

### 1.2 What Razorpay does: product lines
| Line | Products | Who it serves |
|---|---|---|
| **Payments (core)** | Payment Gateway (100+ modes), **Payment Links**, Payment Pages, Payment Buttons, **QR Codes**, Invoices, Smart Collect, Subscriptions / UPI AutoPay, International Payments, Magic Checkout (1-click + COD/RTO tools), Optimizer, TokenHQ, Instant Settlements, Webstore | D2C/e-commerce, SaaS, edtech, freelancers, SMEs |
| **Offline** | Razorpay POS (card/UPI terminals) | Physical retail |
| **Business banking (RazorpayX)** | Current Account, Payouts, Payout Links, Escrow+, Tax Payments, Source-to-Pay, Payroll, Bank Account Verification | Finance teams at SMEs and startups |
| **Credit (Razorpay Capital)** | Line of Credit, working capital, Digital Lending 2.0 | SMEs needing cash flow |
| **AI (launched at FTX'26, 12 Mar 2026)** | **Agent Studio** (built on Anthropic's Claude Agent SDK): Abandoned Cart Conversion, Dispute Responder, Subscription Recovery, Cashflow Forecaster. **Agentic Experience Platform:** Agentic Onboarding (5 min, down from 30–45), **Agentic Dashboard** (natural-language ops such as "match this bank statement to my settlements"), Agentic Integration (under 10 min). **Later in 2026:** **RAY**, an AI assistant on the dashboard **and WhatsApp** (*"How much did I collect today?… When is my next settlement due?"*; write actions need approval), **Vulcan**, a payments foundation model for routing, fraud and disputes (Aug 2026), and **Smart AML Screener** (Aug 2026) | All; mostly the desktop dashboard, and now WhatsApp through RAY |
| **International** | Curlec (Malaysia), US, Singapore ⚠️ | Cross-border |

### 1.3 How Razorpay makes money
- Payments MDR / platform fee: **Standard plan 2% + 18% GST (~2.36% effective)**; no setup fee or AMC.
- **Instant / on-demand settlement is a paid add-on** (up to ~1% extra). Default settlement is **T+2** working days (the RBI PA Directions cap it at T+1 for UPI-type flows).
- SaaS/banking fees (RazorpayX, Payroll), lending interest and origination fees, and value-added services.
- Current acquisition hook: **0% platform fee for new merchants** activated from 1 Jul 2026, up to ₹5L GMV or 90 days.
- **New: UPI MDR from 15 Oct 2026 (verified).** **0.4% on P2M UPI payments above ₹2,000**, capped at ₹300 from ₹75,000. Razorpay confirms it **stacks on top of its 2% platform fee, plus GST**. Razorpay's standard merchants are **not** covered by the small-merchant exemption. Full detail and implications are in **§3.3**.

### 1.4 Who Razorpay targets
- **Historical core:** online-first businesses (startups, D2C, SaaS, edtech, marketplaces) that integrate the gateway through APIs.
- **Long tail:** freelancers, creators, tutors, home bakers and small service firms who **never integrate an API** and use Payment Links, Pages, QR and the mobile app. The app is marketed to "freelancers and individuals… registered and unregistered businesses".
- **Offline:** POS-led physical retail, where Razorpay is weaker than PhonePe, Paytm and Pine Labs.
- **Implication for this track:** the "SME merchant on a phone" is most likely a **no-code, long-tail Razorpay merchant** who collects money through links or QR, or a **small D2C owner** watching their business from their phone.

### 1.5 The Razorpay mobile app today (baseline)
The "Razorpay Payments for Business" app (Android and iOS) supports:
- A home screen with **settlement balance**, a 7-day payments chart and a floating **"New Payment Link"** button
- Tracking payments, settlements and refunds; capturing payments; cancelling links
- **One-tap refunds**
- Creating and sharing Payment Links over WhatsApp, SMS and email
- Generating and sharing API keys
- Faster activation ("within minutes")

**What the app does not (visibly) do, going by the public listing and help docs.** Treat these as hypotheses to check in the actual app:
- Dispute/chargeback response with evidence upload (a desktop dashboard flow; the bank window is **~3 business days**)
- **Re-KYC** (the docs say "Update KYC on your dashboard")
- Settlement-hold resolution: the docs tell the merchant to "contact support"
- Reconciliation (the Agentic Dashboard demo is desktop-first)
- Follow-ups and reminders on unpaid links

**What merchants say about the app itself (Play Store, 887 written reviews since Jan 2025; 2.5★ average for written reviews, against 4.1★ overall):**
- **Forced re-login with an OTP every time the app opens** (~7% of merchant complaints). Users ask for MPIN or biometric login: *"What is the point of having a mobile app if I have to sign in (with 2FA) every single time"* (X, Dec 2025).
- **Slowness, hangs and a frozen Transactions tab** (~12%): *"feels more like opening a website inside a browser frame"* (Sep 2026).
- **Missing data:** no day-wise or "yesterday" revenue, only 90 days of history in the app, and the **Oct 2026 UI update** removed stats and graphs (*"Many stats are missing"*, 6 Oct 2026).
- Any prototype should open straight to the task, with no OTP wall, and feel native. Details in [`SOCIAL_SENTIMENT.md`](SOCIAL_SENTIMENT.md).

---

## 2. Who the Indian SME merchant is and how they behave

| Insight | Data | Source |
|---|---|---|
| The phone is the business device | **70–71%** of retail MSMEs say the smartphone is their *primary* business device (**84%** of women entrepreneurs) | PayNearby MSME Digital Index (10,000+ MSMEs) |
| WhatsApp is the operating system | **97%** of MSMEs use WhatsApp or WhatsApp Business | PayNearby |
| Low back-office tooling | Only **29%** use accounting software, **17%** POS, **14%** CRM | PayNearby |
| Barriers | 36% hesitate to adopt new tech; 18% worry about cost | PayNearby |
| Language | 52% prefer English, 21% Hindi, the rest other regional languages | PayNearby |
| UPI dominates | UPI is ~62% of gateway volume and ~73% of India's digital transaction volume | Mordor, Razorpay blog |
| Working capital stress | **₹8.1 lakh crore** stuck in delayed MSME payments (Economic Survey 2026); the average payment cycle is **73 days** against a 45-day norm | Business Standard, Whalesbook |
| Fear of chasing customers | Most MSMEs don't escalate late payments because they fear losing the customer | MSME Samadhaan coverage |

**Working persona sketch (to validate):** an owner-operator running 1–10 people. They collect through UPI QR and payment links sent on WhatsApp, check the phone for "paisa aaya kya?" dozens of times a day, keep no finance team, and treat settlement money as their working capital for stock and salaries.

### 2.1 Merchant demographics: what's public (added 12 Oct 2026)

Razorpay doesn't publish a merchant-count split by city tier, income or education. Its own site gives different totals depending on the page ("1,50,000+ businesses" on the homepage on 12 Oct 2026; "50 lakh+" in older listings; "12M+ onboarded" in press). So the profile below is built from proxies and labelled as such.

| Dimension | Best available data | Source (quality) |
|---|---|---|
| **City tier** | **54%** of Razorpay's digital transaction *volume* came from SMBs in Tier 2/3 cities (2020). Tier 2/3 cities made up **50%+** of all online transactions on Razorpay in early 2021. No merchant-*count* split is published | [Razorpay newsroom, 2020](https://razorpay.com/newsroom/razorpay-registered-3x-growth-in-payment-volume-through-smbs-that-went-online-for-the-first-time-during-covid-in-2020/); [The News Minute, 2021](https://www.thenewsminute.com/article/digital-payments-india-grew-76-last-12-months-razorpay-report-147056) (company data, dated) |
| **Business size** | Nationally, **63.1M of 63.4M MSMEs are micro (1–10 people)**. A modelled estimate puts ~62% of Razorpay customers at under 50 employees | [Statista / MSME data](https://statista.com/statistics/1420022/india-estimated-distribution-of-msme-by-nature-of-activity); iDataLabs (modelled, low quality) |
| **Income / turnover** | Unincorporated (micro) enterprise output is **~₹4.9 lakh per year (~₹41k/month)** per establishment. Value added per worker is **₹1.50 lakh/year**: ₹1.81 lakh urban vs ₹1.14 lakh rural (2023-24). Razorpay's long-tail merchants who collect online sit above this median; our persona's ₹3–4 lakh/month is the upper end | [MoSPI ASUSE 2023-24, PIB](https://www.pib.gov.in/FactsheetDetails.aspx?Id=149090); [Dataful](https://insights.dataful.in/articles/indias-unincorporated-sector-is-becoming-more-service-driven) (official) |
| **Women and home sellers** | **68%** of women selling online are in Tier 2 cities; **28%** are homepreneurs; social media is **39%** of their online selling (Shiprocket, n=1,900). **41%** of 9,000 women entrepreneurs on Meesho were homemakers; **60%+** of Meesho's entrepreneurs are in Tier 3+ | [Entrepreneur India (Shiprocket)](https://india.entrepreneur.com/news-and-trends/women-entrepreneurs-in-smaller-cities-leading-the-charge/347143); [YourStory (Meesho)](https://yourstory.com/2022/03/meesho-survey-women-entrepreneurship-career-business) (platform surveys, dated) |
| **Device** | **71%** of MSMEs run the business mainly on a smartphone; **84%** of women entrepreneurs | PayNearby MSME Digital Index 2025 (survey) |
| **Education** | No national or Razorpay split found. ASUSE notes that urban entrepreneurs are better educated than rural ones. IFMR finds fixed-store merchants significantly more educated than other merchant types. The World Bank Micro Firms Survey (India, 2022) has an owner-education variable in its microdata | [World Bank microdata](https://microdata.worldbank.org/catalog/6495/variable/F1/V49?name=mb12); [IFMR LEAD](https://ifmrlead.org/?p=7740) (gap) |

**Target segment for QuickUnfreeze (derived):**
- **Who:** long-tail, no-code Razorpay merchants. Owner-operated micro businesses (1–10 people) that collect through Payment Links, QR or razorpay.me rather than an API integration.
- **Where:** Tier 1 to Tier 3 cities. Tier 2/3 carries over half of SMB volume.
- **Profile:**
  - often women home sellers and service providers (bakers, tutors, boutique and Instagram sellers)
  - monthly collections roughly **₹0.5–5 lakh**
  - **phone-first**
  - fluent in WhatsApp, UPI and a regional language, but not in dashboards or English compliance forms
- **Education:** assumed literate, not necessarily English-first. This is why the product leads with **voice in Hindi or Marathi**, not text.
- **Validate with Razorpay data:**
  - KYC business type and city tier of merchants due for re-KYC and of merchants with risk holds
  - app language settings
  - the share using Payment Links / QR only


---

## 3. Merchant Pain Points

### 3.1 Evidence by theme

**A. Settlement holds, fund freezes and account suspension.** This is the most severe issue and the one that most damages trust.
- It dominates negative reviews: Trustpilot rates Razorpay **1.4/5** (453 reviews, 73% one-star) and PissedConsumer **1.7/5** (462 reviews). Typical reviews: *"Settlement stopped 3 days after launch"*, *"account permanently disabled citing ToS violation without specific reasons."*
- Triggers include unusual volume spikes, documentation gaps and risk flags. Razorpay's docs say a held merchant should "contact the support team".
- Merchants usually can't see **why** the hold happened, **what document is needed**, or **when** the money will be released.
- **Social data (12 Oct 2026):** holds and suspensions make up **12%** of merchants' 1–2★ Play reviews since 2025. The **most-upvoted review in the dataset (266 👍)** is a hold story (*"Now they say settlement would take 120 days"*). On X, ~17 merchant accounts posted about holds, including suspensions *before a single transaction* and international payments banned after *"1 customer did a chargeback"* in 10 years.

**B. Regulatory re-KYC. The deadline has reportedly moved to 15 Mar 2027.**
- The RBI PA Master Directions (15 Sep 2025) require **full re-KYC and due diligence for every existing merchant**, including business identity, beneficial ownership and the nature of goods. The deadline was **15 Sep 2026**, and **physical verification must be done by the PA's own employees**.
- Early Sep 2026: PAs (Paytm, PhonePe, Google Pay) asked the RBI for an extension. They expected **~80%** completion by the deadline, and an estimated **30–35% of small informal merchants** may not complete. **Update (12 Oct 2026):** the RBI has reportedly **extended the deadline by six months to 15 Mar 2027**. This was said by Pine Labs at GFF 2026 ([NewsBytes](https://www.newsbytesapp.com/news/business/rbi-extends-merchant-re-kyc-deadline-to-march-15-2027/tldr)); there is no RBI circular yet ⚠️. Entrackr separately mentions a December 2026 completion date, so dates differ between sources. If Razorpay keeps its 30-day rule, the re-KYC **hold wave moves to around 13 Feb 2027**.
- Razorpay's own re-KYC rules: **settlements are placed on hold 30 days *before* the deadline** if re-KYC is pending, the account moves toward **"Live Disabled"** at 30 days past the deadline, and it is disabled at 60 days. The flow takes about 5–10 minutes, is **desktop-dashboard based**, and involves reviewing details, PAN and business type, then uploading documents.
- This pain point affects the whole base, and failure means money stops arriving. After the extension it is **less urgent this month**, but it's still a big wave in early 2027, and periodic re-KYC continues after that.

**C. Customer support is hard to reach.** This is the most common complaint in every review source.
- Reviews say: *"never replies the mails, ticket raises"*, *"no way of reaching their team on call or chat"*, *"raised more than 12 complaint tickets."* Support is ticket-only, with no phone.
- Support pain amplifies A, B and D: the problem hurts, and then the merchant can't find out what is happening.
- **Social data:** it's the #1 theme in merchants' 1–2★ Play reviews (**18%**), and ~20 merchant accounts complained about it on X. The few who praise support almost all name a **dedicated account manager**, which small merchants don't get. *"Even their customer service is an artificial entity"* (X, Sep 2026).

**D. Payment status uncertainty: silent failures, pending payments and "was I paid?"**
- Phi Commerce study: **~1.8%** of digital payments fall into a reconciliation gap where the customer is debited but the merchant gets no confirmation. Other estimates put **2.2–3.4% of UPI** payments as failing silently. In one sale, a brand saw 402 "failed" payments, **74 of which were actually successful debits**.
- Reviews also say *"Most payments get stuck, payment link does not work."*
- For an SME this means an awkward customer conversation ("I paid!" / "It doesn't show"), orders held back, and double-charge refund requests.

**E. Settlement visibility: "Why is this settlement short?"**
- Each settlement is **one lump-sum NEFT credit covering many payments**, net of the 2% platform fee, 18% GST on that fee, refunds and chargebacks. A ₹10,000 payment settles as ₹9,764 ([Terra Insight](https://www.terra-insight.com/insights/razorpay-settlement-reconciliation/)).
- **Timing mismatches:** refunds are deducted from *future* settlements 5–7 working days later, so *"a March order refund frequently reduces an April settlement"*. Fees are **not returned** on refunds, which merchants commonly misunderstand ([Razorpay blog](https://razorpay.com/blog/refunds-and-mdr-in-payment-gateways/), [Balances docs](https://razorpay.com/docs/payments/dashboard/account-settings/balances/)).
- More moving parts: partial settlements when the balance is low, separate balances for online, in-person (POS) and international payments (each with its own settlement), device rental deducted from the POS balance, and long-weekend delays ([Settlement FAQs](https://razorpay.com/docs/payments/settlements/faqs/)).
- **Razorpay's official answer to "how do I reconcile?" is to download the Settlement Reconciliation Report**, a CSV with fields like `entity_id`, `fee`, `tax`, `on_hold` and `settlement_id`. That is a desktop, accountant-style task. Only **29%** of MSMEs use accounting software.
- **From 15 Oct 2026, the new UPI MDR adds a deduction that varies payment by payment.** It applies only to UPI payments above ₹2,000 and is a flat ₹5 for some categories, so the same-looking day can settle differently (see §3.3).
- The mobile app *does* list settlements ("tap a settlement to view more details"), but the docs don't say whether it shows a per-payment breakdown or explains deductions ([mobile docs](https://razorpay.com/docs/payments/mobile-app/track-manage/view-settlements/?preferred-country=IN)) ⚠️ verify in the app.
- Razorpay's **Agentic Dashboard** does "Intelligent Reconciliation": upload a bank-statement screenshot and it flags discrepancies. It is **early access** and web-dashboard framed ([Razorpay blog](https://razorpay.com/blog/razorpay-agentic-platform/)). Independent builders have also made web reconciliation tools, one of them for an earlier Razorpay AI Buildathon "AI Finance Controller" track. **Bulk reconciliation for finance teams is crowded. Explaining a single settlement to the owner on a phone is not.**
- Complaints mention *"hidden charges"* and *"held my fund however they are deducting their commission"* ([ConsumerComplaints.in](https://www.consumercomplaints.in/razorpay-b115695), [Trustpilot](https://www.trustpilot.com/review/razorpay.com)). Counterpoint: a mid-market CFO on Capterra praises the reporting for reconciliation, so the pain is concentrated among **owner-operators without a finance person**.
- **Social data:** *"Razorpay: no way to check in dashboard what you are charged for various kinds of payments"* (X, Jul 2026). Fee and settlement complaints are **~5–6%** each of merchants' 1–2★ Play reviews, real but quieter than A, B and C. X adds a specific pain: **weekend and bank-holiday settlement gaps** (*"My settlements are paused for 3 days"*), and an instant-settlement quota that leaves *"only 60% you can draw"*.
- **Razorpay's RAY assistant** (dashboard and WhatsApp, 2026) now answers *"When is my next settlement due?"*. Conversational settlement Q&A is covered. Proactive, itemised explanation plus resolution is not shown.

**F. Refunds**
- Complaints about *"refunds not processed"*, *"2 months for a refund"* and reversals that never reach customers. The merchant carries the reputational cost with their own customer.

**G. Chargebacks and disputes**
- The bank response window is **~3 business days**, and a missed deadline means an automatic loss. The evidence (invoices, delivery proof, chats) usually sits **on the merchant's phone and in WhatsApp**. Reviewers call the chargeback process "difficult to track".
- Chargebacks can cost up to **2–3% of international revenue**. NPCI changed UPI chargeback rules (Feb and Jul 2025) toward automated acceptance and rejection, which gives merchants less room for manual intervention.
- Razorpay built a *Dispute Responder Agent*, so this is a known, strategic pain.

**H. Collecting money that is owed (receivables)**
- ₹8.1 lakh crore is stuck across MSMEs. Payment links get sent but not paid, and follow-up is manual over WhatsApp. Merchants avoid pushing for fear of losing the customer.
- Instamojo sells "automated payment reminders" as a differentiator, which suggests merchants value it.

**I. Cost of money: fees and instant settlement**
- An effective rate of ~2.36% plus up to ~1% for instant settlement feels expensive to small merchants, who often compare it with **zero-MDR UPI on a PhonePe or Paytm QR**. Capterra reviewers call fees high and report payout delays.
- From 15 Oct 2026, UPI payments above ₹2,000 also carry the 0.4% MDR plus GST on top of the platform fee (§3.3). Merchants are resistant: in a LocalCircles survey, **41% of merchants won't bear any UPI MDR** and only **17%** accept 0.4%.

**J. Onboarding and activation delays**
- Reviews report **8–10 working-day approvals** and ₹199 charged before eligibility was confirmed. Agentic Onboarding (5 min) targets this. Onboarding happens once per merchant, so it is not a frequent task.
- **Social data shows this is much bigger than assumed:** it's tied for the #1 theme in merchants' 1–2★ Play reviews (**18%**, and the **most upvoted**, at 508 👍), and it's the **#1 theme on X** (~28 founder and merchant accounts). Complaints: PAN "mismatch" with no explanation, video KYC needing the *physical* PAN card, "rejected without any specific reason", no option to re-apply, and the ₹199 fee kept on rejection (~3%). Agentic Onboarding has not visibly fixed the rejection experience. The pattern is the same as A: blocked, no reason, no next step.

**K. COD / RTO (D2C only)**
- COD is 58–64% of orders in Tier-2/3 India. COD orders have **3–5× the RTO** of prepaid (~28–35% vs 4–8%), and each RTO costs **₹150–300**. This is high-value for small D2C brands, and Magic Checkout already targets it.

### 3.2 Prioritisation matrix (urgent, frequent, high-value, and fit with the FSB brief)

Scoring: ●●● high, ●● medium, ● low. "Mobile fit" asks whether the phone is the natural place for the task, because the merchant is away from a desk, the evidence lives on the phone, or it needs a quick action. "Razorpay gap" asks how poorly the current app serves it.

"Social signal" (added 12 Oct 2026) measures how loudly merchants complain about it on the Play Store and X ([`SOCIAL_SENTIMENT.md`](SOCIAL_SENTIMENT.md)).

| # | Pain point | Urgent | Frequent | High-value | Mobile fit | Razorpay gap (app) | Social signal | Notes |
|---|---|---|---|---|---|---|---|---|
| A | Settlement hold / funds frozen | ●●● | ● (rare, but catastrophic) | ●●● | ●●● | ●●● | ●●● (12% of Play complaints; most-upvoted review) | #1 driver of hate reviews. Unclear "why / what now" |
| B | Re-KYC to avoid a settlement hold | ●● (deadline reportedly moved to 15 Mar 2027) | ● (one-time per cycle) | ●●● | ●●● (phone camera, Aadhaar/DigiLocker) | ●●● (dashboard-only per docs) | ●● (part of the KYC cluster) | Hold wave expected around Feb 2027; affects the whole base |
| D | "Did this payment actually go through?" | ●●● | ●●● (daily) | ●● | ●●● | ●● | ●–●● (mostly consumer-side; merchants ask for alerts) | Happens with the customer standing in front of the merchant |
| G | Responding to a chargeback in 3 days | ●●● | ● to ●● (depends on category) | ●●● | ●●● (evidence on phone/WhatsApp) | ●●● (desktop flow) | ● (few posts; chargebacks trigger holds) | Razorpay invests here (Dispute Agent) |
| E | "Why is this settlement short?" (one settlement, explained) | ●● (rises from 15 Oct with the MDR) | ●●● (every working day) | ●● | ●●● for one settlement / ● for bulk reconciliation | ●● (app lists settlements; RAY answers Q&A) | ●● (~5–6%; weekend/holiday gaps on X) | Bulk reconciliation is crowded (Agentic Dashboard, other builders); proactive owner-facing explanation isn't |
| H | Chasing unpaid links / receivables | ●● | ●●● | ●●● | ●●● (WhatsApp-native) | ●● | ● (barely mentioned) | Big macro pain; relationship-sensitive |
| F | Refund stuck / customer chasing refund | ●● | ●● | ●● | ●●● | ●● | ●● (mostly consumers) | App has one-tap refund; status tracking is the gap |
| C | Can't reach support | ●●● | ●● | ●● | ●● | ●●● | ●●● (#1 on Play, 18%) | A meta-problem that makes A, B, D, F and G worse |
| I | Cost of instant settlement | ● | ●●● | ●● | ●● | ● | ●● (fees ~5%; "small pay more than big") | Pricing lever; not a product task |
| J | Onboarding / activation / KYC rejection | ●● | ● | ●● | ●●● | ●● (Agentic Onboarding exists, but rejections stay opaque) | ●●● (18% on Play, most upvoted; #1 on X) | **Upgraded:** much louder than assumed; same "blocked, no reason" pattern as A |
| K | COD/RTO | ●● | ●●● | ●●● | ● | ● (Magic Checkout) | ● | D2C only; checkout-side, not the merchant app |
| L | App basics: re-login every open, hangs | ●● | ●●● | ● | ●●● | ●●● | ●● (~7% + ~12%) | A hygiene issue, not a task. Any prototype must avoid it (no OTP wall, native feel) |

**Emerging read (still problem-level, not a solution):** the pains that score highest on **urgency × value × mobile fit × current gap** cluster around **"my money is stuck or at risk and I don't know what to do"**: settlement holds (A), re-KYC (B), chargeback response windows (G), and payment-status uncertainty (D). Receivables (H) scores highest on **frequency × value** but is more crowded (Instamojo, Tally, WhatsApp-native tools). **Settlement explanation (E)** moves up after 15 Oct 2026: it is the most frequent "money" moment, and the MDR makes it harder to understand. Before choosing, validate with **5–8 real Razorpay SME merchant interviews** and a hands-on audit of the current app.

**Social data (12 Oct 2026) sharpens this read:** the three loudest merchant complaints are **support (C), KYC/onboarding rejection (J) and holds/suspension (A)**. All three are the same experience: *"I'm blocked, nobody tells me why, and I can't reach anyone"*. Settlement explanation (E) is real but quieter. Disputes (G) and payment status (D) are quiet on the merchant side. The re-KYC extension reduces B's urgency for October but not the year-round A/J pain.

### 3.3 UPI MDR from 15 Oct 2026: what changes for Razorpay merchants

**Facts** (primary source: [Ministry of Finance FAQ, 15 Sep 2026](https://financialservices.gov.in/sites/default/files/2026-09/FAQs---Merchant-Discount-Rate--MDR--on-Select-UPI--P2M--Transactions_0.pdf)):
| Item | Rule |
|---|---|
| Rate | **0.4%** on P2M UPI payments **above ₹2,000**. Payments of ₹2,000 or less are free (>95% of P2M volume) |
| Cap | ₹300 per transaction for payments of ₹75,000 and above |
| Flat-fee categories | **₹5 per transaction** above ₹2,000 for railways, telecom, insurance, fuel and utilities. **Education** gets "flat-fee structures or capped processing rates" |
| Capital markets | 0.02%, capped at ₹300 |
| Exempt | P2P payments; **UPI AutoPay / mandates**; **P2PM** micro-merchants receiving ≤ ₹1 lakh/month via UPI QR **directly into their own personal accounts**. A P2PM merchant above ₹1 lakh/month for 3 consecutive months moves to P2M |
| Not covered | Credit-on-UPI (RuPay credit cards, credit lines) follows credit-card rules |
| Pass-through | **Prohibited.** Merchants can't charge customers the MDR, and UPI apps can't charge a platform fee |
| Rationale | Fund UPI infrastructure (~₹20,000 Cr/yr cost); a dedicated small-merchant fund is to be designed with the RBI within 3 months |

**What it means for a Razorpay merchant**
- **The fees stack.** Razorpay's own post (22 Sep 2026): *"The 0.4% is separate from your gateway's platform fee… Most merchants pay both, stacked, plus 18% GST"* ([Razorpay blog](https://razorpay.com/blog/lowest-upi-mdr-india-2026-what-merchants-actually-pay-per-payment-gateway)). Example: a ₹5,000 UPI payment costs ₹100 platform fee + ₹20 MDR + GST.
- **No exemption for Razorpay merchants.** Razorpay merchants are P2M merchants paid through a payment aggregator, not P2PM merchants with personal accounts. *(This is my reading of the FAQ; confirm with Razorpay.)*
- **The cost increase is modest relative to the 2% they already pay** (~+0.47% with GST, only on UPI payments above ₹2,000). The bigger shock falls on offline QR merchants moving from 0% to 0.4%. Those are PhonePe's and Paytm's merchants.
- **The real change is complexity.** Whether a payment carries an MDR now depends on amount, payment method (UPI vs credit-on-UPI vs card), category (flat ₹5 vs 0.4%) and mandate status. Each settlement gets one more deduction line that varies from day to day, which feeds directly into pain E.
- **Merchant sentiment is hostile**, and pass-through is illegal. In LocalCircles' survey (32,796 responses, 242 districts), **41% won't bear any MDR**, 9% don't accept UPI, and only **17% accept 0.4%**. Consumers say only **14%** would keep using UPI if merchants passed the charge on ([LocalCircles merchant survey](https://www.localcircles.com/a/press/page/upi-merchant-survey), [LocalCircles consumer survey](https://www.localcircles.com/a/press/page/upi-mdr-consumer-survey)). Expect workarounds such as asking for cash, splitting bills under ₹2,000, or quiet surcharges. These are product anti-patterns: a Razorpay product must not help with them.
- **Industry view:** PhonePe, Paytm and MobiKwik CEOs back the fee ([Medianama](https://www.medianama.com/2026/09/223-payment-ceos-on-upi-mdr-phonepe-paytm-mobikwik/)). Citi estimates a **₹15,000–20,600 Cr** annual revenue pool, much of it likely recycled into cashbacks ([Business Standard](https://www.business-standard.com/industry/banking/upi-mdr-could-add-15-000-20-600-crore-to-fintechs-and-banks-annually-126091601015_1.html)).
- **Timing:** it starts 2 days after the 13 Oct submission deadline, so it will be live during the campus pitches.

**Verdict:** the MDR is **not a standalone mobile task**. An "MDR explainer" would be one-off information, and fee-avoidance tools are off-limits. It **amplifies pain E** and is the trigger for [Solution 4](solutions/04-why-is-my-settlement-short.md).

---

## 4. Competitive Landscape

### 4.1 Market structure
- The India payment-gateway market is ~US$2.3B in 2026, growing ~11.7% a year (Mordor). UPI is the dominant method.
- There are **two worlds**, and SME merchants live in both:
  1. **Online PA / gateway**, serving integrated or link-based online businesses: Razorpay, PayU, Cashfree, Juspay (orchestration), CCAvenue/Infibeam, Easebuzz, Instamojo, Stripe (invite-only in India).
  2. **Offline / QR / soundbox**, serving kiranas and physical retail: PhonePe, Paytm, Google Pay, BharatPe, Pine Labs.
- Regulation is the same for everyone (RBI PA Directions 2025: T+1 settlement, escrow, full re-KYC), so every player faces the same KYC and settlement pressure.

### 4.2 Competitor profiles
| Player | Scale (latest) | Core merchant type | Product lines | Merchant app / mobile posture | Where they beat Razorpay | Where they're weaker |
|---|---|---|---|---|---|---|
| **PayU India** (Prosus) | ~25% of India online payments *revenue*; first full-year adj. EBITDA profit FY26 ($18M) | Large enterprise, e-commerce, BFSI, international | Gateway, LazyPay (BNPL), PayU Finance, VAS (fraud, auth ~34% of payments rev), Mindgate UPI switch, BillDesk deal (blocked) | Enterprise-led; weak SME app story ⚠️ | Enterprise and bank relationships, UPI switch, credit | Less SME/long-tail focus |
| **Cashfree** | ₹967 Cr rev FY26 (+51%); EBITDA+ Mar 2026; 1M+ businesses | Mid-market, SMBs, **payout-heavy** businesses (lending, gaming, marketplaces) | PG, **Payouts**, identity verification (Secure ID), cross-border (140+ currencies) | API/dashboard-first | Payouts, verification APIs, price | Smaller brand; less SME mobile focus |
| **PhonePe (Business)** | "5 crore+" merchants; 45%+ UPI share | Offline kirana and small retail, plus a PG for online | Free UPI QR, **SmartSpeaker** (vernacular voice alerts), POS, **SettleNow** instant settlement, merchant loans (up to 39% flat p.a. cap) | **Mobile-only**: the app is the product | Distribution, zero-MDR UPI, instant settle, voice alerts | Online gateway depth; enterprise |
| **Paytm for Business** | 10M+ businesses; ~7M+ soundboxes | Offline micro and small merchants | Soundbox, Card Soundbox (tap ≤ ₹5,000), card machines, PG, merchant loans | Mobile-first: live alerts, refunds, insights, instant settlement | Soundbox leadership, credit cross-sell | Regulatory overhang (Paytm Payments Bank history) |
| **Pine Labs** | Listed Nov 2025; FY26 rev ₹2,711 Cr, net profit ₹113 Cr; ~9.9 lakh merchants, 18.4 lakh devices | Mid-to-large offline retail, brands, EMI-heavy categories | POS, brand/bank **EMI & offers**, issuing (gift/prepaid cards), online PG (Plural) | Device-led; merchant portal | Offline enterprise, affordability/EMI network | Long-tail micro merchants |
| **Instamojo** | "2M+ small businesses" (vendor claim) | Micro-businesses, creators, solopreneurs | Payment links, **automated payment reminders**, free online store (mojoCommerce) | Mobile + links | Simplicity, reminders, free store | Scale, trust, feature depth |
| **BharatPe** | — | Offline kiranas | Unified QR, POS, merchant credit | Mobile app | Merchant lending to kiranas | Governance history; online |
| **Juspay** | — | Large enterprises | Payment orchestration (HyperCheckout), UPI SDKs | Not merchant-facing for SMEs | Success-rate optimisation for large merchants | Not an SME play |
| **Stripe** | Invite-only in India since 2024; previewing UPI via Link for global sellers | Indian exporters and SaaS selling abroad | Global payments, billing, agentic commerce | — | Global stack | Not really competing for domestic SMEs now |
| **Easebuzz** | — | Price-sensitive small/mid merchants (education, housing societies) | PG, collections, payouts | — | Price, vertical depth | Brand |

### 4.3 How merchants differ across competitors
| Dimension | Cashfree / PayU (online PAs, Razorpay's direct peers) | PhonePe / Paytm / BharatPe (offline QR) | Pine Labs (offline enterprise) |
|---|---|---|---|
| Typical merchant | Online business: website, app, or links on WhatsApp/Instagram | Kirana, food stall, small shop | Brand stores, electronics, large-format retail |
| Integration | API or no-code links/pages | None: print a QR, get a soundbox | Terminal installation |
| Pricing | ~2% platform fee + GST; **from 15 Oct, + 0.4% MDR on UPI above ₹2,000** | UPI at **zero MDR** until 15 Oct. After that, still zero for P2PM micro-merchants (≤ ₹1L/mo), and 0.4% above ₹2,000 for P2M shops. Revenue from devices, loans, ads | MDR + device rental + EMI economics |
| Settlement | T+1/T+2; instant is paid | Daily, plus instant (SettleNow) | T+1 |
| What the merchant checks on the phone | Settlements, payment status, refunds, disputes | "Did I get paid?" (voice alert), daily total | Mostly the terminal and back office |
| Key pain | Holds, reconciliation, disputes, support | Re-KYC risk, loan costs, soundbox rentals | EMI reconciliation, device uptime |
| Revenue model | Transaction fee + VAS + banking + credit | Credit and devices; payments are the funnel | Devices + transactions + issuing |

### 4.4 Strategic observations (market-level, not solutions)
1. **The offline players are mobile-first and Razorpay's app is desktop-derived.** PhonePe and Paytm treat the phone (plus a voice speaker) as the merchant's entire interface. Razorpay's key operational flows (disputes, re-KYC, holds, reconciliation) still point to the web dashboard.
2. **Everyone is chasing merchant credit.** PhonePe, Paytm, BharatPe, PayU and Razorpay Capital all use payments data to underwrite loans. Cash-flow visibility and settlements are the wedge into credit.
3. **Instant settlement is table stakes offline and a paid add-on for Razorpay.** Cash-flow anxiety is central to the SME experience.
4. **Razorpay's AI bet (Agent Studio / Agentic Dashboard) targets disputes, recovery, cash flow and reconciliation.** It is dashboard-first, which leaves a mobile surface for these same jobs open.
5. **Regulation raises the operational burden for every PA equally** (re-KYC, T+1, physical verification). Whoever makes compliance painless for the merchant keeps them.
6. **Trust is Razorpay's weak flank at the SME end**: 1.4/5 on Trustpilot against strong developer sentiment. Opaque holds plus unreachable support is the recurring story.
7. **UPI MDR narrows the "free QR vs 2% gateway" gap** (0.4% vs ~2.4%, above ₹2,000). It hurts offline-QR players' merchants more than Razorpay's, and gives PhonePe and Paytm a new revenue line. For Razorpay merchants the change is mostly in **complexity**, not cost (§3.3).
8. **Reconciliation is a crowded idea among builders.** Razorpay's Agentic Dashboard, an earlier Razorpay AI Buildathon track ("AI Finance Controller"), and open-source tools all target finance-team, web-based reconciliation. Any settlement idea needs a clearly different user (the owner) and surface (mobile).
9. **Razorpay's 2026 AI work goes into checkout, fraud and Q&A, not into "blocked" moments.** RAY (dashboard and WhatsApp Q&A), Vulcan (routing and fraud), Smart AML Screener (preventing one cause of holds) and Dispute Responder all target performance or analytics. None addresses the experience of being held, suspended or KYC-rejected, which is the loudest merchant complaint.
10. **Trust is improving, slowly.** The share of 1–2★ written Play reviews fell from 67% (2024) to 63% (2025) to 56% (2026 to date). Praise clusters around named account managers, a service small merchants don't get.

---

## 5. Open Questions to Validate Before Picking a Problem
1. **App audit:** install the Razorpay Payments app. Which of dispute response, re-KYC, hold resolution and payment-status lookup can actually be done on mobile today? Confirm the gaps in §1.5.
2. **Re-KYC status:** the extension to **15 Mar 2027** is reported (NewsBytes, citing Pine Labs at GFF 2026). Confirm it against an RBI circular, and check whether Razorpay's 30-day pre-deadline hold still applies (that would put it around 13 Feb 2027). What share of Razorpay's small merchants are pending? Is there a mobile re-KYC flow now?
3. **Frequency data:** how often does a typical SME see (a) a settlement hold, (b) a dispute, (c) a pending or "silent" payment? Ask merchants, and ask Razorpay contacts or alumni if possible.
4. **Segment choice:** a no-code link/QR merchant (tutor, clinic, home business) or a small D2C brand? Their top pains differ (receivables and status versus disputes, RTO and reconciliation).
5. **Current workaround:** what does the merchant do today? Examples: calls a CA, screenshots UPI apps, emails support, gives up.
6. **Merchant interviews:** 5–8 conversations (ISB network, local shops, Instagram sellers) to rank A, B, D, E, G and H by felt pain.
7. **MDR presentation:** how will Razorpay show the MDR in settlements, the reconciliation report and the monthly tax invoice: a separate line, or folded into "fee"? Does any Razorpay merchant category get the education or utility flat rate?

---

## Sources
- Razorpay Build Challenge brief (`RazorpayxISB_BuildChallenge.pdf`)
- [Razorpay Newsroom — Agent Studio at FTX'26](https://razorpay.com/newsroom/razorpay-launches-the-worlds-first-ai-native-agent-studio-for-payments-at-ftx26-powered-by-anthropics-claude/)
- [Razorpay Agent Studio](https://razorpay.com/agent-studio/) · [The Paypers coverage](https://thepaypers.com/payments/news/razorpay-launches-ai-agent-studio-and-agentic-experience-platform)
- [Razorpay Payments App](https://razorpay.com/payments-app/) · [Google Play listing](https://play.google.com/store/apps/details?id=com.razorpay.payments.app&hl=en_IN)
- [Razorpay Re-KYC docs](https://razorpay.com/docs/payments/dashboard/re-kyc/)
- [Razorpay — Settlement Transparency playbook 2026](https://razorpay.com/blog/settlement-transparency-the-complete-merchant-playbook-for-questioning-your-payment-gateway-in-2026)
- [Razorpay pricing explained](https://razorpay.com/blog/razorpay-payment-gateway-pricing-explained/) · [Xflow Razorpay review 2026](https://www.xflowpay.com/blog/razorpay-review)
- [Razorpay Dispute Guide](https://razorpay.com/dispute-guide/) · [Razorpay chargebacks blog](https://razorpay.com/blog/chargebacks/)
- [Medianama — Razorpay FY25](https://www.medianama.com/2025/10/223-razorpay-fy25-65-percent-revenue-growth-ipo-plans/) · [Samco — FY25 results](https://www.samco.in/knowledge-center/articles/razorpay-fy25-results-revenue-soars-65-post-esop-loss-of-rs-1209-crore/) · [Inc42 financials](https://inc42.com/company/razorpay/financials/)
- [Trustpilot — Razorpay](https://www.trustpilot.com/review/razorpay.com) · [Capterra — Razorpay reviews](https://www.capterra.com/p/179263/Razorpay/reviews/) · [PissedConsumer](https://razorpay.pissedconsumer.com/review.html)
- [BusinessToday — PAs seek re-KYC extension (Sep 2026)](https://www.businesstoday.in/latest/corporate/story/payment-aggregators-seek-more-time-from-rbi-to-complete-merchant-re-kyc-report-553334-2026-09-04) · [Free Press Journal](https://www.freepressjournal.in/business/payment-aggregators-seek-rbi-extension-for-merchant-re-kyc-deadline) · [VARINDIA](https://varindia.com/news/rbi-kyc-deadline-likely-to-disrupt-upi-payments-for-millions-of-small-merchants)
- [Khaitan & Co — PA Master Directions summary](https://www.khaitanco.com/sites/default/files/2025-10/ERGO%20-%20PA%20Master%20Directions%20-%203%20Oct%202025.pdf) · [Mondaq — PA compliance](https://www.mondaq.com/india/financial-services/1726232/rbi-master-directions-2025-compliance-and-operational-challenges-for-payment-aggregators)
- [NPCI UPI chargeback changes — BW Businessworld](https://www.businessworld.in/article/npci-simplifies-upi-chargeback-rules-new-framework-effective-from-15-july-561146) · [Angel One](https://www.angelone.in/news/market-updates/npci-introduces-new-chargeback-rule-for-upi-transactions)
- [IBS Intelligence — Silent payment failures study](https://ibsintelligence.com/ibsi-news/silent-payment-failures-emerge-as-hidden-drain-on-indias-d2c-profits-study-shows/)
- [Entrepreneur India — PayNearby MSME Digital Index](https://india.entrepreneur.com/news-and-trends/whatsapp-and-whatsapp-business-dominate-msme-landscape-with/476232) · [CXOToday — PayNearby survey](https://cxotoday.com/media-coverage/73-msmes-report-business-growth-via-digital-adoption-led-by-upi-and-smartphones-paynearby-survey/)
- [Business Standard — ₹8.1 trn delayed MSME payments](https://www.business-standard.com/budget/news/delayed-payments-continue-to-hit-msmes-8-1-trillion-stuck-eco-survey-126012901139_1.html) · [Whalesbook — SME Receivables Report 2026](https://www.whalesbook.com/news/English/economy/MSME-Payment-Delays-Rs-38-Crore-Stuck-Per-Firm-Report-Shows/6a41b79bfb97bcde4ce565b2)
- [Mordor Intelligence — India PG market](https://www.mordorintelligence.com/industry-reports/india-payment-gateway-market) · [Decentro — Razorpay alternatives](https://decentro.tech/blog/razorpay-alternatives/)
- [Business Standard — Prosus/PayU FY26](https://www.business-standard.com/companies/news/prosus-india-revenue-up-13-payu-turns-profitable-swiggy-offsets-gains-126062900870_1.html) · [Outlook Business — PayU H1 FY26](https://www.outlookbusiness.com/start-up/news/payu-indias-revenue-jumps-20-in-h1-fy26-on-payments-credit-growth)
- [Business Standard — Cashfree FY26](https://www.business-standard.com/amp/companies/news/cashfree-payments-net-loss-at-118-5-cr-in-fy26-revenue-jumps-51-126082001251_1.html) · [BW Disrupt — Cashfree](https://www.bwdisrupt.com/article/cashfree-payments-reaches-rs-1-000-cr-revenue-in-fy26-targets-full-year-profitability-in-fy27-608274)
- [PhonePe Business app](https://play.google.com/store/apps/details?id=com.phonepe.app.business&hl=en) · [PhonePe SmartSpeaker](https://www.phonepe.com/business-solutions/offline-merchant/smartspeaker/)
- [Paytm for Business](https://business.paytm.com/) · [Paytm Soundbox](https://business.paytm.com/soundbox)
- [Pine Labs FY26 — Whalesbook](https://www.whalesbook.com/news/English/bankingfinance/Pine-Labs-Achieves-Profitability-with-indian-rupee113-Crore-Net-Profit-in-FY26/6a14924db979113840ca8dad) · [Inc42 — Pine Labs](https://inc42.com/features/how-pine-labs-shifted-gears-from-pos-devices-to-an-ai-powered-fintech-stack/) · [Finshots — Pine Labs IPO](https://finshots.in/markets/the-pine-labs-ipo/)
- [Instamojo — Capterra](https://www.capterra.com/p/182477/Instamojo/) · [BharatPe — Wikipedia](https://en.wikipedia.org/wiki/BharatPe) · [Stripe India review 2026](https://www.infinityapp.in/blog/stripe-review) · [PaymentProviders.io](https://paymentproviders.io/blog/best-payment-gateways-india)
- [Shipmozo — RTO guide](https://www.shipmozo.com/blog/how-to-reduce-rto-in-ecommerce) · [HillTeck — RTO cost](https://www.hillteck.com/blog/rto-cost-indian-d2c-brands.html)
- **UPI MDR (added 5 Oct 2026):** [Ministry of Finance FAQ — MDR on select UPI P2M transactions (15 Sep 2026)](https://financialservices.gov.in/sites/default/files/2026-09/FAQs---Merchant-Discount-Rate--MDR--on-Select-UPI--P2M--Transactions_0.pdf) · [Razorpay — Lowest UPI MDR 2026 (stacking)](https://razorpay.com/blog/lowest-upi-mdr-india-2026-what-merchants-actually-pay-per-payment-gateway) · [Razorpay — MDR vs platform fees](https://razorpay.com/blog/upi-charges-explained-mdr-vs-platform-fees/) · [Entrepreneur India](https://india.entrepreneur.com/business-news/npci-announces-0-4-mdr-on-upi-transactions-above-inr-2000) · [Angel One](https://www.angelone.in/news/economy/npci-introduces-0-4-mdr-on-upi-payments-above-2-000-from-october-15-2026) · [Medianama — CEOs back MDR](https://www.medianama.com/2026/09/223-payment-ceos-on-upi-mdr-phonepe-paytm-mobikwik/) · [Business Standard — revenue pool](https://www.business-standard.com/industry/banking/upi-mdr-could-add-15-000-20-600-crore-to-fintechs-and-banks-annually-126091601015_1.html) · [LocalCircles merchant survey](https://www.localcircles.com/a/press/page/upi-merchant-survey) · [LocalCircles consumer survey](https://www.localcircles.com/a/press/page/upi-mdr-consumer-survey)
- **Social sentiment and re-KYC update (added 12 Oct 2026):** [`SOCIAL_SENTIMENT.md`](SOCIAL_SENTIMENT.md) (Play Store dataset in [`data/`](data/play_reviews_razorpay_payments.csv); X posts linked inline) · [NewsBytes: RBI extends merchant re-KYC deadline to 15 Mar 2027](https://www.newsbytesapp.com/news/business/rbi-extends-merchant-re-kyc-deadline-to-march-15-2027/tldr) · [Entrackr: re-KYC by Dec 2026](https://entrackr.com/news/zero-mdr-on-upi-gaming-ban-and-now-re-kyc-govt-puts-payment-aggregators-in-a-bind-10481623) · Razorpay on X, RAY: [1](https://x.com/Razorpay/status/2075152799709716883), [2](https://x.com/Razorpay/status/2097916649903186231), [3](https://x.com/Razorpay/status/2097681561416323151)
- **Settlements (added 5 Oct 2026):** [Razorpay Settlement FAQs](https://razorpay.com/docs/payments/settlements/faqs/) · [Razorpay About Settlements](https://razorpay.com/docs/payments/settlements/) · [Razorpay Balances](https://razorpay.com/docs/payments/dashboard/account-settings/balances/) · [Razorpay — Refunds and MDR](https://razorpay.com/blog/refunds-and-mdr-in-payment-gateways/) · [Razorpay mobile app — View Settlements](https://razorpay.com/docs/payments/mobile-app/track-manage/view-settlements/?preferred-country=IN) · [Razorpay Agentic Platform](https://razorpay.com/blog/razorpay-agentic-platform/) · [Terra Insight — Razorpay settlement reconciliation](https://www.terra-insight.com/insights/razorpay-settlement-reconciliation/) · [Terra Insight — PG reconciliation India](https://www.terra-insight.com/payment-gateway-reconciliation/) · [ConsumerComplaints.in — Razorpay](https://www.consumercomplaints.in/razorpay-b115695) · [PhonePe — track settlements](https://cms.phonepe.com/en/mx/merchant-help/settlements/know-more-about-settlements/how-settlement-works/how-do-i-track-my-settlements/) · Builder projects: [finance-reconciliation-agent (Razorpay AI Buildathon Track 04)](https://github.com/amaansaxena/finance-reconciliation-agent), [residual](https://github.com/CaptainAni187/residual)
