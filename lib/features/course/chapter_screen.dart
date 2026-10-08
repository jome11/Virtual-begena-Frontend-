import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_strings.dart';
import '../../core/data/curriculum.dart';
import '../../core/services/course_progress_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/brand_palette.dart';
import '../../shared/widgets/blue_fade_background.dart';
import '../../shared/widgets/mode_app_bar.dart';
import 'chapter_widgets.dart';

class ChapterScreen extends StatefulWidget {
  final int number;
  final int initialTab;
  const ChapterScreen({super.key, required this.number, this.initialTab = 0});

  @override
  State<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  late int _tab = widget.initialTab;
  CourseSnapshot _snap = const CourseSnapshot({}, {});

  Chapter get _ch =>
      chapters[(widget.number - 1).clamp(0, chapters.length - 1)];

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    final s = await CourseProgress.load();
    if (mounted) setState(() => _snap = s);
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final ch = _ch;
    final n = ch.number;
    return Scaffold(
      appBar: ModeAppBar(
        modeLabel: 'CHAPTER $n',
        modeColor: AppColors.modeProgress,
        onBack: () => context.go('/course'),
      ),
      body: BlueFadeBackground(
        child: ValueListenableBuilder<Language>(
          valueListenable: languageNotifier,
          builder: (context, lang, _) {
            final tabs = [tr('ትምህርት', 'Learn'), tr('ፈተና', 'Quiz'), tr('ተግባር', 'Assignment')];
            return SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 56),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton.icon(
                              onPressed: () => context.go('/course'),
                              icon: const Icon(Icons.arrow_back_rounded, size: 18),
                              label: Text(tr('ወደ ኮርሱ', 'Back to course')),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              clipBehavior: Clip.antiAlias,
                              padding: const EdgeInsets.all(28),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF0B1F4B), Color(0xFF2563EB)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF2563EB).withValues(alpha: 0.25),
                                    blurRadius: 30,
                                    offset: const Offset(0, 14),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    right: -4,
                                    top: -20,
                                    child: Text(
                                      '$n',
                                      style: TextStyle(
                                        fontSize: 120,
                                        height: 1,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white.withValues(alpha: 0.10),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(ch.icon, color: Colors.white70, size: 18),
                                          const SizedBox(width: 8),
                                          Text(
                                            '${tr('ምዕራፍ', 'CHAPTER')} $n',
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 60),
                                        child: Text(
                                          tr(ch.title, ch.titleEn),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 26,
                                            fontWeight: FontWeight.w800,
                                            height: 1.3,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.16),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          () {
                                            final words = ch.points.join(' ').split(' ').length;
                                            final m = (words / 120).ceil().clamp(1, 99);
                                            return tr('~$m ደቂቃ ንባብ', '~$m min read');
                                          }(),
                                          style: const TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (lang == Language.en) ...[
                              const SizedBox(height: 10),
                              Text('Lesson text is currently in Amharic, taken from the lesson plan.',
                                  style: TextStyle(color: brand.inkMuted, fontSize: 12)),
                            ],
                            const SizedBox(height: 20),
                            Wrap(
                              spacing: 8,
                              children: [
                                for (var i = 0; i < tabs.length; i++)
                                  ChoiceChip(
                                    label: Text(tabs[i]),
                                    selected: _tab == i,
                                    showCheckmark: false,
                                    selectedColor: brand.amber,
                                    labelStyle: TextStyle(
                                        color: _tab == i ? Colors.white : brand.ink,
                                        fontWeight: FontWeight.w700),
                                    onSelected: (_) => setState(() => _tab = i),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            if (_tab == 0) _learn(ch),
                            if (_tab == 1) ...[
                              if (examsFor.containsKey(n)) ...[
                                _ExamCard(chapter: n, snap: _snap),
                                const SizedBox(height: 16),
                              ],
                              _Quiz(
                                key: ValueKey('quiz$n'),
                                chapter: ch,
                                best: _snap.quiz[n] ?? 0,
                                onFinished: (score) async {
                                  await CourseProgress.saveQuiz(n, score);
                                  _reload();
                                },
                              ),
                            ],
                            if (_tab == 2)
                              _AssignmentTab(
                                key: ValueKey('assign$n'),
                                chapter: ch,
                                done: _snap.assignments.contains(n),
                                onChanged: _reload,
                              ),
                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (n > 1)
                                  TextButton.icon(
                                    onPressed: () => context.go('/course/${n - 1}'),
                                    icon: const Icon(Icons.chevron_left_rounded),
                                    label: Text(tr('ቀዳሚ ምዕራፍ', 'Previous chapter')),
                                  )
                                else
                                  const SizedBox(),
                                if (n < chapters.length)
                                  TextButton.icon(
                                    onPressed: () => context.go('/course/${n + 1}'),
                                    icon: const Icon(Icons.chevron_right_rounded),
                                    iconAlignment: IconAlignment.end,
                                    label: Text(tr('ቀጣይ ምዕራፍ', 'Next chapter')),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _para(String p, {bool lead = false}) {
    final brand = context.brand;
    final isVerse = RegExp(r'^\S+\s\d+፥\d+').hasMatch(p);
    if (isVerse) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 4, 0, 4),
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: brand.amber, width: 3)),
          ),
          child: Text(
            p,
            style: TextStyle(
              color: brand.ink,
              fontSize: 17,
              height: 1.9,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.only(bottom: lead ? 22 : 16),
      child: Text(
        p,
        style: TextStyle(
          color: lead ? brand.ink : brand.ink.withValues(alpha: 0.88),
          fontSize: lead ? 19 : 16.5,
          height: lead ? 1.9 : 1.95,
          fontWeight: lead ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }

  Widget _learn(Chapter ch) {
    final brand = context.brand;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < ch.points.length; i++)
                _para(ch.points[i], lead: i == 0),
            ],
          ),
        ),
        if (ch.tool != null) ...[
          const SizedBox(height: 20),
          Divider(color: brand.beige),
          const SizedBox(height: 24),
        ],
        if (ch.tool == 'parts') const PartsExplorer(),
        if (ch.tool == 'fingers') const FingerChart(),
        if (ch.tool == 'qenet') const QenetExplorer(),
        const SizedBox(height: 32),
        FilledButton(
          onPressed: () => setState(() => _tab = 1),
          style: FilledButton.styleFrom(
            backgroundColor: brand.amber,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          ),
          child: Text(tr('ወደ ፈተናው', 'Take the quiz')),
        ),
      ],
    );
  }
}

class _Quiz extends StatefulWidget {
  final Chapter chapter;
  final int best;
  final ValueChanged<int> onFinished;
  const _Quiz({super.key, required this.chapter, required this.best, required this.onFinished});

  @override
  State<_Quiz> createState() => _QuizState();
}

class _QuizState extends State<_Quiz> {
  late final List<List<String>> _opts = [
    for (final q in widget.chapter.quiz) ([...q.options]..shuffle(Random())),
  ];
  int _i = 0;
  int _score = 0;
  String? _picked;
  bool _done = false;

  String get _correct => widget.chapter.quiz[_i].options.first;

  void _pick(String o) {
    if (_picked != null) return;
    setState(() {
      _picked = o;
      if (o == _correct) _score++;
    });
  }

  void _next() {
    if (_i + 1 < widget.chapter.quiz.length) {
      setState(() {
        _i++;
        _picked = null;
      });
    } else {
      setState(() => _done = true);
      widget.onFinished(_score);
    }
  }

  void _retry() => setState(() {
        _i = 0;
        _score = 0;
        _picked = null;
        _done = false;
      });

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final total = widget.chapter.quiz.length;
    if (_done) {
      final pass = _score >= 2;
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: panelDecoration(context),
        child: Column(
          children: [
            Icon(pass ? Icons.emoji_events_rounded : Icons.menu_book_rounded,
                size: 48, color: pass ? const Color(0xFFF59E0B) : brand.amber),
            const SizedBox(height: 12),
            Text('$_score / $total',
                style: TextStyle(color: brand.ink, fontSize: 36, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(
                pass
                    ? tr('እንኳን ደስ አለዎት!', 'Well done!')
                    : tr('ምዕራፉን እንደገና አንብበው ይሞክሩ።', 'Re-read the chapter and try again.'),
                style: TextStyle(color: brand.inkMuted)),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: _retry, child: Text(tr('እንደገና', 'Try again'))),
          ],
        ),
      );
    }
    final q = widget.chapter.quiz[_i];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: panelDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${_i + 1} / $total',
              style: TextStyle(color: brand.inkMuted, fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(q.q,
              style: TextStyle(color: brand.ink, fontSize: 18, fontWeight: FontWeight.w700, height: 1.5)),
          const SizedBox(height: 16),
          for (final o in _opts[_i])
            Builder(builder: (_) {
              final picked = _picked != null;
              final isCorrect = o == _correct;
              Color border = brand.beige;
              Color fill = Colors.transparent;
              if (picked && isCorrect) {
                border = const Color(0xFF10B981);
                fill = const Color(0xFF10B981).withValues(alpha: 0.12);
              } else if (picked && o == _picked) {
                border = const Color(0xFFEF4444);
                fill = const Color(0xFFEF4444).withValues(alpha: 0.12);
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _pick(o),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: fill,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: border, width: 1.5),
                    ),
                    child: Text(o, style: TextStyle(color: brand.ink, height: 1.4)),
                  ),
                ),
              );
            }),
          if (_picked != null) ...[
            const SizedBox(height: 8),
            FilledButton(
              onPressed: _next,
              style: FilledButton.styleFrom(backgroundColor: brand.amber),
              child: Text(_i + 1 < total ? tr('ቀጣይ', 'Next') : tr('ጨርስ', 'Finish')),
            ),
          ],
          if (widget.best > 0) ...[
            const SizedBox(height: 14),
            Text(tr('ምርጥ ውጤትዎ፦ ${widget.best}/$total', 'Your best: ${widget.best}/$total'),
                style: TextStyle(color: brand.inkMuted, fontSize: 12)),
          ],
        ],
      ),
    );
  }
}

