import 'package:flutter/material.dart';
import '../../core/theme/brand_palette.dart';
import '../../core/constants/app_strings.dart';
import 'interlace_border.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        return Container(
          width: double.infinity,
          color: brand.background,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 44),
          child: Column(
            children: [
              InterlaceBorder(color: brand.amber.withValues(alpha: 0.3)),
              const SizedBox(height: 8),
              Divider(color: brand.beige),
              const SizedBox(height: 24),
              Text(
                AppStrings.get('app_title'),
                style: TextStyle(
                  color: brand.ink,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.get('footer_subtitle'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: brand.ink.withValues(alpha: 0.55),
                  fontSize: 12.5,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                AppStrings.get('footer_copyright'),
                style: TextStyle(
                  color: brand.ink.withValues(alpha: 0.4),
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
