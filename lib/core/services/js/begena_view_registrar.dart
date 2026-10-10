import 'dart:ui_web' as ui_web;
import 'package:web/web.dart' as web;

class BegenaViewRegistrar {
  static const stageViewId = 'begena-viewer-stage';
  static bool _registered = false;

  static void ensureRegistered() {
    if (_registered) return;
    ui_web.platformViewRegistry.registerViewFactory(stageViewId, (int _) {
      return web.HTMLDivElement()
        ..id = stageViewId
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.position = 'relative';
    });
    _registered = true;
  }
}
