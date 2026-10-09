import '../constants/qenet.dart';
import 'curriculum.dart' show fingerTable;

/// Note on each main string, per qenet (PDF 6.2 and 6.4).
const _stringNotes = <Qenet, Map<int, String>>{
  Qenet.selamta: {1: 'F', 4: 'C', 6: 'D', 8: 'A', 10: 'G'},
  Qenet.tezeta: {1: 'E', 4: 'C', 6: 'D', 8: 'A', 10: 'G'},
  Qenet.anchihoye: {1: 'F', 4: 'C', 6: 'D♭', 8: 'A', 10: 'G♭'},
};

/// Strings in scale order starting from C (same for all three qenets).
const scaleStringOrder = <int>[4, 6, 1, 10, 8];

int stringForFinger(int finger) => fingerTable[finger - 1].$4;

int fingerForString(int string) =>
    fingerTable.firstWhere((f) => f.$4 == string).$1;

String noteFor(Qenet q, int finger) =>
    _stringNotes[q]![stringForFinger(finger)]!;

/// The scale, ascending, expressed as fingers: [2, 3, 1, 5, 4].
final List<int> scaleFingersUp = [
  for (final s in scaleStringOrder) fingerForString(s),
];

class ExerciseLevel {
  final int id;
  final String titleAm, titleEn, descAm, descEn, source;
  final List<int> fingers;
  final int rounds;
  final bool adaptive;

  const ExerciseLevel({
    required this.id,
    required this.titleAm,
    required this.titleEn,
    required this.descAm,
    required this.descEn,
    required this.source,
    required this.fingers,
    required this.rounds,
    this.adaptive = false,
  });
}

List<ExerciseLevel> exerciseLevels(Qenet q) {
  final up = scaleFingersUp;
  final down = up.reversed.skip(1).toList(); // G F D C

  final (sigAm, sigEn, sig) = switch (q) {
    Qenet.selamta => (
        'ሰላምታ መነሻ ቅኝት ነው፤ በድምጾቹ መካከል መዝለልን (C–F፣ D–G፣ F–A) ይለማመዱ።',
        'Selamta is the base qenet; practise jumping between its notes (C–F, D–G, F–A).',
        <int>[2, 1, 3, 5, 1, 4],
      ),
    Qenet.tezeta => (
        'ከሰላምታ የሚለየው 1ኛው አውታር ብቻ ነው (F→E)፤ ድምጹን በደንብ ያዳምጡ።',
        'It differs from Selamta only on string 1 (F→E) — listen closely.',
        <int>[1, 2, 1, 3, 1, 2, 1, 3],
      ),
    Qenet.anchihoye => (
        'ከሰላምታ የሚለዩት 6ኛውና 10ኛው አውታር ናቸው (በግማሽ ድምጽ ዝቅ ይላሉ)።',
        'It differs from Selamta on strings 6 and 10 (lowered a semitone).',
        <int>[3, 5, 3, 5, 2, 3, 5, 4],
      ),
  };

  return [
    ExerciseLevel(
      id: 1,
      titleAm: 'ጣቶችና አውታሮች',
      titleEn: 'Fingers & strings',
      descAm:
          'አምስቱን ጣቶች ከአውራ ጣት እስከ ትንሿ ጣት፣ ከዚያ ወደ ኋላ ይንኩ። ዋና አውታሮች፦ 1፣ 4፣ 6፣ 8፣ 10።',
      descEn:
          'Pluck the five fingers thumb to pinky, then back. Main strings: 1, 4, 6, 8, 10.',
      source: '5.2',
      fingers: const [1, 2, 3, 4, 5, 4, 3, 2, 1],
      rounds: 2,
    ),
    ExerciseLevel(
      id: 2,
      titleAm: 'ቅኝቱን ወደ ላይ',
      titleEn: 'Scale upward',
      descAm: 'የቅኝቱን አምስት ድምጾች ከC ጀምሮ በቅደም ተከተል ይንኩ።',
      descEn: "Play the qenet's five notes in order, starting from C.",
      source: '6.2 · 6.4',
      fingers: up,
      rounds: 3,
    ),
    ExerciseLevel(
      id: 3,
      titleAm: 'ወደ ላይና ወደ ታች',
      titleEn: 'Up and down',
      descAm: 'ቅኝቱን ወደ ላይ ከዚያ ወደ ታች ይንኩ።',
      descEn: 'Play the scale upward, then back down.',
      source: '6.4',
      fingers: [...up, ...down],
      rounds: 3,
    ),
    ExerciseLevel(
      id: 4,
      titleAm: 'የቅኝቱ ልዩ አውታሮች',
      titleEn: 'Signature strings',
      descAm: sigAm,
      descEn: sigEn,
      source: '6.2 · 6.4',
      fingers: sig,
      rounds: 3,
    ),
    ExerciseLevel(
      id: 5,
      titleAm: 'ደካማ ጣትን ማጠንከር',
      titleEn: 'Strengthen weak fingers',
      descAm: 'ብዙ የተሳሳቱበትን ጣት የሚደጋግም ድብልቅ ልምምድ።',
      descEn: 'A mixed drill that repeats the finger you miss most.',
      source: '5.2',
      fingers: const [1, 2, 3, 4, 5],
      rounds: 5,
      adaptive: true,
    ),
  ];
}
