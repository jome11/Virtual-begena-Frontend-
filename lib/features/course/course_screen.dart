import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_strings.dart';
import '../../core/data/curriculum.dart';
import '../../core/services/course_progress_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../core/theme/brand_palette.dart';
import '../../shared/widgets/blue_fade_background.dart';
import '../../shared/widgets/motion.dart';
import '../../shared/widgets/mode_app_bar.dart';
import 'chapter_widgets.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  late final Future<CourseSnapshot> _future = CourseProgress.load();

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: const ModeAppBar(
        modeLabel: 'COURSE',
        modeColor: AppColors.modeProgress,
      ),
      body: BlueFadeBackground(
        child: ValueListenableBuilder<Language>(
          valueListenable: languageNotifier,
          builder: (context, lang, _) => FutureBuilder<CourseSnapshot>(
            future: _future,
            builder: (context, snap) {
              final s = snap.data ?? const CourseSnapshot({}, {});
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
                      child: Reveal(
                        child: Column(
                          children: [
                            Text(tr('የበገና ኮርስ', 'The Begena Course'),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.playfairDisplay(
                                    color: brand.ink, fontSize: 40, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 10),
                            Text(
                                tr('ስድስት ምዕራፎች፣ ፈተናዎች፣ ተግባራትና የእጅ ልምምድ።',
                                    'Six chapters with quizzes, assignments and hands-on practice.'),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: brand.inkMuted, fontSize: 16)),
                            const SizedBox(height: 22),
                            SizedBox(
                              width: 360,
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: LinearProgressIndicator(
                                      value: s.chaptersDone / chapters.length,
                                      minHeight: 10,
                                      color: brand.amber,
                                      backgroundColor: brand.beige,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                      tr('${s.chaptersDone} ከ${chapters.length} ቀናት ተጠናቀዋል',
                                          '${s.chaptersDone} of ${chapters.length} days complete'),
                                      style: TextStyle(color: brand.inkMuted, fontSize: 12)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            FilledButton.icon(
                              onPressed: () => context.go('/daily-plan'),
                              icon: const Icon(Icons.event_available_rounded),
                              style: FilledButton.styleFrom(
                                  backgroundColor: brand.amber,
                                  padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16)),
                              label: Text(tr('የ28 ቀን እቅድ', 'Open the 28-day plan')),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 960),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              LayoutBuilder(builder: (context, c) {
                                final cols = c.maxWidth > 720 ? 2 : 1;
                                final w = (c.maxWidth - 16 * (cols - 1)) / cols;
                                return Wrap(
                                  spacing: 16,
                                  runSpacing: 16,
                                  children: [
                                    for (var i = 0; i < chapters.length; i++)
                                      SizedBox(
                                        width: w,
                                        child: Reveal(
                                          delay: Duration(milliseconds: 80 * i),
                                          child: _ChapterCard(chapter: chapters[i], snap: s),
                                        ),
                                      ),
                                  ],
                                );
                              }),
                              const SizedBox(height: 40),
                              const Reveal(child: _QenetOrder()),
                              const SizedBox(height: 64),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ChapterCard extends StatelessWidget {
  final Chapter chapter;
  final CourseSnapshot snap;
  const _ChapterCard({required this.chapter, required this.snap});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final n = chapter.number;
    final done = snap.chapterDone(n);
    final quiz = snap.quiz[n] ?? 0;
    return HoverLift(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => context.go('/course/$n'),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: panelDecoration(context).copyWith(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: done ? const Color(0xFF10B981) : brand.beige, width: done ? 2 : 1),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: brand.amber.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(done ? Icons.check_rounded : chapter.icon, color: done ? const Color(0xFF10B981) : brand.amber),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${tr('ቀን', 'Day')} $n',
                        style: TextStyle(color: brand.inkMuted, fontSize: 11, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(tr(chapter.title, chapter.titleEn),
                        style: TextStyle(color: brand.ink, fontWeight: FontWeight.w800, fontSize: 16)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.quiz_rounded, size: 14, color: brand.inkMuted),
                        const SizedBox(width: 4),
                        Text('$quiz/3', style: TextStyle(color: brand.inkMuted, fontSize: 12)),
                        const SizedBox(width: 12),
                        Icon(
                          snap.assignments.contains(n)
                              ? Icons.task_alt_rounded
                              : Icons.radio_button_unchecked_rounded,
                          size: 14,
                          color: brand.inkMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(tr('ተግባር', 'Assignment'),
                            style: TextStyle(color: brand.inkMuted, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QenetOrder extends StatelessWidget {
  const _QenetOrder();

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final order = [scales[0], scales[1], scales[3], scales[4], scales[2], scales[5], scales[6]];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: panelDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr('የሚመከር የቅኝት ቅደም ተከተል', 'Recommended qenet order'),
              style: TextStyle(color: brand.ink, fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 6,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (var i = 0; i < order.length; i++) ...[
                Chip(
                  label: Text(tr(order[i].name, order[i].nameEn)),
                  backgroundColor: order[i].qenet != null ? brand.amber : Colors.transparent,
                  side: BorderSide(color: order[i].qenet != null ? brand.amber : brand.beige),
                  labelStyle: TextStyle(
                      color: order[i].qenet != null ? Colors.white : brand.ink,
                      fontWeight: FontWeight.w700),
                ),
                if (i < order.length - 1)
                  Icon(Icons.arrow_forward_rounded, size: 16, color: brand.inkMuted),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Text(
              tr('የተሞሉት በልምምድ ሞድ ይገኛሉ፤ ሌሎቹ ለጊዜው የንድፈ ሐሳብ ብቻ ናቸው።',
                  'Filled = available in the practice modes. The others are theory-only for now.'),
              style: TextStyle(color: brand.inkMuted, fontSize: 12)),
        ],
      ),
    );
  }
}
