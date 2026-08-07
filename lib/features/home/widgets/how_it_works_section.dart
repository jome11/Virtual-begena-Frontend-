import 'package:flutter/material.dart';
import '../../../core/theme/app_color_scheme.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      (AppStrings.get('feature_1_title'), AppStrings.get('feature_1_desc')),
      (AppStrings.get('feature_2_title'), AppStrings.get('feature_2_desc')),
      (AppStrings.get('feature_3_title'), AppStrings.get('feature_3_desc')),
    ];

    return Container(
      width: double.infinity,
      color: context.colors.background.withValues(alpha: 0.6), // surfaceAlt equivalent
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 72),
      child: Column(
        children: [
          Text(
            AppStrings.get('feature_title'),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 48),
          LayoutBuilder(
            builder: (context, c) {
              final narrow = c.maxWidth < 800;
              final tiles = List.generate(
                steps.length,
                (i) => _StepTile(
                  index: i + 1,
                  title: steps[i].$1,
                  desc: steps[i].$2,
                  narrow: narrow,
                ),
              );
              return ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: narrow
                    ? Column(
                        children: [
                          for (final t in tiles)
                            Padding(padding: const EdgeInsets.only(bottom: 28), child: t)
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [for (final t in tiles) Expanded(child: t)],
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  final int index;
  final String title;
  final String desc;
  final bool narrow;
  const _StepTile({required this.index, required this.title, required this.desc, required this.narrow});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: narrow ? 0 : 16),
      child: Column(
        crossAxisAlignment: narrow ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: context.colors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.sage, width: 1.5),
            ),
            alignment: Alignment.center,
            child: Text(
              '$index',
              style: const TextStyle(color: AppColors.sage, fontWeight: FontWeight.w700, fontSize: 15),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: narrow ? TextAlign.center : TextAlign.left,
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            textAlign: narrow ? TextAlign.center : TextAlign.left,
            style: TextStyle(
              color: context.colors.textSecondary.withValues(alpha: 0.85),
              fontSize: 13.5,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}
