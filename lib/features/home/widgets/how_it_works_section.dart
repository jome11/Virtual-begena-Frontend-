import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/brand_palette.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/motion.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        final steps = [
          (AppStrings.get('feature_1_title'), AppStrings.get('feature_1_desc'), brand.beige),
          (AppStrings.get('feature_2_title'), AppStrings.get('feature_2_desc'), brand.rose.withValues(alpha: 0.5)),
          (AppStrings.get('feature_3_title'), AppStrings.get('feature_3_desc'), brand.amber.withValues(alpha: 0.16)),
        ];

        return Container(
          width: double.infinity,
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
          child: Column(
            children: [
              Text(
                AppStrings.get('feature_title'),
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  color: brand.ink,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 52),
              LayoutBuilder(
                builder: (context, c) {
                  final narrow = c.maxWidth < 800;
                  final tiles = <Widget>[
                    for (var i = 0; i < steps.length; i++)
                      Reveal(
                        delay: Duration(milliseconds: 150 * i),
                        child: _StepCard(
                          title: steps[i].$1,
                          desc: steps[i].$2,
                          bg: steps[i].$3,
                        ),
                      ),
                  ];
                  return ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1040),
                    child: narrow
                        ? Column(
                            children: [
                              for (final t in tiles)
                                Padding(padding: const EdgeInsets.only(bottom: 16), child: t)
                            ],
                          )
                        : Row(
                            children: [
                              for (final t in tiles)
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: t,
                                  ),
                                )
                            ],
                          ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StepCard extends StatelessWidget {
  final String title;
  final String desc;
  final Color bg;
  const _StepCard({required this.title, required this.desc, required this.bg});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: brand.ink,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            desc,
            style: TextStyle(
              color: brand.ink.withValues(alpha: 0.6),
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
