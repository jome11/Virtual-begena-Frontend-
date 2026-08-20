import 'dart:ui_web' as ui_web;
import 'package:web/web.dart' as web;

class Begena3DCanvasRegistrar {
  static const canvasViewId = 'begena-3d-canvas';
  static bool _registered = false;

  static void ensureRegistered() {
    if (_registered) return;
    ui_web.platformViewRegistry.registerViewFactory(canvasViewId, (int _) {
      return web.HTMLCanvasElement()
        ..id = canvasViewId
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.display = 'block';
    });
    _registered = true;
  }
}
