import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/qenet.dart';
import '../../core/data/curriculum.dart';
import '../../core/data/exercise_plan.dart';
import '../../core/logic/exercise_logic.dart';
import '../../core/services/hand_tracking_service.dart';
import '../../core/services/progress_service.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/camera_controls_panel.dart';
import '../../shared/widgets/camera_feed_view.dart';
import '../../shared/widgets/camera_panel.dart';
import '../../shared/widgets/mode_app_bar.dart';
import '../../shared/widgets/panel_card.dart';
import '../../shared/widgets/qenet_selector.dart';
import '../../shared/widgets/stat_tile.dart';

enum _Flash { none, ok, miss }

enum _TileState { done, current, upcoming }

class ExerciseScreen extends StatefulWidget {
  final Qenet? initialQenet;
  const ExerciseScreen({super.key, this.initialQenet});
  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  late Qenet _qenet = widget.initialQenet ?? Qenet.selamta;
  late List<ExerciseLevel> _levels = exerciseLevels(_qenet);

  bool _showStrings = false;
  int _levelIndex = 0;
  List<int> _seq = [];
  int _pos = 0;
  int _roundsDone = 0;

  // Totals for the whole screen session (saved to progress).
  int _correct = 0;
  int _wrong = 0;
  int _sessionNum = 1;

  // Totals for the current level.
  int _lvlCorrect = 0;
  int _lvlWrong = 0;
  int _streak = 0;
  int _bestStreak = 0;

  bool _levelDone = false;
  String? _notice;
  _Flash _flash = _Flash.none;
  Timer? _flashTimer;
  int? _lastTs;

  final Set<int> _cleared = {};
  final Map<int, int> _mistakes = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

  ExerciseLevel get _level => _levels[_levelIndex];

  int get _lvlAccuracy {
    final t = _lvlCorrect + _lvlWrong;
    return t == 0 ? 0 : (_lvlCorrect / t * 100).round();
  }

  @override
  void initState() {
    super.initState();
    handTrackingService.addListener(_onTrackingUpdate);
    handTrackingService.start();
    handTrackingService.setMode('practice');
    handTrackingService.setVirtualStrings(_showStrings);
    handTrackingService.setQenet(_qenet.name);
    _startLevel(0);
  }

  @override
  void dispose() {
    _flashTimer?.cancel();
    handTrackingService.removeListener(_onTrackingUpdate);
    handTrackingService.stop();
    super.dispose();
  }

  List<int> _buildSeq() {
    if (_level.adaptive) {
      final mistakes = _mistakes.values.fold<int>(0, (a, b) => a + b);
      return generateExercise(mistakes == 0 ? null : getWeakest(_mistakes));
    }
    return List<int>.of(_level.fingers);
  }

  void _startLevel(int i) {
    _levelIndex = i;
    _roundsDone = 0;
    _pos = 0;
    _lvlCorrect = 0;
    _lvlWrong = 0;
    _streak = 0;
    _bestStreak = 0;
    _levelDone = false;
    _notice = null;
    _lastTs = handTrackingService.lastPluck?['timestamp'] as int?;
    _seq = _buildSeq();
    handTrackingService.setTargetFinger(_seq[_pos]);
  }

  void _flashFor(_Flash f) {
    _flash = f;
    _flashTimer?.cancel();
    _flashTimer = Timer(const Duration(milliseconds: 450), () {
      if (mounted) setState(() => _flash = _Flash.none);
    });
  }

  void _finishRound() {
    _roundsDone++;
    _sessionNum++;
    final total = _correct + _wrong;
    ProgressService.saveSession(
      mode: 'exercise',
      qenet: _qenet.name,
      correct: _correct,
      wrong: _wrong,
      accuracy: total == 0 ? 0 : ((_correct / total) * 100).round(),
      sessionNum: _sessionNum,
    );

    if (_roundsDone >= _level.rounds) {
      final acc = _lvlAccuracy;
      if (acc >= examPassAccuracy) {
        _cleared.add(_levelIndex);
        _levelDone = true;
        return;
      }
      // Not accurate enough: restart this level.
      _notice = tr(
        'ትክክለኛነት $acc% ነው፤ ለማለፍ $examPassAccuracy% ያስፈልጋል። ደረጃው እንደገና ይጀምራል።',
        'Accuracy was $acc%; you need $examPassAccuracy%. The level restarts.',
      );
      _roundsDone = 0;
      _lvlCorrect = 0;
      _lvlWrong = 0;
      _streak = 0;
    }
    _pos = 0;
    _seq = _buildSeq();
  }

