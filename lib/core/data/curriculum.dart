import 'package:flutter/material.dart';
import '../constants/app_strings.dart';
import '../constants/qenet.dart';
import '../constants/mezmur_data.dart';

String tr(String am, String en) =>
    languageNotifier.value == Language.am ? am : en;

const examPassAccuracy = 70;
const examsFor = <int, List<String>>{
  7: ['selamta'],
};

/// A text in both languages.
class L {
  final String am, en;
  const L(this.am, this.en);
  String get t => tr(am, en);
}

class QuizQ {
  final L _q;
  final List<L> _o; // the first option is the correct answer
  const QuizQ(this._q, this._o);
  String get q => _q.t;
  List<String> get options => [for (final o in _o) o.t];
}

class Chapter {
  final int number;
  final String title;
  final String titleEn;
  final IconData icon;
  final String? tool; // 'parts' | 'fingers' | 'qenet'
  final List<L> _points;
  final List<QuizQ> quiz;
  final L _assignment;
  const Chapter({
    required this.number,
    required this.title,
    required this.titleEn,
    required this.icon,
    this.tool,
    required List<L> points,
    required this.quiz,
    required L assignment,
  })  : _points = points,
        _assignment = assignment;

  List<String> get points => [for (final p in _points) p.t];
  String get assignment => _assignment.t;
}

