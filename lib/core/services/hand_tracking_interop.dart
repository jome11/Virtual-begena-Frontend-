import 'dart:js_interop';

@JS('handTracking.start')
external JSPromise _start(String videoId, String canvasId);
@JS('handTracking.stop')
external void _stop();
@JS('handTracking.setQenet')
external void _setQenet(String qenet);
@JS('handTracking.setVirtualStrings')
external void _setVirtualStrings(bool on);
@JS('handTracking.setTargetFinger')
external void _setTargetFinger(JSAny? finger); // pass null or a number
@JS('handTracking.setMode')
external void _setMode(String mode);
@JS('handTracking.captureCalibration')
external bool _captureCalibration();
@JS('handTracking.clearCalibration')
external void _clearCalibration();
@JS('handTracking.getState')
external String _getState();

class HandTrackingInterop {
  static Future<void> start(String videoId, String canvasId) => _start(videoId, canvasId).toDart;
  static void stop() => _stop();
  static void setQenet(String qenet) => _setQenet(qenet);
  static void setVirtualStrings(bool on) => _setVirtualStrings(on);
  static void setTargetFinger(int? finger) => _setTargetFinger(finger?.toJS);
  static void setMode(String mode) => _setMode(mode);
  static bool captureCalibration() => _captureCalibration();
  static void clearCalibration() => _clearCalibration();
  static String getStateJson() => _getState();
}