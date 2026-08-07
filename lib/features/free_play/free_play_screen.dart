import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/qenet.dart';
import '../../core/services/hand_tracking_service.dart';
import '../../shared/widgets/camera_panel.dart';
import '../../shared/widgets/panel_card.dart';
import '../../shared/widgets/qenet_selector.dart';
import '../../shared/widgets/mode_app_bar.dart';

class FreePlayScreen extends StatefulWidget {
  const FreePlayScreen({super.key});
  @override
  State<FreePlayScreen> createState() => _FreePlayScreenState();
}

class _FreePlayScreenState extends State<FreePlayScreen> {
  Qenet _qenet = Qenet.selamta;

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
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: ModeAppBar(
        modeLabel: 'FREEPLAY MODE',
        modeColor: AppColors.modeFreePlay,
        leading: QenetSelector(selected: _qenet, onChanged: (q) => setState(() => _qenet = q)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: LayoutBuilder(
          builder: (context, c) {
            final camera = CameraPanel(service: handTrackingService);
            final panel = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PanelCard(
                  child: Column(children: [
                    const Icon(Icons.music_note, color: AppColors.modeTuning, size: 32),
                    const SizedBox(height: 12),
                    Text(
                      'Pluck any string to hear it',
                      style: TextStyle(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'No targets — just explore!',
                      style: TextStyle(
                        color: context.colors.textSecondary.withValues(alpha: 0.8),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 16),
                PanelCard(
                  child: Center(
                    child: Text(
                      'Ready!',
                      style: TextStyle(color: context.colors.textSecondary),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => context.go('/dashboard'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    side: const BorderSide(color: AppColors.danger),
                  ),
                  icon: const Icon(Icons.close, size: 16),
                  label: const Text('Exit'),
                ),
              ],
            );
            if (c.maxWidth < 800) {
              return SingleChildScrollView(child: Column(children: [camera, const SizedBox(height: 16), panel]));
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: camera),
                const SizedBox(width: 20),
                SizedBox(width: 280, child: panel)
              ],
            );
          },
        ),
      ),
    );
  }
}
