import 'dart:async';
import 'dart:convert';

import 'hand_tracking_service.dart';
import 'js/camera_view_registrar.dart';
import 'js/hand_tracking_interop.dart';

/// Real, camera-backed implementation.
class WebHandTrackingService extends HandTrackingService {
  Timer? _poll;

  bool _ready = false;
  String? _detectedFinger;
  int? _detectedString;
  bool? _lastPluckCorrect;
  Map<String, dynamic>? _lastPluck;

  @override
  bool get isReady => _ready;
  @override
  String? get detectedFinger => _detectedFinger;
  @override
  int? get detectedString => _detectedString;
  @override
  bool? get lastPluckCorrect => _lastPluckCorrect;
  @override
  Map<String, dynamic>? get lastPluck => _lastPluck;

  @override
  Future<void> start() async {
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

  @override
  void setQenet(String qenet) => HandTrackingInterop.setQenet(qenet);

  @override
  void setTargetFinger(int? finger) => HandTrackingInterop.setTargetFinger(finger);

  void _tick() {
    try {
      final json = HandTrackingInterop.getStateJson();
      if (json.isEmpty) return;
      final Map<String, dynamic> state = jsonDecode(json) as Map<String, dynamic>;
      _applyState(state);
    } catch (_) {
      // JS side not ready yet
    }
  }

  void _applyState(Map<String, dynamic> state) {
    final finger = state['finger'] as String?;
    final string = state['string'] as int?;
    final correct = state['correct'] as bool?;
    final lastPluck = state['lastPluck'] as Map<String, dynamic>?;

    bool changed = false;
    if (finger != _detectedFinger) {
      _detectedFinger = finger;
      changed = true;
    }
    if (string != _detectedString) {
      _detectedString = string;
      changed = true;
    }
    if (correct != _lastPluckCorrect) {
      _lastPluckCorrect = correct;
      changed = true;
    }
    
    // Check if timestamp changed for last pluck
    if (lastPluck != null && (lastPluck['timestamp'] != _lastPluck?['timestamp'])) {
      _lastPluck = lastPluck;
      changed = true;
    }

    if (changed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }
}
