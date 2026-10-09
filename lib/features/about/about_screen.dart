import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/brand_palette.dart';
import '../../shared/widgets/motion.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  static const _blocks = [
    ('about_what_heading', 'about_what_body'),
    ('about_why_heading', 'about_why_body'),
    ('about_how_heading', 'about_how_body'),
    ('about_note_heading', 'about_note_body'),
  ];

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 72),
          child: Column(
            children: [
              Reveal(
                child: Text(
                  AppStrings.get('about'),
                  style: GoogleFonts.playfairDisplay(
                    color: brand.ink,
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Reveal(
                          child: Text(
                            AppStrings.get('about_lead'),
                            style: TextStyle(
                              color: brand.inkMuted,
                              fontSize: 18,
                              height: 1.6,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        for (final b in _blocks)
                          Reveal(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 28, bottom: 10),
                                  child: Text(
                                    AppStrings.get(b.$1),
                                    style: TextStyle(
                                      color: brand.ink,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  AppStrings.get(b.$2),
                                  style: TextStyle(
                                    color: brand.inkMuted,
                                    fontSize: 15,
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
