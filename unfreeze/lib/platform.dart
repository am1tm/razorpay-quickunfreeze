import 'dart:async';
import 'dart:io' show File;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart' show Color;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import 'api.dart';
import 'fixtures.dart';

/// Notifications, microphone and audio playback. Web and denied-permission paths are
/// handled here so screens never need to branch on platform.
class Platform {
  final _notifications = FlutterLocalNotificationsPlugin();
  final _recorder = AudioRecorder();
  final _player = AudioPlayer();

  /// True once Android granted POST_NOTIFICATIONS. False on web or when denied:
  /// the home screen then shows the in-app freeze banner instead.
  final notificationsAllowed = ValueNotifier<bool>(
    !kIsWeb,
  ); // corrected by init() on Android

  /// Hidden when the mic permission is denied; chips and clips still work.
  final micAvailable = ValueNotifier<bool>(true);

  static const maxRecording = Duration(seconds: 15);

  /// Called when the merchant taps the alert (set by main.dart to open the re-KYC flow).
  void Function()? onAlertTap;

  Future<void> init() async {
    if (kIsWeb) return;
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('ic_stat_unfreeze'),
    );
    await _notifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (_) => onAlertTap?.call(),
    );
    final launch = await _notifications.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp ?? false) onAlertTap?.call();
    final android = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    notificationsAllowed.value =
        await android?.requestNotificationsPermission() ?? false;
  }

  /// The demo's entry point: "Settlements on hold from (date). Complete re-KYC in about 90 seconds."
  Future<void> scheduleFreezeAlert({
    Duration after = const Duration(seconds: 4),
  }) async {
    if (kIsWeb || !notificationsAllowed.value) return;
    await Future<void>.delayed(after);
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'freeze_alerts',
        'Settlement alerts',
        channelDescription: 'Warnings before settlements pause',
        importance: Importance.high,
        priority: Priority.high,
        icon: 'ic_stat_unfreeze',
        color: Color(0xFF3395FF),
      ),
    );
    await _notifications.show(
      id: 1,
      title: 'Settlements on hold from ${Fixtures.holdDate}',
      body:
          'Your re-KYC is due. Complete it in about 90 seconds to avoid the hold.',
      notificationDetails: details,
    );
  }

  // ---- Microphone -------------------------------------------------------------------------

  Timer? _autoStop;
  Completer<Uint8List?>? _recording;

  Future<bool> startRecording() async {
    if (!await _recorder.hasPermission()) {
      micAvailable.value = false;
      return false;
    }
    final path = kIsWeb
        ? ''
        : '${(await getTemporaryDirectory()).path}/question.wav';
    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 16000,
        numChannels: 1,
      ),
      path: path,
    );
    _recording = Completer<Uint8List?>();
    _autoStop = Timer(maxRecording, () => stopRecording());
    return true;
  }

  /// Stops (or auto-stops at 15 s) and returns the WAV bytes.
  Future<Uint8List?> stopRecording() async {
    _autoStop?.cancel();
    final pending = _recording;
    if (pending == null) return null;
    _recording = null;
    final out = await _recorder.stop();
    Uint8List? bytes;
    if (out != null) {
      bytes = kIsWeb
          ? (await http.get(Uri.parse(out))).bodyBytes
          : await File(out).readAsBytes();
    }
    pending.complete(bytes);
    return bytes;
  }

  /// Completes when the current recording stops, including the 15 s auto-stop.
  Future<Uint8List?>? get recordingDone => _recording?.future;

  // ---- Playback ---------------------------------------------------------------------------

  Future<void> play(VoiceAnswer a) async {
    try {
      await _player.stop();
      if (a.audio != null) {
        if (kIsWeb) {
          await _player.setAudioSource(
            AudioSource.uri(Uri.dataFromBytes(a.audio!, mimeType: 'audio/wav')),
          );
        } else {
          final f = File(
            '${(await getTemporaryDirectory()).path}/answer_${DateTime.now().millisecondsSinceEpoch}.wav',
          );
          await f.writeAsBytes(a.audio!);
          await _player.setFilePath(f.path);
        }
      } else {
        await _player.setAsset(a.clipAsset!);
      }
      await _player.play();
    } catch (e) {
      debugPrint('playback failed: $e');
    }
  }

  Future<void> stopPlayback() => _player.stop();
}

final platform = Platform();
