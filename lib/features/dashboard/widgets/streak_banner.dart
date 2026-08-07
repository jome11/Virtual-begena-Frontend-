import 'package:flutter/material.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class StreakBanner extends StatelessWidget {
  final String username;
  final VoidCallback onSignOut;

  const StreakBanner({super.key, required this.username, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, Color.lerp(AppColors.primary, Colors.white, 0.15)!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: context.colors.accent.withValues(alpha: 0.9),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppStrings.get('streak_welcome')} $username',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  AppStrings.get('streak_subtitle'),
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 13),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onSignOut,
            child: Icon(Icons.logout_rounded, color: Colors.white.withValues(alpha: 0.8), size: 20),
          ),
        ],
      ),
    );
  }
}
