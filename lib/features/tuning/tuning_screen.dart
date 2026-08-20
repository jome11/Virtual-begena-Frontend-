import 'package:flutter/material.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/qenet.dart';
import '../../core/constants/tuning_data.dart';
import '../../core/services/js/audio_interop.dart';
import '../../core/services/hand_tracking_service.dart';
import '../../shared/widgets/panel_card.dart';
import '../../shared/widgets/mode_app_bar.dart';
import '../../shared/widgets/begena_3d_canvas.dart';
import '../../shared/widgets/camera_feed_view.dart';
import '../../shared/widgets/camera_panel.dart';

class TuningScreen extends StatefulWidget {
  const TuningScreen({super.key});
  @override
  State<TuningScreen> createState() => _TuningScreenState();
}

class _TuningScreenState extends State<TuningScreen> {
  Qenet _qenet = Qenet.selamta;
  String _key = 'C';
  int _selected = 1;
  Map<int, String> _current = {
    for (final s in activeStrings) s: stringNotes[s]!.first
  };
  Map<int, bool>? _results;
  int? _lastTickTimestamp;

  Map<int, String> get _targets => qenetTuning[_qenet]![_key]!;
  static const _labels = {1: '1', 4: '2', 6: '3', 8: '4', 10: '5'};

  @override
  void initState() {
    super.initState();
    handTrackingService.addListener(_onTuningGesture);
    handTrackingService.start();
    handTrackingService.setMode('tuning');
    handTrackingService.setSelectedString(_selected);
  }

  void _onTuningGesture() {
    final tick = handTrackingService.lastTuningTick;
    if (tick == null) return;
    final ts = tick['timestamp'] as int;
    if (ts == _lastTickTimestamp) return;
    _lastTickTimestamp = ts;
    _cycle(tick['direction'] as int);
  }

  void _reset() {
    setState(() {
      _current = {for (final s in activeStrings) s: stringNotes[s]!.first};
      _results = null;
    });
  }

  void _cycle(int delta) {
    final notes = stringNotes[_selected]!;
    final idx = notes.indexOf(_current[_selected]!);
    final newIdx = (idx + delta).clamp(0, notes.length - 1);
    final newNote = notes[newIdx];
    if (newNote == _current[_selected]) return;
    setState(() {
      _current[_selected] = newNote;
      _results = null;
    });
    _play(_selected, newNote);
  }

  void _play(int string, String note) {
    final file = stringSoundFiles[string]?[note];
    if (file != null) playAudio('sounds/$file');
  }

  void _check() {
    final results = {
      for (final s in activeStrings) s: _current[s] == _targets[s]
    };
    setState(() => _results = results);
  }