class _AssignmentTab extends StatefulWidget {
  final Chapter chapter;
  final bool done;
  final VoidCallback onChanged;
  const _AssignmentTab({super.key, required this.chapter, required this.done, required this.onChanged});

  @override
  State<_AssignmentTab> createState() => _AssignmentTabState();
}

class _AssignmentTabState extends State<_AssignmentTab> {
  final _c = TextEditingController();
  late bool _done = widget.done;

  @override
  void initState() {
    super.initState();
    CourseProgress.assignmentText(widget.chapter.number).then((t) {
      if (mounted) _c.text = t;
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Future<void> _save(bool done) async {
    await CourseProgress.saveAssignment(widget.chapter.number, _c.text, done);
    if (!mounted) return;
    setState(() => _done = done);
    widget.onChanged();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(tr('ተቀምጧል', 'Saved'))));
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final n = widget.chapter.number;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: panelDecoration(context),
          child: Text(widget.chapter.assignment,
              style: TextStyle(color: brand.ink, fontSize: 16, height: 1.7)),
        ),
        if (n == 5 || n == 6) ...[
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              OutlinedButton.icon(
                onPressed: () => context.go('/exercise?qenet=selamta'),
                icon: const Icon(Icons.bolt_rounded),
                label: Text(tr('ሰላምታ ይለማመዱ', 'Practice Selamta')),
              ),
              if (n == 6)
                OutlinedButton.icon(
                  onPressed: () => context.go('/exercise?qenet=tezeta'),
                  icon: const Icon(Icons.bolt_rounded),
                  label: Text(tr('ትዝታ ይለማመዱ', 'Practice Tezeta')),
                ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        TextField(
          controller: _c,
          minLines: 5,
          maxLines: 12,
          decoration: InputDecoration(
            hintText: tr('መልስዎን እዚህ ይጻፉ…', 'Write your answer here…'),
            filled: true,
            fillColor: brand.surface,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            OutlinedButton(
                onPressed: () => _save(_done), child: Text(tr('አስቀምጥ', 'Save draft'))),
            FilledButton.icon(
              onPressed: () => _save(!_done),
              style: FilledButton.styleFrom(
                  backgroundColor: _done ? const Color(0xFF10B981) : brand.amber),
              icon: Icon(_done ? Icons.check_rounded : Icons.flag_rounded),
              label: Text(_done ? tr('ተጠናቋል', 'Done') : tr('እንደተጠናቀቀ ምልክት አድርግ', 'Mark as done')),
            ),
          ],
        ),
      ],
    );
  }
}

