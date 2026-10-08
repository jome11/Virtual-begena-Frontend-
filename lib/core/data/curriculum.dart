import 'package:flutter/material.dart';
import '../constants/app_strings.dart';
import '../constants/qenet.dart';

String tr(String am, String en) =>
    languageNotifier.value == Language.am ? am : en;

const examPassAccuracy = 70;
const examsFor = <int, List<String>>{
  5: ['selamta'],
  6: ['tezeta', 'anchihoye'],
};

class QuizQ {
  final String q;
  final List<String> options; // options.first is the correct answer
  const QuizQ(this.q, this.options);
}

class Chapter {
  final int number;
  final String title;
  final String titleEn;
  final IconData icon;
  final String? tool; // 'parts' | 'fingers' | 'qenet'
  final List<String> points;
  final List<QuizQ> quiz;
  final String assignment;
  const Chapter({
    required this.number,
    required this.title,
    required this.titleEn,
    required this.icon,
    this.tool,
    required this.points,
    required this.quiz,
    required this.assignment,
  });
}

const chapters = <Chapter>[
  Chapter(
    number: 1,
    title: 'በገና ምንድን ነው?',
    titleEn: 'What is the Begena?',
    icon: Icons.auto_stories_rounded,
    points: [
      'በገና በኢትዮጵያ ኦርቶዶክስ ተዋሕዶ ቤተ ክርስቲያን ከሚጠቀሙባቸው አውታር ካላቸው የዜማ መሳሪያዎች የሚመደብ ነው።',
      'በመመሰጥ ኃይሉ፣ በእርጋታው እና ብቻውን የሚዘመርበት በመሆኑ የተለየ ነው።',
      'በዕብራይስጥ «ናጌን» ይባላል።',
      'መምህር ሙሴ ኃይሉ፦ በገና ማለት «ድርደራ፣ ምስጋና፣ መዝሙር» ማለት ነው።',
      'በገናን የሚደረድር በገነኛ ይባላል።',
    ],
    quiz: [
      QuizQ('በገና ስንት አውታሮች አሉት?', ['10', '5', '8', '12']),
      QuizQ('በዕብራይስጥ በገና ምን ይባላል?', ['ናጌን', 'መሰንቆ', 'ክራር', 'ከበሮ']),
      QuizQ('መምህር ሙሴ ኃይሉ እንደሚያብራሩት «በገና» ማለት ምን ማለት ነው?',
          ['ድርደራ፣ ምስጋና፣ መዝሙር', 'ጦርነት፣ ድል፣ ክብር', 'ዕረፍት፣ እንቅልፍ፣ ዝምታ', 'ንግድ፣ ገበያ፣ ዋጋ']),
    ],
    assignment:
        'በገና ምን እንደሆነ በራስዎ ቃላት በሦስት ዓረፍተ ነገር ይጻፉ፤ ከስሙ ትርጉሞች አንዱን ይጥቀሱ።',
  ),
  Chapter(
    number: 2,
    title: 'የበገና ታሪክ',
    titleEn: 'History of the Begena',
    icon: Icons.history_edu_rounded,
    points: [
      'ዘፍ. 4፥21 — የላሜህ ልጅ ዩባል በገናንና መለከትን ለሚይዙ አባት ነበር።',
      'በኦሪት ዘመን በገና በአምልኮ ውስጥ ነበር (2ኛ ሳሙ. 6፥5፤ 1ኛ ዜና 15፥16-28)።',
      'ቅዱስ ዳዊት ከተሰጡት ሰባት ሀብታት መካከል ሁለቱ ሀብተ በገና እና ሀብተ ፈውስ ናቸው።',
      'ሳኦልን ክፉ መንፈስ ሲያሳድደው ዳዊት በበገና ሲደረድርለት መንፈሱ ይርቅ ነበር (1ኛ ሳሙ. 16፥14-23)።',
      'በራእየ ዮሐንስ ዐራቱ እንስሶችና ሃያ አራቱ ሊቃነ ካህናት በገና ይዘው ይታያሉ (ራእ. 5፥8)።',
      'የበገና መነሻን በተመለከተ ሁለት አመለካከቶች አሉ፦ ከእስራኤል ወደ ኢትዮጵያ መጣ፣ ወይም መነሻው ኢትዮጵያ ነው።',
      'በ1966 ዓ.ም. ገደማ ከደርዳሪዎች ብዙዎች ሲታጡ፣ ቀሪዎችም ዕድሜ እየገፋባቸው ነበር፤ ከዚያ በኋላ መምህር ብርሃን አድማሱ ጀምበሬ እና ሌሎች በገና ማስተማር ቀጥለዋል።',
    ],
    quiz: [
      QuizQ('በመጽሐፍ ቅዱስ በገና በመጀመሪያ የተጠቀሰው ከማን ዘመን ጋር ነው?',
          ['ከዩባል', 'ከዳዊት', 'ከሰሎሞን', 'ከሳኦል']),
      QuizQ('ሀብተ ፈውስ ማለት ምን ማለት ነው?', [
        'በገናውን እየደረደሩ ድውይ መፈወስ',
        'እንጨት ጠርቦ በገና መሥራት',
        'መዝሙር መጻፍ',
        'ጦር መምራት'
      ]),
      QuizQ('ዳዊት በበገና ሲደረድርለት መንፈሱ የሚርቅለትና የሚረጋጋው ንጉሥ ማን ነው?',
          ['ሳኦል', 'ሰሎሞን', 'ምኒልክ', 'ቴዎድሮስ']),
    ],
    assignment:
        'ከዘፍ. 4፥21፣ 1ኛ ሳሙ. 16፥14-23 ወይም ራእ. 5፥8 አንዱን ያንብቡ፤ በገና በዚያ ታሪክ ውስጥ ምን ሚና እንዳለው በሁለት ዓረፍተ ነገር ይጻፉ።',
  ),
  Chapter(
    number: 3,
    title: 'የበገና አገልግሎት',
    titleEn: 'The Purpose of the Begena',
    icon: Icons.volunteer_activism_rounded,
    points: [
      'የበገና ጥቅሞች፦ እግዚአብሔርን ለማመስገንና ለጸሎት፣ መንፈሳዊ ሕይወትን ለማጠንከር፣ ለተመስጦ፣ ከኀዘን ለመጽናናት።',
      'በአብይ ጾም፣ በታላላቅ በዓላት፣ በሠርግና በሞት ጊዜ ዜማዎች ይቀርቡ ነበር።',
      'ከደርዳሪዎች የሚጠበቅ፦ የነገረ ሃይማኖት ግንዛቤ፣ መልካም ምግባር፣ ተገቢ አለባበስ፣ ጤናማ ማኅበራዊ ሕይወት።',
      'ደርዳሪ ከመጀመሩ በፊት በጸሎት እንዲጀምር ይመከራል።',
    ],
    quiz: [
      QuizQ('ደርዳሪ ከመጀመሩ በፊት ምን እንዲያደርግ ይመከራል?',
          ['በጸሎት እንዲጀምር', 'ወዲያውኑ እንዲጫወት', 'ታዳሚ እንዲጠብቅ', 'ቅኝቱን እንዲቀይር']),
      QuizQ('ከሚከተሉት ውስጥ ከደርዳሪ የሚጠበቀው የትኛው ነው?',
          ['መልካም ምግባር', 'ፈጣን መጫወት', 'ውድ በገና መያዝ', 'ብዙ ተመልካች ማግኘት']),
      QuizQ('በገና በየትኞቹ ጊዜያት ይቀርብ ነበር?', [
        'በአብይ ጾም፣ በበዓላት፣ በሠርግና በሞት ጊዜ',
        'በግብርና ወቅት ብቻ',
        'በጦርነት ጊዜ ብቻ',
        'በገበያ ቀን ብቻ'
      ]),
    ],
    assignment:
        'ከደርዳሪ ከሚጠበቁ አራት ነገሮች አንዱን ይምረጡ፤ ለምን አስፈላጊ እንደሆነ በሁለት ዓረፍተ ነገር ያብራሩ።',
  ),
  Chapter(
    number: 4,
    title: 'የበገና አካል ክፍሎችና ምሳሌያቸው',
    titleEn: 'Parts of the Begena and Their Symbolism',
    icon: Icons.category_rounded,
    tool: 'parts',
    points: [
      'በገና ከእንጨትና ከእንስሳት ተዋጽኦ (ቆዳ፣ አንጀት፣ ቀንድ) ይሠራል።',
      'ቁመቱ ከ90 እስከ 140 ሳ.ሜ ድረስ ይደርሳል።',
      'አውታሮቹ ከበሬ (ከብት) አንጀት ተፈትለው ይሠራሉ።',
      'እያንዳንዱ የበገና አካል ክፍል መንፈሳዊ ምሳሌ አለው።',
    ],
    quiz: [
      QuizQ('አሥሩ አውታሮች የምን ምሳሌ ናቸው?',
          ['የአሥርቱ ትዕዛዛት', 'የአሥራ ሁለቱ ሐዋርያት', 'የሰባቱ ሀብታት', 'የሦስቱ ዜማዎች']),
      QuizQ('የድምጽ ሳጥኑ (ገበቴ) የማን ምሳሌ ነው?', [
        'የእመቤታችን የቅድስት ድንግል ማርያም',
        'የደብረሲና ተራራ',
        'የመንፈስ ቅዱስ',
        'የቅዱስ ሚካኤል'
      ]),
      QuizQ('ድህንጻ ከምን ይሠራል?', ['ከቀንድ', 'ከብረት', 'ከአንጀት', 'ከሸክላ']),
    ],
    assignment:
        'ከበገና አካል ክፍሎች ሦስቱን ይምረጡ፤ ስማቸውን፣ ተግባራቸውንና ምሳሌያቸውን በሰንጠረዥ ይጻፉ።',
  ),
  Chapter(
    number: 5,
    title: 'የበገና አያያዝና አደራደር',
    titleEn: 'Holding and Playing the Begena',
    icon: Icons.front_hand_rounded,
    tool: 'fingers',
    points: [
      'በገና በግራ እጅ ጣቶች ይደረደራል (ትውፊቱ እንዲህ ነው)፤ ቀኝ እጅ በደረት በኩል ያለውን ምሰሶ ይደግፋል።',
      'በገና በሁለት መንገድ ይደረደራል፦ ድርደራ (ጣቶች እያንዳንዱን አውታር በማሳረፍ) እና መግረፍ (ድህንጻን በመጠቀም አሥሩንም አውታር በመምታት)።',
      '1ኛ፣ 4ኛ፣ 6ኛ፣ 8ኛ እና 10ኛ አውታሮች ዋና ድምጾች ናቸው፤ የተቀሩት አምስቱ ማረፊያና ማጀቢያ ናቸው።',
    ],
    quiz: [
      QuizQ('በትውፊቱ በገና በየትኛው እጅ ጣቶች ይደረደራል?',
          ['በግራ እጅ', 'በቀኝ እጅ', 'በሁለቱም እኩል', 'በእግር']),
      QuizQ('የበገና ሁለቱ የአደራደር መንገዶች ምንድን ናቸው?',
          ['ድርደራና መግረፍ', 'ማሰርና መፍታት', 'መቃኘትና መጠገን', 'መዘመርና ማጨብጨብ']),
      QuizQ('ዋና ድምጾች የሚሰጡት አውታሮች የትኞቹ ናቸው?', [
        '1፣ 4፣ 6፣ 8 እና 10',
        '1፣ 2፣ 3፣ 4 እና 5',
        '2፣ 3፣ 5፣ 7 እና 9',
        'ሁሉም አውታሮች'
      ]),
    ],
    assignment:
        'የአምስቱን ጣቶች ስምና ዋና አውታራቸውን ሳያዩ ይድገሙ፤ ከዚያ በልምምድ ሞድ ሰላምታን ሦስት ጊዜ ይለማመዱ።',
  ),
  Chapter(
    number: 6,
    title: 'ቅኝት (ቀመር)',
    titleEn: 'Qenet (Scales)',
    icon: Icons.library_music_rounded,
    tool: 'qenet',
    points: [
      'ቅኝት የአንድ የዜማ ሥልት መሠረታዊ ድምጾችን ይዞ የሚገኝ ቀመር ነው፤ ቅኝት የሌለው ዜማ አይኖርም።',
      'ዋና ዋና አራት ቅኝቶች፦ ትዝታ፣ ባቲ፣ አንቺ ሆዬ ለኔ፣ አምባሰል። ከእነዚህ በተጨማሪ ሰላምታ ቅኝት በበገና ዜማዎች ይጠቀማል።',
      'የመማር ደረጃ፦ ሰላምታ → ዋኔን (ትዝታ) → አንቺ ሆዬ (ስለ ቸርነትህ) → አምባሰል፣ ንዑስ ዋኔን፣ ባቲ፣ ባቲ ማይነር።',
      'ሰላምታና ዋኔን በአንድ ድምጽ ብቻ (F→E) ስለሚለያዩ በደንብ መሰማት አለባቸው።',
    ],
    quiz: [
      QuizQ('በበገና ትምህርት መጀመሪያ እንዲማር የሚመከረው ቅኝት የትኛው ነው?',
          ['ሰላምታ', 'አምባሰል', 'ባቲ', 'ንዑስ ዋኔን']),
      QuizQ('ሰላምታና ዋኔን በስንት ድምጽ ይለያያሉ?',
          ['በአንድ ድምጽ (F→E)', 'በሁለት ድምጽ', 'በሦስት ድምጽ', 'አይለያዩም']),
      QuizQ('ሰላምታን ወደ አንቺ ሆዬ ለመቀየር በግማሽ ድምጽ የሚወርዱት የትኞቹ አውታሮች ናቸው?',
          ['6ኛውና 10ኛው', '1ኛውና 4ኛው', '2ኛውና 3ኛው', '8ኛውና 9ኛው']),
    ],
    assignment:
        'ሰላምታንና ትዝታን ተራ በተራ ይለማመዱ፤ በሁለቱ መካከል ያለውን ልዩነት (F→E) በራስዎ ቃላት ይግለጹ።',
  ),
];

