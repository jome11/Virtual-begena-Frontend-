import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/responsive.dart';

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
            'Why Choose Virtual Begena?',
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
      const _FeatureCard(
        icon: Icons.school,
        title: 'Structured Lessons',
        description: 'Step-by-step guidance from beginners to advanced techniques.',
      ),
      const _FeatureCard(
        icon: Icons.music_note,
        title: 'Interactive Practice',
        description: 'Real-time feedback and virtual strings to master the melody.',
      ),
      const _FeatureCard(
        icon: Icons.history_edu,
        title: 'Cultural Heritage',
        description: 'Learn the history and spiritual significance of the Begena.',
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
