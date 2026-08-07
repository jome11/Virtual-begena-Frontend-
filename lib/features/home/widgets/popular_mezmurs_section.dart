import 'package:flutter/material.dart';
import '../../../core/theme/brand_palette.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/song_carousel.dart';

class PopularMezmursSection extends StatelessWidget {
  const PopularMezmursSection({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        return Container(
          width: double.infinity,
          color: brand.background,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 70),
          child: Column(
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    color: brand.ink.withValues(alpha: 0.85),
                    fontSize: 20,
                    height: 1.4,
                    fontFamily: 'Poppins', // Ensure consistency with app font
                  ),
                  children: [
                    const TextSpan(text: 'Take a look at some of the '),
                    TextSpan(
                      text: 'most popular Mezmurs',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: brand.ink,
                      ),
                    ),
                    const TextSpan(text: '\nour students are practicing right now.'),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const SongCarousel(),
            ],
          ),
        );
      },
    );
  }
}
