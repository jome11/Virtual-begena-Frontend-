import 'package:flutter/material.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../core/theme/app_colors.dart';

const _fingerNames = {1: 'Thumb', 2: 'Index', 3: 'Middle', 4: 'Ring', 5: 'Pinky'};

void showSessionBreakdown(BuildContext context, Map<String, dynamic> session) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _Sheet(data: session),
  );
}

int _count(dynamic map, int finger) =>
    map is Map ? ((map['$finger'] as num?)?.toInt() ?? 0) : 0;

class _Sheet extends StatelessWidget {
  final Map<String, dynamic> data;
  const _Sheet({required this.data});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final ok = data['finger_successes'];
    final bad = data['finger_mistakes'];

    final rows = <int, (int, int)>{
      for (final f in _fingerNames.keys) f: (_count(ok, f), _count(bad, f)),
    };
    final attempted = rows.entries.where((e) => e.value.$1 + e.value.$2 > 0).toList();

    int? weakest;
    double worst = 2;
    for (final e in attempted) {
      final rate = e.value.$1 / (e.value.$1 + e.value.$2);
      if (rate < worst) {
        worst = rate;
        weakest = e.key;
      }
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${(data['mode'] as String? ?? '').toUpperCase()} · ${data['qenet'] ?? ''} · ${data['accuracy']}%',
            style: TextStyle(
                color: c.textPrimary, fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text('Finger breakdown',
              style: TextStyle(color: c.textSecondary, fontSize: 13)),
          const SizedBox(height: 18),
          if (attempted.isEmpty)
            Text('No per-finger data for this session.',
                style: TextStyle(color: c.textSecondary))
          else
            for (final e in attempted) ...[
              Builder(builder: (_) {
                final total = e.value.$1 + e.value.$2;
                final rate = e.value.$1 / total;
                final color = rate >= 0.8
                    ? AppColors.success
                    : rate >= 0.5
                        ? AppColors.warning
                        : AppColors.danger;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(_fingerNames[e.key]!,
                              style: TextStyle(
                                  color: c.textPrimary,
                                  fontWeight: FontWeight.w700)),
                          if (e.key == weakest && attempted.length > 1) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.danger.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text('Focus here',
                                  style: TextStyle(
                                      color: AppColors.danger,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ],
                          const Spacer(),
                          Text('${e.value.$1} ✓   ${e.value.$2} ✗',
                              style: TextStyle(
                                  color: c.textSecondary, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: rate,
                          minHeight: 8,
                          color: color,
                          backgroundColor: color.withValues(alpha: 0.12),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
        ],
      ),
    );
  }
}
