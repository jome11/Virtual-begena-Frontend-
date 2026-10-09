import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/qenet.dart';
import '../../core/data/curriculum.dart';
import '../../core/data/exercise_plan.dart';
import '../../core/services/course_progress_service.dart';
import '../../core/services/hand_tracking_service.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/camera_controls_panel.dart';
import '../../shared/widgets/camera_feed_view.dart';
import '../../shared/widgets/camera_panel.dart';
import '../../shared/widgets/mode_app_bar.dart';
import '../../shared/widgets/panel_card.dart';
import '../../shared/widgets/stat_tile.dart';

enum _Phase { ready, running, finished }

class PracticalExamScreen extends StatefulWidget {
  final Qenet qenet;
  const PracticalExamScreen({super.key, required this.qenet});

  @override
  State<PracticalExamScreen> createState() => _PracticalExamScreenState();
}

class _PracticalExamScreenState extends State<PracticalExamScreen> {
  static const _partA = 5; // string -> finger (PDF 5.2)
  static const _notes = 10; // 5 + the 5 notes of the scale (PDF 6.4)
  static const _maxWrong = 4; // 10 correct out of 14 plucks is 71%

  _Phase _phase = _Phase.ready;
  bool _showStrings = false;
  late List<int> _targets = _newTargets();
  int _index = 0;
  int _correct = 0;
  int _wrong = 0;
  int? _lastTs;

  int get _accuracy => (_correct + _wrong) == 0
      ? 0
      : (_correct / (_correct + _wrong) * 100).round();

  /// Part 1: the five fingers in random order (asked as string numbers).
  /// Part 2: the qenet's scale upward from C.
  List<int> _newTargets() {
    final a = [1, 2, 3, 4, 5]..shuffle(Random());
    final up = scaleFingersUp;
    if (a.last == up.first) a.add(a.removeAt(0));
    return [...a, ...up];
  }

  @override
  void initState() {
    super.initState();
    handTrackingService.addListener(_onTracking);
    handTrackingService.start();
    handTrackingService.setVirtualStrings(_showStrings);
    handTrackingService.setQenet(widget.qenet.name);
    handTrackingService.setTargetFinger(null);
  }

  @override
  void dispose() {
    handTrackingService.removeListener(_onTracking);
    handTrackingService.stop();
    super.dispose();
  }

  void _start() {
    _lastTs = handTrackingService.lastPluck?['timestamp'] as int?;
    setState(() {
      _targets = _newTargets();
      _index = 0;
      _correct = 0;
      _wrong = 0;
      _phase = _Phase.running;
    });
    handTrackingService.setTargetFinger(_targets[0]);
  }

  void _onTracking() {
    if (_phase != _Phase.running) return;
    final pluck = handTrackingService.lastPluck;
    if (pluck == null) return;
    final ts = pluck['timestamp'] as int;
    if (ts == _lastTs) return;
    _lastTs = ts;
    if (pluck['onString'] != true) return;

    final finger = pluck['finger'] as int;
    if (finger == _targets[_index]) {
      HapticFeedback.mediumImpact();
      _correct++;
      if (_index + 1 >= _notes) {
        _finish();
        return;
      }
      _index++;
      handTrackingService.setTargetFinger(_targets[_index]);
    } else {
      _wrong++;
      if (_wrong > _maxWrong) {
        _finish();
        return;
      }
    }
    setState(() {});
  }