// ---- Chapter 4: parts (name, English, symbolism) ----
const bodyParts = <(String, String, String)>[
  ('ቀንበር (ጋድም)', 'Yoke', 'የእግዚአብሔር ስልጣን ምሳሌ'),
  ('ጌጥ (መስቀል)', 'Cross ornament', 'እግዚአብሔር ስለ ሰው ልጆች ፍጹም ፍቅሩን የገለጠበት መስቀል ምሳሌ'),
  ('መቃኛ', 'Tuning pegs', 'በመንፈስ ቅዱስ ይመሰላል፤ አንድም በቅዱሳንና በመላእክት'),
  ('የቀኝ ምሰሶ', 'Right pillar', 'የፍቅረ እግዚአብሔር፣ የብሉይ ኪዳን፣ የቅዱስ ሚካኤል ምሳሌ'),
  ('የግራ ምሰሶ', 'Left pillar', 'የፍቅረ ቢጽ (ሰው)፣ የሐዲስ ኪዳን፣ የቅዱስ ገብርኤል ምሳሌ'),
  ('አውታር', 'Strings (10)', 'የአሥርቱ ትዕዛዛት ምሳሌ (ዘፀ. 20፥1-17)'),
  ('የድምጽ ሳጥን (ገበቴ)', 'Sound box', 'የእመቤታችን የቅድስት ድንግል ማርያም ምሳሌ'),
  ('በርኩማ', 'Berkuma', 'የደብረሲና ተራራ ምሳሌ'),
  ('መወጠሪያ', 'Tensioner', 'የሰዎች መኖሪያ (ምድር) ምሳሌ'),
  ('እንዚራ', 'Enzira', 'ተጋድሎ ላይ ባሉ ክርስቲያኖች ይመሰላል'),
  ('ድህንጻ', 'Plectrum (horn)', 'በክርስቶስ ይመሰላል'),
  ('የመስቀል ምልክት (ከገበቴው ጀርባ)', 'Cross mark on the back', 'ቅዱስ ዳዊት ከሳኦል ጦር የዳነበት ምልክት'),
];

