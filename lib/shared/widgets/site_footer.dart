import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: Column(
        children: [
          const Divider(color: AppColors.borderSubtle),
          const SizedBox(height: 24),
          Text(AppStrings.get('app_title'), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 8),
          Text(
            AppStrings.get('footer_subtitle'),
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.75), fontSize: 12.5, height: 1.5),
          ),
          const SizedBox(height: 20),
          Text(AppStrings.get('footer_copyright'), style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.5), fontSize: 11.5)),
        ],
      ),
    );
  }
}
