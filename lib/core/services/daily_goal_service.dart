import 'package:shared_preferences/shared_preferences.dart';

class DailyGoalService {
  static const goalSessions = 3;

  static String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static Future<int> todayCount() async {
    final p = await SharedPreferences.getInstance();
    return p.getString('goal_day') == _fmt(DateTime.now())
        ? (p.getInt('goal_count') ?? 0)
        : 0;
  }

  static Future<int> streak() async {
    final p = await SharedPreferences.getInstance();
    final last = p.getString('goal_last_hit');
    if (last == null) return 0;
    final today = _fmt(DateTime.now());
    final yesterday = _fmt(DateTime.now().subtract(const Duration(days: 1)));
    return (last == today || last == yesterday) ? (p.getInt('goal_streak') ?? 0) : 0;
  }

  static Future<void> recordSession() async {
    final p = await SharedPreferences.getInstance();
    final today = _fmt(DateTime.now());
    var count = p.getString('goal_day') == today ? (p.getInt('goal_count') ?? 0) : 0;
    count++;
    if (count == goalSessions) {
      final yesterday = _fmt(DateTime.now().subtract(const Duration(days: 1)));
      final cur = p.getInt('goal_streak') ?? 0;
      await p.setInt('goal_streak', p.getString('goal_last_hit') == yesterday ? cur + 1 : 1);
      await p.setString('goal_last_hit', today);
    }
    await p.setString('goal_day', today);
    await p.setInt('goal_count', count);
  }
}