  void _onTrackingUpdate() {
    final pluck = handTrackingService.lastPluck;
    if (pluck == null || _levelDone) return;
    final ts = pluck['timestamp'] as int;
    if (ts == _lastTs) return;
    _lastTs = ts;
    if (pluck['onString'] != true) return;

    final finger = pluck['finger'] as int;
    final target = _seq[_pos];

    setState(() {
      if (finger == target) {
        HapticFeedback.mediumImpact();
        _correct++;
        _lvlCorrect++;
        _streak++;
        if (_streak > _bestStreak) _bestStreak = _streak;
        _notice = null;
        _flashFor(_Flash.ok);
        if (_pos + 1 < _seq.length) {
          _pos++;
        } else {
          _finishRound();
        }
      } else {
        _wrong++;
        _lvlWrong++;
        _streak = 0;
        _mistakes[finger] = (_mistakes[finger] ?? 0) + 1;
        _flashFor(_Flash.miss);
      }
    });
    handTrackingService.setTargetFinger(_levelDone ? null : _seq[_pos]);
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
                setState(() {
                  _qenet = q;
                  _levels = exerciseLevels(q);
                  _startLevel(_levelIndex);
                });
                handTrackingService.setQenet(q.name);
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: LayoutBuilder(
              builder: (context, c) {
                final main = Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _levelChips(),
                    const SizedBox(height: 14),
                    CameraPanel(
                      service: handTrackingService,
                      readyChild: const CameraFeedView(),
                    ),
                    const SizedBox(height: 14),
                    _noteStrip(),
                  ],
                );
                final side = _sidebar();
                if (c.maxWidth < 900) {
                  return SingleChildScrollView(
                    child: Column(children: [main, const SizedBox(height: 16), side]),
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: SingleChildScrollView(child: main)),
                    const SizedBox(width: 20),
                    SizedBox(width: 320, child: SingleChildScrollView(child: side)),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _levelChips() => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (var i = 0; i < _levels.length; i++)
            _LevelChip(
              number: _levels[i].id,
              title: tr(_levels[i].titleAm, _levels[i].titleEn),
              selected: i == _levelIndex,
              cleared: _cleared.contains(i),
              color: _qenet.color,
              onTap: () => setState(() => _startLevel(i)),
            ),
        ],
      );

