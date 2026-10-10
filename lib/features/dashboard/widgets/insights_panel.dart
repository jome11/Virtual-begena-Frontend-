import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart' show Language, languageNotifier;
import '../../../core/constants/qenet.dart';
import '../../../core/data/curriculum.dart' show tr, examPassAccuracy, chapters, examsFor;
import '../../../core/services/auth_service.dart';
import '../../../core/services/certificate_service.dart';
import '../../../core/services/course_progress_service.dart';
import '../../../core/services/progress_service.dart';
import '../../../core/theme/app_color_scheme.dart';

class InsightsPanel extends StatefulWidget {
  const InsightsPanel({super.key});

  @override
  State<InsightsPanel> createState() => _InsightsPanelState();
}

class _InsightsPanelState extends State<InsightsPanel> {
  late final Future<List<Map<String, dynamic>>> _future =
      ProgressService.getHistory();
  late final Future<CourseSnapshot> _course = CourseProgress.load();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _future,
      builder: (context, snap) {
        final stats = _Stats.from(snap.data ?? const []);
        return FutureBuilder<CourseSnapshot>(
          future: _course,
          builder: (context, courseSnap) {
            final progress = _CourseCard(stats: stats, course: courseSnap.data);
            final path = _PathCard(stats: stats);
            return LayoutBuilder(
              builder: (context, c) {
                if (c.maxWidth > 900) {
                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(width: 320, child: progress),
                        const SizedBox(width: 18),
                        Expanded(child: path),
                      ],
                    ),
                  );
                }
                return Column(
                    children: [progress, const SizedBox(height: 18), path]);
              },
            );
          },
        );
      },
    );
  }
}

class _Stats {
  final int sessions;
  final int totalCorrect;
  final double avgAccuracy;
  final Map<Qenet, double> qenetAvg;
  final Map<Qenet, int> qenetCount;

  const _Stats({
    required this.sessions,
    required this.totalCorrect,
    required this.avgAccuracy,
    required this.qenetAvg,
    required this.qenetCount,
  });

  factory _Stats.from(List<Map<String, dynamic>> history) {
    int correct = 0;
    double accSum = 0;
    final sums = {for (final q in Qenet.values) q: 0.0};
    final counts = {for (final q in Qenet.values) q: 0};
    for (final s in history) {
      correct += (s['correct'] as num?)?.toInt() ?? 0;
      final a = (s['accuracy'] as num?)?.toDouble() ?? 0.0;
      accSum += a;
      final name = (s['qenet'] as String? ?? '').toLowerCase();
      for (final q in Qenet.values) {
        if (q.name == name) {
          sums[q] = sums[q]! + a;
          counts[q] = counts[q]! + 1;
        }
      }
    }
    return _Stats(
      sessions: history.length,
      totalCorrect: correct,
      avgAccuracy: history.isEmpty ? 0.0 : accSum / history.length,
      qenetAvg: {
        for (final q in Qenet.values)
          q: counts[q]! == 0 ? 0.0 : sums[q]! / counts[q]!,
      },
      qenetCount: counts,
    );
  }
}

class _CourseCard extends StatelessWidget {
  final _Stats stats;
  final CourseSnapshot? course;
  const _CourseCard({required this.stats, required this.course});

  static int get _totalChapters => chapters.length;
  static int get _totalExams => examsFor.values.fold(0, (a, b) => a + b.length);

