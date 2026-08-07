import 'package:flutter/material.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../shared/widgets/panel_card.dart';
import '../../shared/widgets/stat_tile.dart';
import '../../shared/widgets/mode_app_bar.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        return Scaffold(
          backgroundColor: context.colors.background,
          appBar: ModeAppBar(
            modeLabel: AppStrings.get('mode_progress').toUpperCase(),
            modeColor: AppColors.modeProgress,
          ),
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
                          StatTile(label: AppStrings.get('session'), value: '0', valueColor: AppColors.modeExercise),
                          StatTile(label: AppStrings.get('accuracy'), value: '0%', valueColor: AppColors.success),
                          StatTile(label: AppStrings.get('correct'), value: '0', valueColor: context.colors.accent),
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
                          Text(
                            AppStrings.get('mode_progress'),
                            style: TextStyle(
                              color: context.colors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Divider(color: context.colors.border),
                          const SizedBox(height: 24),
                          Center(
                            child: Text(
                              AppStrings.get('coming_soon'),
                              style: TextStyle(color: context.colors.textSecondary.withValues(alpha: 0.8)),
                            ),
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
      },
    );
  }
}
