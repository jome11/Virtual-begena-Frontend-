import 'package:flutter/material.dart';
import '../../shared/widgets/nav_bar.dart';
import '../../shared/widgets/footer.dart';
import '../../shared/widgets/gradient_background.dart';
import 'widgets/hero_section.dart';
import 'widgets/feature_cards.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(),
      body: GradientBackground(
        child: SingleChildScrollView(
          child: Column(
            children: const [
              HeroSection(),
              FeatureCards(),
              Footer(),
            ],
          ),
        ),
      ),
      endDrawer: const Drawer(
        child: Column(
          children: [
            DrawerHeader(child: Center(child: Text('VIRTUAL BEGENA'))),
            ListTile(title: Text('Home')),
            ListTile(title: Text('About')),
            ListTile(title: Text('Lessons')),
            ListTile(title: Text('Contact')),
          ],
        ),
      ),
    );
  }
}
