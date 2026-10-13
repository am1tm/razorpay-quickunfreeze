import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../analytics.dart';
import '../app_state.dart';
import '../fixtures.dart';
import '../ice_block.dart';
import '../theme.dart';
import 'freeze_flow.dart';

class DoneScreen extends StatelessWidget {
  const DoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final s = appState;
        final needsMore = s.status == CaseStatus.needsMore;
        final time = s.submittedAt == null
            ? ''
            : '${s.submittedAt!.hour.toString().padLeft(2, '0')}:${s.submittedAt!.minute.toString().padLeft(2, '0')}';
        return Scaffold(
          appBar: innerAppBar(context, 'Re-KYC status'),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            children: [
              IceBlock(
                amount: Fixtures.heldAmount,
                frozen: needsMore ? 0.12 : 0,
                height: 110,
              ),
              Text(
                needsMore ? 'One more thing needed' : 'Submitted ✓',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                needsMore
                    ? 'Fix it before ${Fixtures.holdDate} to avoid a settlement hold'
                    : 'Review usually done well before ${Fixtures.holdDate}. Settlements continue meanwhile.',
                style: const TextStyle(color: AppColors.muted, fontSize: 15),
              ),
              const SizedBox(height: 6),
              // Long-press the reference to simulate the review asking for one more thing (demo toggle).
              GestureDetector(
                onLongPress: () => s.markNeedsMore(StepId.photo),
                child: Text(
                  'Ref ${s.referenceId ?? '—'}',
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ),
              const SizedBox(height: 14),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      _TrackStep(
                        label: 'Submitted',
                        detail: 'Today $time',
                        state: _S.done,
                      ),
                      _TrackStep(
                        label: needsMore
                            ? 'Shop photo needs a retake'
                            : 'Under review',
                        detail: needsMore
                            ? 'Tap to fix it'
                            : 'Usually within 24 hours',
                        state: needsMore ? _S.attention : _S.active,
                        onTap: needsMore
                            ? () => Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const FreezeFlowScreen(),
                                ),
                              )
                            : null,
                      ),
                      const _TrackStep(
                        label: 'Verified',
                        detail: "You'll get a notification",
                        state: _S.pending,
                        last: true,
                      ),
                    ],
                  ),
                ),
              ),
              if (s.photoNeedsHumanReview)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Your photo was sent to a person to review.',
                    style: TextStyle(color: AppColors.muted),
                  ),
                ),
              const SizedBox(height: 14),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.event_available_outlined),
                  title: const Text(
                    'A verification visit may be required',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text('Book a 30-minute slot that suits you'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _bookSheet(context),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                icon: const Icon(Icons.share_outlined),
                label: const Text('Share confirmation on WhatsApp'),
                onPressed: () {
                  analytics.track('whatsapp_share');
                  SharePlus.instance.share(
                    ShareParams(
                      text:
                          'Re-KYC submitted for ${Fixtures.businessName} (ref ${s.referenceId}). '
                          'Review usually done well before ${Fixtures.holdDate}.',
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.support_agent),
                label: const Text('Talk to a person (case pre-filled)'),
                onPressed: () => _callbackSheet(context),
              ),
              const SizedBox(height: 16),
              FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () =>
                    Navigator.of(context).popUntil((r) => r.isFirst),
                child: const Text('Back to home'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _bookSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => _BookSheet(
        onBooked: (slot) {
          Navigator.pop(ctx);
          analytics.track('visit_booked');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Visit booked: $slot')));
        },
      ),
    );
  }

  void _callbackSheet(BuildContext context) {
    analytics.track('callback_request');
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Callback requested',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Today, 4–6 pm. Case ${appState.referenceId} is attached, so you won\'t have to explain it again.',
              style: const TextStyle(height: 1.4),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}

enum _S { done, active, attention, pending }

class _TrackStep extends StatelessWidget {
  const _TrackStep({
    required this.label,
    required this.detail,
    required this.state,
    this.last = false,
    this.onTap,
  });
  final String label, detail;
  final _S state;
  final bool last;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = switch (state) {
      _S.done => AppColors.green,
      _S.active => AppColors.blue,
      _S.attention => AppColors.amber,
      _S.pending => AppColors.line,
    };
    return InkWell(
      onTap: onTap,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Icon(
                  state == _S.done ? Icons.check_circle : Icons.circle,
                  size: 18,
                  color: color,
                ),
                if (!last)
                  Expanded(child: Container(width: 2, color: AppColors.line)),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: state == _S.pending
                            ? AppColors.muted
                            : AppColors.navy,
                      ),
                    ),
                    Text(
                      detail,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (onTap != null) const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class _BookSheet extends StatelessWidget {
  const _BookSheet({required this.onBooked});
  final ValueChanged<String> onBooked;
  static const slots = [
    'Tomorrow, 11:00–11:30',
    'Tomorrow, 4:00–4:30',
    'Thu, 10:00–10:30',
  ];
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pick a visit slot',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        for (final s in slots)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.schedule),
            title: Text(s),
            onTap: () => onBooked(s),
          ),
      ],
    ),
  );
}
