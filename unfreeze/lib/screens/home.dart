import 'package:flutter/material.dart';

import '../analytics.dart';
import '../app_state.dart';
import '../fixtures.dart';
import '../ice_block.dart';
import '../platform.dart';
import '../nudge.dart';
import '../theme.dart';
import 'done.dart';
import 'freeze_flow.dart';
import 'risk_teaser.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final body = switch (_tab) {
      0 => const _HomeTab(),
      1 => const _PaymentsTab(),
      2 => const _ProductsTab(),
      3 => const _SupportTab(),
      _ => const _AccountTab(),
    };
    return Scaffold(
      body: SafeArea(bottom: false, child: body),
      bottomNavigationBar: _BottomNav(
        index: _tab,
        onTap: (i) => setState(() => _tab = i),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.index, required this.onTap});
  final int index;
  final ValueChanged<int> onTap;

  static const _items = [
    (Icons.home_outlined, Icons.home, 'Home'),
    (Icons.swap_horiz, Icons.swap_horiz, 'Payments'),
    (Icons.grid_view_outlined, Icons.grid_view, 'Products'),
    (Icons.help_outline, Icons.help, 'Support'),
    (Icons.account_circle, Icons.account_circle, 'Account'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              for (var i = 0; i < _items.length; i++)
                Expanded(
                  child: InkWell(
                    onTap: () => onTap(i),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          i == index ? _items[i].$2 : _items[i].$1,
                          size: 24,
                          color: i == index ? AppColors.blue : AppColors.ink,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _items[i].$3,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: i == index ? AppColors.blue : AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------------------------------ Home

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        appState,
        platform.notificationsAllowed,
        _bannerDismissed,
      ]),
      builder: (context, _) {
        final s = appState;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            const _Greeting(),
            const SizedBox(height: 12),
            if (!platform.notificationsAllowed.value &&
                s.status == CaseStatus.atRisk &&
                !_bannerDismissed.value)
              Nudge(
                radius: 14,
                child: _AlertBanner(
                  onOpen: () => _openFlow(context, 'banner'),
                  onDismiss: () => _bannerDismissed.value = true,
                ),
              ),
            const _CollectedCard(),
            const SizedBox(height: 14),
            s.status == CaseStatus.atRisk
                ? _HoldAlertCard(onStart: () => _openFlow(context, 'home_card'))
                : const _SubmittedCard(),
            const SizedBox(height: 14),
            const _RiskCard(),
            const SizedBox(height: 14),
            const _CollectPayments(),
            const SectionTitle('Payments'),
            const _PaymentsCard(),
            const SizedBox(height: 16),
            const Center(child: ConceptTag()),
          ],
        );
      },
    );
  }

  void _openFlow(BuildContext context, String source) {
    analytics.track('rekyc_open', {'source': source});
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const FreezeFlowScreen()));
  }
}

/// Web and denied-permission stand-in for the push notification: same words, same entry point.
final _bannerDismissed = ValueNotifier<bool>(false);

class _AlertBanner extends StatelessWidget {
  const _AlertBanner({required this.onOpen, required this.onDismiss});
  final VoidCallback onOpen;
  final VoidCallback onDismiss;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Material(
      color: AppColors.navy,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 4, 12),
          child: Row(
            children: [
              const Icon(
                Icons.notifications_active_outlined,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settlements on hold from ${Fixtures.holdDate}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Your re-KYC is due. Complete it in about 90 seconds to avoid the hold.',
                      style: TextStyle(
                        color: Color(0xCCFFFFFF),
                        fontSize: 12.5,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Color(0x99FFFFFF),
                  size: 18,
                ),
                onPressed: onDismiss,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _Greeting extends StatelessWidget {
  const _Greeting();
  String get _greeting {
    final h = DateTime.now().hour;
    return h < 12
        ? 'Good morning'
        : (h < 17 ? 'Good afternoon' : 'Good evening');
  }

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const CircleAvatar(
        radius: 18,
        backgroundColor: AppColors.chip,
        child: Text(
          Fixtures.initials,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
        ),
      ),
      const SizedBox(width: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _greeting,
            style: const TextStyle(fontSize: 12, color: AppColors.muted),
          ),
          const Text(
            Fixtures.ownerName,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.navy,
            ),
          ),
        ],
      ),
    ],
  );
}

