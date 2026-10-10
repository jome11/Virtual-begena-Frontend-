import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_strings.dart' show Language, languageNotifier;
import '../../../core/theme/brand_palette.dart';
import '../../../shared/widgets/motion.dart';
import '../../../shared/widgets/stylized_cross.dart';

// ---------------------------------------------------------------------------
// Shared pieces
// ---------------------------------------------------------------------------

BoxDecoration _cardDecoration(BrandPalette brand) => BoxDecoration(
      color: brand.surface.withValues(alpha: 0.92),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: brand.beige),
    );

class _SectionShell extends StatelessWidget {
  final Widget child;
  const _SectionShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: child,
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String? subtitle;
  const _Header({required this.eyebrow, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 48, height: 1, color: brand.amber.withValues(alpha: 0.4)),
            const SizedBox(width: 12),
            StylizedCross(size: 22, color: brand.amber),
            const SizedBox(width: 12),
            Container(width: 48, height: 1, color: brand.amber.withValues(alpha: 0.4)),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          eyebrow,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: brand.amber,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(
            color: brand.ink,
            fontSize: 32,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: TextStyle(color: brand.inkMuted, fontSize: 15, height: 1.6),
            ),
          ),
        ],
      ],
    );
  }
}

class _ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int maxCols;
  final double minHeight;
  const _ResponsiveGrid({
    required this.children,
    this.maxCols = 3,
    this.minHeight = 0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        const gap = 16.0;
        final cols = c.maxWidth >= 900 ? maxCols : (c.maxWidth >= 560 ? 2 : 1);
        final w = (c.maxWidth - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (var i = 0; i < children.length; i++)
              SizedBox(
                width: w,
                child: Reveal(
                  delay: Duration(milliseconds: 100 * (i % cols)),
                  child: minHeight > 0
                      ? ConstrainedBox(
                          constraints: BoxConstraints(minHeight: minHeight),
                          child: children[i],
                        )
                      : children[i],
                ),
              ),
          ],
        );
      },
    );
  }
}

