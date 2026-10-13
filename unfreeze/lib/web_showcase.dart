import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'analytics.dart';
import 'theme.dart';

/// Desktop web: a realistic phone on a dark stage, with a side panel that explains the demo and
/// nudges the viewer to open it on a phone. Phones (and the APK) get the app full screen.
class PhoneFrame extends StatelessWidget {
  const PhoneFrame({super.key, required this.child});
  final Widget child;

  static const _url = 'https://rzp-unfreeze.vercel.app';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    if (!kIsWeb || size.width < 600) return child;
    final wide = size.width >= 980;
    return Material(
      type: MaterialType.canvas,
      color: const Color(0xFF070C1C),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.25, -0.2),
            radius: 1.3,
            colors: [Color(0xFF13234A), Color(0xFF070C1C)],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 28, 32, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (wide) ...[
                      Flexible(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 440),
                          child: const _SidePanel(url: _url),
                        ),
                      ),
                      const SizedBox(width: 72),
                    ],
                    _Phone(child: child),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 14),
              child: Text(
                'Concept prototype · Razorpay x ISB Build Challenge · synthetic data · not a Razorpay product',
                style: TextStyle(fontSize: 12, color: Color(0x99FFFFFF)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// iPhone-sized device (390 x 844 screen) scaled to fit the window height.
class _Phone extends StatelessWidget {
  const _Phone({required this.child});
  final Widget child;

  static const _screen = Size(390, 844);
  static const _bezel = 12.0;

  @override
  Widget build(BuildContext context) {
    final now = TimeOfDay.now();
    final time =
        '${now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod}:${now.minute.toString().padLeft(2, '0')}';
    return FittedBox(
      child: Container(
        width: _screen.width + _bezel * 2,
        height: _screen.height + _bezel * 2,
        padding: const EdgeInsets.all(_bezel),
        decoration: BoxDecoration(
          color: const Color(0xFF16181D),
          borderRadius: BorderRadius.circular(62),
          border: Border.all(color: const Color(0xFF3A3D45), width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x88000000),
              blurRadius: 60,
              offset: Offset(0, 30),
            ),
            BoxShadow(color: Color(0x2233395F), blurRadius: 2, spreadRadius: 3),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: ColoredBox(
            color: Colors.white,
            child: Column(
              children: [
                // Status bar with the camera island.
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        width: 120,
                        height: 34,
                        margin: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      Positioned(
                        left: 44,
                        top: 17,
                        child: Text(
                          time,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                      const Positioned(
                        right: 30,
                        top: 17,
                        child: Row(
                          children: [
                            Icon(
                              Icons.signal_cellular_alt,
                              size: 17,
                              color: AppColors.ink,
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.wifi, size: 17, color: AppColors.ink),
                            SizedBox(width: 4),
                            Icon(
                              Icons.battery_full,
                              size: 19,
                              color: AppColors.ink,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      size: Size(_screen.width, _screen.height - 50 - 24),
                      padding: EdgeInsets.zero,
                      viewPadding: EdgeInsets.zero,
                    ),
                    child: child,
                  ),
                ),
                // Home indicator.
                SizedBox(
                  height: 24,
                  child: Center(
                    child: Container(
                      width: 134,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.ink,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SidePanel extends StatelessWidget {
  const _SidePanel({required this.url});
  final String url;

  static const _white = Colors.white;
  static const _soft = Color(0xB3FFFFFF);
  static const _faint = Color(0x80FFFFFF);

  @override
  Widget build(BuildContext context) {
    // Scales down as a whole on short windows instead of scrolling or clipping.
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 440,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 44,
                  height: 44,
                  child: CustomPaint(painter: _LogoPainter()),
                ),
                const SizedBox(width: 12),
                const Text(
                  'QuickUnfreeze',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: _white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Text(
              'Clear a settlement hold from your phone, in about 90 seconds.',
              style: TextStyle(
                fontSize: 21,
                height: 1.3,
                fontWeight: FontWeight.w600,
                color: _white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "A concept feature for the Razorpay merchant app. Bharti, the Baker in Nagpur (a Tier 2 city), runs her business from "
              "her phone. Her re-KYC is due, and if it isn't done, her settlements go on hold from 13 Feb. "
              'QuickUnfreeze warns her early, answers her questions in her own language, and lets her finish on the phone.',
              style: TextStyle(fontSize: 14.5, height: 1.5, color: _soft),
            ),
            const SizedBox(height: 22),
            const Text(
              'TRY THIS',
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 1.4,
                fontWeight: FontWeight.w700,
                color: _faint,
              ),
            ),
            const SizedBox(height: 10),
            const _Step(
              1,
              'Tap the dark alert at the top. It stands in for the push notification.',
            ),
            const _Step(
              2,
              'Pick हिं, मराठी or EN. Tap a question, or hold the mic and ask out loud: the answer is spoken back.',
            ),
            const _Step(
              3,
              'Do the 3 steps: confirm details, DigiLocker (mock), one workspace photo that AI checks.',
            ),
            const _Step(4, 'Submit, and watch the held amount melt away.'),
            const _Step(
              5,
              'Back on Home, open the ₹12,600 risk hold: same voice explainer, different case.',
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0x14FFFFFF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0x26FFFFFF)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: QrImageView(
                      data: url,
                      size: 96,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Best on your phone',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "QuickUnfreeze is a web app (PWA). Scan to open it on your phone, then 'Add to Home Screen' for the "
                          'full-screen app with camera and mic.',
                          style: TextStyle(
                            fontSize: 12.5,
                            height: 1.45,
                            color: _soft,
                          ),
                        ),
                        SizedBox(height: 8),
                        _Link(
                          icon: Icons.android,
                          label: 'Download the Android app (APK)',
                          url: '$_site/unfreeze.apk',
                        ),
                        SizedBox(height: 4),
                        _Link(
                          icon: Icons.open_in_new,
                          label: 'rzp-unfreeze.vercel.app',
                          url: _site,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Live: Gemini explanations, answers and photo check; Sarvam speech in Hindi, Marathi and English. '
              'Mocked: merchant data, DigiLocker, the KYC review.',
              style: TextStyle(fontSize: 12, height: 1.5, color: _faint),
            ),
          ],
        ),
      ),
    );
  }
}

const _site = 'https://rzp-unfreeze.vercel.app';

/// A real hyperlink on the dark panel (pointer cursor, underline on hover via the default link colour).
class _Link extends StatelessWidget {
  const _Link({required this.icon, required this.label, required this.url});
  final IconData icon;
  final String label;
  final String url;
  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: () {
        analytics.track('link_click', {
          'target': url.endsWith('.apk') ? 'apk_download' : 'web_app',
        });
        launchUrl(Uri.parse(url), webOnlyWindowName: '_blank');
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF7DB8FF)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF7DB8FF),
              decoration: TextDecoration.underline,
              decorationColor: Color(0xFF7DB8FF),
            ),
          ),
        ],
      ),
    ),
  );
}

class _Step extends StatelessWidget {
  const _Step(this.n, this.text);
  final int n;
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xFF3395FF),
            shape: BoxShape.circle,
          ),
          child: Text(
            '$n',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              height: 1.45,
              color: Color(0xE6FFFFFF),
            ),
          ),
        ),
      ],
    ),
  );
}

