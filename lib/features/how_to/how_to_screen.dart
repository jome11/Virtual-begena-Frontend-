import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/brand_palette.dart';
import '../../shared/widgets/motion.dart';

class _Step {
  final IconData icon;
  final String title;
  final String body;
  const _Step(this.icon, this.title, this.body);
}

class _Content {
  final String title;
  final String subtitle;
  final List<_Step> steps;
  final String faqTitle;
  final List<(String, String)> faqs;
  const _Content({
    required this.title,
    required this.subtitle,
    required this.steps,
    required this.faqTitle,
    required this.faqs,
  });
}

const _en = _Content(
  title: 'How to use Virtual Begena',
  subtitle: 'Start playing in five simple steps.',
  steps: [
    _Step(Icons.videocam_rounded, 'Allow your camera',
        'When your browser asks, allow camera access. Hand tracking runs in your browser.'),
    _Step(Icons.front_hand_rounded, 'Get in position',
        'Sit about an arm\'s length from the screen with good light, and keep your hands in view.'),
    _Step(Icons.library_music_rounded, 'Pick a qenet',
        'Start with Selamta, then move on to Tezeta and Anchihoye.'),
    _Step(Icons.bolt_rounded, 'Practice with Exercise Mode',
        'Follow the prompts. The app tells you which finger to pluck next and tracks your accuracy.'),
    _Step(Icons.bar_chart_rounded, 'Track your progress',
        'Open My Progress to see your accuracy, your weakest finger and the badges you have earned.'),
  ],
  faqTitle: 'Troubleshooting',
  faqs: [
    ('The camera does not start',
        'Click the camera icon in your browser\'s address bar, allow access, then refresh the page.'),
    ('My hand is not detected',
        'Use brighter light, a plain background, and keep your whole hand inside the frame.'),
    ('The strings feel out of place',
        'Turn on “Show Strings” and adjust your hand until the strings line up with your fingers.'),
    ('Which browser should I use?',
        'A recent version of Chrome or Edge gives the best results.'),
  ],
);

const _am = _Content(
  title: 'እንዴት መጠቀም እንደሚቻል',
  subtitle: 'በአምስት ቀላል ደረጃዎች መጫወት ይጀምሩ።',
  steps: [
    _Step(Icons.videocam_rounded, 'ካሜራዎን ይፍቀዱ',
        'አሳሽዎ ሲጠይቅ የካሜራ መዳረሻን ይፍቀዱ። የእጅ ክትትሉ የሚሠራው በአሳሽዎ ውስጥ ነው።'),
    _Step(Icons.front_hand_rounded, 'ቦታዎን ያዘጋጁ',
        'ከማያ ገጹ የእጅ ርዝመት ያህል ርቀው ይቀመጡ፣ በቂ ብርሃን ይኑር፣ እጆችዎም በካሜራ ይታዩ።'),
    _Step(Icons.library_music_rounded, 'ቅኝት ይምረጡ',
        'በሰላምታ ይጀምሩ፣ ከዚያ ወደ ትዝታ እና አንቺሆዬ ይሂዱ።'),
    _Step(Icons.bolt_rounded, 'በልምምድ ሞድ ይለማመዱ',
        'መመሪያዎቹን ይከተሉ። የትኛውን ጣት መንካት እንዳለብዎ መተግበሪያው ይነግርዎታል፣ ትክክለኛነትዎን ይከታተላል።'),
    _Step(Icons.bar_chart_rounded, 'ሂደትዎን ይከታተሉ',
        'ትክክለኛነትዎን፣ በጣም ደካማ ጣትዎን እና ያገኟቸውን ባጆች ለማየት የእኔ ሂደት ገጽን ይክፈቱ።'),
  ],
  faqTitle: 'የተለመዱ ችግሮች',
  faqs: [
    ('ካሜራው አይጀምርም',
        'በአሳሹ አድራሻ መስመር ላይ ያለውን የካሜራ አዶ ጠቅ አድርገው መዳረሻ ይፍቀዱ፣ ከዚያ ገጹን ያድሱ።'),
    ('እጄ አይታወቅም',
        'የበለጠ ብርሃን ይጠቀሙ፣ ግልጽ ጀርባ ይምረጡ፣ እና መላው እጅዎ በካሜራ ውስጥ እንዲታይ ያድርጉ።'),
    ('አውታሮቹ በትክክለኛ ቦታ አይደሉም',
        '“አውታሮችን አሳይ”ን ያብሩ፣ ከዚያ አውታሮቹ ከጣቶችዎ ጋር እስኪገጣጠሙ እጅዎን ያስተካክሉ።'),
    ('የትኛው አሳሽ ይሻላል?',
        'ለተሻለ ውጤት የቅርብ ጊዜ Chrome ወይም Edge ይጠቀሙ።'),
  ],
);

class HowToSection extends StatelessWidget {
  const HowToSection({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        final t = lang == Language.am ? _am : _en;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 72, 24, 32),
              child: Reveal(
                child: Column(
                  children: [
                    Text(
                      t.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        color: brand.ink,
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(t.subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: brand.inkMuted, fontSize: 16)),
                  ],
                ),
              ),
            ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      for (var i = 0; i < t.steps.length; i++)
                        Reveal(
                          child: _StepTile(
                            index: i + 1,
                            step: t.steps[i],
                            last: i == t.steps.length - 1,
                          ),
                        ),
                      const SizedBox(height: 40),
                      Reveal(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 14,
                          runSpacing: 12,
                          children: [
                            FilledButton.icon(
                              onPressed: () => context.go('/try'),
                              icon: const Icon(Icons.play_circle_outline_rounded),
                              label: Text(AppStrings.get('try_free')),
                              style: FilledButton.styleFrom(
                                backgroundColor: brand.amber,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 26, vertical: 18),
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () => context.go('/signup'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: brand.ink,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 26, vertical: 18),
                              ),
                              child: Text(AppStrings.get('get_started')),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 56),
                      Reveal(child: _TipsCard()),
                      const SizedBox(height: 40),
                      Reveal(
                        child: Text(
                          t.faqTitle,
                          style: GoogleFonts.playfairDisplay(
                            color: brand.ink,
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      for (final f in t.faqs)
                        Reveal(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: brand.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: brand.beige),
                            ),
                            child: Theme(
                              data: Theme.of(context)
                                  .copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                title: Text(f.$1,
                                    style: TextStyle(
                                        color: brand.ink,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14)),
                                childrenPadding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                expandedAlignment: Alignment.centerLeft,
                                children: [
                                  Text(f.$2,
                                      style: TextStyle(
                                          color: brand.inkMuted, height: 1.6)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 56),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StepTile extends StatelessWidget {
  final int index;
  final _Step step;
  final bool last;
  const _StepTile({required this.index, required this.step, required this.last});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: brand.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: brand.beige),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                ),
              ),
              child: Text('$index',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16)),
            ),
            const SizedBox(width: 16),
            Icon(step.icon, color: brand.amber, size: 26),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(step.title,
                      style: TextStyle(
                          color: brand.ink,
                          fontWeight: FontWeight.w700,
                          fontSize: 16)),
                  const SizedBox(height: 6),
                  Text(step.body,
                      style: TextStyle(
                          color: brand.inkMuted, height: 1.6, fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TipsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0B1F4B), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: brand.amber.withValues(alpha: 0.25),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.get('tips_heading'),
              style: const TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          for (final key in const ['tip_show_strings', 'tip_start_selamta'])
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline_rounded,
                      color: Color(0xFF93C5FD), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(AppStrings.get(key),
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            height: 1.6,
                            fontSize: 13.5)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
