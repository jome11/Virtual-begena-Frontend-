import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/data/curriculum.dart';
import '../../core/services/course_progress_service.dart';

class TodayPlanCard extends StatefulWidget {
  const TodayPlanCard({super.key});

  @override
  State<TodayPlanCard> createState() => _TodayPlanCardState();
}

class _TodayPlanCardState extends State<TodayPlanCard> {
  DateTime? _start;
  Set<String> _done = {};
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    () async {
      final s = await CourseProgress.planStart();
      final d = await CourseProgress.planDone();
      if (mounted) setState(() { _start = s; _done = d; _ready = true; });
    }();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) return const SizedBox.shrink();
    String title, subtitle;
    double? progress;
    if (_start == null) {
      title = tr('የ28 ቀን እቅድ', '28-day plan');
      subtitle = tr('ከታሪክ እስከ ሦስቱ ቅኝቶች — ዛሬ ይጀምሩ።', 'From the story to your first three qenet. Start today.');
    } else {
      final day = CourseProgress.dayNumber(_start!);
      final tasks = dailyPlan[day - 1];
      final doneCount = [for (var i = 0; i < tasks.length; i++) if (_done.contains('d$day-t$i')) i].length;
      title = '${tr('ቀን', 'Day')} $day / 28';
      final next = [for (var i = 0; i < tasks.length; i++) if (!_done.contains('d$day-t$i')) tasks[i]];
      subtitle = next.isEmpty
          ? tr('የዛሬ ተግባራት ተጠናቀዋል። ጥሩ ሥራ!', "Today's tasks are done. Great work!")
          : next.first.label;
      progress = tasks.isEmpty ? 1 : doneCount / tasks.length;
    }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0B1F4B), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(subtitle,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13)),
                if (progress != null) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      color: Colors.white,
                      backgroundColor: Colors.white24,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 16),
          FilledButton(
            onPressed: () => context.go('/daily-plan'),
            style: FilledButton.styleFrom(
                backgroundColor: Colors.white, foregroundColor: const Color(0xFF0B1F4B)),
            child: Text(_start == null ? tr('ጀምር', 'Start') : tr('ክፈት', 'Open')),
          ),
        ],
      ),
    );
  }
}