/// The QuickUnfreeze mark (same geometry as the app icon, 512-unit artboard): a slanted ice cube
/// with a rupee, melting into a drop.
class _LogoPainter extends CustomPainter {
  const _LogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 512);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, 0, 512, 512),
        const Radius.circular(112),
      ),
      Paint()..color = const Color(0xFF072654),
    );
    canvas.translate(256, 256);
    canvas.scale(1.12);
    canvas.translate(-274, -251);
    Path poly(List<Offset> pts) => Path()..addPolygon(pts, true);
    canvas.drawPath(
      poly(const [
        Offset(168, 132),
        Offset(372, 132),
        Offset(404, 92),
        Offset(200, 92),
      ]),
      Paint()..color = const Color(0xFF9CCBFF),
    );
    canvas.drawPath(
      poly(const [
        Offset(372, 132),
        Offset(404, 92),
        Offset(380, 300),
        Offset(348, 340),
      ]),
      Paint()..color = const Color(0xFF1F5AF0),
    );
    canvas.drawPath(
      poly(const [
        Offset(168, 132),
        Offset(372, 132),
        Offset(348, 340),
        Offset(144, 340),
      ]),
      Paint()..color = const Color(0xFF3395FF),
    );
    canvas.drawPath(
      poly(const [
        Offset(186, 150),
        Offset(214, 150),
        Offset(196, 300),
        Offset(168, 300),
      ]),
      Paint()..color = const Color(0x47FFFFFF),
    );
    final tp = TextPainter(
      text: const TextSpan(
        text: '₹',
        style: TextStyle(
          fontSize: 168,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          fontFamily: 'Inter',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(276 - tp.width / 2, 236 - tp.height / 2));
    final drop = Path()
      ..moveTo(246, 362)
      ..cubicTo(246, 362, 222, 394, 222, 410)
      ..arcToPoint(
        const Offset(270, 410),
        radius: const Radius.circular(24),
        clockwise: false,
      )
      ..cubicTo(270, 394, 246, 362, 246, 362)
      ..close();
    canvas.drawPath(drop, Paint()..color = const Color(0xFF9CCBFF));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