const chapters = <Chapter>[
  // ------------------------------------------------------------ Day 1
  Chapter(
    number: 1,
    title: 'የስሙ ትርጉም',
    titleEn: 'Meaning of the name “Begena”',
    icon: Icons.auto_stories_rounded,
    points: [
      L('በገና አውታር ካላቸው የዜማ እቃዎች (Chordophone) የሚመደብ ሲሆን፣ ከአምስት ሺህ ስምንት መቶ ዓመት በላይ እድሜ ያለው፤ ለአውታር መሳሪያዎች አባት ሊባል የሚችል ነው።',
          'The Begena (በገና) is classed among the stringed musical instruments (chordophones). It is more than five thousand eight hundred years old, and can be called the father of the stringed instruments.'),
      L('በመመስጥ ኃይሉ፣ በእርጋታው፣ ብቻውን የሚዘመርበት በመሆኑ፣ በሥነ ቃሉ እና በመሳሰሉት ዕሴቶቹ የተለየ ነው።',
          'It stands apart in the power with which it draws a person into deep contemplation (መመስጥ), in its calmness, in being sung with on its own, in its poetic words (ሥነ ቃል) and in similar values.'),
      L('በሰማይም በምድርም አገልግሎት ያለው፣ ለመንፈሳዊ ግልጋሎት ብቻ የምንጠቀምበት ነው፤ የእያንዳንዱ አካል ክፍሎቹ አሰራር፣ ሥያሜና ምሳሌነታቸው መንፈሳዊ ነው፤ ደርዳሪዎቹንም ወደ መንፈሳዊ ሕይወት የሚመራ መንፈሳዊ መሳሪያ ነው።',
          'It serves both in heaven and on earth and is used for spiritual service only. The making of each part, its name and what it stands for are all spiritual, and it is a spiritual instrument that leads those who play it toward spiritual life.'),
      L('የአለቃ ኪዳነ ወልድ ክፍሌ ሰዋሰዋዊ ትርጉም፦ በገናን በሁለት መልኩ «ሲጠብቅና ሲላላ» ብለው ያብራራሉ። ሲላላ፦ ነዘረ፣ መታ፣ ደረደረ ማለት ነው። ሲጠብቅ፦ ነደደ፣ ተቆጣ ያሰኛል።',
          'The grammatical meaning (Aleqa Kidanewold Kifle): he explained the word in two ways, “when it tightens and when it loosens”. When it loosens: to shake or pluck (ነዘረ), to strike (መታ), to play (ደረደረ). When it tightens: to burn (ነደደ), to become angry (ተቆጣ).'),
      L('በዕብራይስጥ በገና «ናጌን» ይባላል፤ በቁሙ መዝሙር ማለት ነው። ማስረጃውም ቅዱስ መጽሐፍ ነው፦ «እግዚአብሔርን በመሰንቆ አመስግኑት ዐሥር አውታር ባለው በበገና ዘምሩለት» (መዝ. 32/33፥2)፤ «ጆሮዬን ወደ ምሳሌ አዘነብላለሁ ነገሬን በበገና እገልጻለሁ» (መዝ. 48/49፥4-5)።',
          'In Hebrew the Begena is called “Nagen” (ናጌን), and taken literally it means “psalm” (መዝሙር). The evidence is Holy Scripture: “Praise the Lord with the mesenqo, and sing to him with the Begena that has ten strings” (Psalm 32/33:2); “I will incline my ear to a proverb; I will express my matter on the Begena” (Psalm 48/49:4–5).'),
      L('የግዕዙ መጽሐፍ ቅዱስ በሁሉም ቦታ ላይ በገናን «መዝሙር» በማለት ይጠቅሰዋል።',
          'The Ge’ez Bible refers to the Begena everywhere as “mezmur” (መዝሙር, psalm).'),
      L('የከሳቴ ብርሃን ተሰማ ትርጉም፦ በገና፦ በዐሥር አውታር (ጅማት) በገናን ሠራ፣ ቃኘ፣ ደረደረ ... በገናን በገነ ብለውታል። በገነኛ፦ በገናን የሚመታ፣ በገናን የሚያውቅ፤ ደርዳሪ ማለት ነው።',
          'Kesate Birhan Tessema defined it: he made a Begena with ten strings (sinews), tuned it, played it ... they say he “begenu” (በገነ) the Begena. Begenyña (በገነኛ): one who strikes the Begena, one who knows the Begena; a player (ደርዳሪ).'),
      L('ሥነ ቃላዊ ትርጉም፦ በገኑ ማለት አደረቀ፣ አቃጠለ፣ አነደደ ማለት ነው። የበገና አካል በደረቅ እንጨት፣ በደረቅ ቆዳና በደረቅ ጅማት ስለሚሠራ በገና ተባለ ተብሎ ይተረጎማል። በሌላ መልኩ «በ» እና «ገና» ተነጣጥሎ ሲታይ፣ በገና በዓል ወይም በገና ወቅት የሚደረደር የምስጋና መሣሪያ ስለሆነ በገና ተባለ ይባላል።',
          'The word-origin meaning: begenu (በገኑ) means to dry, to scorch, to set alight. The whole Begena is made from dry wood, dry skin and dry sinew, so it was called Begena. Split into “be” (በ) and “gena” (ገና): it is an instrument of thanksgiving played at the feast or season of Gena (Christmas), so it was called Begena.'),
      L('በገናን በገኑ ማለት ደረደረ ማለት ነው፤ ስለሆነም በገና ማለት ድርደራ፣ ምስጋና፣ መዝሙር ማለት ነው። ማስረጃ፦ «አቤቱ አምላኬ በገና እመሰግንሃለሁ» (መዝ. 42/43፥4)፤ «ለእግዚአብሔር በገና ድርድሩለት» (መዝ. 46፥6)። ቅዱስ ዳዊትም በመዝሙሩ በገናን መዝሙር፣ ምስጋና፣ ድርደራ በማለት ገልጿል።',
          'To “begenu” the Begena means to play it (ደረደረ). So Begena means playing, praise, psalm. Evidence: “O Lord my God, I will praise you on the Begena” (Psalm 42/43:4); “Play the Begena for the Lord” (Psalm 46:6). David, the Begena player, describes it in his psalms as psalm, praise and playing (ድርደራ).'),
    ],
    quiz: [
      QuizQ(L('በገና ከስንት ዓመት በላይ እድሜ አለው ተብሏል?', 'About how old is the Begena said to be?'), [
        L('ከ5,800 ዓመት በላይ', 'More than 5,800 years'),
        L('ከ500 ዓመት በላይ', 'More than 500 years'),
        L('ከ1,000 ዓመት በላይ', 'More than 1,000 years'),
        L('ከ10,000 ዓመት በላይ', 'More than 10,000 years'),
      ]),
      QuizQ(L('በዕብራይስጥ በገና ምን ይባላል?', 'What is the Begena called in Hebrew?'), [
        L('ናጌን', 'Nagen (ናጌን)'),
        L('መሰንቆ', 'Mesenqo (መሰንቆ)'),
        L('እንዚራ', 'Enzira (እንዚራ)'),
        L('ቀንበር', 'Qenber (ቀንበር)'),
      ]),
      QuizQ(L('በገነኛ (Begenyña) ማን ነው?', 'Who is a begenyña (በገነኛ)?'), [
        L('በገናን የሚመታ፣ በገናን የሚያውቅ ደርዳሪ', 'One who strikes the Begena and knows it; a player (ደርዳሪ)'),
        L('የበገና ድምጽ ሳጥን', 'The sound box of the Begena'),
        L('የአንድ ቅኝት ስም', 'The name of a qinyit'),
        L('የመጽሐፍ ቅዱስ መጽሐፍ ስም', 'The name of a book of the Bible'),
      ]),
    ],
    assignment: L(
        'በገና ምን እንደሆነ በራስዎ ቃላት ይጻፉ፤ ከስሙ ትርጉሞች ሁለቱን (አንዱን ሰዋሰዋዊ፣ አንዱን ሥነ ቃላዊ) ይጥቀሱ።',
        'Write in your own words what the Begena is, and give two meanings of its name (one grammatical, one from the word origin).'),
  ),

  // ------------------------------------------------------------ Day 2
  Chapter(
    number: 2,
    title: 'በገና በመጽሐፍ ቅዱስ',
    titleEn: 'The Begena in the Bible',
    icon: Icons.history_edu_rounded,
    points: [
      L('በገና ለመጀመሪያ ጊዜ በመጽሐፍ ቅዱስ የተጠቀሰው በዘፍ. 4፥22 ሲሆን «የላሜህ ልጅ ዮባል» በገናና መለከት ለሚይዙ አባት እንደ ሆነ ተጠቅሷል። ዮባል የእነርሱ አለቃ ነበር።',
          'The Begena is first mentioned in the Bible in Genesis 4:22, where Jubal (ዮባል), son of Lamech, is named as the father of those who hold the Begena and the trumpet (መለከት). Jubal was their chief.'),
      L('ከዚያ ዘመን ጀምሮ በገና እግዚአብሔርን የማመስገኛ የዜማ ዕቃ ሆኖ ታውቆ፣ እንደ ሌሎቹ የቤተ መቅደስ የዜማ ዕቃዎች በሌዋውያን በተመረጡ አለቆች አማካኝነት አገልግሎት ይሰጥ ነበር።',
          'From that time the Begena was known as an instrument of melody for giving thanks to God and, like the other instruments of the temple, it was used in service under chiefs chosen from among the Levites.'),
      L('በገና በመጽሐፍ ቅዱስ ከዘፍጥረት እስከ ራእየ ዮሐንስ ከ50 ጊዜ በላይ ተጠቅሷል፦ ዘፍጥረት 2 · 1ኛ ሳሙኤል 5 · 2ኛ ሳሙኤል 6 · 1ኛ ነገሥት 6 · 2ኛ ነገሥት 6 · 1ኛ ዜና 5 · 2ኛ ዜና 9 · ነሕምያ 6 · መዝሙረ ዳዊት 15 · ኢሳይያስ 2 · ሰቆቃወ ኤርምያስ 6 · ሕዝቅኤል 6 · ዳንኤል 9 · ራእየ ዮሐንስ 9።',
          'In all, the Begena is mentioned in the Bible, from Genesis to the Revelation of John, more than 50 times: Genesis 2 · 1 Samuel 5 · 2 Samuel 6 · 1 Kings 6 · 2 Kings 6 · 1 Chronicles 5 · 2 Chronicles 9 · Nehemiah 6 · Psalms of David 15 · Isaiah 2 · Lamentations 6 · Ezekiel 6 · Daniel 9 · Revelation 9.'),
      L('በገና መቼና እንዴት እንደ ተጀመረ በትክክል መናገር ከባድ ነው፤ ነገር ግን የጥበባት ምንጭ መጽሐፍ ቅዱስ ስለሆነ፣ መጽሐፍ ቅዱስ በመጀመሪያ የሚያሳየን የምስጋና ወይም የዜማ መሣሪያ በገና ነው። በገናን ለመጀመሪያ ጊዜ የደረደሩት የላሜህ ልጅ የዮባል ልጆች ነበሩ (ዘፍ. 4፥22-24)።',
          'It is hard to say exactly when and how the Begena began. But since the Bible is the source of the arts, the first instrument of praise or melody it shows is the Begena. The first to play the Begena were the children of Jubal, son of Lamech (Genesis 4:22–24).'),
      L('የመምህር ሙሴ ኃይሉ የአንድምታ ትርጓሜ፦ ዓይነ ስውር የነበረው ላሜህ በበረሃ እየሄደ ሳለ ቃየል ተሰውሮ ነበር። ላሜህ ድምፅ ሰምቶ እንስሳ መስሎት ድንጋይ ወረወረ፤ ቃየልንም መትቶ ገደለው። ሲቀርቡ ቃየል መሆኑን አይቶ መራራ ለቅሶ አለቀሰ። የላሜህ ሁለት ሚስቶች ይህን ጸጸቱን ለልጆቻቸው ነገሩ፤ ታሪኩ በትውልድ እየተነገረ ወደ ዮባል ልጆች ደረሰ። ከአቤል ጀምሮ በአባቶቻቸው የሆነውን የመገዳደል ታሪክ በማሰብ አዝነው፣ ከደረቁ ቁሳቁሶች በገናን ሠርተው እያንጎራጎሩ ሐዘናቸውን ገለጹ።',
          'The Andimta commentary of Memher Musie Hailu: Lamech, who was blind, was walking in the wilderness while Cain, a wanderer, hid at the edge of the place. Lamech heard a sound, thought it was a wild beast and threw a stone, and it struck Cain and killed him. When they came near and saw it was Cain, he wept bitterly. Lamech’s two wives told their children about his remorse, and the account was passed down until it reached the children of Jubal. Thinking of the killing among their fathers, starting from Abel, and grieving over it, they made Begenas from dry materials and, singing softly in sorrow, expressed their grief.'),
      L('በዚህ መሠረት በገና ከአዳም ዘጠነኛ ትውልድ ላይ መደርደር ጀመረ። የትውልድ ሰንሰለቱ፦ አዳም ቃኤልን፣ ቃኤል ሄኖሕን፣ ሄኖሕ ጋይዳድን፣ ጋይዳድ ሜኤልን፣ ሜኤል ማቱሣኤልን፣ ማቱሣኤል ላሜሕን፣ ላሜሕ ዮባልን ወለደ። ዮባል በገና ለሚደረድሩ አባት ነበር።',
          'So the Begena began to be played in the ninth generation from Adam. The line: Adam begot Cain; Cain begot Henoch; Henoch begot Gaidad; Gaidad begot Me’el; Me’el begot Matusa’el; Matusa’el begot Lamech; Lamech begot Jubal. Jubal was the father of those who play the Begena.'),
    ],
    quiz: [
      QuizQ(L('በገና ለመጀመሪያ ጊዜ የተጠቀሰው በየትኛው መጽሐፍ ነው?', 'In which book is the Begena first mentioned?'), [
        L('ኦሪት ዘፍጥረት', 'Genesis'),
        L('1ኛ ሳሙኤል', '1 Samuel'),
        L('መዝሙረ ዳዊት', 'Psalms of David'),
        L('ራእየ ዮሐንስ', 'Revelation of John'),
      ]),
      QuizQ(L('በገናና መለከት ለሚይዙ አባት የተባለው ማን ነው?', 'Who is named as the father of those who hold the Begena and the trumpet?'), [
        L('ዮባል (የላሜህ ልጅ)', 'Jubal (ዮባል), son of Lamech'),
        L('ቃኤል', 'Cain'),
        L('አቤል', 'Abel'),
        L('ማቱሣኤል', 'Matusa’el'),
      ]),
      QuizQ(L('በገና በብዛት (15 ጊዜ) የተጠቀሰው በየትኛው መጽሐፍ ነው?', 'In which book is the Begena mentioned most often (15 times)?'), [
        L('መዝሙረ ዳዊት', 'Psalms of David'),
        L('ኦሪት ዘፍጥረት', 'Genesis'),
        L('ትንቢተ ኢሳይያስ', 'Isaiah'),
        L('መጽሐፈ ነሕምያ', 'Nehemiah'),
      ]),
    ],
    assignment: L(
        'ከአዳም እስከ ዮባል ያለውን የትውልድ ሰንሰለት በቅደም ተከተል ይጻፉ፤ የዮባል ልጆች በገና የሠሩት ለምን እንደሆነ በአንድ ወይም በሁለት ዓረፍተ ነገር ይግለጹ።',
        'Write the line of generations from Adam to Jubal in order, and say in one or two sentences why the children of Jubal made Begenas.'),
  ),

  // ------------------------------------------------------------ Day 3
  Chapter(
    number: 3,
    title: 'ተዋሕዶን እንወቅ — የአሥርቱ ትዕዛዛት አከፋፈል',
    titleEn: 'Let us know Tewahedo: the Ten Commandments',
    icon: Icons.menu_book_rounded,
    points: [
      L('የክርስቲያን ሕግ የፍቅር ሕግ ነው። ቅዱስ ጳውሎስ ሌላውን የሚወድ ሕግን ፈጽሞታል ካለ በኋላ ከአሥርቱ ትዕዛዛት የተወሰኑትን በመጥቀስ ፍቅር የሕግ ሁሉ ፍጻሜ መሆኑን በግልጽ ይናገራል (ሮሜ 13፥8-10)።',
          'The Christian law is the law of love. After saying that whoever loves another has fulfilled the law, Saint Paul names some of the Ten Commandments and states plainly that love is the fulfilment of all the law (Romans 13:8–10).'),
      L('ጌታችንና መድኃኒታችን ኢየሱስ ክርስቶስ እንዳስተማረን ፍቅር በሁለት ይከፈላል (ማቴ. 22፥34-41)፦ ፍቅረ እግዚአብሔር (እግዚአብሔርን መውደድ) እና ፍቅረ ቢጽ (ወንድምን መውደድ)።',
          'Our Lord and Saviour Jesus Christ taught that love is divided into two (Matthew 22:34–41): love of God (ፍቅረ እግዚአብሔር) and love of neighbour (ፍቅረ ቢጽ), loving one’s brother.'),
      L('ጌታችን ሕግም ነቢያትም በእነዚህ በሁለቱ ትዕዛዛት ተጠቃለዋል ብሎ ስለተናገረ፣ በዚህ መነሻነት አሥርቱን ትዕዛዛት በሁለት እንከፍላቸዋለን።',
          'Because our Lord also said that the Law and the Prophets are summed up in these two commandments, we divide the Ten Commandments into two on this basis.'),
      L('ፍቅረ እግዚአብሔር (ከ1ኛው እስከ 3ተኛው ትዕዛዝ)፦ ከኔ በቀር ሌሎች አማልክት አይሁንልህ። የእግዚአብሔር አምላክህን ስም በከንቱ አትጥራ። የሰንበትን ቀን ትቀድሰው ዘንድ አስብ።',
          'Love of God (the first to the third commandments): You shall have no other gods before me. You shall not take the name of the Lord your God in vain. Remember the Sabbath day, to keep it holy.'),
      L('ፍቅረ ቢጽ (ከ4ተኛው እስከ 10ኛው ትዕዛዝ)፦ አባትና እናትህን አክብር። አትግደል። አታመንዝር። አትስረቅ። በሐሰት አትመስክር። የባልንጀራህን ቤት አትመኝ። ባልንጀራህን እንደራስህ አድርገህ ውደድ።',
          'Love of neighbour (the fourth to the tenth commandments): Honour your father and your mother. You shall not kill. You shall not commit adultery. You shall not steal. You shall not bear false witness. You shall not covet your neighbour’s house. Love your neighbour as yourself.'),
    ],
    quiz: [
      QuizQ(L('ጌታችን ፍቅርን በስንት ከፍሎ አስተማረ?', 'Into how many parts did our Lord teach that love is divided?'), [
        L('በሁለት፦ ፍቅረ እግዚአብሔርና ፍቅረ ቢጽ', 'Two: love of God and love of neighbour'),
        L('በአንድ', 'One'),
        L('በሦስት', 'Three'),
        L('በአሥር', 'Ten'),
      ]),
      QuizQ(L('ፍቅረ እግዚአብሔር የትኞቹን ትዕዛዛት ይይዛል?', 'Which commandments belong to the love of God?'), [
        L('ከ1ኛው እስከ 3ተኛው', 'The first to the third'),
        L('ከ4ተኛው እስከ 10ኛው', 'The fourth to the tenth'),
        L('ከ1ኛው እስከ 5ኛው', 'The first to the fifth'),
        L('10ኛውን ብቻ', 'Only the tenth'),
      ]),
      QuizQ(L('ጌታችን በሁለቱ ትዕዛዛት ተጠቃለዋል ያለው የትኞቹን ነው?', 'What did our Lord say is summed up in the two commandments of love?'), [
        L('ሕግና ነቢያትን', 'The Law and the Prophets'),
        L('መዝሙረ ዳዊትን', 'The Psalms of David'),
        L('አሥሩን አውታር', 'The ten strings'),
        L('የበገና ክፍሎችን', 'The parts of the Begena'),
      ]),
    ],
    assignment: L(
        'የፍቅረ እግዚአብሔርን ሦስት ትዕዛዛትና የፍቅረ ቢጽን ሰባት ትዕዛዛት በተለያየ ዝርዝር ይጻፉ።',
        'Write the three commandments of the love of God and the seven commandments of the love of neighbour as two separate lists.'),
  ),

  // ------------------------------------------------------------ Day 4
  Chapter(
    number: 4,
    title: 'የበገና አካል ክፍሎችና ምሳሌያቸው (፩)',
    titleEn: 'Parts of the Begena and what they stand for (1)',
    icon: Icons.account_tree_rounded,
    tool: 'parts',
    points: [
      L('አሠራር፦ በገና ከእንጨትና ከእንስሳት ተዋጽኦ (ቆዳ፣ አንጀት፣ ቀንድ) ይሠራል። ቁመቱ ከ90 እስከ 140 ሳ.ሜ ይደርሳል። አውታሮቹ ከበሬ (ከብት) አንጀት ተፈትለው ይሠራሉ።',
          'How it is made: the Begena is made from wood and animal products (skin, gut, horn). Its height reaches from 90 to 140 cm. The strings are twisted from cattle (ox) gut.'),
      L('ቀንበር (ጋድም)፦ የስልጣነ እግዚአብሔር ምሳሌ ነው።',
          'ቀንበር (Qenber), also called ጋድም (Gadm): a symbol of the authority of God (ስልጣነ እግዚአብሔር).'),
      L('ጌጥ (መስቀል)፦ እግዚአብሔር ስለ ሰው ልጆች ፍጹም ፍቅሩን የገለጠበት የመስቀል ምሳሌ ነው።',
          'ጌጥ (Get), the cross · መስቀል (Meskel): a symbol of the Cross, on which God showed his perfect love for humankind.'),
      L('መቃኛ፦ በመንፈስ ቅዱስ ይመሰላል፤ ሕግጋትን በመስጠት የምዕመናንን ሕይወት የሚጠብቅ እርሱ ነውና። አንድም መቃኛዎች ይህን ዓለም ድል ነስተው ወደ አሸናፊዋ ሰማያዊት ቤተ ክርስቲያን አካል በተቀላቀሉ ቅዱሳን፣ ጻድቃንና ሰማዕታት ይመሰላሉ። አንድም የመላእክት ምሳሌ ነው።',
          'መቃኛ (Meqanya): likened to the Holy Spirit, because it is He who protects the life of the faithful by giving the laws. Alternatively, the Meqanya are likened to the saints, the righteous and the martyrs who overcame this world and joined the body of the victorious Church in heaven. Alternatively, a symbol of the angels.'),
      L('የቀኝ ምሰሶ፦ የፍቅረ እግዚአብሔር፣ አንድም የብሉይ ኪዳን፣ አንድም የመጋቤ ብሉይ የቅዱስ ሚካኤል ምሳሌ ነው።',
          'ቀኝ ምሰሶ (the right pillar): a symbol of the love of God (ፍቅረ እግዚአብሔር). Alternatively, of the Old Testament (ብሉይ ኪዳን). Alternatively, of Megabe Bluy (መጋቤ ብሉይ), Saint Michael (ቅዱስ ሚካኤል).'),
      L('የግራ ምሰሶ፦ የፍቅረ ቢጽ (ሰው)፣ አንድም የሐዲስ ኪዳን፣ አንድም የመጋቤ ሐዲስ የቅዱስ ገብርኤል ምሳሌ ነው። (ቀኝና ግራ ከማን በኩል እንደሚቆጠሩ ሥርዓተ ትምህርቱ አይናገርም፤ መምህርዎን ይጠይቁ።)',
          'ግራ ምሰሶ (the left pillar): a symbol of the love of one’s neighbour, that is, of people (ፍቅረ ቢጽ). Alternatively, of the New Testament (ሐዲስ ኪዳን). Alternatively, of Megabe Hadis (መጋቤ ሐዲስ), Saint Gabriel (ቅዱስ ገብርኤል). (The curriculum does not say from whose side right and left are counted; ask your teacher.)'),
    ],
    quiz: [
      QuizQ(L('ቀንበር (ጋድም) የምን ምሳሌ ነው?', 'What does the Qenber (Gadm) stand for?'), [
        L('የስልጣነ እግዚአብሔር', 'The authority of God'),
        L('የደብረ ሲና', 'Mount Sinai'),
        L('የእመቤታችን', 'Our Lady'),
        L('የክርስቶስ', 'Christ'),
      ]),
      QuizQ(L('የብሉይ ኪዳንና የቅዱስ ሚካኤል ምሳሌ የሆነው የትኛው ምሰሶ ነው?', 'Which pillar stands for the Old Testament and Saint Michael?'), [
        L('የቀኝ ምሰሶ', 'The right pillar'),
        L('የግራ ምሰሶ', 'The left pillar'),
        L('ቀንበር', 'The Qenber'),
        L('መቃኛ', 'The Meqanya'),
      ]),
      QuizQ(L('በገና ከምን ይሠራል?', 'What is the Begena made from?'), [
        L('ከእንጨትና ከእንስሳት ተዋጽኦ (ቆዳ፣ አንጀት፣ ቀንድ)', 'Wood and animal products (skin, gut, horn)'),
        L('ከብርና ከድንጋይ', 'Iron and stone'),
        L('ከሸክላ ብቻ', 'Clay only'),
        L('ከብርጭቆ', 'Glass'),
      ]),
    ],
    assignment: L(
        'የቀንበርን፣ የጌጥን (መስቀልን)፣ የመቃኛንና የሁለቱን ምሰሶዎች ምሳሌ በራስዎ ቃላት ይጻፉ።',
        'Write in your own words what the Qenber, the Get (cross), the Meqanya and the two pillars stand for.'),
  ),

  // ------------------------------------------------------------ Day 5
  Chapter(
    number: 5,
    title: 'የበገና አካል ክፍሎችና ምሳሌያቸው (፪)',
    titleEn: 'Parts of the Begena and what they stand for (2)',
    icon: Icons.category_rounded,
    tool: 'parts',
    points: [
      L('አውታር፦ የአሥርቱ ትዕዛዛት ምሳሌ ነው (ዘፀ. 20፥1-17)።',
          'አውታር (Awtar), the strings: a symbol of the Ten Commandments (Exodus 20:1–17).'),
      L('አሥሩ አውታር አሥሩ የስሜት ሕዋሳትንም ይወክላሉ፦ ውጫዊ (ዓይን፣ አፍንጫ፣ ጆሮ፣ ምላስ፣ መዳፍ) እና ውስጣዊ (ዓይነ ልቦና፣ አንፈ ልቦና፣ እዝነ ልቦና፣ አፈ ልቦና፣ እደ ልቦና)።',
          'The ten strings also stand for the ten senses. The outer five: the eye, the nose, the ear, the tongue and the palm. The inner five: ዓይነ ልቦና, አንፈ ልቦና, እዝነ ልቦና, አፈ ልቦና and እደ ልቦና, literally the eye, nose, ear, mouth and hand of the heart.'),
      L('እንዲሁም የቅዱስ ያሬድ ሦስቱ ዜማ ስልቶች፦ ግእዝ (አብ)፣ ዕዝል (ወልድ)፣ አራራይ (መንፈስ ቅዱስ)፤ የቅዱስ ዳዊት መዝሙር አሥር አርዕስት (150ውን መዝሙራት በአሥር የከፈለበት)፤ አሥሩ የቅዱሳን ማዕረጋት (ንጽሐ ሥጋ፣ ንጽሐ ነፍስ፣ ንጽሐ ልቦና በሦስት ክፍል ተመድበው ወጣንያን፣ ማዕከላውያንና ፍጹማን ይባላሉ)።',
          'They also stand for the three melodic modes of Saint Yared: ግእዝ (Ge’ez), for the Father; ዕዝል (Ezl), for the Son; አራራይ (Araray), for the Holy Spirit; the ten headings of Saint David’s Psalms, under which he divided the 150 psalms into ten; and the ten ranks of the saints: purity of body, of soul and of heart, arranged in three groups called ወጣንያን, ማዕከላውያን and ፍጹማን.'),
      L('የድምጽ ሳጥን (ገበቴ)፦ የእመቤታችን የቅድስት ድንግል ማርያም ምሳሌ ነው። የበገናው ድምጽ ከድምጽ ሳጥኑ እንደሚገኝ፣ ከእመቤታችን አካላዊ ቃል ወልደ ጌታችን መድኃኒታችንና አምላካችን ኢየሱስ ክርስቶስ ተገኝቷል።',
          'ገበቴ (Gebete), the sound box · የድምጽ ሳጥን: a symbol of Our Lady, the Holy Virgin Mary. Just as the sound of the Begena comes from the sound box, from Our Lady came the incarnate Word (አካላዊ ቃል), the Son, our Lord, Saviour and God, Jesus Christ.'),
      L('በርኩማ፦ የደብረ ሲና ተራራ ምሳሌ ነው።',
          'በርኩማ (Berkuma): a symbol of Mount Sinai (ደብረ ሲና).'),
      L('መወጠሪያ፦ ከእንጨትና ከቆዳ የሚሠራ፣ ከታችኛው የበገና ክፍል የሚገኝ ሲሆን አውታሮቹን ከቀንበሩ ጋር ለመወጠር ይጠቅማል። አሥሩ አውታር እነዚህን ሁለቱን ያገናኛሉ። መወጠሪያ በሰዎች መኖሪያ (በምድር) ይመሰላል፤ ሰዎች በትዕዛዛተ እግዚእ መሰላልነት ከምድር ወደ መንግሥተ ሰማያት ለመግባታቸው ምሳሌ ነው። አንድም በምድር ላይ ያሉ የአዳም ዘር (የሰው ልጆች) ምሳሌ ነው።',
          'መወጠሪያ (Mewetteriya): made from wood and skin and found at the lower part of the Begena, it is used to stretch the strings together with the Qenber. The ten strings join these two parts. It is likened to the dwelling place of people (the earth): a symbol of people entering the kingdom of heaven from the earth by the ladder of the commandments of God. Alternatively, it stands for the descendants of Adam on earth (humankind).'),
      L('እንዚራ፦ በተጋድሎ ላይ ባሉ ክርስቲያኖች ይመሰላል፤ እንዚራ በአሥሩ አውታር ላይ እንዳሉ ሁሉ ክርስቲያኖችም ትዕዛዛተ እግዚአብሔርን መሪ በማድረግ በዓለም ኑሯቸው መንፈሳዊ ሕይወትን ለማበልጸግ ይጋደላሉ።',
          'እንዚራ (Enzira): likened to Christians in spiritual struggle (ተጋድሎ). Just as the Enzira sit on the ten strings, Christians struggle to enrich their spiritual life in the world, taking as their guide the commandments of God, which the ten strings stand for.'),
      L('ድህንጻ፦ ከቀንድ የሚሠራ መግረፊያ ሲሆን አውታሮችን በመግረፍ ድምጽ እንዲሰጥ ያደርጋል። በክርስቶስ ይመሰላል፤ ድህንጻ አሥሩን አውታሮች እየተመላለሰ እንደሚገርፋቸው፣ መድኅነ ዓለም ኢየሱስ ክርስቶስም በብሉይ ኪዳን የሰጣቸውን አሥሩን ትዕዛዛት በሐዲስ ኪዳን አጽንቷቸዋል።',
          'ድህንጻ (Dehntsa): a striker made of horn, used to strike the strings so that they give sound. It is likened to Christ. Just as the Dehntsa goes back and forth, striking the ten strings, so Jesus Christ, Saviour of the world, confirmed in the New Testament the ten commandments that he gave in the Old Testament.'),
      L('ከገበቴው ጀርባ ያለው የመስቀል ቅርጽ ምልክት፦ ቅዱስ ዳዊት ከሳኦል ጦር የዳነበት ምልክት ነው። መስቀል በሐዲስ ኪዳንም ከዲያብሎስ ፍላጻ የምንድንበት ምልክታችን በመሆኑ ይህ ምልክት ተደርጓል።',
          'The cross-shaped mark on the back of the Gebete is the sign of how Saint David was saved from the spear of Saul. In the New Testament the Cross is also our sign of being saved from the arrows of the devil, and so this mark is made.'),
    ],
    quiz: [
      QuizQ(L('የድምጽ ሳጥን (ገበቴ) የማን ምሳሌ ነው?', 'Whom does the sound box (Gebete) stand for?'), [
        L('የእመቤታችን የቅድስት ድንግል ማርያም', 'Our Lady, the Holy Virgin Mary'),
        L('የቅዱስ ሚካኤል', 'Saint Michael'),
        L('የቅዱስ ገብርኤል', 'Saint Gabriel'),
        L('የቅዱስ ያሬድ', 'Saint Yared'),
      ]),
      QuizQ(L('አሥሩ አውታር የምን ምሳሌ ናቸው?', 'What do the ten strings stand for?'), [
        L('የአሥርቱ ትዕዛዛት', 'The Ten Commandments'),
        L('የደብረ ሲና ተራራ', 'Mount Sinai'),
        L('የአዳም ዘር', 'The descendants of Adam'),
        L('የቅዱስ ሚካኤልና የቅዱስ ገብርኤል', 'Saint Michael and Saint Gabriel'),
      ]),
      QuizQ(L('ድህንጻ በማን ይመሰላል?', 'Whom is the Dehntsa likened to?'), [
        L('በክርስቶስ', 'Christ'),
        L('በመንፈስ ቅዱስ', 'The Holy Spirit'),
        L('በደብረ ሲና', 'Mount Sinai'),
        L('በቅዱስ ሚካኤል', 'Saint Michael'),
      ]),
    ],
    assignment: L(
        'ከቀን 4 እና ከቀን 5 አራት የበገና ክፍሎችን መርጠው እያንዳንዳቸው የምን ምሳሌ እንደሆኑ ይጻፉ።',
        'Choose four parts of the Begena from Day 4 and Day 5 and write what each one stands for.'),
  ),

  // ------------------------------------------------------------ Day 6
  Chapter(
    number: 6,
    title: 'የበገና አያያዝና አደራደር፣ ቅኝት',
    titleEn: 'Holding and playing the Begena, and the qinyit',
    icon: Icons.back_hand_rounded,
    tool: 'fingers',
    points: [
      L('በገና በግራ እጅ ጣቶች ይደረደራል (ትውፊቱ እንዲህ ነው)፤ ቀኝ እጅ በደረት በኩል ያለውን ምሰሶ ይደግፋል። ግራ እጅ ጥበብ ማሰብን የሚያዳብር «የስሜት ጣቢያ» የሆነውን ቀኝ የአእምሮ ክፍል ያንቀሳቅሳል ተብሎ ይገለጻል።',
          'The Begena is played with the fingers of the left hand (this is the tradition). The right hand supports the pillar on the chest side. It is explained that the left hand stirs the right half of the brain, the “station of feeling” that develops artistic thinking.'),
      L('በገና የሚደረደረው በሁለት መንገድ ነው፦ ድርደራ (ጣቶች እያንዳንዱን አውታር በማሳረፍ የሚደረድሩበት) እና መግረፍ (ድህንጻን በመጠቀም አሥሩንም አውታር የሚመታበት)።',
          'The Begena is played in two ways: ድርደራ (Dirdera), where the fingers rest on each string in turn and play it; and መግረፍ (Megref), where the Dehntsa is used to strike all ten strings.'),
      L('የጣት ስያሜና አቀማመጥ፦ 1ኛ አውራ ጣት — 1ኛ አውታር (ማረፊያ 2ኛ)፤ 2ኛ አመልካች ጣት — 4ኛ (3ኛ)፤ 3ኛ መሐል ጣት — 6ኛ (5ኛ)፤ 4ኛ ቀለበት ጣት — 8ኛ (7ኛ)፤ 5ኛ ትንሿ ጣት — 10ኛ (9ኛ)።',
          'The names of the fingers and the strings they play: 1st, thumb (አውራ ጣት) — string 1 (resting string 2); 2nd, index (አመልካች ጣት) — string 4 (3); 3rd, middle (መሐል ጣት) — string 6 (5); 4th, ring (ቀለበት ጣት) — string 8 (7); 5th, little (ትንሿ ጣት) — string 10 (9).'),
      L('1ኛ፣ 4ኛ፣ 6ኛ፣ 8ኛ እና 10ኛ አውታሮች የዋና ዋና ድምጾች ናቸው፤ የተቀሩት አምስቱ አውታሮች ማረፊያና ማጀቢያ ናቸው።',
          'Strings 1, 4, 6, 8 and 10 give the main notes. The other five strings are resting and accompanying strings (ማረፊያ and ማጀቢያ).'),
      L('ቅኝት ማለት የአንድ ዜማ ሥልት መሠረታዊ ድምጾችን ይዞ የሚገኝ ቀመር ነው። ቅኝት የሌለው ዜማ አይኖርም።',
          'A qinyit (ቅኝት) is a formula that holds the basic notes of a melodic style. There is no melody without a qinyit.'),
      L('በኢትዮጵያ ዋና ዋና አራት ቅኝቶች ትዝታ፣ ባቲ፣ አንቺ ሆዬ ለኔ፣ አምባሰል ናቸው። እነዚህ አምስት ድምጽ (Pentatonic) ያላቸው ቅኝቶች ሲሆኑ ስማቸውን ከታዋቂ የባሕል ዜማዎችና ከቦታ ስሞች ያገኙ ናቸው። ከእነዚህ በተጨማሪ ሰላምታ ቅኝት በበገና ዜማዎች ይጠቀማል።',
          'In Ethiopia the four main qinyitoch are Tizita, Bati, Anchi Hoye Lene and Ambassel. These are qinyitoch of five notes (pentatonic), and they take their names from famous folk melodies and from place names. In addition, the Selamta qinyit is used in Begena melodies.'),
      L('ድምጾች (ከ C ጀምሮ)፦ ትዝታ ሜጀር C D E G A · ትዝታ ማይነር C D E♭ G A♭ · ባቲ ሜጀር C E F G B · ባቲ ማይነር C E♭ F G B♭ · አንቺ ሆዬ ለኔ C D♭ F G♭ A · አምባሰል C D♭ F G A♭ · ሰላምታ C D F G A።',
          'Notes (starting on C): Tizita major C D E G A · Tizita minor C D E♭ G A♭ · Bati major C E F G B · Bati minor C E♭ F G B♭ · Anchi Hoye Lene C D♭ F G♭ A · Ambassel C D♭ F G A♭ · Selamta C D F G A.'),
    ],
    quiz: [
      QuizQ(L('በትውፊቱ በገና በየትኛው እጅ ጣቶች ይደረደራል?', 'With the fingers of which hand is the Begena played, by tradition?'), [
        L('በግራ እጅ', 'The left hand'),
        L('በቀኝ እጅ', 'The right hand'),
        L('በሁለቱም እጆች በእኩል', 'Both hands equally'),
        L('ድህንጻን ብቻ በመጠቀም', 'Using only the Dehntsa'),
      ]),
      QuizQ(L('አመልካች ጣት የሚደረድረው የትኛውን አውታር ነው?', 'Which string does the index finger play?'), [
        L('4ኛውን', 'The 4th'),
        L('1ኛውን', 'The 1st'),
        L('6ኛውን', 'The 6th'),
        L('10ኛውን', 'The 10th'),
      ]),
      QuizQ(L('ቅኝት ምንድን ነው?', 'What is a qinyit?'), [
        L('የአንድ ዜማ ሥልት መሠረታዊ ድምጾችን ይዞ የሚገኝ ቀመር', 'A formula that holds the basic notes of a melodic style'),
        L('የበገና አካል ክፍል', 'A part of the Begena'),
        L('አውታሮችን ለመግረፍ የሚጠቅም መሣሪያ', 'A tool for striking the strings'),
        L('የመጽሐፍ ቅዱስ መጽሐፍ', 'A book of the Bible'),
      ]),
    ],
    assignment: L(
        'አምስቱን ጣቶች እያንዳንዱ የሚደረድረውን አውታር ቁጥር ይጻፉ፤ እንዲሁም የሰላምታ ቅኝትን አምስት ድምጾች ይጻፉ።',
        'Write the five fingers with the number of the string each one plays, and the five notes of the Selamta qinyit.'),
  ),

  // ------------------------------------------------------------ Day 7
  Chapter(
    number: 7,
    title: 'የበገና አምስቱ ዋና ድምጾችና ቅኝቶች',
    titleEn: 'The five main notes, and how the qinyitoch are obtained',
    icon: Icons.music_note_rounded,
    tool: 'qenet',
    points: [
      L('በሰላምታ ቅኝት የአምስቱ ዋና ድምጾች አውታሮች፦ F — 1ኛ አውታር፣ C — 4ኛ፣ D — 6ኛ፣ A — 8ኛ፣ G — 10ኛ። (በሥርዓተ ትምህርቱ ሠንጠረዥ የጣት ቁጥሮች ድምጾቹን ከዝቅተኛ ወደ ከፍተኛ ይከተላሉ — C 1ኛ፣ D 2ኛ፣ F 3ኛ፣ G 4ኛ፣ A 5ኛ — በቀን 6 ያለው የጣት ሠንጠረዥ ግን ጣቶችን በአውታር ቅደም ተከተል ይቆጥራል። ግራ ከተጋቡ መምህርዎን ይጠይቁ።)',
          'In the Selamta qinyit the five main notes lie on these strings: F — string 1, C — string 4, D — string 6, A — string 8, G — string 10. (In the curriculum’s table the finger numbers follow the notes from low to high — C 1st, D 2nd, F 3rd, G 4th, A 5th — while the finger table on Day 6 numbers the fingers by the order of the strings. If this is confusing, ask your teacher.)'),
      L('ትዝታ ቅኝት ከሰላምታ የሚለየው 1ኛው አውታር (F) ወደ E በመቀነሱ ነው፤ አንቺ ሆዬ ለኔ ደግሞ 6ኛውና 10ኛው አውታር በግማሽ ድምጽ ዝቅ ይላሉ።',
          'The Tizita qinyit differs from Selamta in that the first string (F) is lowered to E. In Anchi Hoye Lene, the 6th and 10th strings are lowered by a semitone.'),
      L('የበገና መምህራን ከሰላምታ ቅኝት ጀምሮ ማስተማርን ይመክራሉ፤ ምክንያቱም በበገና ዜማዎች የተለመደ ነው፤ ዜማውም «ሰላም ለኪ» ከመሳሰሉ ዜማዎች ጋር ይተዋወቃል።',
          'Begena teachers recommend starting with the Selamta qinyit, because it is the usual one in Begena melodies, and the student becomes familiar with the melody through songs like “Selam Leki” (ሰላም ለኪ).'),
      L('አምስቱም ቅኝቶች ከሰባቱ የአውሮፓውያን ድምጾች (ዲያቶኒክ፣ C D E F G A B) ሁለት ድምጾችን በማውጣትና አንዳንዶቹን በግማሽ ድምጽ በማውረድ ይገኛሉ። እያንዳንዱ ቅኝት እንዴት እንደሚገኝ ከታች ባለው መሣሪያ ይመልከቱ።',
          'All the qinyitoch are obtained from the seven European notes (diatonic: C D E F G A B) by taking out two notes and lowering some of the others by a semitone. See below how each qinyit is obtained.'),
      L('ልብ ይበሉ፦ ሁሉም ቅኝቶች ለተማሪ ለመለየት ጥንቃቄና ጆሮ ማሰልጠን ይጠይቃሉ፤ በተለይ ሰላምታና ዋኔን በአንድ ድምጽ ብቻ ስለሚለያዩ በደንብ መሰማት አለባቸው።',
          'Please note: all the qinyitoch need care and ear training for a student to tell them apart. In particular, Selamta and Wanen differ by only one note, so they must be listened to well.'),
      L('«ስለ ቸርነትህ» ቅኝት ከሰላምታ ጋር ሲነጻጸር የሚለየው 6ኛውና 10ኛው አውታር ብቻ ነው፤ ስለዚህ ሰላምታ የተቃኘ በገና ሁለቱን አውታር በግማሽ ድምጽ በማውረድ ወደዚህ ቅኝት ሊቀየር ይችላል።',
          'Compared with Selamta, the “Sile Chernetih” qinyit differs only in the 6th and 10th strings. So a Begena tuned to Selamta can be changed into this qinyit by lowering those two strings by a semitone.'),
      L('ለእያንዳንዱ ቅኝት የሚዘመሩ መዝሙሮች አሉ፤ ተማሪ ቅኝቱን ከመዝሙሩ ጋር አያይዞ እንዲያስታውስ ይደረጋል። ለምሳሌ ሰላምታ — «ሆዴ ልመድ»፣ «በጌቴ ሰማኒ»፣ «በመስቀል ተሰቅሎ»፤ ዋኔን — «ርግብና ዋኔን»፤ አንቺ ሆዬ — «ስለ ቸርነትህ»።',
          'There are hymns sung for each qinyit, and the student remembers the qinyit by linking it with its hymn. For example: Selamta — “Hode Limed” (ሆዴ ልመድ), “Be-Gete Semani” (በጌቴ ሰማኒ), “Bemeskel Teseqilo” (በመስቀል ተሰቅሎ); Wanen — “Rigbena Wanen” (ርግብና ዋኔን); Anchi Hoye — “Sile Chernetih” (ስለ ቸርነትህ).'),
      L('አምባሰልና ባቲ በኢትዮጵያ ሙዚቃ ከዓለማዊ ዘፈን ጋር የሚያያዙ ስለሆኑ በበገና እንደ ተጨማሪ ቅኝቶች ተቀምጠዋል፤ የተለየ መንፈሳዊ ዜማ በእነዚህ ቅኝቶች በበገና ይዘመራል።',
          'In Ethiopian music, Ambassel and Bati are linked with secular songs. For that reason they are placed in the book as additional qinyitoch for the Begena. A separate spiritual melody is sung on the Begena in these qinyitoch.'),
      L('የመማር ደረጃ፦ መጀመሪያ ሰላምታ፣ ከዚያ ዋኔን፣ ከዚያ አንቺ ሆዬ ለኔ (ስለ ቸርነትህ)፣ ከዚያ በኋላ አምባሰል፣ ንዑስ ዋኔን፣ ባቲ፣ ባቲ ማይነር።',
          'Order of learning: first Selamta, then Wanen, then Anchi Hoye Lene (Sile Chernetih), and after that Ambassel, Nu’us Wanen, Bati and Bati minor.'),
    ],
    quiz: [
      QuizQ(L('ተማሪ በየትኛው ቅኝት ቢጀምር ይመከራል?', 'Which qinyit is a student advised to begin with?'), [
        L('በሰላምታ', 'Selamta'),
        L('በአምባሰል', 'Ambassel'),
        L('በባቲ ማይነር', 'Bati minor'),
        L('በንዑስ ዋኔን', 'Nu’us Wanen'),
      ]),
      QuizQ(L('በአንቺ ሆዬ ለኔ ቅኝት በግማሽ ድምጽ ዝቅ የሚሉት የትኞቹ አውታሮች ናቸው?', 'In Anchi Hoye Lene, which strings are lowered by a semitone?'), [
        L('6ኛውና 10ኛው', 'The 6th and 10th'),
        L('1ኛውና 4ኛው', 'The 1st and 4th'),
        L('4ኛውና 8ኛው', 'The 4th and 8th'),
        L('2ኛውና 3ኛው', 'The 2nd and 3rd'),
      ]),
      QuizQ(L('ሰላምታና ዋኔን በስንት ድምጽ ይለያያሉ?', 'By how many notes do Selamta and Wanen differ?'), [
        L('በአንድ ድምጽ (F→E)', 'One note (F becomes E)'),
        L('በሁለት ድምጽ', 'Two notes'),
        L('በሦስት ድምጽ', 'Three notes'),
        L('አይለያዩም', 'They do not differ'),
      ]),
    ],
    assignment: L(
        'የሰላምታን፣ የዋኔንንና የአንቺ ሆዬ ለኔን ድምጾች ይጻፉ፤ እያንዳንዳቸው ከሰላምታ ምን እንደሚለዩ ይግለጹ።',
        'Write the notes of Selamta, Wanen and Anchi Hoye Lene, and say what is different in each of the other two compared with Selamta.'),
  ),
];