  Widget _noteStrip() => PanelCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr('የዚህ ዙር ማስታወሻዎች', 'Notes in this round'),
              style: TextStyle(color: context.colors.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var i = 0; i < _seq.length; i++)
                  _NoteTile(
                    note: noteFor(_qenet, _seq[i]),
                    sub: tr('አውታር ${stringForFinger(_seq[i])}',
                        'String ${stringForFinger(_seq[i])}'),
                    state: (_levelDone || i < _pos)
                        ? _TileState.done
                        : (i == _pos ? _TileState.current : _TileState.upcoming),
                    color: _qenet.color,
                  ),
              ],
            ),
          ],
        ),
      );

  Widget _sidebar() {
    final target = _seq[_pos];
    final f = fingerTable[target - 1];
    final lvl = _level;
    final scale = scales.firstWhere((s) => s.qenet == _qenet);
    final progress = _levelDone
        ? 1.0
        : (_roundsDone + _pos / _seq.length) / lvl.rounds;
    final shownRound =
        _roundsDone + 1 > lvl.rounds ? lvl.rounds : _roundsDone + 1;

    final flashColor = switch (_flash) {
      _Flash.ok => AppColors.success,
      _Flash.miss => AppColors.danger,
      _Flash.none => context.colors.textSecondary.withValues(alpha: 0.2),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: flashColor, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _levelDone
                    ? tr('ደረጃው ተጠናቀቀ', 'Level complete')
                    : tr('አሁን የሚነኩት', 'Pluck now'),
                style: TextStyle(color: context.colors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 6),
              if (!_levelDone) ...[
                Text(
                  tr(f.$2, f.$3),
                  style: TextStyle(
                    color: _qenet.color,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  _Pill(text: tr('አውታር ${f.$4}', 'String ${f.$4}'), color: AppColors.warning),
                  _Pill(text: noteFor(_qenet, target), color: _qenet.color),
                ]),
              ],
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  minHeight: 6,
                  backgroundColor: context.colors.background,
                  color: _qenet.color,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _levelDone
                    ? '${lvl.rounds}/${lvl.rounds}'
                    : tr('ዙር $shownRound ከ ${lvl.rounds}',
                        'Round $shownRound of ${lvl.rounds}'),
                style: TextStyle(color: context.colors.textSecondary, fontSize: 12),
              ),
              if (_notice != null) ...[
                const SizedBox(height: 8),
                Text(_notice!,
                    style: const TextStyle(color: AppColors.warning, fontSize: 12)),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (_levelDone) ...[
          PanelCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.check_circle_rounded, color: AppColors.success),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tr('ደረጃው ተጠናቀቀ!', 'Level cleared!'),
                      style: TextStyle(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 6),
                Text(
                  '${tr('ትክክለኛነት', 'Accuracy')}: $_lvlAccuracy% · '
                  '${tr('ረጅሙ ተከታታይ', 'Best streak')}: $_bestStreak',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 12),
                Row(children: [
                  if (_levelIndex + 1 < _levels.length) ...[
                    Expanded(
                      child: FilledButton(
                        onPressed: () => setState(() => _startLevel(_levelIndex + 1)),
                        child: Text(tr('ቀጣይ ደረጃ', 'Next level')),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => _startLevel(_levelIndex)),
                      child: Text(tr('እንደገና', 'Again')),
                    ),
                  ),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        Row(children: [
          Expanded(
            child: StatTile(
              label: tr('ትክክል', 'Correct'),
              value: '$_lvlCorrect',
              valueColor: AppColors.success,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatTile(
              label: tr('ስህተት', 'Wrong'),
              value: '$_lvlWrong',
              valueColor: AppColors.danger,
            ),
          ),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
            child: StatTile(
              label: tr('ትክክለኛነት', 'Accuracy'),
              value: '$_lvlAccuracy%',
              valueColor: _qenet.color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatTile(
              label: tr('ተከታታይ', 'Streak'),
              value: '$_streak',
              valueColor: AppColors.warning,
            ),
          ),
        ]),
        const SizedBox(height: 12),
        PanelCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${tr('ምዕራፍ', 'Ch.')} ${lvl.source}',
                style: TextStyle(color: context.colors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                tr(lvl.titleAm, lvl.titleEn),
                style: TextStyle(
                  color: context.colors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                tr(lvl.descAm, lvl.descEn),
                style: TextStyle(color: context.colors.textSecondary, height: 1.4),
              ),
              const Divider(height: 24),
              Text(
                tr(scale.name, scale.nameEn),
                style: TextStyle(color: context.colors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                scale.notes,
                style: TextStyle(
                  color: _qenet.color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${tr('የድምጽ ርቀት', 'Steps')}: ${scale.steps}',
                style: TextStyle(color: context.colors.textSecondary, fontSize: 12),
              ),
              if (scale.song.isNotEmpty)
                Text(
                  '${tr('ዜማ', 'Song')}: ${scale.song}',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 12),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        CameraControlsPanel(
          showStrings: _showStrings,
          onShowStringsChanged: (v) => setState(() => _showStrings = v),
          modeColor: AppColors.modeExercise,
        ),
      ],
    );
  }
}

class _LevelChip extends StatelessWidget {
  final int number;
  final String title;
  final bool selected;
  final bool cleared;
  final Color color;
  final VoidCallback onTap;

  const _LevelChip({
    required this.number,
    required this.title,
    required this.selected,
    required this.cleared,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.12) : c.surface,
          border: Border.all(
            color: selected ? color : c.textSecondary.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            cleared
                ? const Icon(Icons.check_circle_rounded,
                    size: 18, color: AppColors.success)
                : CircleAvatar(
                    radius: 9,
                    backgroundColor:
                        selected ? color : c.textSecondary.withValues(alpha: 0.25),
                    child: Text(
                      '$number',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: selected ? color : c.textSecondary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoteTile extends StatelessWidget {
  final String note;
  final String sub;
  final _TileState state;
  final Color color;

  const _NoteTile({
    required this.note,
    required this.sub,
    required this.state,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final bg = switch (state) {
      _TileState.done => AppColors.success.withValues(alpha: 0.12),
      _TileState.current => color,
      _TileState.upcoming => c.surface,
    };
    final fg = switch (state) {
      _TileState.done => AppColors.success,
      _TileState.current => Colors.white,
      _TileState.upcoming => c.textPrimary,
    };
    final border = switch (state) {
      _TileState.done => AppColors.success.withValues(alpha: 0.4),
      _TileState.current => color,
      _TileState.upcoming => c.textSecondary.withValues(alpha: 0.25),
    };
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 68,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            note,
            style: TextStyle(color: fg, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            style: TextStyle(color: fg.withValues(alpha: 0.75), fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color color;
  const _Pill({required this.text, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
        ),
      );
}
