// Required proofs from the eng review: D5 (chip answers fall back to the chip-language clip)
// and D6 (an oversized recording, 413 from the API, falls back to the clip).
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:unfreeze/api.dart';
import 'package:unfreeze/fixtures.dart';

Api apiWith(Future<http.Response> Function(http.Request r) handler) =>
    Api(client: MockClient(handler), base: 'https://unfreeze.test', token: 't');

http.Response ok(Object body) =>
    http.Response(jsonEncode(body), 200, headers: {'content-type': 'application/json; charset=utf-8'});

String? mode(http.Request r) =>
    r.url.queryParameters['mode'] ?? (r.body.isEmpty || r.method == 'GET' ? null : jsonDecode(r.body)['mode'] as String?);

void main() {
  test('chip question: ask failure plays the bundled clip in the chip language', () async {
    final a = apiWith((r) async => http.Response('{"error":"gemini 503"}', 502));
    final out = await a.answerText('माझे पैसे का थांबणार?', Lang.mr);
    expect(out.live, isFalse);
    expect(out.clipAsset, 'assets/audio/why_mr.wav');
    expect(out.text, Fixtures.defaultAnswer[Lang.mr]);
  });

  test('chip question: tts failure after a good answer still falls back to the chip clip', () async {
    final a = apiWith((r) async => mode(r) == 'ask'
        ? ok({'text': 'ok', 'lang': 'hi'})
        : http.Response('{"error":"sarvam tts 500"}', 502));
    final out = await a.answerText('मेरा पैसा क्यों रुकेगा?', Lang.hi);
    expect(out.live, isFalse);
    expect(out.clipAsset, 'assets/audio/why_hi.wav');
  });

  test('spoken question: 413 from stt falls back to the chip-language clip', () async {
    final a = apiWith((r) async => http.Response('{"error":"audio too large"}', 413));
    final out = await a.answerSpoken(Uint8List(16), Lang.en);
    expect(out.live, isFalse);
    expect(out.clipAsset, 'assets/audio/why_en.wav');
  });

  test('chip language wins over the detected language on the live path', () async {
    final a = apiWith((r) async {
      switch (mode(r)) {
        case 'ask':
          expect(jsonDecode(r.body)['lang'], 'mr');
          return ok({'text': 'उत्तर', 'lang': 'mr'});
        case 'tts':
          expect(jsonDecode(r.body)['lang'], 'mr');
          return ok({'audio_base64': base64Encode([1, 2, 3]), 'mime': 'audio/wav'});
        default:
          return ok({'transcript': 'mera paisa', 'language_code': 'hi-IN'});
      }
    });
    final out = await a.answerSpoken(Uint8List(16), Lang.mr);
    expect(out.live, isTrue);
    expect(out.question, 'mera paisa'); // the transcript is shown back to the merchant
    expect(out.lang, Lang.mr);
  });

  test('risk-hold question: failure plays the risk clip in the chip language, and the topic is sent', () async {
    final a = apiWith((r) async {
      expect(jsonDecode(r.body)['topic'], 'risk');
      return http.Response('{"error":"gemini 503"}', 502);
    });
    final out = await a.answerText('माझे पैसे होल्डवर का आहेत?', Lang.mr, HoldTopic.risk);
    expect(out.live, isFalse);
    expect(out.clipAsset, 'assets/audio/risk_mr.wav');
    expect(out.text, Fixtures.riskDefaultAnswer[Lang.mr]);
  });
}
