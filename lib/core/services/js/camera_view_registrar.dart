import 'dart:ui_web' as ui_web;
import 'package:web/web.dart' as web;

class CameraViewRegistrar {
  static const videoViewId = 'begena-camera-video';
  static const canvasViewId = 'begena-camera-canvas';
  static bool _registered = false;

  static void ensureRegistered() {
    if (_registered) return;
    ui_web.platformViewRegistry.registerViewFactory(videoViewId, (int _) {
      return web.HTMLVideoElement()
        ..id = videoViewId
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'cover'
        ..style.transform = 'scaleX(-1)' // mirror, matches the React version
        ..autoplay = true
        ..muted = true;
    });
    ui_web.platformViewRegistry.registerViewFactory(canvasViewId, (int _) {
      return web.HTMLCanvasElement()
        ..id = canvasViewId
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.transform = 'scaleX(-1)'
        ..style.position = 'absolute'
        ..style.top = '0'
        ..style.left = '0';
    });
    _registered = true;
  }
}