import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/brand_palette.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/youtube_embed.dart';

const _cta = Color(0xFF2563EB);

/// Sample value shown in the card's progress bar. Change it freely.
const _sampleProgress = 0.68;

class _Copy {
  final String badge;
  final String titleLead;
  final String titleAccent;
  final List<String> checks;
  final String start;
  final String featured;
  final String progress;
  final String certTitle;
  final String certSub;
  const _Copy({
    required this.badge,
    required this.titleLead,
    required this.titleAccent,
    required this.checks,
    required this.start,
    required this.featured,
    required this.progress,
    required this.certTitle,
    required this.certSub,
  });
}

const _en = _Copy(
  badge: 'Trusted by learners worldwide',
  titleLead: 'Master the Begena',
  titleAccent: 'Step by Step',
  checks: [
    'Learn at your own pace',
    'Interactive hand tracking',
    'Earn certificates',
    'Free play mode',
  ],
  start: 'Start Learning',
  featured: 'Featured Lesson',
  progress: 'Course Progress',
  certTitle: 'Certificate',
  certSub: 'Earn on completion',
);

const _am = _Copy(
  badge: 'በመላው ዓለም በተማሪዎች የታመነ',
  titleLead: 'በገናን ይልመዱ',
  titleAccent: 'ደረጃ በደረጃ',
  checks: [
    'በራስዎ ፍጥነት ይማሩ',
    'በእጅ መከታተያ የሚሰራ ልምምድ',
    'ሰርተፊኬት ያግኙ',
    'ነጻ የመጫወቻ ሞድ',
  ],
  start: 'መማር ይጀምሩ',
  featured: 'ተለይቶ የቀረበ ትምህርት',
  progress: 'የኮርስ ሂደት',
  certTitle: 'ሰርተፊኬት',
  certSub: 'ሲጨርሱ ያገኛሉ',
);

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final hPad = MediaQuery.of(context).size.width < 700 ? 20.0 : 40.0;
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        final copy = lang == Language.am ? _am : _en;
        return Padding(
          padding: EdgeInsets.fromLTRB(hPad, 48, hPad, 72),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1280),
              child: LayoutBuilder(
                builder: (context, c) {
                  final narrow = c.maxWidth < 950;
                  final titleSize =
                      narrow ? 38.0 : (c.maxWidth / 20).clamp(42.0, 60.0).toDouble();
                  final text = _HeroText(copy: copy, narrow: narrow, titleSize: titleSize);
                  final card = _HeroCard(copy: copy, narrow: narrow);
                  if (narrow) {
                    return Column(children: [text, const SizedBox(height: 56), card]);
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 5, child: text),
                      const SizedBox(width: 64),
                      Expanded(flex: 5, child: card),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HeroText extends StatelessWidget {
  final _Copy copy;
  final bool narrow;
  final double titleSize;
  const _HeroText({
    required this.copy,
    required this.narrow,
    required this.titleSize,
  });

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final align = narrow ? TextAlign.center : TextAlign.left;
    final cross = narrow ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    return Column(
      crossAxisAlignment: cross,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: brand.amber.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: brand.amber.withValues(alpha: 0.6)),
          ),
          child: Text(
            copy.badge,
            style: TextStyle(
              color: brand.amber,
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 32),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: '${copy.titleLead} '),
              TextSpan(text: copy.titleAccent, style: TextStyle(color: brand.amber)),
            ],
          ),
          textAlign: align,
          style: GoogleFonts.poppins(
            color: brand.ink,
            fontSize: titleSize,
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 28),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Text(
            AppStrings.get('hero_subtitle').replaceAll('\n', ' '),
            textAlign: align,
            style: TextStyle(
              color: brand.ink.withValues(alpha: 0.75),
              fontSize: narrow ? 16 : 18,
              height: 1.65,
            ),
          ),
        ),
        const SizedBox(height: 32),
        Wrap(
          alignment: narrow ? WrapAlignment.center : WrapAlignment.start,
          spacing: 44,
          runSpacing: 16,
          children: [for (final c in copy.checks) _Check(c)],
        ),
        const SizedBox(height: 40),
        Wrap(
          alignment: narrow ? WrapAlignment.center : WrapAlignment.start,
          spacing: 16,
          runSpacing: 14,
          children: [
            ElevatedButton(
              onPressed: () => context.go('/signup'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _cta,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    copy.start,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16.5),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () => context.go('/try'),
              style: OutlinedButton.styleFrom(
                foregroundColor: brand.ink,
                side: BorderSide(color: brand.ink.withValues(alpha: 0.3)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                AppStrings.get('try_free'),
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Check extends StatelessWidget {
  final String label;
  const _Check(this.label);

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle_outline_rounded, color: brand.amber, size: 22),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: brand.ink,
            fontSize: 15.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _HeroCard extends StatefulWidget {
  final _Copy copy;
  final bool narrow;
  const _HeroCard({required this.copy, required this.narrow});

  @override
  State<_HeroCard> createState() => _HeroCardState();
}

class _HeroCardState extends State<_HeroCard> {
  // Placeholder videos, replace later. id = the part after "v=" in a YouTube link.
  static const _videos = [
    ('nAlD9nkJzLc', 'The Story of the Begena'),
    ('DykDffdo8yk', 'Learn to play: intro'),
    ('SLZc4q3vp38', 'Finger exercises'),
    ('lW645IYBLXg', 'Begena mezmur'),
  ];
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final copy = widget.copy;

    final card = Container(
      decoration: BoxDecoration(
        color: brand.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: brand.amber.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: brand.amber.withValues(alpha: 0.18),
            blurRadius: 50,
            offset: const Offset(0, 24),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: YoutubeEmbed(videoId: _videos[_index].$1),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 26, 28, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    copy.featured,
                    style: TextStyle(
                      color: brand.ink,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _videos[_index].$2,
                    style: TextStyle(color: brand.inkMuted, fontSize: 15),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        copy.progress,
                        style: TextStyle(color: brand.inkMuted, fontSize: 14),
                      ),
                      Text(
                        '${(_sampleProgress * 100).round()}%',
                        style: TextStyle(
                          color: brand.ink,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: _sampleProgress,
                      minHeight: 9,
                      backgroundColor: brand.beige.withValues(alpha: 0.6),
                      color: brand.amber,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (var i = 0; i < _videos.length; i++)
                        ChoiceChip(
                          label: Text(_videos[i].$2),
                          selected: i == _index,
                          showCheckmark: false,
                          selectedColor: _cta,
                          backgroundColor: brand.background,
                          labelStyle: TextStyle(
                            color: i == _index ? Colors.white : brand.ink,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          onSelected: (_) => setState(() => _index = i),
                        ),
                    ],
                  ),
                  // Room so the floating certificate chip doesn't cover the chips.
                  const SizedBox(height: 44),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        card,
        Positioned(
          left: widget.narrow ? 16 : -32,
          bottom: -28,
          child: _CertChip(copy: copy),
        ),
      ],
    );
  }
}

class _CertChip extends StatelessWidget {
  final _Copy copy;
  const _CertChip({required this.copy});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: brand.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: brand.amber.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: brand.amber.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.workspace_premium_outlined, color: brand.amber, size: 30),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                copy.certTitle,
                style: TextStyle(
                  color: brand.ink,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                copy.certSub,
                style: TextStyle(color: brand.inkMuted, fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
