import 'package:flutter/material.dart';
import '../../core/services/section_nav.dart';
import '../../core/theme/brand_palette.dart';
import '../../shared/widgets/blue_fade_background.dart';
import '../../shared/widgets/motion.dart';
import '../../shared/widgets/nav_bar.dart';
import '../../shared/widgets/site_footer.dart';
import '../about/about_screen.dart';
import '../contact/contact_screen.dart';
import '../how_to/how_to_screen.dart';
import 'widgets/explore_instrument_section.dart';
import 'widgets/hero_section.dart';
import 'widgets/how_it_works_section.dart';
import 'widgets/orthodox_sections.dart';
import 'widgets/popular_mezmurs_section.dart';
import 'widgets/stats_strip.dart';

class HomeScreen extends StatefulWidget {
  /// Optional section name from the URL (?section=about) to scroll to.
  final String? section;
  const HomeScreen({super.key, this.section});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scroll = ScrollController();
  final _progress = ValueNotifier<double>(0);
  final _showTop = ValueNotifier<bool>(false);
  final _areaKey = GlobalKey();
  final Map<SiteSection, GlobalKey> _keys = {
    for (final s in SiteSection.values) s: GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    SectionNav.attach(_keys, _scroll);
    _scroll.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _updateActive();
    });
    _scrollToRequested();
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.section != oldWidget.section) _scrollToRequested();
  }

  void _scrollToRequested() {
    final name = widget.section;
    if (name == null) return;
    for (final s in SiteSection.values) {
      if (s.name == name) {
        Future.delayed(const Duration(milliseconds: 350), () {
          if (mounted) SectionNav.scrollTo(s);
        });
        return;
      }
    }
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    final max = _scroll.position.maxScrollExtent;
    _progress.value = max <= 0 ? 0 : (_scroll.offset / max).clamp(0.0, 1.0);
    _showTop.value = _scroll.offset > 600;
    _updateActive();
  }

  /// Finds which section is under the nav bar so the nav can highlight it.
  void _updateActive() {
    if (!_scroll.hasClients) return;
    final areaBox = _areaKey.currentContext?.findRenderObject() as RenderBox?;
    if (areaBox == null || !areaBox.attached) return;
    final top = areaBox.localToGlobal(Offset.zero).dy;
    var current = SiteSection.home;
    for (final s in SiteSection.values) {
      final box = _keys[s]?.currentContext?.findRenderObject() as RenderBox?;
      if (box == null || !box.attached) continue;
      if (box.localToGlobal(Offset.zero).dy <= top + 140) current = s;
    }
    final pos = _scroll.position;
    if (pos.maxScrollExtent > 0 && pos.pixels >= pos.maxScrollExtent - 8) {
      current = SiteSection.contact;
    }
    if (SectionNav.active.value != current) SectionNav.active.value = current;
  }

  @override
  void dispose() {
    SectionNav.detach(_scroll);
    _scroll.removeListener(_onScroll);
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
      body: BlueFadeBackground(
        child: Column(
          children: [
            // Sticky: lives outside the scroll view.
            const NavBar(),
            Expanded(
              child: Stack(
                key: _areaKey,
                children: [
                  SingleChildScrollView(
                    controller: _scroll,
                    child: Column(
                      children: [
                        KeyedSubtree(
                          key: _keys[SiteSection.home],
                          child: const Column(
                            children: [
                              Reveal(child: HeroSection()),
                              Reveal(child: StatsStrip()),
                              ScriptureSection(),
                              Reveal(child: ExploreInstrumentSection()),
                              SymbolismSection(),
                              HowItWorksSection(),
                              TraditionSection(),
                              Reveal(child: PopularMezmursSection()),
                            ],
                          ),
                        ),
                        KeyedSubtree(
                          key: _keys[SiteSection.howTo],
                          child: const HowToSection(),
                        ),
                        KeyedSubtree(
                          key: _keys[SiteSection.about],
                          child: const AboutSection(),
                        ),
                        KeyedSubtree(
                          key: _keys[SiteSection.contact],
                          child: const ContactSection(),
                        ),
                        const SiteFooter(),
                      ],
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
            ),
          ],
        ),
      ),
    );
  }
}
