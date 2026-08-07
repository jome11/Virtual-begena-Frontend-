import 'package:flutter/material.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/qenet.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/hand_tracking_service.dart';
import '../../shared/widgets/camera_panel.dart';
import '../../shared/widgets/camera_feed_view.dart';
import '../../shared/widgets/stat_tile.dart';
import '../../shared/widgets/panel_card.dart';
import '../../shared/widgets/qenet_selector.dart';
import '../../shared/widgets/mode_app_bar.dart';

const _fingerOrder = ['THUMB', 'INDEX', 'MIDDLE', 'RING', 'PINKY'];

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});
  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  Qenet _qenet = Qenet.selamta;
  final int _session = 1;
  final int _correct = 0;
  final int _wrong = 0;
  final int _fingerIndex = 0;
  final int _fingerSessions = 0;
  final Set<String> _mastered = {};

  double get _accuracy => (_correct + _wrong) == 0 ? 0 : _correct / (_correct + _wrong) * 100;

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
            modeLabel: AppStrings.get('mode_exercise').toUpperCase(),
            modeColor: AppColors.modeExercise,
            leading: QenetSelector(selected: _qenet, onChanged: (q) => setState(() => _qenet = q)),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: LayoutBuilder(
              builder: (context, c) {
                final camera = CameraPanel(service: handTrackingService, readyChild: const CameraFeedView());
                final sidebar = _sidebar();
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

  Widget _sidebar() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      PanelCard(
        child: Column(children: [
          Text(AppStrings.get('session'), style: TextStyle(color: context.colors.textSecondary, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            '#$_session',
            style: TextStyle(
              color: context.colors.accent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
      ),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: StatTile(label: AppStrings.get('correct'), value: '$_correct', valueColor: AppColors.success)),
        const SizedBox(width: 12),
        Expanded(child: StatTile(label: AppStrings.get('wrong'), value: '$_wrong', valueColor: AppColors.danger)),
      ]),
      const SizedBox(height: 12),
      StatTile(label: AppStrings.get('accuracy'), value: '${_accuracy.toStringAsFixed(0)}%', valueColor: AppColors.modeExercise),
      const SizedBox(height: 12),
      PanelCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(AppStrings.get('mode_exercise'), style: TextStyle(color: context.colors.textSecondary, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            _fingerOrder[_fingerIndex],
            style: const TextStyle(color: AppColors.warning, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _fingerSessions / 5,
              minHeight: 6,
              backgroundColor: context.colors.background,
              color: AppColors.warning,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$_fingerSessions/5 ${AppStrings.get('session').toLowerCase()}',
            style: TextStyle(color: context.colors.textSecondary, fontSize: 12),
          ),
        ]),
      ),
      const SizedBox(height: 12),
      PanelCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(AppStrings.get('ready'), style: TextStyle(color: context.colors.textSecondary, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            _mastered.isEmpty ? AppStrings.get('coming_soon') : _mastered.join(', '),
            style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold),
          ),
        ]),
      ),
      const SizedBox(height: 12),
      OutlinedButton.icon(
        onPressed: handTrackingService.recalibrate,
        icon: const Icon(Icons.settings, size: 16),
        label: Text(AppStrings.get('back')),
      ),
    ],
  );
}