class _CollectedCard extends StatelessWidget {
  const _CollectedCard();
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: Column(
        children: [
          const Text(
            'Collected today',
            style: TextStyle(fontSize: 13, color: AppColors.muted),
          ),
          const SizedBox(height: 4),
          Text(
            rupees(Fixtures.collectedToday),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 8),
          const SoftPill('View breakdown (${Fixtures.paymentsToday} payments)'),
          const SizedBox(height: 14),
          const Divider(),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _Stat(
                    'Next settlement',
                    rupees(Fixtures.nextSettlement),
                    Fixtures.nextSettlementNote,
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: _Stat(
                    'Account balance',
                    rupees(Fixtures.accountBalance),
                    'After fees & adjustments',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value, this.note);
  final String label, value, note;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 12),
    child: Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.muted),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          note,
          style: const TextStyle(fontSize: 11, color: AppColors.muted),
        ),
      ],
    ),
  );
}

/// The re-KYC warning. The ice block shows the money that would be held.
class _HoldAlertCard extends StatelessWidget {
  const _HoldAlertCard({required this.onStart});
  final VoidCallback onStart;
  @override
  Widget build(BuildContext context) {
    final s = appState;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.amber.withValues(alpha: .45)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Pill(
                  'ACTION NEEDED',
                  color: AppColors.amber,
                  bg: AppColors.amberBg,
                ),
                const Spacer(),
                Text(
                  '${s.daysLeft} days left',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.amber,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Settlements on hold from ${Fixtures.holdDate}',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Your re-KYC is due. Complete it so payouts keep reaching your bank.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.muted,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 4),
            IceBlock(
              amount: Fixtures.heldAmount,
              frozen: 1,
              forming: true,
              height: 128,
              caption: 'a week of settlements would be held',
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${3 - s.done.length} quick steps · about 90 seconds',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.muted,
                    ),
                  ),
                ),
                // Nudge the button only when the alert banner isn't already doing it.
                Nudge(
                  active:
                      platform.notificationsAllowed.value ||
                      _bannerDismissed.value,
                  radius: 22,
                  child: FilledButton(
                    onPressed: onStart,
                    child: const Text('Complete re-KYC'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Assumes RBI\'s re-KYC deadline of ${Fixtures.deadlineLabel} and a 30-day early settlement hold.',
              style: const TextStyle(fontSize: 10.5, color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubmittedCard extends StatelessWidget {
  const _SubmittedCard();
  @override
  Widget build(BuildContext context) {
    final needsMore = appState.status == CaseStatus.needsMore;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                needsMore ? const FreezeFlowScreen() : const DoneScreen(),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: needsMore ? AppColors.amberBg : AppColors.greenBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  needsMore ? Icons.error_outline : Icons.check,
                  color: needsMore ? AppColors.amber : AppColors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      needsMore ? 'One more thing needed' : 'Re-KYC submitted',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      needsMore
                          ? 'Fix it before ${Fixtures.holdDate} to avoid a settlement hold'
                          : 'Review usually done well before ${Fixtures.holdDate}',
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.muted),
            ],
          ),
        ),
      ),
    );
  }
}

