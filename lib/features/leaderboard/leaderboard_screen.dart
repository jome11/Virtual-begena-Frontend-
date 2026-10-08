import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/progress_service.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/mode_app_bar.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  bool _weekly = false;
  late Future<List<Map<String, dynamic>>> _future = ProgressService.getLeaderboard();

  void _setWeekly(bool w) => setState(() {
        _weekly = w;
        _future = ProgressService.getLeaderboard(weekly: w);
      });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.background,
      appBar: const ModeAppBar(
        modeLabel: 'LEADERBOARD',
        modeColor: AppColors.modeFreePlay,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: false, label: Text('All time')),
                    ButtonSegment(value: true, label: Text('This week')),
                  ],
                  selected: {_weekly},
                  onSelectionChanged: (s) => _setWeekly(s.first),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _future,
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final rows = snap.data ?? const [];
                    if (rows.isEmpty) {
                      return Center(
                        child: Text(
                          'No rankings yet. Finish a session to appear here.',
                          style: TextStyle(color: c.textSecondary),
                        ),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: rows.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) => _LeaderRow(data: rows[i]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeaderRow extends StatelessWidget {
  final Map<String, dynamic> data;
  const _LeaderRow({required this.data});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final rank = (data['rank'] as num?)?.toInt() ?? 0;
    final name = data['name'] as String? ?? '—';
    final me = name == authService.currentUsername;
    final medal = switch (rank) {
      1 => const Color(0xFFF59E0B),
      2 => const Color(0xFF94A3B8),
      3 => const Color(0xFFB45309),
      _ => c.border,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: me ? c.accent.withValues(alpha: 0.1) : c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: me ? c.accent : c.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: medal,
            child: Text('$rank',
                style: TextStyle(
                    color: rank <= 3 ? Colors.white : c.textPrimary,
                    fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                        color: c.textPrimary, fontWeight: FontWeight.w700)),
                Text('${data['sessions']} sessions · ${data['avg_accuracy']}% accuracy',
                    style: TextStyle(color: c.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Text('${data['total_correct']}',
              style: TextStyle(
                  color: c.accent, fontSize: 20, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
