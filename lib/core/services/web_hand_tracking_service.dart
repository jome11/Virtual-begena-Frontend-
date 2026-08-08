import 'dart:async';
import 'dart:convert';

import 'hand_tracking_service.dart';
import 'js/camera_view_registrar.dart';
import 'js/hand_tracking_interop.dart';

/// Real, camera-backed implementation. Talks to the `handTracking` JS
/// global through [HandTrackingInterop] and polls [HandTrackingInterop.getStateJson]
/// for the latest detection.
///
/// NOTE: adjust the JSON key names in [_applyState] to match whatever your
/// `handTracking.getState()` JS function actually returns.
class WebHandTrackingService extends HandTrackingService {
  Timer? _poll;

  bool _ready = false;
  String? _detectedFinger;
  int? _detectedString;
  bool? _lastPluckCorrect;

  @override
  bool get isReady => _ready;
  @override
  String? get detectedFinger => _detectedFinger;
  @override
  int? get detectedString => _detectedString;
  @override
  bool? get lastPluckCorrect => _lastPluckCorrect;

  @override
  Future<void> start() async {
    // Registers the <video>/<canvas> platform views. Must happen before
    // CameraFeedView's HtmlElementViews are built.
    CameraViewRegistrar.ensureRegistered();

    await HandTrackingInterop.start(
      CameraViewRegistrar.videoViewId,
      CameraViewRegistrar.canvasViewId,
    );

    _ready = true;
    notifyListeners();

    _poll?.cancel();
    _poll = Timer.periodic(const Duration(milliseconds: 100), (_) => _tick());
  }

  @override
  Future<void> stop() async {
    _poll?.cancel();
    _poll = null;
    HandTrackingInterop.stop();
    _ready = false;
    notifyListeners();
  }

  @override
  Future<void> recalibrate() async {
    HandTrackingInterop.clearCalibration();
    HandTrackingInterop.captureCalibration();
  }

  @override
  void setVirtualStrings(bool on) => HandTrackingInterop.setVirtualStrings(on);

  @override
  bool captureCalibration() => HandTrackingInterop.captureCalibration();

  void _tick() {
    late final Map<String, dynamic> state;
    try {
      state = jsonDecode(HandTrackingInterop.getStateJson()) as Map<String, dynamic>;
    } catch (_) {
      return; // JS side not ready yet on this tick
    }
    _applyState(state);
  }

  void _applyState(Map<String, dynamic> state) {
    final finger = state['finger'] as String?;
    final string = state['string'] as int?;
    final correct = state['correct'] as bool?;

    if (finger == _detectedFinger && string == _detectedString && correct == _lastPluckCorrect) {
      return; // nothing changed, skip the rebuild
    }

    _detectedFinger = finger;
    _detectedString = string;
    _lastPluckCorrect = correct;
    notifyListeners();
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }
}