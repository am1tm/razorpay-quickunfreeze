// Mock merchant data and every canned (fallback) string the app can show.
// AI calls in api.dart fall back to these when they time out or fail.

enum Lang { hi, mr, en }

/// Which hold the explanation card is about.
enum HoldTopic { reKyc, risk }

extension LangX on Lang {
  String get chip =>
      const {Lang.hi: 'हिं', Lang.mr: 'मराठी', Lang.en: 'EN'}[this]!;
  String get code => name; // matches the API's lang field
  String get clipAsset => 'assets/audio/why_$name.wav';

  /// Labels on the explanation card, in the selected language.
  String get whyTitle => const {
    Lang.hi: 'अपनी भाषा में पूछें',
    Lang.mr: 'तुमच्या भाषेत विचारा',
    Lang.en: 'Ask why, in your language',
  }[this]!;
  String get askHint => const {
    Lang.hi: 'सवाल पर टैप करें या माइक दबाकर बोलें। जवाब सुनाई देगा।',
    Lang.mr: 'प्रश्नावर टॅप करा किंवा माइक दाबून बोला. उत्तर ऐकू येईल.',
    Lang.en: "Tap a question or hold the mic. You'll hear the answer.",
  }[this]!;
  String get holdToAsk => const {
    Lang.hi: 'दबाकर रखें और हिंदी में पूछें',
    Lang.mr: 'दाबून ठेवा आणि मराठीत विचारा',
    Lang.en: 'Hold to ask in English',
  }[this]!;
  String get listening => const {
    Lang.hi: 'सुन रहे हैं… छोड़ें और पूछें',
    Lang.mr: 'ऐकत आहोत… सोडा आणि विचारा',
    Lang.en: 'Listening… release to ask',
  }[this]!;
  String get thinking => const {
    Lang.hi: 'देख रहे हैं…',
    Lang.mr: 'पाहत आहोत…',
    Lang.en: 'Looking into it…',
  }[this]!;
  String clipFor(HoldTopic t) =>
      t == HoldTopic.risk ? 'assets/audio/risk_$name.wav' : clipAsset;
}

class Fixtures {
  static const merchantName = 'Bharti';
  static const ownerName = 'BHARTI SHAH';
  static const initials = 'BS';
  static const merchantId = 'Mx7Qp2LkD9fA1v';
  static const paymentHandle = 'razorpay.me/@bhartisbakes';
  static const collectedToday = 18450;
  static const paymentsToday = 23;
  static const nextSettlement = 18450;
  static const nextSettlementNote = 'Auto-settles on 14 Oct';
  static const accountBalance = 48200;
  static const bankMasked = 'HDFC Bank ••4417';
  static const weekBars = [
    9.2,
    12.4,
    6.1,
    14.8,
    11.0,
    16.3,
    18.45,
  ]; // ₹ thousands, last 7 days
  static const businessName = "Bharti's Bakes";
  static const city = 'Nagpur';

  /// What a hold would stop: about a week of settlements (sum of [weekBars]), not today's balance.
  static const heldAmount = 88250;
  static const riskAmount = 12600;

  /// Single source of truth for every date in the app (and the AI prompt). RBI's re-KYC deadline
  /// is reportedly 15 Mar 2027; Razorpay's docs pause settlements 30 days earlier (assumption).
  static final freezeDate = DateTime(2027, 2, 13);
  static DateTime get deadline => freezeDate.add(const Duration(days: 30));

  static const _monthsEn = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  static const _monthsHi = [
    'जनवरी',
    'फरवरी',
    'मार्च',
    'अप्रैल',
    'मई',
    'जून',
    'जुलाई',
    'अगस्त',
    'सितंबर',
    'अक्टूबर',
    'नवंबर',
    'दिसंबर',
  ];
  static const _monthsMr = [
    'जानेवारी',
    'फेब्रुवारी',
    'मार्च',
    'एप्रिल',
    'मे',
    'जून',
    'जुलै',
    'ऑगस्ट',
    'सप्टेंबर',
    'ऑक्टोबर',
    'नोव्हेंबर',
    'डिसेंबर',
  ];

