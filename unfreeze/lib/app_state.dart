import 'dart:math';

import 'package:flutter/foundation.dart';

import 'analytics.dart';
import 'fixtures.dart';

enum StepId { details, digilocker, photo }

enum CaseStatus { atRisk, submitted, needsMore }

/// The one piece of state the whole demo runs on. The ice block's frozen level and the
/// checklist are both derived from [done].
class FreezeController extends ChangeNotifier {
  FreezeController({DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;

  final Set<StepId> done = {};
  CaseStatus status = CaseStatus.atRisk;
  Lang lang = Lang.hi;

  // Photo step outcome.
  int retakes = 0;
  bool photoNeedsHumanReview = false;
  String? photoNote;

  /// Business details shown pre-filled in step 1; the merchant can correct any row.
  final Map<String, String> details = Map.of(Fixtures.details);

  void editDetail(String key, String value) {
    details[key] = value;
    notifyListeners();
  }

  String? referenceId;
  DateTime? submittedAt;

  bool riskCleared = false;

  /// True once the merchant has asked R.A.Y. a question (drives the 'try the mic' nudge).
  bool askedOnce = false;

  void markAsked() {
    if (askedOnce) return;
    askedOnce = true;
    notifyListeners();
  }

  int get daysLeft => max(0, Fixtures.freezeDate.difference(_today()).inDays);

  DateTime _today() {
    final n = _clock();
    return DateTime(n.year, n.month, n.day);
  }

  /// 1.0 = fully frozen at the start of the flow, 0.0 = all three steps done.
  double get frozen => 1 - done.length / StepId.values.length;

  bool get allDone => done.length == StepId.values.length;

  void setLang(Lang l) {
    if (l == lang) return;
    lang = l;
    analytics.track('lang_change', {'lang': l.name});
    notifyListeners();
  }

  void complete(StepId step) {
    if (done.add(step)) {
      analytics.track('step_complete', {
        'step': step.name,
        'steps_done': done.length,
      });
      notifyListeners();
    }
  }

  void recordRetake() {
    retakes++;
    analytics.track('photo_retake', {'retakes': retakes});
    notifyListeners();
  }

  void completePhoto({String? note, bool humanReview = false}) {
    photoNote = note;
    photoNeedsHumanReview = humanReview;
    complete(StepId.photo);
  }

  void submit() {
    status = CaseStatus.submitted;
    submittedAt = _clock();
    referenceId ??= 'RK-${20400 + Random().nextInt(500)}';
    analytics.track('rekyc_submit', {
      'retakes': retakes,
      'human_review': photoNeedsHumanReview,
      'lang': lang.name,
    });
    notifyListeners();
  }

  /// Demo toggle: the (mock) review comes back asking for one more thing.
  void markNeedsMore(StepId step) {
    status = CaseStatus.needsMore;
    done.remove(step);
    notifyListeners();
  }

  void clearRisk() {
    riskCleared = true;
    analytics.track('risk_proof_submit');
    notifyListeners();
  }

  void reset() {
    done.clear();
    status = CaseStatus.atRisk;
    retakes = 0;
    photoNeedsHumanReview = false;
    photoNote = null;
    referenceId = null;
    submittedAt = null;
    riskCleared = false;
    askedOnce = false;
    details
      ..clear()
      ..addAll(Fixtures.details);
    notifyListeners();
  }
}

final appState = FreezeController();
