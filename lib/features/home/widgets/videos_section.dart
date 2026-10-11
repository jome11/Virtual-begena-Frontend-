import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/brand_palette.dart';
import '../../../shared/widgets/youtube_embed.dart';

class VideosSection extends StatefulWidget {
  const VideosSection({super.key});

  @override
  State<VideosSection> createState() => _VideosSectionState();
}

class _VideosSectionState extends State<VideosSection> {
  // id = the part after "v=" in a YouTube link. (id, English, Amharic)
  static const _videos = [
    ('nAlD9nkJzLc', 'The Story of the Begena', 'የበገና ታሪክ'),
    ('DykDffdo8yk', 'Learn to play: intro', 'መጫወት ይማሩ፦ መግቢያ'),
    ('SLZc4q3vp38', 'Finger exercises', 'የጣት ልምምዶች'),
    ('lW645IYBLXg', 'Begena mezmur', 'የበገና መዝሙር'),
  ];
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width >= 1150) return const SizedBox.shrink();
    final brand = context.brand;
    final narrow = MediaQuery.of(context).size.width < 700;
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        final am = lang == Language.am;
        final headingStyle = am
            ? TextStyle(
                fontFamily: 'BelaBereka',
                color: brand.ink,
                fontSize: narrow ? 30 : 44,
                fontWeight: FontWeight.w800,
              )
            : GoogleFonts.poppins(
                color: brand.ink,
                fontSize: narrow ? 30 : 44,
                fontWeight: FontWeight.w800,
              );
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: narrow ? 20 : 32, vertical: 72),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                children: [
                  Text(am ? 'ይመልከቱና ይማሩ' : 'Watch & Learn',
                      textAlign: TextAlign.center, style: headingStyle),
                  const SizedBox(height: 36),
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
                  const SizedBox(height: 24),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (var i = 0; i < _videos.length; i++)
                        ChoiceChip(
                          label: Text(am ? _videos[i].$3 : _videos[i].$2),
                          selected: i == _index,
                          showCheckmark: false,
                          selectedColor: brand.amber,
                          backgroundColor: brand.surface,
                          labelStyle: TextStyle(
                            fontFamily: am ? 'BelaBereka' : null,
                            color: i == _index ? Colors.white : brand.ink,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                          onSelected: (_) => setState(() => _index = i),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