// ---- Chapter 5: finger table (no., Amharic, English, main string, rest string) ----
const fingerTable = <(int, String, String, int, int)>[
  (1, 'አውራ ጣት', 'Thumb', 1, 2),
  (2, 'አመልካች ጣት', 'Index', 4, 3),
  (3, 'መሐል ጣት', 'Middle', 6, 5),
  (4, 'ቀለበት ጣት', 'Ring', 8, 7),
  (5, 'ትንሿ ጣት', 'Pinky', 10, 9),
];

// ---- Chapter 6: scales ----
class Scale {
  final String name, nameEn, notes, steps, how, song;
  final Qenet? qenet; // non-null = available in practice modes
  const Scale(this.name, this.nameEn, this.notes, this.steps, this.how,
      this.song, this.qenet);
}

const scales = <Scale>[
  Scale('ሰላምታ', 'Selamta', 'C D F G A', '1 · 1½ · 1 · 1 · 1½',
      'ከሰባቱ ድምጾች 3ኛና 7ኛውን ማውጣት', '«ሰላም ለኪ»', Qenet.selamta),
  Scale('ዋኔን (ትዝታ)', 'Wanen (Tezeta)', 'C D E G A', '1 · 1 · 1½ · 1 · 1½',
      '4ኛና 7ኛውን ማውጣት፤ ከሰላምታ የሚለየው አንድ ድምጽ (F→E) ብቻ ነው', '«ርግብና ዋኔ»', Qenet.tezeta),
  Scale('ንዑስ ዋኔን (ትዝታ ማይነር)', 'Nus Wanen (Tezeta minor)', 'C D E♭ G A♭',
      '1 · ½ · 2 · ½ · 2', 'ከዋኔ 3ኛና 5ኛውን በግማሽ ድምጽ ማውረድ (E→E♭፣ A→A♭)', '', null),
  Scale('አንቺ ሆዬ', 'Anchihoye', 'C D♭ F G♭ A', '½ · 2 · ½ · 1½ · 1½',
      'ከሰላምታ 2ኛና 5ኛ ዲያቶኒክ ድምጾች (D፣ G) በግማሽ ማውረድ — በበገና 6ኛውና 10ኛው አውታር',
      '«ስለ ቸርነትህ ጌታ ተመስገን»', Qenet.anchihoye),
  Scale('አምባሰል', 'Ambassel', 'C D♭ F G A♭', '½ · 2 · 1 · ½ · 2',
      'ከአምስቱ ድምጾች 2ኛውንና 5ኛውን (D፣ A) በግማሽ ማውረድ', '', null),
  Scale('ባቲ ሜጀር', 'Bati major', 'C E F G B', '2 · ½ · 1 · 2 · ½',
      'ከሰላምታ D→E እና A→B (አንድ ሙሉ ድምጽ ወደ ላይ)', '', null),
  Scale('ባቲ ማይነር', 'Bati minor', 'C E♭ F G B♭', '1½ · 1 · 1 · 1½ · 1',
      'ከባቲ ሜጀር 2ኛና 5ኛውን በግማሽ ድምጽ ማውረድ (E→E♭፣ B→B♭)', '', null),
];

