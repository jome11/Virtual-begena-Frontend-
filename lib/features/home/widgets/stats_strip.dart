import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/brand_palette.dart';

class StatsStrip extends StatelessWidget {
  const StatsStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        // Adjust these numbers to match what the app really has
        const stats = [(10, 'stat_strings'), (3, 'stat_qenet'), (6, 'stat_modes')];
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1000),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
              decoration: BoxDecoration(
                color: brand.surface.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: brand.beige),
                boxShadow: [
                  BoxShadow(
                    color: brand.amber.withValues(alpha: 0.12),
                    blurRadius: 40,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: Wrap(
                alignment: WrapAlignment.spaceAround,
                runSpacing: 24,
                spacing: 48,
                children: [
                  for (final s in stats) _Stat(value: s.$1, labelKey: s.$2),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Stat extends StatelessWidget {
  final int value;
  final String labelKey;
  const _Stat({required this.value, required this.labelKey});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: value.toDouble()),
          duration: const Duration(milliseconds: 1600),
          curve: Curves.easeOutCubic,
          builder: (context, v, _) => Text(
            v.round().toString(),
            style: TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.w800,
              color: brand.amber,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppStrings.get(labelKey),
          style: TextStyle(
            color: brand.inkMuted,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: languageNotifier.value == Language.am ? 'BelaBereka' : null,
          ),
        ),
      ],
    );
  }
}
