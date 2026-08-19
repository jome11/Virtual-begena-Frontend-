import 'package:flutter/material.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../core/services/hand_tracking_service.dart';
import 'panel_card.dart';

/// Shared "Show Strings" toggle + "Calibrate" controls used across all
/// camera-based modes (Exercise, Free Play, Mezmur Tenat) so the behavior
/// and styling stay consistent everywhere.
class CameraControlsPanel extends StatelessWidget {
  final bool showStrings;
  final ValueChanged<bool> onShowStringsChanged;
  final Color modeColor;

  const CameraControlsPanel({
    super.key,
    required this.showStrings,
    required this.onShowStringsChanged,
    required this.modeColor,
  });

  void _calibrate(BuildContext context) {
    final ok = handTrackingService.captureCalibration();
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Show your hand to the camera before calibrating')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PanelCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Show Strings',
                style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.w600),
              ),
              Switch(
                value: showStrings,
                onChanged: (v) {
                  onShowStringsChanged(v);
                  handTrackingService.setVirtualStrings(v);
                },
                activeThumbColor: modeColor,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => _calibrate(context),
          icon: const Icon(Icons.settings, size: 16),
          label: const Text('Calibrate'),
        ),
      ],
    );
  }
}