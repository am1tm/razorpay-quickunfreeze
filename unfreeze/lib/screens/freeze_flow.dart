import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../analytics.dart';
import '../api.dart';
import '../app_state.dart';
import '../fixtures.dart';
import '../ice_block.dart';
import '../nudge.dart';
import '../theme.dart';
import '../why_card.dart';
import 'done.dart';

class FreezeFlowScreen extends StatefulWidget {
  const FreezeFlowScreen({super.key});
  @override
  State<FreezeFlowScreen> createState() => _FreezeFlowScreenState();
}

class _FreezeFlowScreenState extends State<FreezeFlowScreen> {
  @override
  void initState() {
    super.initState();
    api.ping();
  }

  Future<void> _complete(StepId step) async {
    appState.complete(step);
    await meltTick();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final s = appState;
        // Guide the eye: first ask R.A.Y. (mic nudge), then the next undone step gets a tint.
        final nextStep = StepId.values
            .where((x) => !s.done.contains(x))
            .firstOrNull;
        final guide = s.askedOnce || s.done.isNotEmpty;
        return Scaffold(
          appBar: innerAppBar(context, 'Complete re-KYC'),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            children: [
              const SizedBox(height: 8),
              Text(
                s.allDone
                    ? 'All set. Submit to avoid the hold.'
                    : 'Settlements on hold from ${Fixtures.holdDate}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: AppColors.muted),
              ),
              IceBlock(
                amount: Fixtures.heldAmount,
                frozen: s.frozen,
                height: 120,
                caption: s.allDone
                    ? 'hold avoided once submitted'
                    : '${s.done.length} of 3 steps done',
              ),
              const SizedBox(height: 10),
              WhyCard(
                key: ValueKey(s.lang),
                lang: s.lang,
                topic: HoldTopic.reKyc,
              ),
              const SizedBox(height: 12),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    _StepTile(
                      next: guide && nextStep == StepId.details,
                      title: 'Confirm business details',
                      subtitle: 'Already filled in. Just check.',
                      done: s.done.contains(StepId.details),
                      onTap: () => _detailsSheet(context),
                    ),
                    const Divider(height: 1),
                    _StepTile(
                      next: guide && nextStep == StepId.digilocker,
                      title: 'PAN & Aadhaar',
                      subtitle:
                          'Fetched from DigiLocker. No physical card needed.',
                      done: s.done.contains(StepId.digilocker),
                      onTap: () => _digilockerSheet(context),
                    ),
                    const Divider(height: 1),
                    _StepTile(
                      next: guide && nextStep == StepId.photo,
                      title: 'Shop or workspace photo',
                      subtitle:
                          s.photoNote ??
                          'One clear photo of where you run your business',
                      done: s.done.contains(StepId.photo),
                      onTap: () => _photoSheet(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Nudge(
                active: s.allDone,
                radius: 26,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: s.allDone
                      ? () {
                          s.submit();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const DoneScreen(),
                            ),
                          );
                        }
                      : null,
                  child: Text(
                    s.allDone
                        ? 'Submit re-KYC'
                        : 'Complete ${3 - s.done.length} more',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---- Step 1: confirm details --------------------------------------------------------------

  void _detailsSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your business details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const Text(
              'From your account. Tap a row to edit.',
              style: TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 8),
            ListenableBuilder(
              listenable: appState,
              builder: (context, _) => Column(
                children: [
                  for (final e in appState.details.entries)
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        e.key,
                        style: const TextStyle(color: AppColors.muted),
                      ),
                      subtitle: Text(
                        e.value,
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.navy,
                        ),
                      ),
                      trailing: e.key == 'PAN'
                          ? const Text(
                              'via DigiLocker',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.muted,
                              ),
                            )
                          : const Icon(Icons.edit_outlined, size: 18),
                      onTap: e.key == 'PAN'
                          ? null
                          : () => _editDetail(context, e.key, e.value),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                _complete(StepId.details);
              },
              child: const Text('Looks right'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editDetail(
    BuildContext context,
    String key,
    String value,
  ) async {
    final c = TextEditingController(text: value);
    final out = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit ${key.toLowerCase()}'),
        content: TextField(controller: c, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, c.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (out != null && out.isNotEmpty) appState.editDetail(key, out);
  }

  // ---- Step 2: DigiLocker (mock consent flow) -----------------------------------------------

  void _digilockerSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => _DigiLockerSheet(
        onDone: () {
          Navigator.pop(ctx);
          _complete(StepId.digilocker);
        },
      ),
    );
  }

  // ---- Step 3: photo + AI quality check ----------------------------------------------------

  void _photoSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => _PhotoSheet(
        onDone: () {
          Navigator.pop(ctx);
          meltTick();
        },
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({
    required this.title,
    required this.subtitle,
    required this.done,
    required this.onTap,
    this.next = false,
  });
  final String title, subtitle;
  final bool done;
  final VoidCallback onTap;

  /// The first step still to do: a light tint and a small "Next" tag (static, no motion).
  final bool next;
  @override
  Widget build(BuildContext context) => ListTile(
    tileColor: next ? AppColors.paleBlue.withValues(alpha: .55) : null,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    leading: AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: done
          ? const Icon(
              Icons.check_circle,
              color: AppColors.green,
              key: ValueKey(1),
            )
          : const Icon(
              Icons.radio_button_unchecked,
              color: AppColors.muted,
              key: ValueKey(0),
            ),
    ),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    subtitle: Text(subtitle),
    trailing: done
        ? null
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (next)
                const Pill('Next', color: AppColors.blue, bg: Colors.white),
              const Icon(Icons.chevron_right),
            ],
          ),
    onTap: done ? null : onTap,
  );
}

// ---------------------------------------------------------------------------------------------

class _DigiLockerSheet extends StatefulWidget {
  const _DigiLockerSheet({required this.onDone});
  final VoidCallback onDone;
  @override
  State<_DigiLockerSheet> createState() => _DigiLockerSheetState();
}

class _DigiLockerSheetState extends State<_DigiLockerSheet> {
  int _stage = 0; // 0 mobile, 1 otp, 2 consent, 3 fetched
  String _otp = '';

  Future<void> _sendOtp() async {
    setState(() => _stage = 1);
    for (final d in '482913'.split('')) {
      await Future<void>.delayed(const Duration(milliseconds: 180));
      if (!mounted) return;
      setState(() => _otp += d);
    }
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (mounted) setState(() => _stage = 2);
  }

  Future<void> _allow() async {
    setState(() => _stage = 3);
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    if (mounted) widget.onDone();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B3A6B),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.folder_shared,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'DigiLocker',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              const Pill('Mock', color: AppColors.muted),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: switch (_stage) {
              0 => Column(
                key: const ValueKey(0),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Aadhaar-linked mobile',
                    style: TextStyle(color: AppColors.muted),
                  ),
                  const Text(
                    '+91 ••••• •3210',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _sendOtp,
                    child: const Text('Send OTP'),
                  ),
                ],
              ),
              1 => Column(
                key: const ValueKey(1),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter the OTP sent to •3210',
                    style: TextStyle(color: AppColors.muted),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      for (var i = 0; i < 6; i++)
                        Container(
                          width: 40,
                          height: 48,
                          margin: const EdgeInsets.only(right: 8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.line),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            i < _otp.length ? _otp[i] : '',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Auto-filled from SMS',
                    style: TextStyle(fontSize: 12, color: AppColors.muted),
                  ),
                ],
              ),
              2 => Column(
                key: const ValueKey(2),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Share these documents with the payment company?',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  const ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.badge_outlined),
                    title: Text('PAN verification record'),
                  ),
                  const ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.fingerprint),
                    title: Text('Aadhaar (masked)'),
                  ),
                  const Text(
                    'Documents from DigiLocker are as valid as the originals.',
                    style: TextStyle(fontSize: 12, color: AppColors.muted),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(onPressed: _allow, child: const Text('Allow')),
                ],
              ),
              _ => const Padding(
                key: ValueKey(3),
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: AppColors.green, size: 32),
                    SizedBox(width: 10),
                    Text(
                      'PAN & Aadhaar fetched',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------------------------

class _PhotoSheet extends StatefulWidget {
  const _PhotoSheet({required this.onDone});
  final VoidCallback onDone;
  @override
  State<_PhotoSheet> createState() => _PhotoSheetState();
}

class _PhotoSheetState extends State<_PhotoSheet> {
  Uint8List? _bytes;
  bool _checking = false;
  PhotoVerdict? _verdict;

  Future<void> _pick(ImageSource src) async {
    final x = await ImagePicker().pickImage(
      source: src,
      maxWidth: 1280,
      imageQuality: 70,
    );
    if (x == null) return;
    final bytes = await x.readAsBytes();
    setState(() {
      _bytes = bytes;
      _checking = true;
      _verdict = null;
    });
    final v = await api.photoCheck(bytes);
    analytics.track('photo_check', {'pass': v.pass, 'advisory': v.advisory});
    if (!mounted) return;
    setState(() {
      _checking = false;
      _verdict = v;
    });
    if (v.pass) {
      await Future<void>.delayed(const Duration(milliseconds: 900));
      appState.completePhoto(
        note: v.advisory
            ? 'Accepted · a reviewer will check it'
            : 'Looks good: ${v.reason}',
      );
      widget.onDone();
    } else {
      appState.recordRetake();
    }
  }

  void _submitAnyway() {
    analytics.track('photo_submit_anyway');
    appState.completePhoto(
      note: 'Sent for a person to review',
      humanReview: true,
    );
    widget.onDone();
  }

  @override
  Widget build(BuildContext context) {
    final v = _verdict;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Shop or workspace photo',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const Text(
            'Your shop front, stall or, if you work from home, your workspace (for example, your baking counter).',
            style: TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 12),
          if (_bytes != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.memory(
                _bytes!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          if (_checking)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 10),
                  Text('Checking photo quality…'),
                ],
              ),
            ),
          if (v != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    v.pass ? Icons.check_circle : Icons.refresh,
                    color: v.pass ? AppColors.green : AppColors.amber,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      v.reason,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          if (!_checking && (v == null || !v.pass)) ...[
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _pick(ImageSource.camera),
                    icon: const Icon(Icons.photo_camera),
                    label: Text(v == null ? 'Take photo' : 'Retake'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pick(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Gallery'),
                  ),
                ),
              ],
            ),
            // AI advises, never blocks: after the first retake the merchant can send it for a person.
            if (appState.retakes > 0)
              TextButton(
                onPressed: _submitAnyway,
                child: const Text('Submit anyway, a person will review'),
              ),
          ],
          const SizedBox(height: 8),
          const Text(
            'Prototype: photos are sent to a third-party AI (Google Gemini) for a quality check. Don\'t upload real documents.',
            style: TextStyle(fontSize: 11, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
