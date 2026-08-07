import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      child: LayoutBuilder(
        builder: (context, c) {
          final narrow = c.maxWidth < 900;
          final text = _HeroText(narrow: narrow);
          final art = _HeroArt(narrow: narrow);
          if (narrow) {
            return Column(children: [text, const SizedBox(height: 36), art]);
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Expanded(flex: 5, child: text), const SizedBox(width: 48), Expanded(flex: 4, child: art)],
          );
        },
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  final bool narrow;
  const _HeroText({required this.narrow});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: narrow ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.get('hero_title'),
          textAlign: narrow ? TextAlign.center : TextAlign.left,
          style: const TextStyle(color: AppColors.primary, fontSize: 40, fontWeight: FontWeight.w800, height: 1.15),
        ),
        const SizedBox(height: 18),
        Text(
          AppStrings.get('hero_subtitle'),
          textAlign: narrow ? TextAlign.center : TextAlign.left,
          style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.9), fontSize: 16, height: 1.6),
        ),
        const SizedBox(height: 30),
        Wrap(
          alignment: narrow ? WrapAlignment.center : WrapAlignment.start,
          spacing: 14,
          runSpacing: 12,
          children: [
            ElevatedButton(
              onPressed: () => context.go('/login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: Text(AppStrings.get('start_learning'), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.play_circle_outline, color: AppColors.primary, size: 18),
              label: Text('See how it works', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 14)),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroArt extends StatelessWidget {
  final bool narrow;
  const _HeroArt({required this.narrow});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: narrow ? 260 : 340,
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      alignment: Alignment.center,
      child: Icon(Icons.music_note_rounded, size: 96, color: AppColors.sage.withValues(alpha: 0.5)),
    );
  }
}