class _RiskCard extends StatelessWidget {
  const _RiskCard();
  @override
  Widget build(BuildContext context) {
    final cleared = appState.riskCleared;
    // After re-KYC is submitted, the risk hold is the next thing to try.
    return Nudge(
      active: appState.status != CaseStatus.atRisk && !cleared,
      radius: 16,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) {
                analytics.track('risk_open');
                return const RiskTeaserScreen();
              },
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cleared ? AppColors.greenBg : AppColors.paleBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    cleared ? Icons.check : Icons.pause_circle_outline,
                    color: cleared ? AppColors.green : AppColors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cleared
                            ? 'Proof submitted for review'
                            : '₹12,600 on hold · risk review',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        cleared
                            ? 'Usually reviewed within 24 hours'
                            : 'Share proof of delivery to release it',
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.muted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CollectPayments extends StatelessWidget {
  const _CollectPayments();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.paleBlue,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Collect payments',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
          decoration: BoxDecoration(
            color: AppColors.navy,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(Icons.link, color: Colors.white70, size: 18),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Get paid on your branded payment link',
                      style: TextStyle(fontSize: 10.5, color: Colors.white60),
                    ),
                    Text(
                      Fixtures.paymentHandle,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.share_outlined, size: 14, color: AppColors.ink),
                    SizedBox(width: 4),
                    Text(
                      'Share',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _Tile(Icons.link, 'Payment\nlinks'),
            _Tile(Icons.description_outlined, 'Payment\npages'),
            _Tile(Icons.grid_view, 'All\nproducts'),
          ],
        ),
      ],
    ),
  );
}

class _Tile extends StatelessWidget {
  const _Tile(this.icon, this.label);
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: AppColors.blue, size: 30),
      ),
      const SizedBox(height: 6),
      Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.2,
        ),
      ),
    ],
  );
}

class _PaymentsCard extends StatelessWidget {
  const _PaymentsCard();
  @override
  Widget build(BuildContext context) {
    const bars = Fixtures.weekBars;
    final maxBar = bars.reduce((a, b) => a > b ? a : b);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rupees(88250),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                      const Text(
                        '112 payments',
                        style: TextStyle(fontSize: 13, color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
                const SoftPill('Past 7 days', outlined: true),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 110,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final b in bars)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          height: 110 * b / maxBar,
                          decoration: BoxDecoration(
                            color: b == bars.last
                                ? AppColors.blue
                                : AppColors.blue.withValues(alpha: .25),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '6 Oct',
                  style: TextStyle(fontSize: 11, color: AppColors.muted),
                ),
                Text(
                  '9 Oct',
                  style: TextStyle(fontSize: 11, color: AppColors.muted),
                ),
                Text(
                  '12 Oct',
                  style: TextStyle(fontSize: 11, color: AppColors.muted),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Row(
              children: [
                Expanded(
                  child: Text(
                    'Recent payments',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                  ),
                ),
                Text(
                  'See all',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            for (final p in Fixtures.payments.take(3)) _PaymentRow(p),
          ],
        ),
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow(this.p);
  final (String, String, int, String) p;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                p.$1,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${p.$2} · ${p.$4}',
                style: const TextStyle(fontSize: 12, color: AppColors.muted),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              rupees(p.$3),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const Pill(
              'CAPTURED',
              color: AppColors.green,
              bg: AppColors.greenBg,
            ),
          ],
        ),
      ],
    ),
  );
}

// -------------------------------------------------------------------------------------- Payments