  Future<void> _finish() async {
    handTrackingService.setTargetFinger(null);
    final passed = _correct >= _notes && _accuracy >= examPassAccuracy;
    setState(() => _phase = _Phase.finished);
    if (passed) await CourseProgress.saveExam(widget.qenet.name, _accuracy);
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(passed ? tr('አልፈዋል!', 'You passed!') : tr('ገና አልተሳካም', 'Not yet')),
        content: Text(passed
            ? tr('ትክክለኛነትዎ $_accuracy% ነው።', 'Your accuracy was $_accuracy%.')
            : tr('ትክክለኛነትዎ $_accuracy% ነው፤ ለማለፍ ቢያንስ $examPassAccuracy% ያስፈልጋል። ልምምድ ሞድ ውስጥ ይለማመዱና እንደገና ይሞክሩ።',
                'Your accuracy was $_accuracy%. You need at least $examPassAccuracy% to pass. Practice in Exercise Mode and try again.')),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() => _phase = _Phase.ready);
            },
            child: Text(tr('እንደገና', 'Try again')),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go('/course');
            },
            child: Text(tr('ወደ ኮርሱ', 'Back to course')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        return Scaffold(
          backgroundColor: context.colors.background,
          appBar: ModeAppBar(
            modeLabel: '${tr('የተግባር ፈተና', 'PRACTICAL TEST')} · ${widget.qenet.label}',
            modeColor: widget.qenet.color,
            onBack: () => context.go('/course'),
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
                    SizedBox(width: 280, child: sidebar),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _sidebar() {
    final running = _phase == _Phase.running;
    final finger = _targets[_index];
    final inScale = _index >= _partA;
    final f = fingerTable[finger - 1];
    final big = inScale
        ? noteFor(widget.qenet, finger)
        : tr('አውታር ${f.$4}', 'String ${f.$4}');
    final part = inScale
        ? tr('ክፍል 2 ከ2 · ቅኝቱን ወደ ላይ', 'Part 2 of 2 · the scale, upward')
        : tr('ክፍል 1 ከ2 · አውታርና ጣት', 'Part 1 of 2 · string & finger');
    final scale = scales.firstWhere((s) => s.qenet == widget.qenet);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PanelCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!running) ...[
                Text(
                  tr('ክፍል 1፦ የሚታየውን አውታር በትክክለኛው ጣት ይንኩ (5)። ክፍል 2፦ የ${widget.qenet.label} ቅኝት አምስት ድምጾችን ከC ጀምሮ በቅደም ተከተል ይንኩ (5)። ከ4 ስህተት በላይ ከሆነ ፈተናው ያበቃል።',
                      'Part 1: pluck the string shown with the right finger (5). Part 2: play the five notes of ${widget.qenet.label} in order from C (5). More than 4 mistakes ends the test.'),
                  style: TextStyle(color: context.colors.textSecondary, height: 1.5),
                ),
                const SizedBox(height: 10),
                Text(
                  '${tr('የቅኝቱ ድምጾች', 'Scale notes')}: ${scale.notes}',
                  style: TextStyle(
                    color: widget.qenet.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                FilledButton.icon(
                  onPressed: _start,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(tr('ፈተናውን ጀምር', 'Start the test')),
                ),
              ] else ...[
                Text(part,
                    style: TextStyle(color: context.colors.textSecondary, fontSize: 12)),
                const SizedBox(height: 6),
                Text(big,
                    style: const TextStyle(
                        color: AppColors.warning,
                        fontSize: 26,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _correct / _notes,
                    minHeight: 6,
                    backgroundColor: context.colors.background,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(height: 6),
                Text('$_correct / $_notes',
                    style: TextStyle(color: context.colors.textSecondary, fontSize: 12)),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
              child: StatTile(
                  label: tr('ትክክል', 'Correct'),
                  value: '$_correct',
                  valueColor: AppColors.success)),
          const SizedBox(width: 12),
          Expanded(
              child: StatTile(
                  label: tr('ስህተት (ከፍተኛ 4)', 'Mistakes (max 4)'),
                  value: '$_wrong',
                  valueColor: AppColors.danger)),
        ]),
        const SizedBox(height: 12),
        StatTile(
            label: tr('ትክክለኛነት', 'Accuracy'),
            value: '$_accuracy%',
            valueColor: widget.qenet.color),
        const SizedBox(height: 12),
        CameraControlsPanel(
          showStrings: _showStrings,
          onShowStringsChanged: (v) => setState(() => _showStrings = v),
          modeColor: widget.qenet.color,
        ),
      ],
    );
  }
}
