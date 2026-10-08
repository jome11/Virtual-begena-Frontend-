import 'dart:js_interop';

@JS('begena3D.mount')
external JSPromise _mount(String canvasId);
@JS('begena3D.isReady')
external bool _isReady();
@JS('begena3D.pluck')
external void _pluck(int stringNumber);

class Begena3DInterop {
  static Future<void> mount(String canvasId) => _mount(canvasId).toDart;
  static bool isReady() => _isReady();
  static void pluck(int stringNumber) => _pluck(stringNumber);
}