class _PaymentsTab extends StatelessWidget {
  const _PaymentsTab();
  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,
    child: Column(
      children: [
        const TabBar(
          tabs: [
            Tab(text: 'Transactions'),
            Tab(text: 'Settlements'),
          ],
        ),
        Expanded(
          child: TabBarView(
            children: [
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.line),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search, size: 18, color: AppColors.muted),
                        SizedBox(width: 8),
                        Text(
                          'Search by payment ID, phone, email or order',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      SoftPill('Past 7 days', outlined: true),
                      SizedBox(width: 8),
                      SoftPill(
                        'Filters',
                        outlined: true,
                        trailing: Icons.filter_alt_outlined,
                      ),
                      Spacer(),
                      Text(
                        'Reports',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  for (final p in Fixtures.payments) ...[
                    _PaymentRow(p),
                    const Divider(),
                  ],
                ],
              ),
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'NEXT SETTLEMENT',
                            style: TextStyle(
                              fontSize: 11,
                              letterSpacing: .5,
                              color: AppColors.muted,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${rupees(Fixtures.nextSettlement)} · 14 Oct',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.navy,
                            ),
                          ),
                          const Text(
                            'New payments auto-settle to ${Fixtures.bankMasked}',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SectionTitle(
                    'Past settlements',
                    trailing: SoftPill('Past 7 days', outlined: true),
                  ),
                  const Wrap(
                    spacing: 8,
                    children: [
                      _FilterChip('All 4', selected: true),
                      _FilterChip('Processed 4'),
                      _FilterChip('Created 0'),
                      _FilterChip('Failed 0'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  for (final st in Fixtures.settlements)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.account_balance_outlined,
                            color: AppColors.muted,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  st.$1,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  st.$3,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            rupees(st.$2),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _FilterChip extends StatelessWidget {
  const _FilterChip(this.label, {this.selected = false});
  final String label;
  final bool selected;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: selected ? AppColors.paleBlue : Colors.white,
      border: Border.all(color: selected ? AppColors.blue : AppColors.line),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      label,
      style: TextStyle(
        fontSize: 13,
        color: selected ? AppColors.blue : AppColors.ink,
      ),
    ),
  );
}

// -------------------------------------------------------------------------------- Products/Support

class _ProductsTab extends StatelessWidget {
  const _ProductsTab();
  static const items = [
    (Icons.link, 'Payment Links'),
    (Icons.description_outlined, 'Payment Pages'),
    (Icons.qr_code_2, 'QR Codes'),
    (Icons.autorenew, 'Subscriptions'),
    (Icons.receipt_long_outlined, 'Invoices'),
    (Icons.storefront_outlined, 'Storefront'),
  ];
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      const Text(
        'Products',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.navy,
        ),
      ),
      const SizedBox(height: 12),
      GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: [
          for (final i in items)
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.line),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(i.$1, color: AppColors.blue, size: 28),
                  const SizedBox(height: 8),
                  Text(
                    i.$2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    ],
  );
}

class _SupportTab extends StatelessWidget {
  const _SupportTab();
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: const [
      Text(
        'Support',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.navy,
        ),
      ),
      SizedBox(height: 12),
      Card(
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.phone_callback_outlined),
              title: Text('Request a callback'),
              trailing: Icon(Icons.chevron_right),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.confirmation_number_outlined),
              title: Text('Raise a ticket'),
              trailing: Icon(Icons.chevron_right),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.menu_book_outlined),
              title: Text('Help articles'),
              trailing: Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    ],
  );
}

// --------------------------------------------------------------------------------------- Account

class _AccountTab extends StatelessWidget {
  const _AccountTab();
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      const Text(
        'Account and settings',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.navy,
        ),
      ),
      const SizedBox(height: 12),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.blue,
                    child: Text(
                      Fixtures.initials,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Fixtures.ownerName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                        ),
                      ),
                      Text(
                        'Owner',
                        style: TextStyle(fontSize: 12, color: AppColors.muted),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.chip,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Text(
                      'Merchant ID',
                      style: TextStyle(fontSize: 12, color: AppColors.muted),
                    ),
                    Spacer(),
                    Text(
                      Fixtures.merchantId,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.copy, size: 14),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 14),
      Card(
        child: Column(
          children: [
            _row(
              Icons.account_balance_outlined,
              'Bank accounts and settlements',
            ),
            const Divider(),
            _row(Icons.help_outline, 'Support'),
            const Divider(),
            _row(Icons.description_outlined, 'Terms & Conditions'),
            const Divider(),
            _row(Icons.shield_outlined, 'Privacy Policy'),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.restart_alt, color: AppColors.ink),
              title: const Text(
                'Reset demo',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                appState.reset();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Demo reset')));
              },
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      const Center(child: ConceptTag()),
    ],
  );

  Widget _row(IconData i, String t) => ListTile(
    leading: Icon(i, color: AppColors.ink),
    title: Text(
      t,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    ),
    trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
  );
}
