import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/brand_palette.dart';
import '../../../shared/widgets/begena_3d_model.dart';

class ExploreInstrumentSection extends StatelessWidget {
  const ExploreInstrumentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        final am = lang == Language.am;
        return Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 960),
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  brand.surface.withValues(alpha: 0.9),
                  brand.beige.withValues(alpha: 0.5),
                ],
              ),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: brand.beige),
            ),
            child: Column(
              children: [
                Text(
                  am ? 'መሣሪያውን ይመልከቱ' : 'Meet the instrument',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    color: brand.ink,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  am
                      ? 'በመጎተት ያሽከርክሩት።'
                      : 'Drag to rotate the begena, a ten-stringed lyre.',
                  style: TextStyle(color: brand.inkMuted, fontSize: 14),
                ),
                const SizedBox(height: 12),
                const Begena3DModel(height: 420),
              ],
            ),
          ),
        );
      },
    );
  }
}
