class ContentBlock {
  final String? heading;
  final String? paragraph;
  final List<String>? bullets;
  const ContentBlock({this.heading, this.paragraph, this.bullets});
}

const List<ContentBlock> begenaAboutEn = [
  ContentBlock(
    paragraph:
        'The Begena (Ethiopian harp) is classified as a string instrument and is among the oldest in the world, with a history spanning over 5,800 years. It is unique for its meditative power, serene sound, solo performance style, rich poetic traditions, and deep cultural values. Furthermore, it is a purely spiritual instrument used exclusively for religious service both in heaven and on earth. The crafting, naming, and symbolism of every single component are deeply spiritual, guiding both the player and the listener toward a spiritual life.',
  ),
  ContentBlock(
    paragraph:
        'The Begena is traditionally played using the fingers of the left hand. However, if a player lacks a left hand or left-hand fingers for any reason, they may use their right hand. Traditional practice, nevertheless, dictates that it be played with the left hand.',
  ),
  ContentBlock(
    heading: 'When is the Begena Played?',
    paragraph:
        'Although listening to Begena music today is most common among believers during fasting seasons—particularly during Great Lent—its use is by no means restricted to these periods. Historians note that this association began during the reign of Emperor Haile Selassie I. The Church\u2019s radio program used to broadcast Begena music during Great Lent, leading the public to gradually adopt the habit of listening to it primarily during fasts.',
  ),
  ContentBlock(
    heading: 'Parts of the Begena',
    paragraph: 'The Begena consists of 10 main components:',
    bullets: [
      'Yoke (Qenber)',
      'Tuning pegs (Meqanya)',
      'Ornaments (Get)',
      'Pillars / Side arms (Miseso)',
      'Strings (Awtar)',
      'Soundbox / Body (Gebete)',
      'Bridge (Birkuma)',
      'Leather strips / String dampener (Enzira)',
      'Tensioning cord (Mewoterya)',
      'Tailpiece / Lower anchor (Dihintsa)',
    ],
  ),
  ContentBlock(
    heading: 'What is it Made Of?',
    paragraph: 'The Begena is crafted exclusively from natural materials derived from animals and plants.',
  ),
  ContentBlock(
    heading: 'Animal Derivatives (Cattle hide, sheep intestine, ox tendon, and horn):',
    bullets: [
      'Strings',
      'Leather skin covering the soundbox',
      'Tensioning leather straps',
      'Tailpiece',
      'Tailpiece strap',
      'Dampener strips (Enzira)',
    ],
  ),
  ContentBlock(
    heading: 'Plant Derivatives (Wood species such as Cordia africana, Aningeria, Podocarpus, Olive wood, and Cedar):',
    bullets: [
      'Yoke',
      'Ornaments',
      'Pillars',
      'Soundbox',
      'Bridge',
      'Tensioning pins',
      'Tuning pegs',
      'Tailpiece core',
    ],
  ),
];

const List<ContentBlock> begenaAboutAm = [
  ContentBlock(
    heading: 'በገና',
    paragraph:
        'በገና አውታር ካላቸው የዜማ መሳሪያዎች የሚመደብ ሲሆን በእድሜው ትልቅነትም ከ5800 ዓመት በላይ እድሜ ያለው ነው። በመመሰጥ ኃይሉ፣ በእርጋታው፣ ብቻውን የሚዘመርበት በመሆኑ ፣ በሥነ ቃሉ እና በመሳሰሉት ዕሴቶቹ የተለየ ነው። እንዲሁም በሰማይም በምድርም አገልግሎት ያለው ለመንፈሳዊ ግልጋሎት ብቻ የምንጠቀምበት፤ የእያንዳንዱ አካል ክፍሎቹ አሰራር፣ ሥያሜ እና ምሳሌነታቸውም መንፈሳዊ የሆኑ ደርዳሪዎቹንም ወደ መንፈሳዊ ሕይወት የሚመራ መንፈሳዊ መሳሪያ ነው።',
  ),
  ContentBlock(
    paragraph:
        'በገና የሚደረደረው በግራ እጅ ጣቶች ነው። በተለያዩ ምክንያቶች የግራ እጅ የሌለው ወይም የግራ እጁ ጣቶች የጎደሉበት ሰው ግን በቀኝ እጁ ጣቶች ይደረድራል። ትውፊቱ ግን የሚያዘው በግራ እጅ ጣቶች እንዲደረደር ነው።',
  ),
  ContentBlock(
    heading: 'በገና መቼ ነው የሚደረድረው',
    paragraph:
        'አሁን አሁን በምዕመናን ዘንድ የበገና መዝሙር መስማት የሚዘወተረው በአጽዋማት ወቅት በተለይም በዐቢይ ጾም ጊዜ ቢሆንም፤ ከዚህ ወቅት ጋር ብቻ የሚገድበው ነገር ኖሮ አይደለም። ታሪኩን የሚያውቁ ሲናገሩም እንዲህ ያለው ሁኔታ የመጣው በቀዳማዊ አፄ ኃይለ ሥላሴ ዘመነ መንግስት፣ ቤተክርስቲያን በነበራት የሬድዮ መርሐግብር፤ በዐቢይ ጾም ወቅት ይተላለፍ የነበረው መዝሙር የበገና መዝሙር ስለነበረ ሕዝቡ ከዚህ በመነሳት በጾም ወቅት የበገና መዝሙር መስማትን ባሕል እያደረገው እንደመጣ ይታመናል',
  ),
  ContentBlock(
    heading: 'የበገና ክፍሎች',
    paragraph: 'በገና 10 ክፍሎች አሉት። እነሱም፦',
    bullets: ['ቀንበር', 'መቃኛ', 'ጌጥ', 'ምሰሶ', 'አውታር', 'ገበቴ', 'ብርኩማ', 'እንዚራ', 'መወጠሪያ', 'ድህንጻ'],
  ),
  ContentBlock(
    heading: 'ከምን ይሰራል?',
    paragraph: 'በገና ከእንስሳትና ከእጽዋት ተዋጽኦ የሚሠራ እና እነዚህን ተፈጥሯዊ ግብዓቶችን ብቻ የሚጠቀም የዜማ መሳሪያ ነው።',
  ),
  ContentBlock(
    heading: 'ከእንስሳት ተዋጽኦ፦ የከብት ቆዳ፣ የበግ አንጀት፣ የበሬ ጅማት፣ ቀንድ',
    bullets: ['አውታር', 'የድምጽ ሳጥን መለጎሚያ ቆዳ', 'የመወጠሪያ ጠፈር', 'ድሕንጻ', 'የድሕንጻ ጠፈር', 'እንዚራ'],
  ),
  ContentBlock(
    heading: 'ከእጽዋት ተዋጽኦ፦ ዋንዛ፣ ቀረሮ፣ ዝግባ፣ ወይራ፣ ጥድ',
    bullets: ['ቀንበር', 'ጌጥ', 'ምሰሶ', 'ገበቴ', 'ብርኩማ', 'መወጠሪያ', 'መቃኛ', 'ድሕንጻ'],
  ),
];