// ---- Days 4 and 5: parts of the Begena (Amharic name, English name, Amharic text, English text) ----
const _parts = <(String, String, String, String)>[
  ('ቀንበር (ጋድም)', 'Qenber (Gadm)', 'የስልጣነ እግዚአብሔር ምሳሌ', 'Symbol of the authority of God'),
  ('ጌጥ (መስቀል)', 'Get (cross)', 'እግዚአብሔር ስለ ሰው ልጆች ፍጹም ፍቅሩን የገለጠበት መስቀል ምሳሌ', 'Symbol of the Cross, on which God showed his perfect love for humankind'),
  ('መቃኛ', 'Meqanya', 'በመንፈስ ቅዱስ ይመሰላል፤ አንድም በቅዱሳን፣ አንድም በመላእክት', 'Likened to the Holy Spirit; alternatively to the saints, or to the angels'),
  ('ቀኝ ምሰሶ', 'Right pillar', 'የፍቅረ እግዚአብሔር፣ የብሉይ ኪዳንና የመጋቤ ብሉይ የቅዱስ ሚካኤል ምሳሌ', 'Love of God, the Old Testament, and Saint Michael (Megabe Bluy)'),
  ('ግራ ምሰሶ', 'Left pillar', 'የፍቅረ ቢጽ፣ የሐዲስ ኪዳንና የመጋቤ ሐዲስ የቅዱስ ገብርኤል ምሳሌ', 'Love of neighbour, the New Testament, and Saint Gabriel (Megabe Hadis)'),
  ('አውታር', 'Awtar (strings)', 'የአሥርቱ ትዕዛዛት ምሳሌ (ዘፀ. 20፥1-17)', 'Symbol of the Ten Commandments (Exodus 20:1–17)'),
  ('ገበቴ (የድምጽ ሳጥን)', 'Gebete (sound box)', 'የእመቤታችን የቅድስት ድንግል ማርያም ምሳሌ', 'Symbol of Our Lady, the Holy Virgin Mary'),
  ('በርኩማ', 'Berkuma', 'የደብረ ሲና ተራራ ምሳሌ', 'Symbol of Mount Sinai'),
  ('መወጠሪያ', 'Mewetteriya', 'የሰዎች መኖሪያ (ምድር) ምሳሌ፤ አንድም የአዳም ዘር', 'Likened to the dwelling place of people (the earth); alternatively the descendants of Adam'),
  ('እንዚራ', 'Enzira', 'በተጋድሎ ላይ ባሉ ክርስቲያኖች ይመሰላል', 'Likened to Christians in spiritual struggle'),
  ('ድህንጻ', 'Dehntsa', 'ከቀንድ የሚሠራ መግረፊያ፤ በክርስቶስ ይመሰላል', 'A striker made of horn; likened to Christ'),
  ('የመስቀል ምልክት (ከገበቴው ጀርባ)', 'Cross mark on the back of the Gebete', 'ቅዱስ ዳዊት ከሳኦል ጦር የዳነበት፣ እኛም ከዲያብሎስ ፍላጻ የምንድንበት ምልክት', 'The sign of how David was saved from Saul’s spear, and our sign of being saved from the arrows of the devil'),
];

