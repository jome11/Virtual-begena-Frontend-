import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/daily_goal_service.dart';
import '../../../core/services/reminder_service.dart';
import '../../../core/theme/app_color_scheme.dart';

class DailyGoalCard extends StatefulWidget {
  const DailyGoalCard({super.key});

  @override
  State<DailyGoalCard> createState() => _DailyGoalCardState();
}

class _DailyGoalCardState extends State<DailyGoalCard> {
  int _done = 0;
  int _streak = 0;
  bool _remind = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final done = await DailyGoalService.todayCount();
    final streak = await DailyGoalService.streak();
    final remind = prefs.getBool('goal_remind') ?? false;
    if (!mounted) return;
    setState(() {
      _done = done;
      _streak = streak;
      _remind = remind;
    });
    if (remind) ReminderService.notifyIfNeeded(done, DailyGoalService.goalSessions);
  }

  Future<void> _toggleRemind(bool on) async {
    if (on && !await ReminderService.enable()) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('goal_remind', on);
    if (mounted) setState(() => _remind = on);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final goal = DailyGoalService.goalSessions;
    final met = _done >= goal;
    final tint = met ? const Color(0xFF10B981) : c.accent;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 64,
                  height: 64,
                  child: CircularProgressIndicator(
                    value: (_done / goal).clamp(0.0, 1.0),
                    strokeWidth: 7,
                    backgroundColor: c.border,
                    color: tint,
                  ),
                ),
                Icon(met ? Icons.check_rounded : Icons.flag_rounded, color: tint),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Daily goal',
                    style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(
                  met ? 'Goal reached, great work!' : '$_done / $goal sessions today',
                  style: TextStyle(color: c.textSecondary, fontSize: 13),
                ),
                if (_streak > 0) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.local_fire_department_rounded,
                          size: 16, color: Color(0xFFF59E0B)),
                      const SizedBox(width: 4),
                      Text('$_streak day streak',
                          style: TextStyle(
                              color: c.textPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Column(
            children: [
              Text('Remind me', style: TextStyle(color: c.textSecondary, fontSize: 11)),
              Switch(value: _remind, onChanged: _toggleRemind),
            ],
          ),
        ],
      ),
    );
  }
}
