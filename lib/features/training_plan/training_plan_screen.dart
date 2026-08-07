import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/panel_card.dart';
import '../../shared/widgets/mode_app_bar.dart';

class TrainingPlanScreen extends StatelessWidget {
  const TrainingPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ModeAppBar(modeLabel: 'AI PRACTICE RECOMMENDATIONS', modeColor: AppColors.modeTrainingPlan),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                PanelCard(
                  child: Column(children: [
                    const SizedBox(height: 8),
                    const Icon(Icons.music_note, color: AppColors.modeTuning, size: 32),
                    const SizedBox(height: 10),
                    const Text('Your Personal Begena Teacher',
                        style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('AI analysis of your practice history', style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.8))),
                    const SizedBox(height: 8),
                  ]),
                ),
                const SizedBox(height: 16),
                PanelCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(children: [
                        Text('📋 ', style: TextStyle(fontSize: 14)),
                        Text('RECOMMENDATIONS', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 13)),
                      ]),
                      const SizedBox(height: 10),
                      Text('Complete some practice sessions first and I will give you personalized recommendations!',
                          style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.9))),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Refresh Recommendations'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