List<(String, String, String)> get bodyParts =>
    [for (final p in _parts) (p.$1, p.$2, tr(p.$3, p.$4))];

// ---- Day 6: finger table (no., Amharic, English, main string, rest string) ----
const fingerTable = <(int, String, String, int, int)>[
  (1, 'አውራ ጣት', 'Thumb', 1, 2),
  (2, 'አመልካች ጣት', 'Index', 4, 3),
  (3, 'መሐል ጣት', 'Middle', 6, 5),
  (4, 'ቀለበት ጣት', 'Ring', 8, 7),
  (5, 'ትንሿ ጣት', 'Pinky', 10, 9),
];

// ---- Day 7: qinyitoch ----
class Scale {
  final String name, nameEn, notes, steps, howAm, howEn, songAm, songEn;
  final Qenet? qenet; // non-null = available in practice modes
  const Scale(this.name, this.nameEn, this.notes, this.steps, this.howAm,
      this.howEn, this.songAm, this.songEn, this.qenet);

  String get how => tr(howAm, howEn);
  String get song => tr(songAm, songEn);
}

const scales = <Scale>[
  Scale('ሰላምታ', 'Selamta', 'C D F G A', '1 · 1½ · 1 · 1 · 1½',
      '3ኛና 7ኛውን ማውጣት', 'Take out the 3rd and the 7th notes',
      '«ሰላም ለኪ» (ሰላም ለማርያም)', '“Selam Leki” (ሰላም ለኪ), that is “Selam Le Mariyam”', Qenet.selamta),
  Scale('ዋኔን (ትዝታ)', 'Wanen (Tizita major)', 'C D E G A', '1 · 1 · 1½ · 1 · 1½',
      '4ኛና 7ኛውን ማውጣት፤ ከሰላምታ የሚለየው አንድ ድምጽ (F→E) ብቻ ነው',
      'Take out the 4th and the 7th notes; it differs from Selamta by one note only (F becomes E)',
      '«ርግብና ዋኔ»', '“Rigbena Wane” (ርግብና ዋኔ)', Qenet.tezeta),
  Scale('ንዑስ ዋኔን (ትዝታ ማይነር)', 'Nu’us Wanen (Tizita minor)', 'C D E♭ G A♭', '1 · ½ · 2 · ½ · 2',
      'ከዋኔ 3ኛና 5ኛውን በግማሽ ድምጽ ማውረድ (E→E♭፣ A→A♭)',
      'Lower the 3rd and 5th notes of Wanen by a semitone (E to E♭, A to A♭)',
      '', '', null),
  Scale('አንቺ ሆዬ ለኔ', 'Anchi Hoye Lene', 'C D♭ F G♭ A', '½ · 2 · ½ · 1½ · 1½',
      'ከሰላምታ 2ኛና 5ኛ ድምጾች (D፣ G) በግማሽ ማውረድ — በበገና 6ኛውና 10ኛው አውታር',
      'Lower the 2nd and 5th notes of Selamta (D and G) by a semitone; on the Begena these are the 6th and 10th strings',
      '«ስለ ቸርነትህ ጌታ ተመስገን»', '“Sile Chernetih Geta Temesgen” (ስለ ቸርነትህ ጌታ ተመስገን)', Qenet.anchihoye),
  Scale('አምባሰል', 'Ambassel', 'C D♭ F G A♭', '½ · 2 · 1 · ½ · 2',
      'ከአምስቱ ድምጾች 2ኛውንና 5ኛውን (D፣ A) በግማሽ ማውረድ',
      'Lower the 2nd and 5th notes (D and A) by a semitone',
      'የወሎ አምባሰል አካባቢ', 'The area of Wollo Ambassel (የወሎ አምባሰል)', null),
  Scale('ባቲ ሜጀር', 'Bati major', 'C E F G B', '2 · ½ · 1 · 2 · ½',
      'ከሰባቱ 2ኛና 6ኛውን ማውጣት፤ ከሰላምታ D→E እና A→B (አንድ ሙሉ ድምጽ ወደ ላይ)',
      'Take out the 2nd and 6th of the seven notes; compared with Selamta, D becomes E and A becomes B (a whole tone higher)',
      'የወሎ ባቲ አካባቢ', 'The area of Wollo Bati (የወሎ ባቲ)', null),
  Scale('ባቲ ማይነር', 'Bati minor', 'C E♭ F G B♭', '1½ · 1 · 1 · 1½ · 1',
      'ከባቲ ሜጀር 2ኛና 5ኛውን በግማሽ ድምጽ ማውረድ (E→E♭፣ B→B♭)',
      'Lower the 2nd and 5th notes of Bati major by a semitone (E to E♭, B to B♭)',
      '', '', null),
];

