import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'theme.dart';

/// The money, frozen. [frozen] 1.0 = solid block, 0.0 = fully melted (amount shown free).
/// Changes animate: the block shrinks from the top, drips appear, a puddle spreads, and the
/// amount counts up as it thaws. [forming] adds creeping frost for the prevention state.
class IceBlock extends StatelessWidget {
  const IceBlock({
    super.key,
    required this.amount,
    required this.frozen,
    this.height = 170,
    this.forming = false,
    this.caption,
    this.extraCubes = 0,
  });

  final int amount;
  final double frozen;
  final double height;
  final bool forming;
  final String? caption;

  /// Small cubes stacked on the block: settlements that froze since the hold (risk teaser).
  final int extraCubes;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: frozen.clamp(0, 1)),
        duration: const Duration(milliseconds: 1100),
        curve: Curves.easeInOutCubic,
        builder: (context, f, _) {
          final thawed = 1 - f;
          final shown =
              amount; // the money never changes; only the ice around it does
          return SizedBox(
            width: double.infinity,
            height: height,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: _FrostAnimated(
                    builder: (t) => CustomPaint(
                      painter: _IcePainter(
                        frozen: f,
                        forming: forming,
                        t: t,
                        extraCubes: extraCubes,
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '₹${formatInr(shown)}${f < 0.02 ? ' ✓' : ''}',
                      style: TextStyle(
                        fontSize: height * 0.2,
                        fontWeight: FontWeight.w700,
                        color: Color.lerp(
                          AppColors.iceText,
                          AppColors.navy,
                          thawed,
                        ),
                        shadows: f > 0.3
                            ? [
                                const Shadow(
                                  color: Colors.white,
                                  blurRadius: 12,
                                ),
                              ]
                            : null,
                      ),
                    ),
                    if (caption != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          caption!,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.navy.withValues(alpha: .7),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Slow shimmer for frost and drips; cheap because only this subtree repaints.
class _FrostAnimated extends StatefulWidget {
  const _FrostAnimated({required this.builder});
  final Widget Function(double t) builder;
  @override
  State<_FrostAnimated> createState() => _FrostAnimatedState();
}

class _FrostAnimatedState extends State<_FrostAnimated>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  )..repeat();
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    builder: (_, _) => widget.builder(_c.value),
  );
}

class _IcePainter extends CustomPainter {
  _IcePainter({
    required this.frozen,
    required this.forming,
    required this.t,
    required this.extraCubes,
  });
  final double frozen;
  final bool forming;
  final double t;
  final int extraCubes;

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = Random(7);
    final w = size.width, h = size.height;
    final blockW = min(w * 0.82, h * 2.1);
    final left = (w - blockW) / 2;
    final bottom = h * 0.9;
    final fullH = h * 0.78;
    final level = forming ? 1.0 : frozen;
    final blockH = fullH * (0.06 + 0.94 * level);
    final top = bottom - blockH;

    // Puddle grows as the block melts.
    final melt = forming ? 0.0 : 1 - frozen;
    if (melt > 0.02) {
      final puddle = Rect.fromCenter(
        center: Offset(w / 2, bottom + 2),
        width: blockW * (0.9 + 0.35 * melt),
        height: 10 + 8 * melt,
      );
      canvas.drawOval(
        puddle,
        Paint()..color = AppColors.water.withValues(alpha: 0.25 + 0.35 * melt),
      );
    }

    if (level < 0.03) return;

    final r = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, blockW, blockH),
      Radius.circular(18 * (0.5 + level / 2)),
    );

    // Body.
    canvas.drawRRect(
      r,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFF2FBFF).withValues(alpha: .95),
            const Color(0xFFC8ECFB).withValues(alpha: .9),
            const Color(0xFF9FD8F2).withValues(alpha: .9),
          ],
        ).createShader(r.outerRect),
    );

    canvas.save();
    canvas.clipRRect(r);

    // Glossy highlight band.
    final band = Path()
      ..moveTo(left + blockW * 0.08, top)
      ..lineTo(left + blockW * 0.26, top)
      ..lineTo(left + blockW * 0.06, bottom)
      ..lineTo(left - blockW * 0.12, bottom)
      ..close();
    canvas.drawPath(
      band,
      Paint()..color = Colors.white.withValues(alpha: 0.35),
    );

    // Frost specks.
    final speck = Paint()..color = Colors.white.withValues(alpha: 0.7);
    for (var i = 0; i < 70; i++) {
      final dx = left + rnd.nextDouble() * blockW;
      final dy = top + rnd.nextDouble() * blockH;
      canvas.drawCircle(Offset(dx, dy), rnd.nextDouble() * 1.6 + 0.3, speck);
    }

    // Cracks.
    final crack = Paint()
      ..color = Colors.white.withValues(alpha: 0.75)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < 4; i++) {
      var p = Offset(
        left + blockW * (0.15 + 0.22 * i),
        top + blockH * (0.15 + 0.1 * (i % 2)),
      );
      final path = Path()..moveTo(p.dx, p.dy);
      for (var s = 0; s < 4; s++) {
        p = p.translate((rnd.nextDouble() - .5) * 26, blockH * 0.12);
        path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(path, crack);
    }
    canvas.restore();

    // Rim.
    canvas.drawRRect(
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colors.white.withValues(alpha: 0.9),
    );

    // Creeping frost at the edges while the freeze is forming (prevention state).
    if (forming) {
      final frost = Paint()
        ..color = Colors.white.withValues(alpha: 0.55 + 0.25 * sin(t * 2 * pi));
      for (var i = 0; i < 26; i++) {
        final edge = i % 2 == 0 ? left : left + blockW;
        final y = top + (i / 26) * blockH;
        final len = 6 + 10 * ((sin(t * 2 * pi + i) + 1) / 2);
        final dir = i % 2 == 0 ? 1.0 : -1.0;
        canvas.drawLine(
          Offset(edge, y),
          Offset(edge + dir * len, y + 4),
          frost
            ..strokeWidth = 1.4
            ..strokeCap = StrokeCap.round,
        );
      }
    }

    // Drips while melting.
    if (melt > 0.05) {
      final drip = Paint()..color = AppColors.water.withValues(alpha: 0.8);
      for (var i = 0; i < 4; i++) {
        final x = left + blockW * (0.2 + 0.2 * i);
        final phase = (t + i * 0.27) % 1;
        final y = bottom + 4 + phase * 14;
        canvas.drawOval(
          Rect.fromCenter(center: Offset(x, y), width: 5, height: 7),
          drip..color = drip.color.withValues(alpha: 0.8 * (1 - phase)),
        );
      }
    }

    // Stacked small cubes: settlements frozen since the hold.
    for (var i = 0; i < extraCubes; i++) {
      final s = 22.0;
      final cube = RRect.fromRectAndRadius(
        Rect.fromLTWH(left + blockW - s * (i + 1.3), top - s * 0.75, s, s),
        const Radius.circular(5),
      );
      canvas.drawRRect(cube, Paint()..color = const Color(0xFFD7F1FC));
      canvas.drawRRect(
        cube,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(_IcePainter old) =>
      old.frozen != frozen ||
      old.t != t ||
      old.forming != forming ||
      old.extraCubes != extraCubes;
}

/// Haptic tick used when a step melts part of the block.
Future<void> meltTick() => HapticFeedback.mediumImpact();
