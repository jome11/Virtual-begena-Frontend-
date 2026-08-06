import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../shared/widgets/animated_button.dart';
import '../../../core/constants/app_strings.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Container(
      width: double.infinity,
      height: Responsive.isDesktop(context) ? size.height * 0.8 : null,
      color: AppColors.background,
      child: Responsive(
        mobile: _buildContent(context, isMobile: true),
        desktop: _buildContent(context, isMobile: false),
      ),
    );
  }

  Widget _buildContent(BuildContext context, {required bool isMobile}) {
    return Column(
      children: [
        if (isMobile) 
          Image.asset(
            'assets/images/landing_hero.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 300,
              color: AppColors.primary.withOpacity(0.1),
              child: const Center(child: Text('Image not found\nPlace landing_hero.jpg in assets/images/')),
            ),
          ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 60,
            horizontal: isMobile ? 20 : 100,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.get('hero_title'),
                      textAlign: isMobile ? TextAlign.center : TextAlign.left,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppColors.primary,
                        fontSize: isMobile ? 40 : 64,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppStrings.get('hero_subtitle'),
                      textAlign: isMobile ? TextAlign.center : TextAlign.left,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: isMobile ? 18 : 22,
                      ),
                    ),
                    const SizedBox(height: 40),
                    AnimatedButton(
                      text: AppStrings.get('start_learning'),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              if (!isMobile)
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/landing_hero.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 500,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(child: Text('Image not found\nPlace landing_hero.jpg in assets/images/')),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
