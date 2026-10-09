import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/mezmur_data.dart';
import '../../../core/data/curriculum.dart' show chapters;
import '../../../core/theme/brand_palette.dart';
import '../../../shared/widgets/motion.dart';

class _StatData {
  final IconData icon;
  final int value;
  final String label;
  const _StatData(this.icon, this.value, this.label);
}

class StatsStrip extends StatelessWidget {
  const StatsStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final narrow = MediaQuery.of(context).size.width < 700;
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        final am = lang == Language.am;
        // Lessons and songs are counted from your real data, so they stay accurate.
        final songCount = mezmurLibrary.values.fold<int>(0, (n, l) => n + l.length);
        final stats = <_StatData>[
          _StatData(Icons.graphic_eq_rounded, 10, AppStrings.get('stat_strings')),
          _StatData(Icons.library_music_rounded, 3, AppStrings.get('stat_qenet')),
          _StatData(Icons.tune_rounded, 6, AppStrings.get('stat_modes')),
          _StatData(Icons.menu_book_rounded, chapters.length, am ? 'ምዕራፎች' : 'Lessons'),
          _StatData(Icons.queue_music_rounded, songCount, am ? 'መዝሙሮች' : 'Mezmur songs'),
        ];

        final headingStyle = am
            ? TextStyle(
                fontFamily: 'BelaBereka',
                color: brand.ink,
                fontSize: narrow ? 26 : 36,
                fontWeight: FontWeight.w800,
                height: 1.2,
              )
            : GoogleFonts.poppins(
                color: brand.ink,
                fontSize: narrow ? 26 : 36,
                fontWeight: FontWeight.w800,
                height: 1.2,
              );

        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: narrow ? 20 : 32, vertical: 72),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1300),
              child: Column(
                children: [
                  Text(
                    am
                        ? 'በገናን ለመማር የሚያስፈልግዎ ሁሉ'
                        : 'Everything You Need to Learn the Begena',
                    textAlign: TextAlign.center,
                    style: headingStyle,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    am
                        ? 'ከመጀመሪያው ክር እስከ ሙሉ መዝሙር፣ ሁሉም በአንድ ቦታ።'
                        : 'From the first string to a full mezmur, all in one place.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: am ? 'BelaBereka' : null,
                      color: brand.ink.withValues(alpha: 0.75),
                      fontSize: narrow ? 14 : 16.5,
                    ),
                  ),
                  const SizedBox(height: 48),
                  LayoutBuilder(
                    builder: (context, c) {
                      const gap = 24.0;
                      final w = c.maxWidth;
                      final cols = w >= 1000 ? 5 : (w >= 680 ? 3 : 2);
                      final cardW = ((w - gap * (cols - 1)) / cols).floorToDouble();
                      return Wrap(
                        alignment: WrapAlignment.center,
                        spacing: gap,
                        runSpacing: gap,
                        children: [
                          for (final s in stats)
                            SizedBox(
                              width: cardW,
                              child: HoverLift(child: _StatCard(data: s)),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final _StatData data;
  const _StatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final am = languageNotifier.value == Language.am;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 28),
      decoration: BoxDecoration(
        color: brand.surface.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: brand.beige.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: brand.amber.withValues(alpha: 0.12),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(data.icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 18),
          _CountUp(value: data.value),
          const SizedBox(height: 4),
          Text(
            data.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: am ? 'BelaBereka' : null,
              color: brand.inkMuted,
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Counts up from 0 the first time it scrolls into view.
class _CountUp extends StatefulWidget {
  final int value;
  const _CountUp({required this.value});

  @override
  State<_CountUp> createState() => _CountUpState();
}

class _CountUpState extends State<_CountUp> {
  final _detectorKey = UniqueKey();
  bool _started = false;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return VisibilityDetector(
      key: _detectorKey,
      onVisibilityChanged: (info) {
        if (!_started && info.visibleFraction > 0.3 && mounted) {
          setState(() => _started = true);
        }
      },
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: _started ? widget.value.toDouble() : 0),
        duration: const Duration(milliseconds: 1600),
        curve: Curves.easeOutCubic,
        builder: (context, v, _) => Text(
          v.round().toString(),
          style: GoogleFonts.poppins(
            fontSize: 38,
            fontWeight: FontWeight.w800,
            color: brand.ink,
          ),
        ),
      ),
    );
  }
}
