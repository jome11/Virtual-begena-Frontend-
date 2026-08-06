import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/responsive.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.symmetric(
        vertical: 40,
        horizontal: Responsive.isDesktop(context)
            ? AppConstants.desktopHorizontalPadding
            : AppConstants.horizontalPadding,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VIRTUAL BEGENA',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Bringing the ancient sounds\nto the modern world.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.facebook, color: AppColors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.language, color: AppColors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
          const Divider(color: Colors.white24, height: 40),
          const Text(
            '© 2026 Virtual Begena. All rights reserved.',
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
