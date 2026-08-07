import 'dart:convert';
import 'api_client.dart';

const fingerNumberByName = {'THUMB': 1, 'INDEX': 2, 'MIDDLE': 3, 'RING': 4, 'PINKY': 5};

class ProgressService {
  static Future<void> saveSession({
    required String mode, // 'exercise' | 'freeplay' | 'mezmur'
    required String qenet, // 'selamta' | 'tezeta' | 'anchihoye'
    required int correct,
    required int wrong,
    required int accuracy,
    required int sessionNum,
    String? mezmurName,
    Map<int, int> fingerMistakes = const {},
    Map<int, int> fingerSuccesses = const {},
  }) async {
    await ApiClient.post('/progress/save', {
      'mode': mode,
      'qenet': qenet,
      'correct': correct,
      'wrong': wrong,
      'accuracy': accuracy,
      'session_num': sessionNum,
      'mezmur_name': mezmurName,
      'finger_mistakes': fingerMistakes.map((k, v) => MapEntry('$k', v)),
      'finger_successes': fingerSuccesses.map((k, v) => MapEntry('$k', v)),
    });
  }

  static Future<List<Map<String, dynamic>>> getHistory() async {
    final data = await ApiClient.get('/progress/history');
    final list = (data['history'] as List).cast<Map<String, dynamic>>();
    for (final session in list) {
      if (session['finger_mistakes'] is String) {
        session['finger_mistakes'] = jsonDecode(session['finger_mistakes'] as String);
      }
      if (session['finger_successes'] is String) {
        session['finger_successes'] = jsonDecode(session['finger_successes'] as String);
      }
    }
    return list;
  }

  static Future<Map<String, dynamic>> getRecommendations() async {
    return await ApiClient.get('/progress/recommendations');
  }

  static Future<String> getSessionNarrative({
    required int sessionNum,
    required int correct,
    required int wrong,
    required int weakFinger,
    required Map<int, int> fingerSuccesses,
    required Map<int, int> fingerMistakes,
    required String qenet,
    required int userId,
  }) async {
    final data = await ApiClient.post('/progress/session-narrative', {
      'sessionNum': sessionNum,
      'correct': correct,
      'wrong': wrong,
      'weakFinger': weakFinger,
      'fingerSuccesses': fingerSuccesses.map((k, v) => MapEntry('$k', v)),
      'fingerMistakes': fingerMistakes.map((k, v) => MapEntry('$k', v)),
      'qenet': qenet,
      'userId': userId,
    }, auth: false);
    return data['narrative'] as String;
  }
}