  @override
  Widget build(BuildContext context) {
    final done = course?.chaptersDone ?? 0;
    final examsPassed = course == null
        ? 0
        : course!.exams.values.where((v) => v >= examPassAccuracy).length;
    final value = done / _totalChapters;
    final percent = (value * 100).round();

    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0B1F4B), Color(0xFF2563EB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2563EB).withValues(alpha: 0.3),
              blurRadius: 30,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: value),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutCubic,
              builder: (context, v, _) => SizedBox(
                width: 160,
                height: 160,
                child: CustomPaint(
                  painter: _RingPainter(v),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          tr('ምዕራፎች', 'CHAPTERS'),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 12,
                            letterSpacing: 2,
                          ),
                        ),
                        Text(
                          '$done/$_totalChapters',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              tr('ከኮርሱ $percent% ተጠናቋል', '$percent% of the course complete'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              tr('የተግባር ፈተናዎች፦ $examsPassed/$_totalExams',
                  'Practical tests: $examsPassed/$_totalExams'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              tr(
                '${stats.sessions} ልምምዶች · አማካይ ትክክለኛነት ${stats.avgAccuracy.round()}%',
                '${stats.sessions} sessions · ${stats.avgAccuracy.round()}% avg accuracy',
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.75),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double value;
  _RingPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 8;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..color = Colors.white.withValues(alpha: 0.18);
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..shader = const SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: [Color(0xFF93C5FD), Colors.white],
      ).createShader(rect);
    canvas.drawCircle(center, radius, track);
    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * value, false, arc);
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.value != value;
}

class _PathCard extends StatelessWidget {
  final _Stats stats;
  const _PathCard({required this.stats});

  bool _done(Qenet q) =>
      stats.qenetCount[q]! >= 3 && stats.qenetAvg[q]! >= 70;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final order = Qenet.values;
    final badges = [
      (Icons.flag_rounded, 'First session', stats.sessions >= 1),
      (Icons.local_fire_department_rounded, '10 sessions', stats.sessions >= 10),
      (Icons.emoji_events_rounded, '90% accuracy',
          stats.sessions > 0 && stats.avgAccuracy >= 90),
      (Icons.library_music_rounded, 'All 3 qenet',
          order.every((q) => stats.qenetCount[q]! > 0)),
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your learning path',
              style: TextStyle(
                  color: c.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          for (var i = 0; i < order.length; i++) ...[
            _PathRow(
              qenet: order[i],
              count: stats.qenetCount[order[i]]!,
              avg: stats.qenetAvg[order[i]]!,
              done: _done(order[i]),
              unlocked: i == 0 || _done(order[i - 1]),
              onCertificate: _done(order[i])
                  ? () => CertificateService.download(
                        name: authService.currentUsername ?? 'Student',
                        qenetLabel: order[i].label,
                        accuracy: stats.qenetAvg[order[i]]!.round(),
                        sessions: stats.qenetCount[order[i]]!,
                      )
                  : null,
            ),
            if (i < order.length - 1)
              Container(
                width: 2,
                height: 16,
                margin: const EdgeInsets.only(left: 19),
                color: c.border,
              ),
          ],
          const SizedBox(height: 20),
          Divider(color: c.border),
          const SizedBox(height: 12),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              for (final b in badges) _Badge(icon: b.$1, label: b.$2, earned: b.$3),
            ],
          ),
        ],
      ),
    );
  }
}

class _PathRow extends StatelessWidget {
  final Qenet qenet;
  final int count;
  final double avg;
  final bool done;
  final bool unlocked;
  final VoidCallback? onCertificate;

  const _PathRow({
    required this.qenet,
    required this.count,
    required this.avg,
    required this.done,
    required this.unlocked,
    this.onCertificate,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = unlocked ? qenet.color : c.textSecondary;
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Icon(
            done
                ? Icons.check_rounded
                : unlocked
                    ? Icons.play_arrow_rounded
                    : Icons.lock_rounded,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(qenet.label,
                      style: TextStyle(
                          color: c.textPrimary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1)),
                  const Spacer(),
                  Text('$count sessions · ${avg.round()}%',
                      style: TextStyle(color: c.textSecondary, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: (avg / 100).clamp(0.0, 1.0),
                  minHeight: 8,
                  color: color,
                  backgroundColor: color.withValues(alpha: 0.12),
                ),
              ),
              if (onCertificate != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: onCertificate,
                    icon: const Icon(Icons.workspace_premium_rounded, size: 18),
                    label: const Text('Download certificate'),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool earned;
  const _Badge({required this.icon, required this.label, required this.earned});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Opacity(
      opacity: earned ? 1 : 0.45,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: earned
                  ? const LinearGradient(
                      colors: [Color(0xFF60A5FA), Color(0xFF1D4ED8)])
                  : null,
              color: earned ? null : c.border,
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(color: c.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}