class _IconBadge extends StatelessWidget {
  final IconData? icon;
  const _IconBadge({this.icon});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: brand.amber.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: icon == null
            ? StylizedCross(size: 22, color: brand.amber)
            : Icon(icon, color: brand.amber, size: 22),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 1. The Harp in Scripture
// ---------------------------------------------------------------------------

class ScriptureSection extends StatelessWidget {
  const ScriptureSection({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        final am = lang == Language.am;

        // (reference, text)
        final verses = <(String, String)>[
          (
            am ? 'መዝ. 92፥3' : 'Psalm 92:3',
            am
                ? 'ቅዱስ ዳዊት በመዝሙሩ በገናን «መዝሙር፣ ምስጋና» በማለት ተርጉሞታል።'
                : 'Upon an instrument of ten strings, and upon the psaltery; upon the harp with a solemn sound.',
          ),
          (
            am ? '1ኛ ሳሙ. 16፥23' : '1 Samuel 16:23',
            am
                ? 'ክፉ መንፈስ ሳኦልን ሲያሳድደው ዳዊት በበገና ይደረድርለት ነበር፤ መንፈሱ ይርቅ፣ ሳኦልም ይረጋጋ ነበር።'
                : '…David took an harp, and played with his hand: so Saul was refreshed, and was well, and the evil spirit departed from him.',
          ),
          (
            am ? 'ራእ. 5፥8' : 'Revelation 5:8',
            am
                ? 'ሃያ አራቱ ሊቃነ ካህናት እያንዳንዳቸው በገናና የቅዱሳን ጸሎት የሆነ ዕጣን የሞላበት የወርቅ ዕቃ ይዘው ይታያሉ።'
                : '…four and twenty elders fell down before the Lamb, having every one of them harps, and golden vials full of odours, which are the prayers of saints.',
          ),
        ];

        return _SectionShell(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Header(
                eyebrow: am ? 'ቅዱስ መጽሐፍ' : 'HOLY SCRIPTURE',
                title: am ? 'በገና በቅዱስ መጽሐፍ' : 'The Harp in Scripture',
                subtitle: am
                    ? 'በገና በምድርም በሰማይም የምስጋና መሣሪያ ሆኖ ይታያል።'
                    : 'From the days of Adam’s children to the throne of heaven, the harp serves the praise of God.',
              ),
              const SizedBox(height: 40),
              _ResponsiveGrid(
                maxCols: 3,
                minHeight: 180,
                children: [
                  for (var i = 0; i < verses.length; i++)
                    _VerseCard(
                      reference: verses[i].$1,
                      text: verses[i].$2,
                      serifItalic: !am,
                    ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                am
                    ? 'ተጨማሪ፦ ዘፍ. 4፥21 · 2ኛ ሳሙ. 6፥5 · 2ኛ ዜና 5፥12-14'
                    : 'Further reading: Genesis 4:21 · 2 Samuel 6:5 · 2 Chronicles 5:12–14',
                textAlign: TextAlign.center,
                style: TextStyle(color: brand.inkMuted, fontSize: 12.5, letterSpacing: 0.4),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _VerseCard extends StatelessWidget {
  final String reference;
  final String text;
  final bool serifItalic;
  const _VerseCard({
    required this.reference,
    required this.text,
    required this.serifItalic,
  });

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(brand),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '“',
            style: GoogleFonts.playfairDisplay(
              color: brand.amber,
              fontSize: 44,
              height: 0.8,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: serifItalic
                ? GoogleFonts.playfairDisplay(
                    color: brand.ink,
                    fontSize: 16,
                    height: 1.6,
                    fontStyle: FontStyle.italic,
                  )
                : TextStyle(color: brand.ink, fontSize: 15, height: 1.7),
          ),
          const SizedBox(height: 16),
          Text(
            reference.toUpperCase(),
            style: TextStyle(
              color: brand.amber,
              fontWeight: FontWeight.w700,
              fontSize: 12,
              letterSpacing: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. What the begena symbolises
// ---------------------------------------------------------------------------

class SymbolismSection extends StatelessWidget {
  const SymbolismSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        final am = lang == Language.am;

        // (icon or null for the cross, title, body)
        final items = <(IconData?, String, String)>[
          (
            Icons.graphic_eq_rounded,
            am ? 'አሥሩ አውታር' : 'The ten strings',
            am
                ? 'የአሥርቱ ትእዛዛት ምሳሌ ናቸው (ዘፀ. 20፥1-17)።'
                : 'They stand for the Ten Commandments given to Moses (Exodus 20:1–17).',
          ),
          (
            Icons.auto_awesome_rounded,
            am ? 'የድምጽ ሳጥን (ገበቴ)' : 'The sound box (gebete)',
            am
                ? 'የእመቤታችን የቅድስት ድንግል ማርያም ምሳሌ፤ የበገናው ድምጽ ከድምጽ ሳጥኑ እንደሚገኝ፣ አካላዊ ቃል ኢየሱስ ክርስቶስ ከእመቤታችን ተገኝቷል።'
                : 'A symbol of the Holy Virgin Mary: as the begena’s voice comes from its sound box, the Word, our Lord Jesus Christ, was born of her.',
          ),
          (
            null,
            am ? 'የመስቀል ምልክት' : 'The cross',
            am
                ? 'ቅዱስ ዳዊት ከሳኦል ጦር የዳነበት፣ እኛም ከዲያብሎስ ፍላጻ የምንድንበት ምልክት።'
                : 'The sign by which David was saved from Saul’s army, and by which we are saved from the arrows of the devil.',
          ),
          (
            Icons.swap_horiz_rounded,
            am ? 'ሁለቱ ምሰሶዎች' : 'The two posts',
            am
                ? 'የቀኝ ምሰሶ የብሉይ ኪዳንና የቅዱስ ሚካኤል፣ የግራ ምሰሶ የሐዲስ ኪዳንና የቅዱስ ገብርኤል ምሳሌ ነው።'
                : 'The right post stands for the Old Testament and Saint Michael; the left for the New Testament and Saint Gabriel.',
          ),
          (
            Icons.touch_app_rounded,
            am ? 'ድህንጻ' : 'The plectrum',
            am
                ? 'አሥሩን አውታሮች እየተመላለሰ እንደሚገርፋቸው፣ ክርስቶስ አሥሩን ትእዛዛት በሐዲስ ኪዳን አጽንቷል።'
                : 'As it sweeps across the ten strings, so Christ confirmed the ten commandments in the New Testament.',
          ),
          (
            Icons.account_balance_rounded,
            am ? 'ቀንበር' : 'The yoke (kenber)',
            am
                ? 'የስልጣነ እግዚአብሔር ምሳሌ ነው።'
                : 'The crossbar that holds the strings is a symbol of the authority of God.',
          ),
        ];

        return _SectionShell(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Header(
                eyebrow: am ? 'ምሳሌዎች' : 'THE SYMBOLISM',
                title: am ? 'ምሳሌ የሞላው በገና' : 'A harp full of meaning',
                subtitle: am
                    ? 'የእያንዳንዱ የበገና አካል አሰራር፣ ስያሜና ምሳሌነት መንፈሳዊ ነው።'
                    : 'In the Ethiopian Orthodox Tewahedo tradition, every part of the begena points to the faith.',
              ),
              const SizedBox(height: 40),
              _ResponsiveGrid(
                children: [
                  for (final item in items)
                    _SymbolCard(icon: item.$1, title: item.$2, body: item.$3),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SymbolCard extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String body;
  const _SymbolCard({required this.icon, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return HoverLift(
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: _cardDecoration(brand),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _IconBadge(icon: icon),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.playfairDisplay(
                color: brand.ink,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: TextStyle(color: brand.inkMuted, fontSize: 14, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. The tradition of the begena
// ---------------------------------------------------------------------------

class TraditionSection extends StatelessWidget {
  const TraditionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        final am = lang == Language.am;

        // When the begena is played.
        final occasions = <(IconData, String, String)>[
          (
            Icons.brightness_3_rounded,
            am ? 'አብይ ጾም' : 'The Great Fast',
            am
                ? 'ዝግተኛና ተደጋጋሚ ድምፁ ሰውን ወደ ጥልቅ ጸሎትና ተመስጦ ያደርሳል።'
                : 'Its slow, repeating sound draws the heart into deep prayer.',
          ),
          (
            Icons.celebration_rounded,
            am ? 'ታላላቅ በዓላት' : 'The great feasts',
            am
                ? 'በታላላቅ በዓላት የምስጋና ዜማዎች ይቀርባሉ።'
                : 'Hymns of praise offered on the major feasts of the Church.',
          ),
          (
            Icons.favorite_border_rounded,
            am ? 'ሠርግ' : 'Weddings',
            am
                ? 'በሠርግ ጊዜ መዝሙሮች ይቀርባሉ።'
                : 'Mezmur sung to bless the celebration.',
          ),
          (
            Icons.wb_twilight_rounded,
            am ? 'ሐዘንና መታሰቢያ' : 'Mourning and remembrance',
            am
                ? 'ከኀዘን ለመጽናናትና የሕይወትን አላፊነት ለማሰብ በስንብትና በመታሰቢያ ዜማዎች ይታያል።'
                : 'Comfort in grief, and a reminder of life’s brevity in farewell and memorial songs.',
          ),
        ];

        return _SectionShell(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Header(
                eyebrow: am ? 'ትውፊት' : 'THE TRADITION',
                title: am ? 'የበገና ትውፊት' : 'The tradition of the begena',
                subtitle: am
                    ? 'በገና ለመንፈሳዊ ግልጋሎት ብቻ የምንጠቀምበት መንፈሳዊ መሳሪያ ነው።'
                    : 'Tradition holds that the begena is an instrument for spiritual service alone, and that it is more than 5,800 years old.',
              ),
              const SizedBox(height: 40),
              _ResponsiveGrid(
                maxCols: 4,
                children: [
                  for (final o in occasions)
                    _OccasionCard(icon: o.$1, title: o.$2, body: o.$3),
                ],
              ),
              const SizedBox(height: 28),
              Reveal(
                child: _YaredBanner(am: am),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OccasionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  const _OccasionCard({required this.icon, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(brand),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _IconBadge(icon: icon),
          const SizedBox(height: 14),
          Text(
            title,
            style: GoogleFonts.playfairDisplay(
              color: brand.ink,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: TextStyle(color: brand.inkMuted, fontSize: 13.5, height: 1.55),
          ),
        ],
      ),
    );
  }
}



class _YaredBanner extends StatelessWidget {
  final bool am;
  const _YaredBanner({required this.am});

  @override
  Widget build(BuildContext context) {
    // (mode, who it is remembered as)
    final modes = <(String, String)>[
      ('ግእዝ', am ? 'አብ' : 'the Father'),
      ('ዕዝል', am ? 'ወልድ' : 'the Son'),
      ('አራራይ', am ? 'መንፈስ ቅዱስ' : 'the Holy Spirit'),
    ];
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0B1F4B), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const StylizedCross(size: 26, color: Colors.white),
          const SizedBox(height: 14),
          Text(
            am ? 'የቅዱስ ያሬድ ሦስቱ ዜማዎች' : 'The three modes of Saint Yared',
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 16),
          for (final m in modes)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    m.$1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '— ${m.$2}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
