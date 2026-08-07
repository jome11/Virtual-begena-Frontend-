import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        final steps = [
          (AppStrings.get('feature_1_title'), AppStrings.get('feature_1_desc'), AppColors.brandBeige),
          (AppStrings.get('feature_2_title'), AppStrings.get('feature_2_desc'), AppColors.brandRose.withValues(alpha: 0.5)),
          (AppStrings.get('feature_3_title'), AppStrings.get('feature_3_desc'), AppColors.brandAmber.withValues(alpha: 0.16)),
        ];

        return Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
          child: Column(
            children: [
              Text(
                AppStrings.get('feature_title'),
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  color: AppColors.brandInk,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 52),
              LayoutBuilder(
                builder: (context, c) {
                  final narrow = c.maxWidth < 800;
                  final tiles = steps
                      .map((s) => _StepCard(
                            title: s.$1,
                            desc: s.$2,
                            bg: s.$3,
                          ))
                      .toList();
                  return ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 960),
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
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.brandInk,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            desc,
            style: TextStyle(
              color: AppColors.brandInk.withValues(alpha: 0.6),
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