  @override
  void dispose() {
    handTrackingService.removeListener(_onTuningGesture);
    handTrackingService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final target = _targets[_selected]!;
    final current = _current[_selected]!;
    final inTune = current == target;
    final notes = stringNotes[_selected]!;
    final idx = notes.indexOf(current);

    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        return Scaffold(
          backgroundColor: context.colors.background,
          appBar: ModeAppBar(
            modeLabel: AppStrings.get('mode_tuning').toUpperCase(),
            modeColor: AppColors.modeTuning,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: LayoutBuilder(
              builder: (context, c) {
                final dial = _dialCard(target, current, inTune, idx, notes.length);
                final panel = _panel();
                if (c.maxWidth < 800) {
                  return SingleChildScrollView(
                      child: Column(children: [dial, const SizedBox(height: 16), panel]));
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: dial),
                    const SizedBox(width: 20),
                    SizedBox(width: 300, child: panel),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _dialCard(String target, String current, bool inTune, int idx, int noteCount) {
    return PanelCard(
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: [
              for (final q in Qenet.values)
                ChoiceChip(
                  label: Text(q.label),
                  selected: _qenet == q,
                  onSelected: (_) => setState(() {
                    _qenet = q;
                    _results = null;
                  }),
                  selectedColor: AppColors.modeTuning,
                  labelStyle: TextStyle(
                      color: _qenet == q ? Colors.white : context.colors.textPrimary,
                      fontWeight: FontWeight.bold),
                ),
              const SizedBox(width: 10),
              for (final k in ['C', 'C#'])
                ChoiceChip(
                  label: Text(k),
                  selected: _key == k,
                  onSelected: (_) => setState(() {
                    _key = k;
                    _results = null;
                  }),
                  selectedColor: AppColors.modeTuning,
                  labelStyle: TextStyle(
                      color: _key == k ? Colors.white : context.colors.textPrimary,
                      fontWeight: FontWeight.bold),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: activeStrings.map((s) {
              final active = s == _selected;
              final result = _results?[s];
              Color ringColor = active
                  ? AppColors.modeTuning
                  : context.colors.textSecondary.withValues(alpha: 0.4);
              if (result != null) ringColor = result ? AppColors.success : AppColors.danger;
              return GestureDetector(
                onTap: () => setState(() {
                  _selected = s;
                  _results = null;
                  handTrackingService.setSelectedString(s);
                }),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: active
                        ? AppColors.modeTuning.withValues(alpha: 0.15)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: ringColor, width: active ? 3 : 2),
                  ),
                  child: Center(
                    child: Text(
                      _labels[s]!,
                      style: TextStyle(
                          color: active ? AppColors.modeTuning : context.colors.textSecondary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          // Hidden camera mount — hand tracking still runs, we just don't
          // show the video feed on this screen.
          // Small camera feed + large 3D begena, side by side.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 140,
                height: 105,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CameraPanel(
                    service: handTrackingService,
                    readyChild: const CameraFeedView(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(child: Begena3DCanvas(height: 320)),
            ],
          ),
          const SizedBox(height: 10),
          AnimatedBuilder(
            animation: handTrackingService,
            builder: (context, _) {
              final isPinching = handTrackingService.pinching;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: (isPinching ? AppColors.success : context.colors.textSecondary)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isPinching ? 'PINCH DETECTED — TWIST TO TUNE' : 'PINCH THUMB + INDEX',
                  style: TextStyle(
                    color: isPinching ? AppColors.success : context.colors.textSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: (inTune ? AppColors.success : AppColors.modeTuning).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              inTune ? 'IN TUNE' : 'ADJUST',
              style: TextStyle(
                color: inTune ? AppColors.success : AppColors.modeTuning,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => _cycle(-1),
                icon: const Icon(Icons.remove_circle_outline),
                iconSize: 32,
                color: AppColors.modeTuning,
              ),
              const SizedBox(width: 20),
              Text(current,
                  style: TextStyle(
                      color: context.colors.textPrimary, fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(width: 20),
              IconButton(
                onPressed: () => _cycle(1),
                icon: const Icon(Icons.add_circle_outline),
                iconSize: 32,
                color: AppColors.modeTuning,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('Pinch thumb + index, then twist to tune — or tap +/−',
              style: TextStyle(color: context.colors.textSecondary, fontSize: 12)),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => _play(_selected, current),
            icon: const Icon(Icons.volume_up, size: 18),
            label: const Text('Play'),
          ),
        ],
      ),
    );
  }

  Widget _panel() {
    final target = _targets[_selected]!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PanelCard(
          child: Column(children: [
            Text(AppStrings.get('mode_tuning'),
                style: TextStyle(color: context.colors.textSecondary, fontSize: 12)),
            const SizedBox(height: 4),
            Text('String ${_labels[_selected]}',
                style: const TextStyle(
                    color: AppColors.modeTuning, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: TextStyle(color: context.colors.textSecondary, fontSize: 13),
                children: [
                  const TextSpan(text: 'Target: '),
                  TextSpan(
                      text: target,
                      style: TextStyle(
                          color: context.colors.textPrimary, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ]),
        ),
        if (_results != null) ...[
          const SizedBox(height: 16),
          PanelCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _results!.values.every((v) => v) ? 'PERFECTLY TUNED! 🎵' : 'Some strings need adjusting',
                  style: TextStyle(
                    color: _results!.values.every((v) => v) ? AppColors.success : AppColors.warning,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: activeStrings.map((s) {
                    final ok = _results![s]!;
                    return Chip(
                      label: Text(_labels[s]!),
                      backgroundColor:
                      ok ? AppColors.success.withValues(alpha: 0.15) : AppColors.danger.withValues(alpha: 0.15),
                      labelStyle: TextStyle(
                          color: ok ? AppColors.success : AppColors.danger,
                          fontWeight: FontWeight.bold),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _check,
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.modeTuning,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14)),
          icon: const Icon(Icons.check),
          label: const Text('Check Tuning', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: _reset,
          icon: const Icon(Icons.refresh, size: 16),
          label: Text(AppStrings.get('restart')),
        ),
      ],
    );
  }
}


