import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/hand_tracking_service.dart';
import '../../shared/widgets/camera_panel.dart';
import '../../shared/widgets/camera_feed_view.dart';
import '../../shared/widgets/panel_card.dart';
import '../../shared/widgets/stat_tile.dart';
import '../../shared/widgets/mode_app_bar.dart';

const _stringGuide = [
  ['String 1', 'THUMB'], ['String 2', 'INDEX'], ['String 3', 'MIDDLE'], ['String 4', 'RING'], ['String 5', 'PINKY'],
];

class RealPlayScreen extends StatefulWidget {
  const RealPlayScreen({super.key});
  @override
  State<RealPlayScreen> createState() => _RealPlayScreenState();
}

class _RealPlayScreenState extends State<RealPlayScreen> {
  @override
  void initState() {
    super.initState();
    handTrackingService.start();
  }

  @override
  void dispose() {
    handTrackingService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        return Scaffold(
          backgroundColor: context.colors.background,
          appBar: ModeAppBar(
            modeLabel: AppStrings.get('mode_real_play').toUpperCase(),
            modeColor: AppColors.modeRealPlay,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: LayoutBuilder(
              builder: (context, c) {
                final camera = CameraPanel(service: handTrackingService, readyChild: const CameraFeedView());
                final sidebar = Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(children: [
                      Expanded(child: StatTile(label: AppStrings.get('correct'), value: '0', valueColor: AppColors.success)),
                      const SizedBox(width: 12),
                      Expanded(child: StatTile(label: AppStrings.get('wrong'), value: '0', valueColor: AppColors.danger)),
                    ]),
                    const SizedBox(height: 12),
                    StatTile(label: AppStrings.get('accuracy'), value: '0%', valueColor: AppColors.modeRealPlay),
                    const SizedBox(height: 12),
                    PanelCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppStrings.get('mode_real_play_sub'), style: TextStyle(color: context.colors.textSecondary, fontSize: 12)),
                          const SizedBox(height: 8),
                          ..._stringGuide.map((s) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(s[0], style: TextStyle(color: context.colors.textPrimary, fontSize: 13)),
                                Text(s[1], style: const TextStyle(color: AppColors.modeRealPlay, fontWeight: FontWeight.bold, fontSize: 13)),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    PanelCard(
                      child: Column(children: [
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          Text(AppStrings.get('ready'), style: TextStyle(color: context.colors.textSecondary, fontSize: 12)),
                        ]),
                        const SizedBox(height: 6),
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.danger, shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          Text(AppStrings.get('wrong'), style: TextStyle(color: context.colors.textSecondary, fontSize: 12)),
                        ]),
                        const SizedBox(height: 6),
                        Text(
                          AppStrings.get('coming_soon'),
                          style: TextStyle(color: context.colors.textSecondary.withValues(alpha: 0.7), fontSize: 12),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => context.go('/dashboard'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.danger,
                        side: const BorderSide(color: AppColors.danger),
                      ),
                      icon: const Icon(Icons.close, size: 16),
                      label: Text(AppStrings.get('exit')),
                    ),
                  ],
                );
                if (c.maxWidth < 800) {
                  return SingleChildScrollView(child: Column(children: [camera, const SizedBox(height: 16), sidebar]));
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: camera),
                    const SizedBox(width: 20),
                    SizedBox(width: 280, child: sidebar)
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}