// ---- Daily plan ----
enum TaskKind { read, quiz, assignment, exercise, freePlay, mezmur, progress, course, exam }

class Task {
  final TaskKind kind;
  final int chapter;
  final String qenet;
  final int count;
  final int song;
  const Task._(this.kind, {this.chapter = 0, this.qenet = '', this.count = 1, this.song = 0});
  const Task.read(int c) : this._(TaskKind.read, chapter: c);
  const Task.quiz(int c) : this._(TaskKind.quiz, chapter: c);
  const Task.assignment(int c) : this._(TaskKind.assignment, chapter: c);
  const Task.exercise(String q, int sessions)
      : this._(TaskKind.exercise, qenet: q, count: sessions);
  const Task.freePlay(int minutes) : this._(TaskKind.freePlay, count: minutes);
  const Task.mezmur(String q, int song) : this._(TaskKind.mezmur, qenet: q, song: song);
  const Task.progress() : this._(TaskKind.progress);
  const Task.course() : this._(TaskKind.course);
  const Task.exam(String q) : this._(TaskKind.exam, qenet: q);
}

const _qenetNames = {
  'selamta': ('ሰላምታ', 'Selamta'),
  'tezeta': ('ትዝታ (ዋኔን)', 'Tizita (Wanen)'),
  'anchihoye': ('አንቺ ሆዬ ለኔ', 'Anchi Hoye Lene'),
};

