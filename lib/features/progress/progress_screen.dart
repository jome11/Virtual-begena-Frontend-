import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/panel_card.dart';
import '../../shared/widgets/stat_tile.dart';
import '../../shared/widgets/mode_app_bar.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ModeAppBar(modeLabel: 'MY PROGRESS', modeColor: AppColors.modeProgress),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                LayoutBuilder(
                  builder: (context, c) {
                    final tiles = [
                      StatTile(label: 'Total Sessions', value: '0', valueColor: AppColors.modeExercise),
                      StatTile(label: 'Avg Accuracy', value: '0%', valueColor: AppColors.success),
                      StatTile(label: 'Total Correct', value: '0', valueColor: AppColors.secondary),
                    ];
                    
                    if (c.maxWidth < 500) {
                      return Column(
                        children: tiles.map((t) => Padding(padding: const EdgeInsets.only(bottom: 12), child: t)).toList(),
                      );
                    }
                    
                    return Row(
                      children: tiles.map((t) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: t))).toList(),
                    );
                  },
                ),
                const SizedBox(height: 16),
                PanelCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Session History', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 24),
                      Center(
                        child: Text('No sessions yet — start practicing!', style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.8))),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
