import 'package:flutter/material.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/progress_service.dart';
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
          body: FutureBuilder<List<Map<String, dynamic>>>(
            future: ProgressService.getHistory(),
            builder: (context, snapshot) {
              final history = snapshot.data ?? [];
              final totalSessions = history.length;
              
              int totalCorrect = 0;
              double sumAccuracy = 0;
              for (final s in history) {
                totalCorrect += (s['correct'] as num?)?.toInt() ?? 0;
                sumAccuracy += (s['accuracy'] as num?)?.toDouble() ?? 0;
              }
              final avgAccuracy = totalSessions == 0 ? 0 : (sumAccuracy / totalSessions).round();

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        LayoutBuilder(
                          builder: (context, c) {
                            final tiles = [
                              StatTile(
                                label: AppStrings.get('session'),
                                value: '$totalSessions',
                                valueColor: AppColors.modeExercise,
                              ),
                              StatTile(
                                label: AppStrings.get('accuracy'),
                                value: '$avgAccuracy%',
                                valueColor: AppColors.success,
                              ),
                              StatTile(
                                label: AppStrings.get('correct'),
                                value: '$totalCorrect',
                                valueColor: context.colors.accent,
                              ),
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
                              if (snapshot.connectionState == ConnectionState.waiting)
                                const Center(child: CircularProgressIndicator())
                              else if (history.isEmpty)
                                Center(
                                  child: Text(
                                    AppStrings.get('coming_soon'),
                                    style: TextStyle(color: context.colors.textSecondary.withValues(alpha: 0.8)),
                                  ),
                                )
                              else
                                ...history.map((s) => _SessionRow(data: s)),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _SessionRow extends StatelessWidget {
  final Map<String, dynamic> data;
  const _SessionRow({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (data['mode'] as String? ?? '').toUpperCase(),
                style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Text(
                data['qenet'] as String? ?? '',
                style: TextStyle(color: context.colors.textSecondary, fontSize: 12),
              ),
            ],
          ),
          Text(
            '${data['accuracy']}%',
            style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