  static String _devanagari(int n) =>
      n.toString().split('').map((d) => '०१२३४५६७८९'[int.parse(d)]).join();

  /// "13 Feb", "13 फरवरी", "१३ फेब्रुवारी".
  static String dayMonth(DateTime d, [Lang lang = Lang.en]) => switch (lang) {
    Lang.en => '${d.day} ${_monthsEn[d.month - 1]}',
    Lang.hi => '${d.day} ${_monthsHi[d.month - 1]}',
    Lang.mr => '${_devanagari(d.day)} ${_monthsMr[d.month - 1]}',
  };

  static String get holdDate => dayMonth(freezeDate);
  static String get deadlineLabel => '${dayMonth(deadline)} ${deadline.year}';

  /// Canned explanation (fallback for the live AI one).
  static String explain(Lang lang, [HoldTopic topic = HoldTopic.reKyc]) {
    if (topic == HoldTopic.risk) return riskExplain[lang]!;
    final date = dayMonth(freezeDate, lang);
    return switch (lang) {
      Lang.hi =>
        'RBI हर पेमेंट कंपनी से अपने व्यापारियों का दोबारा KYC करवाने को कहता है। आपका re-KYC बाकी है — '
            'नहीं हुआ तो $date से आपके सेटलमेंट होल्ड पर चले जाएँगे। आपके अकाउंट में कोई गड़बड़ी नहीं है, बस तीन छोटे काम, करीब 90 सेकंड।',
      Lang.mr =>
        'RBI प्रत्येक पेमेंट कंपनीला व्यापाऱ्यांचे पुन्हा KYC करायला सांगते. तुमचे re-KYC बाकी आहे — '
            'ते न झाल्यास $dateपासून तुमचे सेटलमेंट होल्डवर जातील. तुमच्या खात्यात काहीही चूक नाही, फक्त तीन छोट्या पायऱ्या, सुमारे ९० सेकंद.',
      Lang.en =>
        'RBI asks every payment company to re-verify its merchants. Your re-KYC is due — if it isn\'t done, '
            'your settlements will be put on hold from $date. Nothing is wrong with your account: three quick steps, about 90 seconds.',
    };
  }

  /// Text of the bundled clip for each language (assets/audio/why_LANG.wav).
  static const defaultAnswer = {
    Lang.hi:
        'आपका पैसा अभी रुका नहीं है। RBI के नियम से हर व्यापारी का re-KYC ज़रूरी है — अभी तीन छोटे काम पूरे करें, आपके सेटलमेंट चलते रहेंगे।',
    Lang.mr:
        'तुमचे पैसे अजून थांबलेले नाहीत. RBI च्या नियमानुसार प्रत्येक व्यापाऱ्याचे re-KYC आवश्यक आहे — आत्ताच तीन छोट्या पायऱ्या पूर्ण करा, तुमचे सेटलमेंट सुरू राहतील.',
    Lang.en:
        "Your money isn't stuck yet. RBI needs a quick re-KYC from every merchant. Finish three short steps now, and your settlements keep flowing.",
  };

  // ---- Risk hold (two flagged orders) ----------------------------------------------------

  static const riskExplain = {
    Lang.hi:
        'हाल के दो ऑर्डर, #2271 (₹7,400) और #2276 (₹5,200), आपके आम ऑर्डर से बड़े थे, इसलिए उन्हें रूटीन जाँच के लिए रोका गया है: '
        'कुल ₹12,600 होल्ड पर है। बाकी पेमेंट पहले की तरह सेटल हो रहे हैं। डिलीवरी की फ़ोटो, चैट का स्क्रीनशॉट या कूरियर रसीद जोड़ें; जाँच आमतौर पर 24 घंटे में हो जाती है।',
    Lang.mr:
        'अलीकडच्या दोन ऑर्डर, #2271 (₹7,400) आणि #2276 (₹5,200), तुमच्या नेहमीच्या ऑर्डरपेक्षा मोठ्या होत्या, म्हणून त्या नियमित तपासणीसाठी थांबवल्या आहेत: '
        'एकूण ₹12,600 होल्डवर आहेत. बाकीचे पेमेंट नेहमीप्रमाणे सेटल होत आहेत. डिलिव्हरीचे फोटो, चॅटचे स्क्रीनशॉट किंवा कुरियर पावती जोडा; तपासणी साधारण २४ तासांत होते.',
    Lang.en:
        'Two recent orders, #2271 (₹7,400) and #2276 (₹5,200), were bigger than your usual orders, so they were held for a routine check: '
        '₹12,600 in total. Your other payments keep settling as usual. Add delivery photos, chat screenshots or a courier receipt; a reviewer usually checks within 24 hours.',
  };

