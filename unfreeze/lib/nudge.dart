import 'package:flutter/material.dart';

import 'theme.dart';

/// A pre-attentive "tap here next" cue: a soft ring that breathes outward around [child].
/// Only one should be active on a screen at a time, so the eye is drawn to the next step
/// without the UI feeling busy. Stops animating (and costs nothing) when [active] is false.
///
/// With [times] set, it pulses that many times and then rests (with an optional small
/// [bump] in scale), so it catches the eye once instead of nagging.
class Nudge extends StatefulWidget {
  const Nudge({
    super.key,
    required this.child,
    this.active = true,
    this.radius = 14,
    this.color = AppColors.blue,
    this.times,
    this.bump = 0,
  });

  final Widget child;
  final bool active;
  final double radius;
  final Color color;

  /// Pulse this many times, then stop. Null = keep breathing while [active].
  final int? times;

  /// Extra scale at the peak of each pulse (e.g. 0.03 = 3%).
  final double bump;

  @override
  State<Nudge> createState() => _NudgeState();
}

class _NudgeState extends State<Nudge> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );
  bool _done = false;

  @override
  void initState() {
    super.initState();
    if (widget.active) _start();
  }

  Future<void> _start() async {
    if (widget.times == null) {
      _c.repeat();
      return;
    }
    for (var i = 0; i < widget.times! && mounted && widget.active; i++) {
      await _c.forward(from: 0);
    }
    if (mounted) setState(() => _done = true);
  }

  @override
  void didUpdateWidget(Nudge old) {
    super.didUpdateWidget(old);
    if (widget.active && !old.active && !_done) _start();
    if (!widget.active && _c.isAnimating) _c.stop();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active || _done) return widget.child;
    return AnimatedBuilder(
      animation: _c,
      child: widget.child,
      builder: (context, child) {
        final t = Curves.easeOut.transform(_c.value);
        // Scale bumps up in the first third of the pulse and settles back.
        final s =
            1 +
            widget.bump *
                (_c.value < .33 ? _c.value / .33 : (1 - _c.value) / .67);
        return Transform.scale(
          scale: s,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.radius),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: .32 * (1 - t)),
                  spreadRadius: 7 * t,
                  blurRadius: 4 + 6 * t,
                ),
              ],
            ),
            child: child,
          ),
        );
      },
    );
  }
}
