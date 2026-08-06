import 'package:flutter/material.dart';
import '../../shared/widgets/nav_bar.dart';
import '../../shared/widgets/footer.dart';
import '../../shared/widgets/gradient_background.dart';
import '../../core/constants/app_strings.dart';
import 'widgets/hero_section.dart';
import 'widgets/feature_cards.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, child) {
        return Scaffold(
          appBar: const NavBar(),
          body: GradientBackground(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  HeroSection(),
                  FeatureCards(),
                  Footer(),
                ],
              ),
            ),
          ),
          endDrawer: Drawer(
            child: Column(
              children: [
                DrawerHeader(child: Center(child: Text(AppStrings.get('app_title')))),
                ListTile(title: Text(AppStrings.get('home'))),
                ListTile(title: Text(AppStrings.get('about'))),
                ListTile(title: Text(AppStrings.get('lessons'))),
                ListTile(title: Text(AppStrings.get('contact'))),
              ],
            ),
          ),
        );
      },
    );
  }
}
