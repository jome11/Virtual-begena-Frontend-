import 'dart:js_interop';

@JS('begena3D.mount')
external JSPromise _mount(String canvasId);
@JS('begena3D.isReady')
external bool _isReady();

class Begena3DInterop {
  static Future<void> mount(String canvasId) => _mount(canvasId).toDart;
  static bool isReady() => _isReady();
}
