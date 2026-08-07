import 'package:flutter/material.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../shared/widgets/nav_bar.dart';
import '../../shared/widgets/site_footer.dart';
import 'widgets/hero_section.dart';
import 'widgets/how_it_works_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: SingleChildScrollView(
        child: Column(
          children: const [
            NavBar(),
            HeroSection(),
            HowItWorksSection(),
            SiteFooter(),
          ],
        ),
      ),
    );
  }
}
