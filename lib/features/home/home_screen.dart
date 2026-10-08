import 'package:flutter/material.dart';
import '../../core/theme/brand_palette.dart';
import '../../shared/widgets/blue_fade_background.dart';
import '../../shared/widgets/motion.dart';
import '../../shared/widgets/nav_bar.dart';
import '../../shared/widgets/site_footer.dart';
import 'widgets/explore_instrument_section.dart';
import 'widgets/hero_section.dart';
import 'widgets/how_it_works_section.dart';
import 'widgets/popular_mezmurs_section.dart';
import 'widgets/stats_strip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scroll = ScrollController();
  final _progress = ValueNotifier<double>(0);
  final _showTop = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      final max = _scroll.position.maxScrollExtent;
      _progress.value = max <= 0 ? 0 : (_scroll.offset / max).clamp(0.0, 1.0);
      _showTop.value = _scroll.offset > 600;
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    _progress.dispose();
    _showTop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Scaffold(
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _showTop,
        builder: (context, show, child) => AnimatedScale(
          scale: show ? 1 : 0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutBack,
          child: child,
        ),
        child: FloatingActionButton.small(
          backgroundColor: brand.amber,
          foregroundColor: Colors.white,
          onPressed: () => _scroll.animateTo(
            0,
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutCubic,
          ),
          child: const Icon(Icons.arrow_upward_rounded),
        ),
      ),
      body: Stack(
        children: [
          BlueFadeBackground(
            child: SingleChildScrollView(
              controller: _scroll,
              child: const Column(
                children: [
                  NavBar(),
                  Reveal(child: HeroSection()),
                  Reveal(child: StatsStrip()),
                  Reveal(child: ExploreInstrumentSection()),
                  HowItWorksSection(),
                  Reveal(child: PopularMezmursSection()),
                  SiteFooter(),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ValueListenableBuilder<double>(
              valueListenable: _progress,
              builder: (context, v, _) => LinearProgressIndicator(
                value: v,
                minHeight: 3,
                backgroundColor: Colors.transparent,
                color: brand.amber,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