  static const riskDefaultAnswer = {
    Lang.hi:
        'आपका अकाउंट ठीक है। सिर्फ़ ये दो ऑर्डर जाँचे जा रहे हैं। डिलीवरी का सबूत जोड़ें, जाँच आमतौर पर 24 घंटे में हो जाती है।',
    Lang.mr:
        'तुमचे खाते ठीक आहे. फक्त या दोन ऑर्डरची तपासणी होत आहे. डिलिव्हरीचा पुरावा जोडा, तपासणी साधारण २४ तासांत होते.',
    Lang.en:
        'Your account is fine. Only these two orders are being checked. Add proof they were delivered, and a reviewer usually checks it within 24 hours.',
  };

  static const riskSuggestions = {
    Lang.hi: [
      'मेरा पैसा होल्ड पर क्यों है?',
      'कौन सा सबूत जोड़ूँ?',
      'पैसा कब मिलेगा?',
    ],
    Lang.mr: [
      'माझे पैसे होल्डवर का आहेत?',
      'कोणता पुरावा जोडू?',
      'पैसे कधी मिळतील?',
    ],
    Lang.en: [
      'Why is my money on hold?',
      'What proof should I add?',
      'When will I get it?',
    ],
  };

  static Map<Lang, String> answerFor(HoldTopic t) =>
      t == HoldTopic.risk ? riskDefaultAnswer : defaultAnswer;
  static Map<Lang, List<String>> suggestions(HoldTopic t) =>
      t == HoldTopic.risk ? riskSuggestions : reKycSuggestions;

  static const reKycSuggestions = {
    Lang.hi: [
      'मेरा पैसा क्यों रुकेगा?',
      'कौन से डॉक्यूमेंट चाहिए?',
      'क्या मेरे अकाउंट में दिक्कत है?',
    ],
    Lang.mr: [
      'माझे पैसे का थांबणार?',
      'कोणती कागदपत्रे लागतील?',
      'माझ्या खात्यात काही अडचण आहे का?',
    ],
    Lang.en: [
      'Why will my money stop?',
      'What documents do I need?',
      'Is my account in trouble?',
    ],
  };

  static const photoAdvisory =
      'Photo accepted. Automatic quality check unavailable; a reviewer will check it.';

  static const details = {
    'Business name': "Bharti's Bakes",
    'Business type': 'Home bakery · Proprietorship',
    'PAN': 'ABCPP••••K',
    'Settlement bank': 'HDFC Bank ••••4417',
    'Address': 'Dharampeth, Nagpur 440010',
  };

  static const payments = [
    ('Anjali M.', 'UPI', 1450, '10:42'),
    ('Rohit K.', 'Card', 3200, '10:05'),
    ('Sneha P.', 'UPI', 850, '09:51'),
    ('Order #2291', 'Payment Link', 2600, '09:12'),
    ('Kavita D.', 'UPI', 620, 'Yesterday'),
    ('Order #2288', 'Payment Link', 4100, 'Yesterday'),
  ];

  static const settlements = [
    ('Tue, 14 Oct', 18450, 'Scheduled'),
    ('Mon, 13 Oct', 21380, 'Settled · UTR ••8812'),
    ('Fri, 10 Oct', 16920, 'Settled · UTR ••7741'),
    ('Thu, 9 Oct', 12240, 'Settled · UTR ••7310'),
  ];
}
