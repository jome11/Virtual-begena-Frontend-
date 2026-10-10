import 'dart:js_interop';

@JS('begenaBridge.mount')
external JSPromise _mount(String containerId, String modelUrl, String partsUrl);
@JS('begenaBridge.select')
external void _select(JSAny? id);
@JS('begenaBridge.setView')
external void _setView(String name);
@JS('begenaBridge.destroy')
external void _destroy();
@JS('begenaBridge.getState')
external String _getState();
@JS('begenaBridge.getPartsJson')
external String _getPartsJson();

class BegenaViewerInterop {
  static Future<void> mount(String containerId, String modelUrl, String partsUrl) =>
      _mount(containerId, modelUrl, partsUrl).toDart;
  static void select(String? id) => _select(id?.toJS);
  static void setView(String name) => _setView(name);
  static void destroy() => _destroy();
  static String getStateJson() => _getState();
  static String getPartsJson() => _getPartsJson();
}
