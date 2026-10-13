# Razorpay Merchant Sentiment: Top Complaints and Feature Requests

*Compiled 12 Oct 2026. Companion to [`RESEARCH_FINDINGS.md`](RESEARCH_FINDINGS.md) and [`solutions/README.md`](solutions/README.md).*

**Question:** What do Razorpay merchants complain about most, and what do they ask for, on X, app stores and review sites?

**Short answer:** The top three complaints all involve trust and access, not the product itself:
1. "I can't reach a human."
2. "I can't get through onboarding or KYC, and nobody tells me why."
3. "My account or money was frozen, and nobody tells me why."

Next come complaints about the mobile app: it hangs, and it logs merchants out every time they open it. Fees and settlement delays come after that. Most feature requests turn these complaints around: give a reason and a way forward, let me stay logged in, show me yesterday's numbers.

---

## 1. Sources and method

| Source | What was collected | Size | Notes |
|---|---|---|---|
| **Google Play: Razorpay Payments for Business** (`com.razorpay.payments.app`) | All reviews the store returned, newest first | **3,538 reviews** (Nov 2020 to Oct 2026); **887 since 1 Jan 2025** | Main quantitative base. Rating 4.1 overall (9.7k ratings), but **2.5 average for written reviews since 2025**. Full dataset: [`data/play_reviews_razorpay_payments.csv`](data/play_reviews_razorpay_payments.csv) |
| Google Play: RazorpayX, Razorpay mPOS | Reviews | 148 + 368 | Context only; not coded |
| **X (Twitter)** | Live search from a logged-in session, 12 queries: `to:Razorpay`, `@RazorpayCare`, settlement, hold/suspended/disabled/blocked/frozen, support/ticket/customer care, KYC, charges, app/dashboard, feature-request phrases, chargeback/dispute, RazorpayX payout | **1,812 unique posts**; **910 from 2025 onward** that aren't Razorpay's own | I read all of them. About half are news, developer build logs, job posts or deal-hunter posts. The rest are consumers chasing refunds from merchants. **~110 unique merchant or founder accounts** post a genuine complaint, request or praise, and §3a counts them by hand |
| **Trustpilot** | Latest page plus summary | 453 reviews, **1.4/5** | 24 most recent reviews read (Jun to Oct 2026) |
| **PissedConsumer** | Latest reviews plus the site's AI summary | 462 reviews, **1.7/5** | Mostly consumer-side complaints |
| Reddit | Blocked for automated access | — | X post mentions **r/Razorpay** as a place where "there are a lot of issues that need solution" ([X, 31 Jul 2026](https://x.com/maushookar/status/2083174147824501007)). Still to do |

**How the Play Store reviews were coded:**
- I took the 538 one- and two-star reviews since Jan 2025.
- I removed 40 reviews from **consumers**: people disputing unauthorised debits, loan-app auto-debits, or refunds from a merchant that happened to use Razorpay. They aren't merchants, so they distort merchant priorities.
- That leaves **498 merchant or unclear reviews**. I tagged each one against 11 themes using keyword rules, then checked the tags by reading all 397 reviews longer than 40 characters.
- One review can carry several themes.
- Many reviews are just "worst app" and match no theme. Percentages below are of all 498, so they **understate** each theme's real share.
- "👍 weight" is the total thumbs-up votes on the reviews in a theme. It shows how many other users agreed.

**Limits:**
- People write reviews when they are angry, so these are complaint *rankings*, not a measure of how satisfied Razorpay's merchant base is overall. Play's 4.1 star average includes many silent five-star ratings.
- X search is not a random sample.
- The keyword coding was checked by reading, but I didn't double-code it.

---

## 2. Overall sentiment

| Measure | Value |
|---|---|
| Play written reviews since 2025: star split | 1★ 526 · 2★ 12 · 3★ 23 · 4★ 32 · 5★ 294 (**61% are 1–2★**) |
| Share of 1–2★ reviews by year | 2024: **67%** → 2025: **63%** → 2026 to date: **56%** (improving) |
| Since Jul 2026 | 55 one-star vs 47 five-star. More five-star reviews are arriving, possibly in-app prompts; there's no text to tell |
| Trustpilot | 1.4/5; Razorpay replies to most reviews with the same template |
| PissedConsumer | 1.7/5; "33% would recommend" |
| X | Merchant posts are almost all negative or asking for help. One clear positive: *"support improved by leaps and bounds… now they resolve the issue like a flash"* ([X, 30 Jun 2026](https://x.com/RajalingamVivek/status/2071828915266715745)) |
| What 4–5★ reviewers praise (71 with text) | Easy and simple (18), support (13), fast settlement (11), UI (10). G2 (4.2) and Capterra (3.6) are kinder, because their users are mostly developers and finance teams |

**How to read this:** Developers and larger businesses like the product. Small merchants and new merchants dislike the way Razorpay *treats* them: holds, rejections, and support that won't answer. The trend is improving but still poor.

---

## 3. Top 10 complaints

Rank = Play Store frequency, adjusted using X, Trustpilot and PissedConsumer.

| # | Complaint | Play: share of 498 merchant 1–2★ reviews | 👍 weight | Also on | Representative voice |
|---|---|---|---|---|---|
| 1 | **Support can't be reached; tickets closed without resolution** | 91 (18%) | 341 | X (most common merchant post), Trustpilot (most of the 24 recent reviews), PissedConsumer | *"Team is closing tickets without any resolution… open since 2nd Sept. We are sitting in the middle of peak festive season"* ([X, 5 Oct 2026](https://x.com/gunjansharma13/status/2106976300816826603)) · *"Most of the startups that I know moved out of Razorpay… ONLY BECAUSE OF YOUR SLAs"* ([X](https://x.com/keerthisiddeshw/status/1868908303071547739)) |
| 2 | **Onboarding and KYC friction or rejection with no reason given** | 89 (18%) | **508** (highest) | X, Trustpilot | *"my PAN details are correct… the system repeatedly reports that they don't match without explaining why. There are no meaningful error messages"* (Play, Jun 2026, 23 👍) · *"Application rejection without any specific reason… new ticket… got closed automatically as duplicate"* ([X, May 2026](https://x.com/krishnan_pandya/status/2055195456465150019)) |
| 3 | **Account disabled, suspended, or funds held with no reason given** | 62 (12%) | 400 | X, Trustpilot #1 (most recent review), Voxya | *"Firstly they said my account is fully activated and as soon as the payment was received, they just turned my account down. Now they say settlement would take 120 days"* (Play, Jul 2025, **266 👍**, the most-upvoted review in the set) · *"Reason cannot be shared with you"* (Play, Oct 2025) |
| 4 | **App slow, hangs, crashes; Transactions tab freezes** | 61 (12%) | 196 | — | *"It feels more like opening a website inside a browser frame than using a smooth mobile app"* (Play, Sep 2026) · *"When I open the Transactions tab, the screen is stuck"* (Play, 27 👍) |
| 5 | **Forced to log in with OTP every time the app opens** | 35 (7%) | 105 | — | *"Almost every time I open the app it asks me to log in again… Once this issue is solved, I'll gladly give 5 stars"* (Play, Sep 2025) |
| 6 | **Settlement delays and slow cycles** | 32 (6%) | 342 | Trustpilot, PissedConsumer | *"6-6 din kon payment rakhta he yaar"* ("who holds payments for 6 days, man", Play, Jul 2026) · *"Payments are stuck for over 15 days and there is absolutely no update"* (Play, Apr 2026) |
| 7 | **Fees too high, or deductions don't match published pricing** | 25 (5%) | 60 | Trustpilot ("pricing shown publicly differs from deductions"), PissedConsumer (top-5 category) | *"It is difficult to clearly understand the final deductions… fee structure very confusing"* (Play, Jul 2026) |
| 8 | **Missing data and controls in the app** | 19 (4%) | 112 | X | *"you can't even check yesterday's revenue"* (Play, Jun 2025) · *"stopped showing data beyond 90 days in app"* (Play, Jan 2026) · *"The new update UI… Many stats are missing and the graph is very bad"* (Play, **6 Oct 2026**) |
| 9 | **₹199 KYC/review fee kept when onboarding is rejected** | 14 (3%) | 28 | Trustpilot (two Aug 2026 reviews) | *"Nowhere before payment was it clearly disclosed that this fee is non refundable if onboarding is rejected"* (Play, Dec 2025) |
| 10 | **Payment failures and capture problems** | 13 (3%) | 52 | X, Trustpilot | *"subscription renewals for credit cards are failing with a 100% rate… I am bleeding customer renewals"* ([X, Aug 2026](https://x.com/ameyakarve/status/2090474306996502570)) |

### 3a. What X adds (hand-counted, unique merchant/founder accounts, Jan 2025 to Oct 2026)

| Theme | Accounts | What X shows that the Play Store doesn't |
|---|---|---|
| **Onboarding and KYC stuck or rejected** | **~28** (vs 4 praising fast onboarding) | Founders and indie developers stuck before going live: *"no API keys before full business KYC"* ([X](https://x.com/prabuddhaxdev/status/1968275638680432985)); *"Video KYC requires the physical PAN card"* ([X, Aug 2026](https://x.com/Gourav_jain_7/status/2085950513317839068)); *"did physical kyc thrice before approving"* ([X](https://x.com/vatsalk9/status/2084820229927129103)); *"We cannot onboard you as your website is under 3 months old"* ([X](https://x.com/Desi_Alchemist/status/1917529800190669226)); stuck on an onboarding screen and unable to raise a ticket ([X](https://x.com/Siddharth1India/status/1949712669260341670)). Several lost them to Dodo Payments, Stripe or Cashfree |
| **Support unreachable** | **~20** (vs 5 praising support or their account manager) | Praise goes almost entirely to *named account managers* (RazorpayX, larger merchants): *"Not your typical AM"* ([X](https://x.com/mohitmalpaniii/status/2037133318526030067)). Small merchants have no such person: *"even their customer service is an artificial entity"* ([X, Sep 2026](https://x.com/PriyankaLahiri_/status/2096175478398955960)). Public escalation works: a founder's tweet got *"the senior team"* to respond *"within an hour"* ([X, Oct 2026](https://x.com/tdinkar/status/2107376447853875320)) |
| **Account suspended or funds held** | **~17** | Same stories as the Play Store, plus specifics: *"suspended for 'suspicious activity' with zero proof… money is stuck for 120 days"* ([X, Dec 2025](https://x.com/AswinAswin1111/status/1999024857368162535)); *"5 chargebacks total… out of tens of thousands of orders… losing lakhs of rev a day"* ([X](https://x.com/kes11av/status/1957734587661959484)); *"banned our international payments just because, in 10 years, 1 customer did a chargeback"* ([X, Oct 2026](https://x.com/ajay138/status/2108737575158718826)); suspended *before a single transaction* ([X](https://x.com/aranyavasfarms/status/1876165744125526235)) |
| **Fees: level and visibility** | **~10** | The UPI MDR debate (Aug–Sep 2026) brought out complaints that **small merchants pay more than big ones** ([X](https://x.com/neorevolt/status/2086721411171922006)) and that UPI already costs ~2.36% on Razorpay. The key line for Solution #4: *"Razorpay: no way to check in dashboard what you are charged for various kinds of payments"* ([X, Jul 2026](https://x.com/IronyMeter/status/2075465873280864507)) |
| **Payment failures and tech** | **~8** | *"Every single payment failure is due to UPI… Razorpay blames NPCI & banks. Banks & NPCI blame Razorpay. We merchants are stuck in the middle"* ([X, Mar 2026](https://x.com/saybwala/status/2033410528048238720)); money deducted from customers with *"no update/webhook… nothing visible on dashboard"* ([X, May 2026](https://x.com/stockmock_in/status/2054414319811752172)) |
| **Settlement timing: weekends and bank holidays** | **~6** | Specific to X and **not in the Play reviews**: *"My settlements are paused for 3 days… That money is already…"* ([X, Jun 2026](https://x.com/PranavDate/status/2070144058333245456)); *"figure out your holiday / weekend settlement cycles. On normal days, the twice a day settlement is magic"* ([X, Aug 2026](https://x.com/saybwala/status/2086016070499074320)); instant settlement *"throws an error that your quota has been used… only 60% you can draw"* ([X](https://x.com/saybwala/status/2076196746175397966)). "Razorpay settlement delayed" is listed as a stock D2C-founder complaint ([X](https://x.com/vikpai/status/2076940643558105474)) |
| **App and dashboard UX** | **~6** | *"What is the point of having a mobile app if I have to sign in (with 2FA) every single time"* ([X, Dec 2025](https://x.com/ankushdharkar/status/2001949023281062169)); *"For everything I had to open documentation… then again switch tab to dashboard"* ([X, May 2026](https://x.com/Sanyam0605/status/2056705529259360739)); Reviews feature switched on by default, emailing customers without consent ([X, Sep 2026](https://x.com/mohitmamoria/status/2098384493811999002)) |
| **Disputes and chargebacks** | **~5** | Supports Solution #2's "missed alert" premise: *"I didn't know such a dispute mechanism exists… and I don't read every email from the payment gateway"* ([X](https://x.com/saybwala/status/1888883547160625194)); *"is it wise to accept the dispute? Will it cause any problems in my account?"* ([X](https://x.com/vvdity/status/1948048281399148863)) |

**What X changes in the ranking:** Onboarding and KYC moves up to #1 on X. That's because founders and developers post there, while shop owners leave Play reviews. Weekend and holiday settlement is a new, specific pain. And X has the clearest single line on fee visibility.

Also mentioned, less often: POS and soundbox hardware not delivered or not working (8); Shopify and Magic Checkout setup issues (Trustpilot, Sep 2026); international payment limits and FIRC (X); account-opening turnover rules for RazorpayX ([X, Oct 2026](https://x.com/ckomagan/status/2107397380928933946)).

**Consumer-side noise, removed from the ranking:** these 40 Play reviews, and most PissedConsumer reviews, are about unauthorised auto-debits, loan apps, and refunds owed by merchants. They show a related problem: consumers blame Razorpay for merchants' failures, which then lands on the merchant as disputes.

---

## 4. Top 10 feature requests

Few people write "please add X". Most requests come as complaints like "there's no option to…". Requests 1–5 come up in several sources; 6–10 are explicit but appear less often.

| # | Request | Evidence |
|---|---|---|
| 1 | **A reachable human: phone or chat, a named contact, a real SLA** | Most frequent complaint on every channel. *"First-line automated support needs human fallback options"* (Trustpilot, Aug 2026, 2★). *"Kindly change your website statement… 'response expected within 4-8 working hours'"* ([X](https://x.com/IngressIT/status/1889982475998556479)) |
| 2 | **A specific reason and a way forward when the account or funds are frozen**: what was violated, which documents are needed, by when | *"no appeal option… amazon… gives options to recover account"* (Play, Oct 2025, Hindi). *"it would be better to hold the payment and allow to receive the payment so that business continue"* (Play, Apr 2024, 14 👍) |
| 3 | **Stay logged in: MPIN, biometric or pattern login** | *"you can add MPIN feature"* (Play, May 2025). *"There is no system of MPIN or biometric login"* (Play, Apr 2025). *"there should have been password or pattern"* (Play, Apr 2025) |
| 4 | **KYC errors that say what's wrong, a re-apply option, fully digital KYC** | *"there is no option to reapply, reset, or contact support"* (Play, Jan 2026). *"insist that users physically show their original PAN and Aadhaar… the entire KYC process should also be digital"* (Play, Sep 2026). *"didn't tell us which documents is missing"* (Play, Jun 2025) |
| 5 | **An eligibility check before charging ₹199, or a refund if rejected** | Play (14 reviews) and Trustpilot. *"They could have rejected on registration but wait for you to pay then reject"* (Play, May 2025) |
| 6 | **Day-wise revenue, history beyond 90 days, report export** | *"No option to see yesterday's transaction"* (Play, May 2026). *"no option to download button report in sheets"* (Play, Jan 2025, 4★). Restore stats and graphs dropped in the Oct 2026 UI update |
| 7 | **A clear fee and deduction breakdown per payout** | Play (Jul 2026), Trustpilot (Aug 2026), PissedConsumer category "disputes over transaction charges" |
| 8 | **Instant payment alerts and a live transaction view in the app** | *"Notifications doesn't work. When we receive any payment. We dont get notification in app"* (Play, Jun 2025). *"no option for live transactions"* (Play, May 2026) |
| 9 | **Self-serve edits: bank account, email, phone, business details** | *"no option to change phone number, business name, anything"* (Play, 25 👍). *"Not having an option to update bank a/c"* (Play, Apr 2025). *"old bank account is inactive… settlements are frozen. I'm not able to change the bank account"* ([X](https://x.com/magali_c/status/1849024414886867297)) |
| 10 | **A native, fast app with test/live mode** | *"make the UI feel like a real native app"* (Play, Sep 2026). *"add both test and live mode in the app"* (Play, 27 👍). Also: download Razorpay's own service invoice (Play, Aug 2025) |

**Added from X:**
- **Settle on weekends and bank holidays, or warn ahead and show when the money will land.** Requested directly ([X](https://x.com/saybwala/status/2086016070499074320)).
- **An exact refund timestamp instead of "5–7 working days"** ([X](https://x.com/pratiknagariya/status/1950167713600729529)).
- **Show what each payment type costs in the dashboard** ([X](https://x.com/IronyMeter/status/2075465873280864507)).
- **Guided steps in the dashboard instead of sending merchants to the docs** ([X](https://x.com/Sanyam0605/status/2056705529259360739)).
- **Mass small UPI payouts** to creators ([X](https://x.com/mememandir/status/2058785106807169329)).
- **MDR relief for small merchants** ([X](https://x.com/Kenu73/status/2100221716668526655)).

Developer-side asks (X, low volume): a create-webhook API like Stripe's ([X](https://x.com/rahul_meX/status/1882086632083660978)), Samsung Pay, bring back the test-mode badge on checkout, PayPal linking, FIRC for international receipts, usage-based billing like Stripe, and a smarter WhatsApp bot for payroll reimbursements.

---

## 5. What Razorpay is already doing about it (from its own X posts)

- **RAY**, an AI assistant on the dashboard **and WhatsApp** (Jul to Sep 2026): *"ask Ray anything from 'How much did I collect today?' to 'Why are my UPI payments failing?' to 'When is my next settlement due?'"* ([X](https://x.com/Razorpay/status/2075152799709716883)). It formats replies for chat: *"A dashboard can display a 50-row table. WhatsApp can't"* ([X](https://x.com/Razorpay/status/2097916649903186231)). Write actions (*"a refund, a settlement, a KYC change"*) need a separate merchant approval step ([X](https://x.com/Razorpay/status/2097681561416323151)).
- **Smart AML Screener** (Aug 2026): Razorpay claims it took a merchant from "30 AML flags/month to zero" and that there have been "no settlement delays since going live". It targets one *cause* of holds, not the experience of being held.
- **Dispute Responder agent** (Jul 2026): gathers evidence and can contest a dispute for the merchant.
- **Vulcan** foundation model (Aug 2026) for routing, fraud and disputes.

**The gap:** Razorpay's AI investment goes into checkout success, fraud and analytics Q&A. **None of it addresses complaints #1–#3**, the moments when a merchant is blocked and needs a reason, a list of what to do, and a person.

---

## 6. What this means for our solution candidates

| Candidate | Social signal | Verdict |
|---|---|---|
| **#1 Unfreeze: clear a settlement hold** | Complaints #1, #2, #3 and #9 together, and requests #1, #2 and #4. The highest-voted review in the dataset (266 👍) is a hold story. On X, ~17 accounts posted about holds and ~28 about stuck KYC | **Strongly confirmed.** It's the loudest, most repeated, most upvoted pain. The flow should *also* fix the onboarding/KYC version ("rejected, why, what next"), which is just as large. ⚠️ **Timing change:** the RBI reportedly **extended the merchant re-KYC deadline by six months to 15 Mar 2027** (Pine Labs at GFF 2026; [NewsBytes](https://www.newsbytesapp.com/news/business/rbi-extends-merchant-re-kyc-deadline-to-march-15-2027/tldr); single source, no RBI circular found). That removes the October deadline as a hook, but holds and KYC rejections are year-round pain, so the case doesn't rest on the deadline |
| **#4 Why is my settlement short?** | Fees and deductions (#7, 5%), settlement delay (#6), request #7. On X: *"no way to check in dashboard what you are charged for various kinds of payments"*, plus weekend and holiday settlement pain. **But RAY already answers "when is my next settlement due"**, including on WhatsApp | **Moderate, slightly stronger after X.** The pain is real but quieter, and Razorpay is moving into the Q&A layer. The difference has to be the itemised breakdown, anomaly flags and resolve actions. A *"when will it land, given the holiday?"* line is an easy addition |
| **#2 Chargeback on mobile** | Few merchant posts (one ₹38,838 chargeback on Trustpilot, Sep 2026). On X: one merchant missed a dispute email, and another didn't know whether accepting a dispute would hurt their account. Chargebacks also *trigger* holds (*"5 chargebacks… out of tens of thousands"*) | **Weak on its own, but linked to #1:** a chargeback can lead to a hold. Razorpay's Dispute Responder already exists |
| **#3 Paisa Aaya? (payment confirmation)** | Request #8 (alerts, live view) and some "money debited, payment failed" posts | **Weak to moderate.** It's mostly a consumer-side complaint |

Mandate-fit scores out of 10, combining this evidence with the other criteria: **#1 8.9 · #3 7.3 · #4 7.2 · #2 7.0** (see [`solutions/README.md`](solutions/README.md)).

**Two quick wins the data points to, not big enough to build a solution around:**
- **Stay logged in.** MPIN or biometric login comes up in 7% of complaints and blocks every under-2-minute task. Any prototype should open straight to the task, with no OTP each time.
- **Native and fast.** The "website in a browser frame" complaint means a prototype that *feels* native is itself a selling point.

---

## 7. Still to do

- [x] X pull across 12 queries (1,812 posts), hand-counted in §3a.
- [ ] Confirm the re-KYC extension to 15 Mar 2027 against an RBI circular, then update `RESEARCH_FINDINGS.md` §5 and Solution 1.
- [ ] Scrape **r/Razorpay**, which needs a logged-in Reddit session in the browse tool.
- [ ] Read Trustpilot pages 2–5 for a 2026-only theme count.
- [ ] Do the app audit: check whether the Oct 2026 UI update changed the login, holds or settlement screens.

## Sources

- Google Play: [Razorpay Payments for Business](https://play.google.com/store/apps/details?id=com.razorpay.payments.app), scraped 12 Oct 2026 with `google-play-scraper`. Dataset in [`data/`](data/play_reviews_razorpay_payments.csv)
- [Trustpilot: razorpay.com](https://www.trustpilot.com/review/razorpay.com) (1.4/5, 453 reviews)
- [PissedConsumer: Razorpay](https://razorpay.pissedconsumer.com/review.html) (1.7/5, 462 reviews)
- [Voxya complaint: settlement on hold](https://voxya.com/consumer-complaints/put-the-settlement-on-hold-by-razorpay/221117) · [Voxya: hold without reason](https://voxya.com/consumer-complaints/hold-the-settlement-without-any-reason/137221)
- [G2 Razorpay reviews](https://www.g2.com/products/razorpay/reviews) · [G2 Razorpay vs Cashfree](https://www.g2.com/compare/razorpay-vs-cashfree) · [Xflow Razorpay review](https://www.xflowpay.com/blog/razorpay-review)
- [Razorpay blog: what to do when your gateway account is frozen](https://razorpay.com/blog/what-to-do-when-your-payment-gateway-account-is-frozen/)
- X posts linked inline; scraped 12 Oct 2026 from 12 live-search queries (logged-in session, gstack browse)
- Re-KYC extension: [NewsBytes, RBI extends merchant re-KYC deadline to 15 Mar 2027](https://www.newsbytesapp.com/news/business/rbi-extends-merchant-re-kyc-deadline-to-march-15-2027/tldr) · [Business Today, PAs seek more time (4 Sep 2026)](https://www.businesstoday.in/latest/corporate/story/payment-aggregators-seek-more-time-from-rbi-to-complete-merchant-re-kyc-report-553334-2026-09-04)
- Older X examples: [Risk Funds On Hold, 48h to respond](https://x.com/ruchitgarg/status/1644690858019807240), [settlements frozen, can't change bank account](https://x.com/magali_c/status/1849024414886867297)