// ---- Daily plan ----
enum TaskKind { read, quiz, assignment, exercise, freePlay, mezmur, progress, course, exam }

class Task {
  final TaskKind kind;
  final int chapter;
  final String qenet;
  final int count;
  const Task._(this.kind, {this.chapter = 0, this.qenet = '', this.count = 1});
  const Task.read(int c) : this._(TaskKind.read, chapter: c);
  const Task.quiz(int c) : this._(TaskKind.quiz, chapter: c);
  const Task.assignment(int c) : this._(TaskKind.assignment, chapter: c);
  const Task.exercise(String q, int sessions)
      : this._(TaskKind.exercise, qenet: q, count: sessions);
  const Task.freePlay(int minutes) : this._(TaskKind.freePlay, count: minutes);
  const Task.mezmur(String q) : this._(TaskKind.mezmur, qenet: q);
  const Task.progress() : this._(TaskKind.progress);
  const Task.course() : this._(TaskKind.course);
  const Task.exam(String q) : this._(TaskKind.exam, qenet: q);
}

const _qenetNames = {
  'selamta': ('ሰላምታ', 'Selamta'),
  'tezeta': ('ትዝታ', 'Tezeta'),
  'anchihoye': ('አንቺ ሆዬ', 'Anchihoye'),
};