extension TaskInfo on Task {
  String get _songName {
    final list = mezmurLibrary[Qenet.values.byName(qenet)];
    if (list == null || song >= list.length) return '';
    return tr(list[song].amharic, list[song].title);
  }

  String get label {
    final qa = _qenetNames[qenet]?.$1 ?? '';
    final qe = _qenetNames[qenet]?.$2 ?? '';
    return switch (kind) {
      TaskKind.read => tr('የቀን $chapter ትምህርት ያንብቡ', 'Read Day $chapter'),
      TaskKind.quiz => tr('የቀን $chapter ፈተና ይውሰዱ', 'Take the Day $chapter quiz'),
      TaskKind.assignment => tr('የቀን $chapter ተግባር ይሥሩ', 'Do the Day $chapter assignment'),
      TaskKind.exercise => tr('ልምምድ ሞድ፦ $qa — $count ክፍለ ጊዜ', 'Exercise Mode: $qe, $count session(s)'),
      TaskKind.freePlay => tr('ነጻ ጨዋታ ለ$count ደቂቃ', 'Free Play for $count minutes'),
      TaskKind.mezmur => tr('መዝሙር ተናት፦ $qa — $_songName', 'Mezmur Tenat: $qe — $_songName'),
      TaskKind.progress => tr('ሂደትዎን ይመልከቱ፤ ደካማ ጣትዎን ይለዩ', 'Check My Progress and find your weakest finger'),
      TaskKind.course => tr('የመጨረሻ ፍተሻ፦ የሰባቱንም ቀን ፈተና ያጠናቅቁ', 'Final check: finish all seven daily quizzes'),
      TaskKind.exam => tr('የተግባር ፈተና፦ $qa', 'Practical test: $qe'),
    };
  }

