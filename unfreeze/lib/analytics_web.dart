import 'dart:convert';
import 'dart:js_interop';

@JS('qfSurface')
external JSString? _qfSurface();

@JS('qfTrack')
external void _qfTrack(JSString name, JSString paramsJson);

/// web_mobile or web_desktop, decided in web/index.html (same rule as the gtag config).
String webSurface() {
  try {
    return _qfSurface()?.toDart ?? 'web_unknown';
  } catch (_) {
    return 'web_unknown';
  }
}

void gtagEvent(String name, Map<String, Object?> params) =>
    _qfTrack(name.toJS, jsonEncode(params).toJS);
