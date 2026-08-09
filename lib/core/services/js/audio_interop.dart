import 'dart:js_interop';

@JS('playAudio')
external void _playAudio(JSAny path);

void playAudio(String path) => _playAudio(path.toJS);
