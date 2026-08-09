import 'package:flutter/material.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/qenet.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/hand_tracking_service.dart';
import '../../core/services/progress_service.dart';
import '../../core/logic/exercise_logic.dart';
import '../../shared/widgets/camera_panel.dart';
import '../../shared/widgets/camera_feed_view.dart';
import '../../shared/widgets/stat_tile.dart';
import '../../shared/widgets/panel_card.dart';
import '../../shared/widgets/qenet_selector.dart';
import '../../shared/widgets/mode_app_bar.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});
  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  Qenet _qenet = Qenet.selamta;
  bool _showStrings = false;
  int _session = 1;
  int _correct = 0;
  int _wrong = 0;

  int? _currentWeakFinger = 1;
  List<int> _exercise = generateExercise(1);
  int _currentIndex = 0;
  int _weakFingerSessionCount = 0;
  List<int> _masteredFingers = [];
  final Map<int, int> _fingerSuccesses = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
  final Map<int, int> _fingerMistakes = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

  int? _lastHandledTimestamp;

  double get _accuracy =>
      (_correct + _wrong) == 0 ? 0 : _correct / (_correct + _wrong) * 100;

  @override
  void initState() {
    super.initState();
    handTrackingService.addListener(_onTrackingUpdate);
    handTrackingService.start();
    handTrackingService.setVirtualStrings(_showStrings);
    handTrackingService.setQenet(_qenet.name);
    handTrackingService.setTargetFinger(_exercise[_currentIndex]);
  }

  void _onTrackingUpdate() {
    final pluck = handTrackingService.lastPluck;
    if (pluck == null || _currentWeakFinger == null) return;
    final ts = pluck['timestamp'] as int;
    if (ts == _lastHandledTimestamp) return;
    _lastHandledTimestamp = ts;

    final finger = pluck['finger'] as int;
    final onString = pluck['onString'] as bool;
    if (!onString) return;

    final target = _exercise[_currentIndex];
    setState(() {
      if (finger == target) {
        _correct++;
        _fingerSuccesses[target] = (_fingerSuccesses[target] ?? 0) + 1;
        if (_currentIndex + 1 < _exercise.length) {
          _currentIndex++;
        } else {
          // finished this round of 5 — check for mastery
          _currentIndex = 0;
          _weakFingerSessionCount++;
          _session++;

          final total = _correct + _wrong;
          ProgressService.saveSession(
            mode: 'exercise',
            qenet: _qenet.name,
            correct: _correct,
            wrong: _wrong,
            accuracy: total == 0 ? 0 : ((_correct / total) * 100).round(),
            sessionNum: _session,
          );

          if (_weakFingerSessionCount >= sessionsToMaster) {
            _masteredFingers = [..._masteredFingers, _currentWeakFinger!];
            _currentWeakFinger = getNextWeakFinger(_masteredFingers, _fingerMistakes);
            _weakFingerSessionCount = 0;
          }
          _exercise =
              _currentWeakFinger != null ? generateExercise(_currentWeakFinger) : [];
        }
      } else {
        _wrong++;
        _fingerMistakes[finger] = (_fingerMistakes[finger] ?? 0) + 1;
      }
      handTrackingService.setTargetFinger(
          _currentWeakFinger != null ? _exercise[_currentIndex] : null);
    });
  }

  @override
  void dispose() {
    handTrackingService.removeListener(_onTrackingUpdate);
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
            leading: QenetSelector(
              selected: _qenet,
              onChanged: (q) {
                setState(() => _qenet = q);
                handTrackingService.setQenet(q.name);
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: LayoutBuilder(
              builder: (context, c) {
                final camera = CameraPanel(
                    service: handTrackingService, readyChild: const CameraFeedView());
                final sidebar = _sidebar();
                if (c.maxWidth < 800) {
                  return SingleChildScrollView(
                      child: Column(children: [camera, const SizedBox(height: 16), sidebar]));
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
              Text(AppStrings.get('session'),
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 12)),
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
            Expanded(
                child: StatTile(
                    label: AppStrings.get('correct'),
                    value: '$_correct',
                    valueColor: AppColors.success)),
            const SizedBox(width: 12),
            Expanded(
                child: StatTile(
                    label: AppStrings.get('wrong'),
                    value: '$_wrong',
                    valueColor: AppColors.danger)),
          ]),
          const SizedBox(height: 12),
          StatTile(
              label: AppStrings.get('accuracy'),
              value: '${_accuracy.toStringAsFixed(0)}%',
              valueColor: AppColors.modeExercise),
          const SizedBox(height: 12),
          PanelCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(AppStrings.get('mode_exercise'),
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 12)),
              const SizedBox(height: 4),
              Text(
                _currentWeakFinger != null
                    ? fingerNames[_currentWeakFinger]!
                    : AppStrings.get('ready').toUpperCase(),
                style: const TextStyle(
                    color: AppColors.warning, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _weakFingerSessionCount / sessionsToMaster,
                  minHeight: 6,
                  backgroundColor: context.colors.background,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '$_weakFingerSessionCount/$sessionsToMaster ${AppStrings.get('session').toLowerCase()}',
                style: TextStyle(color: context.colors.textSecondary, fontSize: 12),
              ),
            ]),
          ),
          const SizedBox(height: 12),
          PanelCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(AppStrings.get('ready'),
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 12)),
              const SizedBox(height: 4),
              Text(
                _masteredFingers.isEmpty
                    ? AppStrings.get('coming_soon')
                    : _masteredFingers.map((f) => fingerNames[f]).join(', '),
                style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold),
              ),
            ]),
          ),
          const SizedBox(height: 12),
          PanelCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Show Strings',
                    style:
                        TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.w600)),
                Switch(
                  value: _showStrings,
                  onChanged: (v) {
                    setState(() => _showStrings = v);
                    handTrackingService.setVirtualStrings(v);
                  },
                  activeThumbColor: AppColors.modeExercise,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              final ok = handTrackingService.captureCalibration();
              if (!ok && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Show your hand to the camera before calibrating')),
                );
              }
            },
            icon: const Icon(Icons.settings, size: 16),
            label: const Text('Calibrate'),
          ),
        ],
      );
}
