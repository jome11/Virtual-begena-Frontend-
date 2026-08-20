import 'package:flutter/material.dart';

import 'web_hand_tracking_service.dart';

abstract class HandTrackingService extends ChangeNotifier {
  bool get isReady;
  String? get detectedFinger;
  int? get detectedString;
  bool? get lastPluckCorrect;
  Map<String, dynamic>? get lastPluck;
  bool get pinching;
  Map<String, dynamic>? get lastTuningTick;

  Future<void> start();
  Future<void> stop();
  Future<void> recalibrate();
  void setVirtualStrings(bool on);
  bool captureCalibration();
  void setQenet(String qenet);
  void setTargetFinger(int? finger);
  void setMode(String mode);
  void setSelectedString(int stringNum);
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
  Map<String, dynamic>? get lastPluck => null;
  @override
  bool get pinching => false;
  @override
  Map<String, dynamic>? get lastTuningTick => null;

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

  @override
  void setVirtualStrings(bool on) {}

  @override
  bool captureCalibration() => true;

  @override
  void setQenet(String qenet) {}

  @override
  void setTargetFinger(int? finger) {}

  @override
  void setMode(String mode) {}

  @override
  void setSelectedString(int stringNum) {}
}

final HandTrackingService handTrackingService = WebHandTrackingService();
