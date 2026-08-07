import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/brand_palette.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/stylized_cross.dart';
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
          color: brand.background,
          child: Column(
            children: [
              InterlaceBorder(color: brand.amber.withValues(alpha: 0.35)),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 48, 32, 88),
                child: LayoutBuilder(
                  builder: (context, c) {
                    final narrow = c.maxWidth < 900;
                    final text = _EditorialText(narrow: narrow);
                    final art = _FloatingArt(narrow: narrow);
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
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: brand.ink,
                side: BorderSide(color: brand.ink.withValues(alpha: 0.3)),
                padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              child: Text(
                AppStrings.get('hero_how_it_works'),
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FloatingArt extends StatelessWidget {
  final bool narrow;
  const _FloatingArt({required this.narrow});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final size = narrow ? 260.0 : 380.0;
    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            left: size * 0.05,
            child: _Blob(diameter: size * 0.55, color: brand.beige),
          ),
          Positioned(
            bottom: 0,
            right: size * 0.02,
            child: _Blob(diameter: size * 0.45, color: brand.rose.withValues(alpha: 0.55)),
          ),
          Positioned(
            top: size * 0.12,
            right: 0,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(color: brand.ink, shape: BoxShape.circle),
            ),
          ),
          Container(
            width: size * 0.42,
            height: size * 0.42,
            decoration: BoxDecoration(
              color: brand.surface,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: brand.ink.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                )
              ],
              border: Border.all(color: brand.amber.withValues(alpha: 0.25), width: 1.5),
            ),
            alignment: Alignment.center,
            child: StylizedCross(size: size * 0.18, color: brand.amber),
          ),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final double diameter;
  final Color color;
  const _Blob({required this.diameter, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    width: diameter,
    height: diameter,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}
