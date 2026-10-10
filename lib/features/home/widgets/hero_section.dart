import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_strings.dart';

// Sacred, dark palette for the hero band only — independent of the light
// brand theme used by the rest of the page, so it reads as its own moment.
const _ink = Color(0xFF0C0B08);       // near-black background
const _inkDeep = Color(0xFF060504);   // darkest edge of the scrim
const _gold = Color(0xFFC9A24B);      // headline accent / CTA
const _goldSoft = Color(0xFFE8D5A3);  // subheading
const _cream = Color(0xFFF4EFE4);     // body text on dark
const _creamMuted = Color(0xB3F4EFE4);

class _Copy {
  final String kicker;
  final String titleLine1;
  final String titleLine2;
  final String subhead;
  final String body;
  final String primaryCta;
  final String secondaryCta;
  const _Copy({
    required this.kicker,
    required this.titleLine1,
    required this.titleLine2,
    required this.subhead,
    required this.body,
    required this.primaryCta,
    required this.secondaryCta,
  });
}

const _en = _Copy(
  kicker: 'BEGENA TRAINER',
  titleLine1: 'Learn the Begena:',
  titleLine2: 'The Sacred Instrument of David',
  subhead: 'Ancient, Spiritual, Orthodox Tradition.',
  body:
      'Guided lessons and real-time hand tracking help you learn the '
      'begena the way it has always been taught — string by string, '
      'hymn by hymn.',
  primaryCta: 'Start Learning Now',
  secondaryCta: 'Explore the Instrument',
);

const _am = _Copy(
  kicker: 'ቨርቹዋል በገና',
  titleLine1: 'በገናን ይማሩ:',
  titleLine2: 'የዳዊት ቅዱስ መሣሪያ',
  subhead: 'ጥንታዊ፣ መንፈሳዊ፣ የኦርቶዶክስ ትውፊት።',
  body:
      'በእጅ መከታተያ ቴክኖሎጂ የታገዙ ትምህርቶች በገናን ከመሠረቱ፣ ጅማት በጅማት፣ '
      'መዝሙር በመዝሙር እንዲማሩ ይረዱዎታል።',
  primaryCta: 'መማር ይጀምሩ',
  secondaryCta: 'መሣሪያውን ይመልከቱ',
);

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        final copy = lang == Language.am ? _am : _en;
        return LayoutBuilder(
          builder: (context, c) {
            final narrow = c.maxWidth < 900;
            return Container(
              width: double.infinity,
              height: narrow ? 640 : 720,
              color: _ink,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background photo — swap the asset path for any of your
                  // begena images (e.g. assets/begena/b2.jpg).
                  Positioned.fill(
                    child: Image.asset(
                      'assets/begena/darkmode.png',
                      fit: BoxFit.cover,
                      alignment:
                          narrow ? Alignment.topCenter : Alignment.centerRight,
                    ),
                  ),
                  // Dark scrim so the text stays readable over the photo.
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: narrow
                            ? const LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [_ink, _ink, Color(0x660C0B08)],
                                stops: [0.0, 0.55, 1.0],
                              )
                            : LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  _inkDeep,
                                  _ink.withValues(alpha: 0.92),
                                  _ink.withValues(alpha: 0.35),
                                ],
                                stops: const [0.0, 0.55, 1.0],
                              ),
                      ),
                    ),
                  ),
                  // Content.
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      narrow ? 24 : 72,
                      narrow ? 120 : 64,
                      narrow ? 24 : 72,
                      narrow ? 48 : 64,
                    ),
                    child: Align(
                      alignment:
                          narrow ? Alignment.bottomCenter : Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 620),
                        child: _HeroText(copy: copy, narrow: narrow),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _HeroText extends StatelessWidget {
  final _Copy copy;
  final bool narrow;
  const _HeroText({required this.copy, required this.narrow});

  @override
  Widget build(BuildContext context) {
    final align = narrow ? TextAlign.center : TextAlign.left;
    final cross = narrow ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    return Column(
      crossAxisAlignment: cross,
      children: [
        Text(
          copy.kicker,
          textAlign: align,
          style: TextStyle(
            color: _goldSoft,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 20),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: '${copy.titleLine1}\n'),
              TextSpan(text: copy.titleLine2, style: const TextStyle(color: _gold)),
            ],
          ),
          textAlign: align,
          style: GoogleFonts.playfairDisplay(
            color: _cream,
            fontSize: narrow ? 34 : 46,
            fontWeight: FontWeight.w700,
            height: 1.18,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          copy.subhead,
          textAlign: align,
          style: GoogleFonts.playfairDisplay(
            color: _goldSoft,
            fontSize: narrow ? 17 : 20,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          copy.body,
          textAlign: align,
          style: TextStyle(
            color: _creamMuted,
            fontSize: narrow ? 14.5 : 16,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 36),
        Wrap(
          alignment: narrow ? WrapAlignment.center : WrapAlignment.start,
          spacing: 16,
          runSpacing: 14,
          children: [
            ElevatedButton(
              onPressed: () => context.go('/signup'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _gold,
                foregroundColor: _inkDeep,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              child: Text(
                copy.primaryCta.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  letterSpacing: 1.1,
                ),
              ),
            ),
            OutlinedButton(
              onPressed: () => context.go('/try'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _cream,
                side: const BorderSide(color: Color(0x80F4EFE4)),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              child: Text(
                copy.secondaryCta.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