  String get route => switch (kind) {
        TaskKind.read => '/course/$chapter',
        TaskKind.quiz => '/course/$chapter?tab=quiz',
        TaskKind.assignment => '/course/$chapter?tab=assignment',
        TaskKind.exercise => '/exercise?qenet=$qenet',
        TaskKind.freePlay => '/free-play',
        TaskKind.mezmur => '/mezmur-tenat?qenet=$qenet',
        TaskKind.progress => '/progress',
        TaskKind.course => '/course',
        TaskKind.exam => '/exam?qenet=$qenet',
      };
}

const dailyPlan = <List<Task>>[
  [Task.read(1), Task.quiz(1), Task.assignment(1)],
  [Task.read(2), Task.quiz(2), Task.assignment(2)],
  [Task.read(3), Task.quiz(3), Task.assignment(3)],
  [Task.read(4), Task.quiz(4), Task.assignment(4)],
  [Task.read(5), Task.quiz(5), Task.assignment(5)],
  [Task.read(6), Task.quiz(6), Task.assignment(6), Task.exercise('selamta', 2)],
  [
    Task.read(7),
    Task.quiz(7),
    Task.assignment(7),
    Task.exercise('selamta', 3),
    Task.exam('selamta'),
    Task.exercise('tezeta', 1),
    Task.exercise('anchihoye', 1),
  ],
  // Week 2: Selamta mezmur tenat
  [Task.read(5), Task.freePlay(3)],
  [Task.quiz(5), Task.assignment(5), Task.exercise('selamta', 2)],
  [Task.mezmur('selamta', 0)],
  [Task.mezmur('selamta', 1)],
  [Task.mezmur('selamta', 2)],
  [Task.mezmur('selamta', 3)],
  [Task.exam('selamta'), Task.progress()],
  // Week 3: Tezeta mezmur tenat
  [Task.read(6), Task.exercise('tezeta', 2)],
  [Task.mezmur('tezeta', 0)],
  [Task.mezmur('tezeta', 1)],
  [Task.mezmur('tezeta', 2)],
  [Task.mezmur('tezeta', 3)],
  [Task.quiz(6), Task.assignment(6)],
  [Task.exam('tezeta'), Task.progress()],
  // Week 4: Anchihoye mezmur tenat
  [Task.exercise('anchihoye', 2)],
  [Task.mezmur('anchihoye', 0)],
  [Task.mezmur('anchihoye', 1)],
  [Task.mezmur('anchihoye', 2)],
  [Task.exam('anchihoye')],
  [Task.freePlay(10), Task.progress()],
  [Task.course()],
];