const _qn = {
  'selamta': ('ሰላምታ', 'Selamta'),
  'tezeta': ('ትዝታ', 'Tezeta'),
  'anchihoye': ('አንቺ ሆዬ', 'Anchihoye'),
};

class _ExamCard extends StatelessWidget {
  final int chapter;
  final CourseSnapshot snap;
  const _ExamCard({required this.chapter, required this.snap});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: panelDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.front_hand_rounded, color: brand.amber),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                  tr('የተግባር ፈተና — በበገና ይጫወቱ', 'Practical test: play it on the begena'),
                  style: TextStyle(
                      color: brand.ink, fontWeight: FontWeight.w800, fontSize: 16)),
            ),
          ]),
          const SizedBox(height: 8),
          Text(
              tr('10 ማስታወሻዎችን በትክክለኛው ጣት ይንኩ፤ ለማለፍ $examPassAccuracy% ያስፈልጋል።',
                  'Pluck 10 notes with the right finger. You need $examPassAccuracy% to pass.'),
              style: TextStyle(color: brand.inkMuted, height: 1.5)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final q in examsFor[chapter]!)
                FilledButton.icon(
                  onPressed: () => context.go('/exam?qenet=$q'),
                  style: FilledButton.styleFrom(
                    backgroundColor: (snap.exams[q] ?? 0) >= examPassAccuracy
                        ? const Color(0xFF10B981)
                        : brand.amber,
                  ),
                  icon: Icon((snap.exams[q] ?? 0) >= examPassAccuracy
                      ? Icons.check_rounded
                      : Icons.play_arrow_rounded),
                  label: Text(
                      '${tr(_qn[q]!.$1, _qn[q]!.$2)}${(snap.exams[q] ?? 0) >= examPassAccuracy ? ' · ${snap.exams[q]}%' : ''}'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
