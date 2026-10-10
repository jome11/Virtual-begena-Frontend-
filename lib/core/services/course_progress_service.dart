import 'package:shared_preferences/shared_preferences.dart';
import '../data/curriculum.dart';
import 'auth_service.dart';

class CourseSnapshot {
  final Map<int, int> quiz;
  final Set<int> assignments;
  final Map<String, int> exams; // best passed accuracy per qenet
  const CourseSnapshot(this.quiz, this.assignments, [this.exams = const {}]);

  bool examsPassed(int n) => (examsFor[n] ?? const <String>[])
      .every((q) => (exams[q] ?? 0) >= examPassAccuracy);

  bool chapterDone(int n) =>
      (quiz[n] ?? 0) >= 2 && assignments.contains(n) && examsPassed(n);

  int get chaptersDone => [for (var n = 1; n <= chapters.length; n++) if (chapterDone(n)) n].length;
}

class CourseProgress {
  static String _k(String k) => '${authService.currentUsername ?? 'guest'}:$k';

  static Future<CourseSnapshot> load() async {
    final p = await SharedPreferences.getInstance();
    return CourseSnapshot(
      {for (var n = 1; n <= chapters.length; n++) n: p.getInt(_k('quiz$n')) ?? 0},
      {for (var n = 1; n <= chapters.length; n++) if (p.getBool(_k('assign_done$n')) ?? false) n},
      {
        for (final q in const ['selamta', 'tezeta', 'anchihoye'])
          q: p.getInt(_k('exam_$q')) ?? 0,
      },
    );
  }

  static Future<void> saveQuiz(int n, int score) async {
    final p = await SharedPreferences.getInstance();
    if (score > (p.getInt(_k('quiz$n')) ?? 0)) await p.setInt(_k('quiz$n'), score);
  }

  static Future<String> assignmentText(int n) async =>
      (await SharedPreferences.getInstance()).getString(_k('assign_text$n')) ?? '';

  static Future<void> saveAssignment(int n, String text, bool done) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_k('assign_text$n'), text);
    await p.setBool(_k('assign_done$n'), done);
  }

  static Future<void> saveExam(String qenet, int accuracy) async {
    final p = await SharedPreferences.getInstance();
    if (accuracy > (p.getInt(_k('exam_$qenet')) ?? 0)) {
      await p.setInt(_k('exam_$qenet'), accuracy);
    }
  }

  // ---- Plan ----
  static Future<DateTime?> planStart() async {
    final s = (await SharedPreferences.getInstance()).getString(_k('plan_start'));
    return s == null ? null : DateTime.tryParse(s);
  }

  static Future<void> startPlan() async => (await SharedPreferences.getInstance())
      .setString(_k('plan_start'), DateTime.now().toIso8601String());

  static Future<void> resetPlan() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_k('plan_start'));
    await p.remove(_k('plan_done'));
  }

  static Future<Set<String>> planDone() async =>
      ((await SharedPreferences.getInstance()).getStringList(_k('plan_done')) ?? []).toSet();

  static Future<void> setTask(String id, bool done) async {
    final p = await SharedPreferences.getInstance();
    final s = (p.getStringList(_k('plan_done')) ?? []).toSet();
    done ? s.add(id) : s.remove(id);
    await p.setStringList(_k('plan_done'), s.toList());
  }

  static int dayNumber(DateTime start) {
    final a = DateTime(start.year, start.month, start.day);
    final n = DateTime.now();
    return (DateTime(n.year, n.month, n.day).difference(a).inDays + 1).clamp(1, dailyPlan.length);
  }
}
