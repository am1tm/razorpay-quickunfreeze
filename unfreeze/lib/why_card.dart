import 'package:flutter/material.dart';

import 'analytics.dart';
import 'api.dart';
import 'app_state.dart';
import 'fixtures.dart';
import 'nudge.dart';
import 'platform.dart';
import 'theme.dart';

/// "Why is this happening?" — explanation plus press-and-hold voice questions.
class WhyCard extends StatefulWidget {
  const WhyCard({super.key, required this.lang, required this.topic});
  final Lang lang;
  final HoldTopic topic;
  @override
  State<WhyCard> createState() => _WhyCardState();
}

class _WhyCardState extends State<WhyCard> {
  bool _recording = false;
  bool _thinking = false;
  VoiceAnswer? _answer;
  String? _asked;
  final _sw = Stopwatch();
  String _method = 'chip';

  Future<void> _startRecording() async {
    appState.markAsked();
    _method = 'voice';
    await platform.stopPlayback();
    final ok = await platform.startRecording();
    if (!ok) {
      if (mounted) setState(() {});
      return;
    }
    setState(() => _recording = true);
    platform.recordingDone?.then((wav) async {
      if (!mounted) return;
      setState(() {
        _recording = false;
        _thinking = true;
        _asked = null;
      });
      _sw
        ..reset()
        ..start();
      analytics.track('ray_ask', {
        'method': 'voice',
        'lang': widget.lang.name,
        'topic': widget.topic.name,
        'heard': wav != null,
      });
      final a = wav == null
          ? VoiceAnswer.fallback(widget.lang, topic: widget.topic)
          : await api.answerSpoken(wav, widget.lang, widget.topic);
      _show(a);
    });
  }

  Future<void> _askChip(String q) async {
    appState.markAsked();
    _method = 'chip';
    _sw
      ..reset()
      ..start();
    analytics.track('ray_ask', {
      'method': 'chip',
      'lang': widget.lang.name,
      'topic': widget.topic.name,
    });
    await platform.stopPlayback();
    setState(() {
      _thinking = true;
      _asked = q;
    });
    _show(await api.answerText(q, widget.lang, widget.topic));
  }

  void _show(VoiceAnswer a) {
    analytics.track('ray_answer', {
      'live': a.live,
      'method': _method,
      'lang': widget.lang.name,
      'topic': widget.topic.name,
      'latency_ms': _sw.elapsedMilliseconds,
    });
    if (!mounted) return;
    setState(() {
      _thinking = false;
      _answer = a;
    });
    platform.play(a);
  }

  @override
  Widget build(BuildContext context) {
    final lang = widget.lang;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const RayBadge(),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text(
                    'AI assistant',
                    style: TextStyle(fontSize: 11.5, color: AppColors.muted),
                  ),
                ),
                for (final l in Lang.values)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: ChoiceChip(
                      label: Text(l.chip, style: const TextStyle(fontSize: 12)),
                      selected: lang == l,
                      showCheckmark: false,
                      onSelected: (_) => appState.setLang(l),
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              lang.whyTitle,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 2),
            // No auto-explanation: the merchant asks (chip or voice), so attention goes to the question.
            Text(
              lang.askHint,
              style: const TextStyle(fontSize: 12.5, color: AppColors.muted),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final q in Fixtures.suggestions(widget.topic)[lang]!)
                  ActionChip(
                    label: Text(q, style: const TextStyle(fontSize: 12)),
                    onPressed: _thinking ? null : () => _askChip(q),
                  ),
              ],
            ),
            ValueListenableBuilder<bool>(
              valueListenable: platform.micAvailable,
              builder: (context, mic, _) => !mic
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ListenableBuilder(
                        listenable: appState,
                        builder: (context, child) => Nudge(
                          active: !appState.askedOnce && !_recording,
                          times: 3,
                          bump: .03,
                          child: child!,
                        ),
                        child: GestureDetector(
                          onLongPressStart: (_) => _startRecording(),
                          onLongPressEnd: (_) => platform.stopRecording(),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _recording
                                  ? AppColors.red.withValues(alpha: .1)
                                  : AppColors.blue.withValues(alpha: .08),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _recording ? Icons.mic : Icons.mic_none,
                                  color: _recording
                                      ? AppColors.red
                                      : AppColors.blue,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _recording ? lang.listening : lang.holdToAsk,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
            if (_thinking)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Ray.teal,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.6,
                          color: Ray.mint,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        lang.thinking,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (_answer != null && !_thinking)
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Ray.pale,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_asked != null)
                      Text(
                        '“$_asked”',
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    const SizedBox(height: 6),
                    const Row(
                      children: [
                        Icon(Icons.auto_awesome, size: 13, color: Ray.mint),
                        SizedBox(width: 4),
                        Text(
                          'R.A.Y.',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Ray.teal,
                            letterSpacing: .4,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(_answer!.text, style: const TextStyle(height: 1.4)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          icon: const Icon(Icons.volume_up_outlined),
                          onPressed: () => platform.play(_answer!),
                        ),
                        if (!_answer!.live)
                          const Pill('saved answer', color: AppColors.muted),
                      ],
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 6),
            const Text(
              'Voice is processed by Sarvam AI. Prototype only.',
              style: TextStyle(fontSize: 10.5, color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}

/// R.A.Y., Razorpay's AI assistant, in its own palette (deep teal + mint). A text badge with a
/// generic sparkle, not Razorpay's mark.
class Ray {
  static const teal = Color(0xFF0F3D3A);
  static const mint = Color(0xFF4FC48A);
  static const pale = Color(0xFFE9F7EF);
}

class RayBadge extends StatelessWidget {
  const RayBadge({super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration: BoxDecoration(
      color: Ray.teal,
      borderRadius: BorderRadius.circular(20),
    ),
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.auto_awesome, size: 12, color: Ray.mint),
        SizedBox(width: 5),
        Text(
          'R.A.Y.',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 11.5,
            letterSpacing: .4,
          ),
        ),
      ],
    ),
  );
}
