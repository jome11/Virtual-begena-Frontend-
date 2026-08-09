import 'dart:math';

const fingerNames = {1: 'THUMB', 2: 'INDEX', 3: 'MIDDLE', 4: 'RING', 5: 'PINKY'};
const sessionsToMaster = 5;
final _rng = Random();

List<int> generateExercise([int? weakFinger]) {
  if (weakFinger != null) {
    final exercise = [weakFinger, weakFinger, weakFinger];
    while (exercise.length < 5) {
      exercise.add(_rng.nextInt(5) + 1);
    }
    return _shuffle(exercise);
  }
  return List.generate(5, (_) => _rng.nextInt(5) + 1);
}

List<int> _shuffle(List<int> input) {
  final a = List<int>.from(input);
  for (int i = a.length - 1; i > 0; i--) {
    final j = _rng.nextInt(i + 1);
    final tmp = a[i];
    a[i] = a[j];
    a[j] = tmp;
  }
  return a;
}

int getWeakest(Map<int, int> mistakes) {
  var worst = mistakes.entries.first;
  for (final e in mistakes.entries) {
    if (e.value > worst.value) worst = e;
  }
  return worst.key;
}

List<String> getMastered(Map<int, int> successes, Map<int, int> mistakes) {
  return successes.entries
      .where((e) => e.value >= 5 && (mistakes[e.key] ?? 0) <= 2)
      .map((e) => fingerNames[e.key]!)
      .toList();
}

int? getNextWeakFinger(List<int> masteredFingers, Map<int, int> fingerMistakes) {
  final unmastered = [1, 2, 3, 4, 5].where((f) => !masteredFingers.contains(f)).toList();
  if (unmastered.isEmpty) return null; // all mastered!

  var worst = unmastered.first;
  for (final f in unmastered) {
    if ((fingerMistakes[f] ?? 0) >= (fingerMistakes[worst] ?? 0)) worst = f;
  }
  return worst;
}