extension TaskInfo on Task {
  String get label {
    final qa = _qenetNames[qenet]?.$1 ?? '';
    final qe = _qenetNames[qenet]?.$2 ?? '';
    return switch (kind) {
      TaskKind.read => tr('ምዕራፍ $chapter ያንብቡ', 'Read Chapter $chapter'),
      TaskKind.quiz => tr('የምዕራፍ $chapter ፈተና ይውሰዱ', 'Take the Chapter $chapter quiz'),
      TaskKind.assignment => tr('የምዕራፍ $chapter ተግባር ይሥሩ', 'Do the Chapter $chapter assignment'),
      TaskKind.exercise => tr('ልምምድ ሞድ፦ $qa — $count ክፍለ ጊዜ', 'Exercise Mode: $qe, $count session(s)'),
      TaskKind.freePlay => tr('ነጻ ጨዋታ ለ$count ደቂቃ', 'Free Play for $count minutes'),
      TaskKind.mezmur => tr('መዝሙር ተናት፦ $qa', 'Mezmur Tenat: $qe'),
      TaskKind.progress => tr('ሂደትዎን ይመልከቱ፤ ደካማ ጣትዎን ይለዩ', 'Check My Progress and find your weakest finger'),
      TaskKind.course => tr('የመጨረሻ ፍተሻ፦ የስድስቱንም ምዕራፎች ፈተና ያጠናቅቁ', 'Final check: finish all six chapter quizzes'),
      TaskKind.exam => tr('የተግባር ፈተና፦ $qa', 'Practical test: $qe'),
    };
  }

