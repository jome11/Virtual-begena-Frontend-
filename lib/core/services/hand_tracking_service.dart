import 'package:flutter/material.dart';

import 'web_hand_tracking_service.dart';

/// Every camera-driven screen talks to this interface only.
/// Swap `handTrackingService` at the bottom for your real model —
/// no screen needs to change.
abstract class HandTrackingService extends ChangeNotifier {
  bool get isReady;
  String? get detectedFinger;   // e.g. 'THUMB'
  int? get detectedString;      // 1-based string index
  bool? get lastPluckCorrect;

  Future<void> start();
  Future<void> stop();
  Future<void> recalibrate();
}

class MockHandTrackingService extends HandTrackingService {
  bool _ready = false;
  @override
  bool get isReady => _ready;
  @override
  String? get detectedFinger => null;
  @override
  int? get detectedString => null;
  @override
  bool? get lastPluckCorrect => null;

  @override
  Future<void> start() async {
    await Future.delayed(const Duration(milliseconds: 800));
    _ready = true;
    notifyListeners();
  }

  @override
  Future<void> stop() async {
    _ready = false;
    notifyListeners();
  }

  @override
  Future<void> recalibrate() async {
    await stop();
    await start();
  }
}

// Swap this back to MockHandTrackingService() if you need to develop UI
// without a working JS hand-tracking model wired up yet.
final HandTrackingService handTrackingService = WebHandTrackingService();