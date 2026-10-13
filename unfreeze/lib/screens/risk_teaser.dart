import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../app_state.dart';
import '../fixtures.dart';
import '../ice_block.dart';
import '../theme.dart';
import '../why_card.dart';

/// Second case: a risk hold that has ALREADY happened (two flagged orders). The same vernacular
/// explanation card as re-KYC explains it; proof of delivery from the gallery releases it (mock).
class RiskTeaserScreen extends StatelessWidget {
  const RiskTeaserScreen({super.key});

  Future<void> _addProof(BuildContext context) async {
    final picked = await ImagePicker().pickMultiImage(
      maxWidth: 1280,
      imageQuality: 70,
      limit: 2,
    );
    if (picked.isEmpty) return;
    appState.clearRisk();
    await meltTick();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final cleared = appState.riskCleared;
        return Scaffold(
          appBar: innerAppBar(context, 'Settlement on hold'),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            children: [
              IceBlock(
                amount: Fixtures.riskAmount,
                frozen: cleared ? 0 : 1,
                extraCubes: cleared ? 0 : 3,
                caption: cleared
                    ? 'proof submitted'
                    : '2 orders held for a routine check',
              ),
              const SizedBox(height: 8),
              Text(
                cleared ? 'Proof submitted ✓' : '₹12,600 is on hold',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                cleared
                    ? 'A reviewer will check it, usually within 24 hours. New payments keep settling.'
                    : 'Two recent orders were flagged for review. Show they were delivered and the hold lifts.',
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),
              if (!cleared) ...[
                WhyCard(
                  key: ValueKey(('risk', appState.lang)),
                  lang: appState.lang,
                  topic: HoldTopic.risk,
                ),
                const SizedBox(height: 12),
                const Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Order #2271 · ₹7,400'),
                        subtitle: Text('Wedding cake · paid 2 Oct'),
                      ),
                      Divider(height: 1),
                      ListTile(
                        title: Text('Order #2276 · ₹5,200'),
                        subtitle: Text('Custom hamper · paid 4 Oct'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () => _addProof(context),
                  icon: const Icon(Icons.add_photo_alternate_outlined),
                  label: const Text('Add proof of delivery'),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Delivery photos, chat screenshots or courier receipts from your gallery.',
                  style: TextStyle(fontSize: 12, color: AppColors.muted),
                ),
              ] else
                FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back to home'),
                ),
            ],
          ),
        );
      },
    );
  }
}
