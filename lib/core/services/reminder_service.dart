import 'dart:js_interop';
import 'package:web/web.dart' as web;

class ReminderService {
  static Future<bool> enable() async {
    if (web.Notification.permission == 'granted') return true;
    final res = await web.Notification.requestPermission().toDart;
    return res.toDart == 'granted';
  }

  static void notifyIfNeeded(int done, int goal) {
    if (done >= goal || web.Notification.permission != 'granted') return;
    web.Notification(
      'Time to practice the begena 🎶',
      web.NotificationOptions(
        body: 'You are ${goal - done} session(s) away from today\'s goal.',
      ),
    );
  }
}
