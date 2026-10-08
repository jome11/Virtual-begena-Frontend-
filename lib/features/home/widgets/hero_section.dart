import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/brand_palette.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/youtube_embed.dart';
import '../../../shared/widgets/interlace_border.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        return Container(
          width: double.infinity,
          color: Colors.transparent,
          child: Column(
            children: [
              InterlaceBorder(color: brand.amber.withValues(alpha: 0.35)),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 48, 32, 88),
                child: LayoutBuilder(
                  builder: (context, c) {
                    final narrow = c.maxWidth < 900;
                    final text = _EditorialText(narrow: narrow);
                    final art = _HeroVideo(narrow: narrow);
                    if (narrow) {
                      return Column(children: [art, const SizedBox(height: 36), text]);
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(flex: 5, child: text),
                        const SizedBox(width: 56),
                        Expanded(flex: 5, child: art)
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EditorialText extends StatelessWidget {
  final bool narrow;
  const _EditorialText({required this.narrow});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Column(
      crossAxisAlignment: narrow ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          'ETHIOPIAN HERITAGE • DIGITAL LESSONS',
          textAlign: narrow ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            color: brand.amber,
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.2,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          AppStrings.get('hero_title'),
          textAlign: narrow ? TextAlign.center : TextAlign.left,
          style: GoogleFonts.playfairDisplay(
            color: brand.ink,
            fontSize: narrow ? 42 : 58,
            fontWeight: FontWeight.w700,
            height: 1.08,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: narrow ? null : 440,
          child: Text(
            AppStrings.get('hero_subtitle'),
            textAlign: narrow ? TextAlign.center : TextAlign.left,
            style: TextStyle(
              color: brand.ink.withValues(alpha: 0.65),
              fontSize: 15.5,
              height: 1.65,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 34),
        Wrap(
          alignment: narrow ? WrapAlignment.center : WrapAlignment.start,
          spacing: 14,
          runSpacing: 12,
          children: [
            ElevatedButton(
              onPressed: () => context.go('/login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: brand.amber,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              child: Text(
                AppStrings.get('start_learning'),
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, letterSpacing: 0.5),
              ),
            ),
            OutlinedButton(
              onPressed: () => context.go('/try'),
              style: OutlinedButton.styleFrom(
                foregroundColor: brand.ink,
                side: BorderSide(color: brand.ink.withValues(alpha: 0.3)),
                padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              child: Text(
                AppStrings.get('try_free'),
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroVideo extends StatefulWidget {
  final bool narrow;
  const _HeroVideo({required this.narrow});

  @override
  State<_HeroVideo> createState() => _HeroVideoState();
}

class _HeroVideoState extends State<_HeroVideo> {
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: brand.amber.withValues(alpha: 0.25),
                blurRadius: 40,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: YoutubeEmbed(videoId: _videos[_index].$1),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var i = 0; i < _videos.length; i++)
              ChoiceChip(
                label: Text(_videos[i].$2),
                selected: i == _index,
                showCheckmark: false,
                selectedColor: brand.amber,
                backgroundColor: brand.surface,
                labelStyle: TextStyle(
                  color: i == _index ? Colors.white : brand.ink,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5,
                ),
                onSelected: (_) => setState(() => _index = i),
              ),
          ],
        ),
      ],
    );
  }
}
