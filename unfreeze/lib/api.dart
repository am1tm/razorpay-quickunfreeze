import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:http/http.dart' as http;

import 'fixtures.dart';

/// Timeouts from the design's build contracts (voice budget revised 12 Oct, see [answer]).
class Budgets {
  static const explain = Duration(seconds: 6);
  static const photo = Duration(seconds: 6);

  /// Live on 13 Oct: Sarvam STT took 1.0-2.5 s for a 1.6 s clip from a desktop; a real spoken
  /// question uploaded from a phone overran the old 2.5 s limit and fell back every time.
  static const stt = Duration(seconds: 5);
  static const ask = Duration(
    seconds: 5,
  ); // within [answer]: ask + tts never exceed 9 s together
  static const tts = Duration(milliseconds: 3500);

  /// ask + tts share one budget, so a quick answer leaves more time for speech.
  /// Live on 12 Oct: ask 1-1.6 s, Bulbul v3 3.2-5.1 s (Marathi slowest). Voice total 5 + 9 = 14 s worst case.
  static const answer = Duration(seconds: 9);
}

class AiText {
  const AiText(this.text, {required this.live});
  final String text;
  final bool live;
}

class PhotoVerdict {
  const PhotoVerdict({
    required this.pass,
    required this.reason,
    this.advisory = false,
  });
  final bool pass;
  final String reason;

  /// True when the AI check was unavailable and the photo was accepted for human review.
  final bool advisory;
}

/// What the voice card plays: live TTS bytes, or the bundled clip for the chip language.
class VoiceAnswer {
  const VoiceAnswer.live({
    required this.text,
    required Uint8List this.audio,
    required this.lang,
    this.question,
  }) : clipAsset = null,
       live = true;
  VoiceAnswer.fallback(
    this.lang, {
    this.question,
    HoldTopic topic = HoldTopic.reKyc,
  }) : text = Fixtures.answerFor(topic)[lang]!,
       audio = null,
       clipAsset = lang.clipFor(topic),
       live = false;

  final String text;
  final Uint8List? audio;
  final String? clipAsset;
  final Lang lang;
  final bool live;

  /// What the merchant asked, when known (the chip text, or the speech-to-text transcript).
  final String? question;
}

class Api {
  Api({http.Client? client, String? base, String? token})
    : _client = client ?? http.Client(),
      _base =
          base ??
          const String.fromEnvironment(
            'API_BASE',
            defaultValue: 'https://rzp-unfreeze.vercel.app',
          ),
      _token = token ?? const String.fromEnvironment('APP_TOKEN');

  final http.Client _client;
  final String _base;
  final String _token;

  Uri _uri([String? mode]) =>
      Uri.parse('$_base/api${mode == null ? '' : '?mode=$mode'}');

  Map<String, String> get _headers => {'x-app-token': _token};

  Future<Map<String, dynamic>> _postJson(
    Map<String, Object?> body,
    Duration timeout,
  ) async {
    final res = await _client
        .post(
          _uri(),
          headers: {..._headers, 'content-type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(timeout);
    if (res.statusCode != 200) throw ApiError(res.statusCode);
    return jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
  }

  /// Wakes the serverless function so the first live answer fits its budget. Result ignored.
  Future<void> ping() async {
    try {
      await _client
          .get(_uri('ping'), headers: _headers)
          .timeout(const Duration(seconds: 5));
    } catch (_) {}
  }

  Future<AiText> explain(Lang lang, [HoldTopic topic = HoldTopic.reKyc]) async {
    try {
      final d = await _postJson({
        'mode': 'explain',
        'lang': lang.code,
        'hold_date': Fixtures.holdDate,
        'topic': topic.name,
      }, Budgets.explain);
      return AiText(d['text'] as String, live: true);
    } catch (_) {
      return AiText(Fixtures.explain(lang, topic), live: false);
    }
  }

  Future<PhotoVerdict> photoCheck(Uint8List jpeg) async {
    try {
      final d = await _postJson({
        'mode': 'photo_check',
        'image': base64Encode(jpeg),
      }, Budgets.photo);
      return PhotoVerdict(
        pass: d['verdict'] == 'pass',
        reason: (d['reason'] as String?) ?? '',
      );
    } catch (_) {
      return const PhotoVerdict(
        pass: true,
        reason: Fixtures.photoAdvisory,
        advisory: true,
      );
    }
  }

  Future<String?> _stt(Uint8List wav) async {
    final res = await _client
        .post(
          _uri('stt'),
          headers: {..._headers, 'content-type': 'application/octet-stream'},
          body: wav,
        )
        .timeout(Budgets.stt);
    if (res.statusCode != 200) throw ApiError(res.statusCode);
    final d = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
    final t = (d['transcript'] as String?)?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }

  Future<String> _ask(String question, Lang lang, HoldTopic topic) async {
    final d = await _postJson({
      'mode': 'ask',
      'lang': lang.code,
      'question': question,
      'hold_date': Fixtures.holdDate,
      'topic': topic.name,
    }, Budgets.ask);
    return d['text'] as String;
  }

  Future<Uint8List> _tts(String text, Lang lang, Duration budget) async {
    final d = await _postJson({
      'mode': 'tts',
      'lang': lang.code,
      'text': text,
    }, budget);
    return base64Decode(d['audio_base64'] as String);
  }

  /// Spoken question: STT -> ask -> TTS. The chip language always wins over detection.
  /// Any stage failing or timing out returns the bundled clip for [chip].
  Future<VoiceAnswer> answerSpoken(
    Uint8List wav,
    Lang chip, [
    HoldTopic topic = HoldTopic.reKyc,
  ]) async {
    try {
      final question = await _stt(wav);
      if (question == null) return VoiceAnswer.fallback(chip, topic: topic);
      return await answerText(question, chip, topic);
    } catch (_) {
      return VoiceAnswer.fallback(chip, topic: topic);
    }
  }

  /// Typed or chip question: ask -> TTS in the chip language, else the bundled clip.
  Future<VoiceAnswer> answerText(
    String question,
    Lang chip, [
    HoldTopic topic = HoldTopic.reKyc,
  ]) async {
    try {
      final sw = Stopwatch()..start();
      final text = await _ask(question, chip, topic);
      final left = Budgets.answer - sw.elapsed;
      final audio = await _tts(
        text,
        chip,
        left > Budgets.tts ? left : Budgets.tts,
      );
      return VoiceAnswer.live(
        text: text,
        audio: audio,
        lang: chip,
        question: question,
      );
    } catch (e) {
      debugPrint('voice answer fell back (${chip.code}, ${topic.name}): $e');
      return VoiceAnswer.fallback(chip, question: question, topic: topic);
    }
  }
}

class ApiError implements Exception {
  ApiError(this.status);
  final int status;
  @override
  String toString() => 'ApiError($status)';
}

final api = Api();
