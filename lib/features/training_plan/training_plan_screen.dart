import 'package:flutter/material.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../shared/widgets/panel_card.dart';
import '../../shared/widgets/mode_app_bar.dart';

class TrainingPlanScreen extends StatelessWidget {
  const TrainingPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        return Scaffold(
          backgroundColor: context.colors.background,
          appBar: ModeAppBar(
            modeLabel: AppStrings.get('mode_training_plan').toUpperCase(),
            modeColor: AppColors.modeTrainingPlan,
          ),
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
                        Text(
                          AppStrings.get('mode_training_plan'),
                          style: TextStyle(
                            color: context.colors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppStrings.get('dashboard_subtitle'),
                          style: TextStyle(color: context.colors.textSecondary.withValues(alpha: 0.8)),
                        ),
                        const SizedBox(height: 8),
                      ]),
                    ),
                    const SizedBox(height: 16),
                    PanelCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            const Text('📋 ', style: TextStyle(fontSize: 14)),
                            Text(
                              AppStrings.get('mode_training_plan_sub').toUpperCase(),
                              style: TextStyle(
                                color: AppColors.success,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ]),
                          const SizedBox(height: 10),
                          Text(
                            AppStrings.get('coming_soon'),
                            style: TextStyle(color: context.colors.textSecondary.withValues(alpha: 0.9)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.refresh, size: 16),
                      label: Text(AppStrings.get('restart')),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
