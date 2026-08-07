import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/nav_bar.dart';
import '../../shared/widgets/site_footer.dart';
import 'widgets/hero_section.dart';
import 'widgets/how_it_works_section.dart';
import 'widgets/popular_mezmurs_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.brandCream,
      body: SingleChildScrollView(
        child: Column(
          children: [
            NavBar(),
            HeroSection(),
            HowItWorksSection(),
            PopularMezmursSection(),
            SiteFooter(),
          ],
        ),
      ),
    );
  }
}
