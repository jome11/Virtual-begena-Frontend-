import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/brand_palette.dart';
import '../../shared/widgets/motion.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 72),
          child: SizedBox(
            width: double.infinity,
            height: 240,
            child: Reveal(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.get('contact'),
                    style: GoogleFonts.playfairDisplay(
                      color: brand.ink,
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  // TODO: add your email / phone / contact form here.
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
