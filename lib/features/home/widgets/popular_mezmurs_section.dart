import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/song_carousel.dart';

class PopularMezmursSection extends StatelessWidget {
  const PopularMezmursSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.brandCream,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 70),
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(color: AppColors.brandInk.withValues(alpha: 0.85), fontSize: 20, height: 1.4),
              children: const [
                TextSpan(text: 'Take a look at some of the '),
                TextSpan(text: 'most popular Mezmurs', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.brandInk)),
                TextSpan(text: '\nour students are practicing right now.'),
              ],
            ),
          ),
          const SizedBox(height: 40),
          const SongCarousel(),
        ],
      ),
    );
  }
}
