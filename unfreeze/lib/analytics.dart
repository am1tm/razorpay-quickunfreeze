import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'analytics_web_stub.dart'
    if (dart.library.js_interop) 'analytics_web.dart'
    as web;

/// One analytics call for every surface (GA4 property G-9LW1SVXX76).
/// Web (phone and desktop browsers): the gtag.js tag in web/index.html.
/// Android app: our API forwards to GA4's Measurement Protocol, so the secret stays server-side.
/// Every event carries `surface`: web_mobile, web_desktop or android_app.
/// Fire-and-forget: analytics never blocks or breaks the app.
class Analytics {
  Analytics._();
  static final instance = Analytics._();

  static const _base = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'https://rzp-unfreeze.vercel.app',
  );
  static const _token = String.fromEnvironment('APP_TOKEN');

  // Android only: one id per app launch (GA4 counts it as a user), and a session id.
  final String _clientId =
      '${Random().nextInt(1 << 31)}.${DateTime.now().millisecondsSinceEpoch ~/ 1000}';
  final int _sessionId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  String get surface => kIsWeb ? web.webSurface() : 'android_app';

  void track(String name, [Map<String, Object?> params = const {}]) {
    final p = <String, Object?>{'surface': surface, ...params};
    try {
      if (kIsWeb) {
        web.gtagEvent(name, p);
      } else {
        _sendAndroid(name, p);
      }
    } catch (e) {
      debugPrint('analytics: $e');
    }
  }

  Future<void> _sendAndroid(String name, Map<String, Object?> p) async {
    try {
      await http
          .post(
            Uri.parse('$_base/api'),
            headers: {
              'x-app-token': _token,
              'content-type': 'application/json',
            },
            body: jsonEncode({
              'mode': 'event',
              'client_id': _clientId,
              'name': name,
              'params': {
                ...p,
                'session_id': _sessionId,
                'engagement_time_msec': 100,
              },
            }),
          )
          .timeout(const Duration(seconds: 5));
    } catch (_) {}
  }
}

final analytics = Analytics.instance;
