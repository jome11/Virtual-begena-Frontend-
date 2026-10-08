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
import '../../shared/widgets/mode_app_bar.dart';
import '../course/chapter_widgets.dart';

class DailyPlanScreen extends StatefulWidget {
  const DailyPlanScreen({super.key});

  @override
  State<DailyPlanScreen> createState() => _DailyPlanScreenState();
}

class _DailyPlanScreenState extends State<DailyPlanScreen> {
  DateTime? _start;
  Set<String> _done = {};
  int _selected = 1;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = await CourseProgress.planStart();
    final d = await CourseProgress.planDone();
    if (!mounted) return;
    setState(() {
      _start = s;
      _done = d;
      _selected = s == null ? 1 : CourseProgress.dayNumber(s);
      _loading = false;
    });
  }

  int get _today => _start == null ? 0 : CourseProgress.dayNumber(_start!);
  String _id(int day, int i) => 'd$day-t$i';

  int _doneCount(int day) => [
        for (var i = 0; i < dailyPlan[day - 1].length; i++)
          if (_done.contains(_id(day, i))) i
      ].length;

  bool _complete(int day) => _doneCount(day) == dailyPlan[day - 1].length;

  Future<void> _toggle(int day, int i, bool v) async {
    await CourseProgress.setTask(_id(day, i), v);
    final d = await CourseProgress.planDone();
    if (mounted) setState(() => _done = d);
  }

  Future<void> _restart() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(tr('እቅዱን እንደገና ይጀምሩ?', 'Restart the plan?')),
        content: Text(tr('እስካሁን የተሞሉ ተግባራት ይጠፋሉ።', 'Your ticked tasks will be cleared.')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(tr('ተወው', 'Cancel'))),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(tr('እንደገና ጀምር', 'Restart'))),
        ],
      ),
    );
    if (ok == true) {
      await CourseProgress.resetPlan();
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: const ModeAppBar(
        modeLabel: 'DAILY PLAN',
        modeColor: AppColors.modeTrainingPlan,
      ),
      body: BlueFadeBackground(
        child: ValueListenableBuilder<Language>(
          valueListenable: languageNotifier,
          builder: (context, lang, _) {
            final weeks = [
              tr('መሠረት — ታሪክና መሣሪያው', 'Foundations: the story and the instrument'),
              tr('እጆችና ሰላምታ', 'Hands and Selamta'),
              tr('ትዝታና አንቺ ሆዬ', 'Tezeta and Anchihoye'),
              tr('መዝሙሮችና ማጠናከር', 'Songs and consolidation'),
            ];
            return SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 760),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 40, 24, 64),
                        child: _loading
                            ? const Center(child: CircularProgressIndicator())
                            : _start == null
                                ? _intro(brand, weeks)
                                : _plan(brand, weeks),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _intro(BrandPalette brand, List<String> weeks) {
    return Column(
      children: [
        Text(tr('የ28 ቀን የበገና እቅድ', 'Your 28-day begena plan'),
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
                color: brand.ink, fontSize: 36, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Text(tr('በቀን ከ20-30 ደቂቃ — ከታሪክ እስከ ሦስቱ ቅኝቶች።', 'About 20-30 minutes a day, from the story to the first three qenet.'),
            textAlign: TextAlign.center, style: TextStyle(color: brand.inkMuted)),
        const SizedBox(height: 24),
        for (var i = 0; i < weeks.length; i++)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: panelDecoration(context),
            child: Row(children: [
              CircleAvatar(
                  radius: 16,
                  backgroundColor: brand.amber,
                  child: Text('${i + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800))),
              const SizedBox(width: 14),
              Expanded(child: Text('${tr('ሳምንት', 'Week')} ${i + 1}: ${weeks[i]}',
                  style: TextStyle(color: brand.ink, fontWeight: FontWeight.w700))),
            ]),
          ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () async {
            await CourseProgress.startPlan();
            _load();
          },
          icon: const Icon(Icons.play_arrow_rounded),
          style: FilledButton.styleFrom(
              backgroundColor: brand.amber,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18)),
          label: Text(tr('እቅዱን ይጀምሩ', 'Start the plan')),
        ),
      ],
    );
  }

  Widget _plan(BrandPalette brand, List<String> weeks) {
    final tasks = dailyPlan[_selected - 1];
    final future = _selected > _today;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${tr('ቀን', 'Day')} $_selected / 28',
            style: GoogleFonts.playfairDisplay(color: brand.ink, fontSize: 34, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text('${tr('ሳምንት', 'Week')} ${(_selected - 1) ~/ 7 + 1}: ${weeks[(_selected - 1) ~/ 7]}',
            style: TextStyle(color: brand.inkMuted)),
        const SizedBox(height: 18),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var d = 1; d <= 28; d++)
              GestureDetector(
                onTap: () => setState(() => _selected = d),
                child: Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _complete(d)
                        ? const Color(0xFF10B981)
                        : d == _selected
                            ? brand.amber
                            : Colors.transparent,
                    border: Border.all(
                        color: d == _today ? brand.amber : brand.beige, width: d == _today ? 2.5 : 1.5),
                  ),
                  child: _complete(d)
                      ? const Icon(Icons.check_rounded, size: 18, color: Colors.white)
                      : Text('$d',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: d == _selected ? Colors.white : brand.inkMuted)),
                ),
              ),
          ],
        ),
        const SizedBox(height: 24),
        if (future)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(tr('ይህ ቀን ገና አልደረሰም — ቅድመ እይታ ብቻ ነው።', 'This day has not started yet. Preview only.'),
                style: TextStyle(color: brand.inkMuted, fontStyle: FontStyle.italic)),
          ),
        for (var i = 0; i < tasks.length; i++)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: panelDecoration(context),
            child: Row(
              children: [
                Checkbox(
                  value: _done.contains(_id(_selected, i)),
                  activeColor: brand.amber,
                  onChanged: future ? null : (v) => _toggle(_selected, i, v ?? false),
                ),
                Expanded(
                  child: Text(tasks[i].label,
                      style: TextStyle(
                          color: brand.ink,
                          fontWeight: FontWeight.w600,
                          decoration: _done.contains(_id(_selected, i))
                              ? TextDecoration.lineThrough
                              : null)),
                ),
                OutlinedButton(
                  onPressed: () => context.go(tasks[i].route),
                  child: Text(tr('ሂድ', 'Go')),
                ),
              ],
            ),
          ),
        const SizedBox(height: 20),
        TextButton(onPressed: _restart, child: Text(tr('እቅዱን እንደገና ጀምር', 'Restart the plan'))),
      ],
    );
  }
}
