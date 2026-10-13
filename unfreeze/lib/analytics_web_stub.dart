// Non-web builds never call these (Analytics checks kIsWeb first).
String webSurface() => 'unknown';

void gtagEvent(String name, Map<String, Object?> params) {}
