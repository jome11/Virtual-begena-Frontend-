import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/constants/app_strings.dart';

class FeatureCards extends StatelessWidget {
  const FeatureCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 80,
        horizontal: Responsive.isDesktop(context)
            ? AppConstants.desktopHorizontalPadding
            : AppConstants.horizontalPadding,
      ),
      child: Column(
        children: [
          Text(
            AppStrings.get('feature_title'),
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          Responsive(
            mobile: Column(
              children: _buildCards(),
            ),
            desktop: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _buildCards().map((e) => Expanded(child: e)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCards() {
    return [
      _FeatureCard(
        icon: Icons.school,
        title: AppStrings.get('feature_1_title'),
        description: AppStrings.get('feature_1_desc'),
      ),
      _FeatureCard(
        icon: Icons.music_note,
        title: AppStrings.get('feature_2_title'),
        description: AppStrings.get('feature_2_desc'),
      ),
      _FeatureCard(
        icon: Icons.history_edu,
        title: AppStrings.get('feature_3_title'),
        description: AppStrings.get('feature_3_desc'),
      ),
    ];
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: AppColors.secondary),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
