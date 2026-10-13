import 'package:flutter/material.dart';

import 'analytics.dart';
import 'api.dart';
import 'platform.dart';
import 'app_state.dart';
import 'screens/freeze_flow.dart';
import 'screens/home.dart';
import 'theme.dart';
import 'web_showcase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const UnfreezeApp(),
  ); // draw first; never block the first frame on a permission prompt
  platform.onAlertTap = _openFlowFromAlert;
  analytics.track('app_open');
  api.ping(); // warm the serverless function before the first live answer
  await platform.init(); // asks for notification permission (Android 13+)
  platform.scheduleFreezeAlert(); // the demo's entry point on Android
}

final navigatorKey = GlobalKey<NavigatorState>();

/// Tapping the push alert lands on the re-KYC flow (unless it's already submitted).
void _openFlowFromAlert() {
  if (appState.status != CaseStatus.atRisk) return;
  analytics.track('rekyc_open', {'source': 'notification'});
  navigatorKey.currentState?.push(
    MaterialPageRoute(builder: (_) => const FreezeFlowScreen()),
  );
}

class UnfreezeApp extends StatelessWidget {
  const UnfreezeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Concept prototype',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      builder: (context, child) => PhoneFrame(child: child!),
      home: const HomeScreen(),
    );
  }
}