  String get route => switch (kind) {
        TaskKind.read => '/course/$chapter',
        TaskKind.quiz => '/course/$chapter?tab=quiz',
        TaskKind.assignment => '/course/$chapter?tab=assignment',
        TaskKind.exercise => '/exercise?qenet=$qenet',
        TaskKind.freePlay => '/free-play',
        TaskKind.mezmur => '/mezmur-tenat',
        TaskKind.progress => '/progress',
        TaskKind.course => '/course',
        TaskKind.exam => '/exam?qenet=$qenet',
      };
}

const dailyPlan = <List<Task>>[
  // Week 1: the story and the instrument
  [Task.read(1), Task.quiz(1), Task.assignment(1)],
  [Task.read(2)],
  [Task.quiz(2), Task.assignment(2)],
  [Task.read(3), Task.quiz(3)],
  [Task.read(4)],
  [Task.quiz(4), Task.assignment(4)],
  [Task.assignment(3), Task.freePlay(5)],
  // Week 2: hands and Selamta
  [Task.read(5), Task.freePlay(3)],
  [Task.quiz(5), Task.assignment(5), Task.exercise('selamta', 2)],
  [Task.exercise('selamta', 3)],
  [Task.exercise('selamta', 3)],
  [Task.read(6), Task.exercise('selamta', 2)],
  [Task.exercise('selamta', 3), Task.exam('selamta')],                       // day 13
  [Task.quiz(6), Task.progress()],
  // Week 3: Tezeta and Anchihoye
  [Task.exercise('tezeta', 2)],
  [Task.exercise('tezeta', 3)],
  [Task.exercise('tezeta', 3), Task.assignment(6), Task.exam('tezeta')],     // day 17
  [Task.exercise('anchihoye', 2)],
  [Task.exercise('anchihoye', 3)],
  [Task.exercise('anchihoye', 3), Task.exam('anchihoye')],                   // day 20
  [Task.exercise('selamta', 1), Task.exercise('tezeta', 1), Task.exercise('anchihoye', 1), Task.progress()],
  // Week 4: songs and consolidation
  [Task.mezmur('selamta')],
  [Task.mezmur('tezeta')],
  [Task.mezmur('anchihoye')],
  [Task.freePlay(10), Task.exercise('selamta', 2)],
  [Task.exercise('tezeta', 2), Task.exercise('anchihoye', 2)],
  [Task.progress(), Task.exercise('selamta', 3)],
  [Task.course()],
];
