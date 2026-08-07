import 'package:flutter/material.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../shared/widgets/panel_card.dart';
import '../../shared/widgets/mode_app_bar.dart';

const _targets = ['F', 'C', 'C#', 'D', 'C#', 'A', 'F#', 'G', 'A', 'F'];
const _notes = ['F', 'C', 'C#', 'A', 'F#'];

class TuningScreen extends StatefulWidget {
  const TuningScreen({super.key});
  @override
  State<TuningScreen> createState() => _TuningScreenState();
}

class _TuningScreenState extends State<TuningScreen> {
  int _selected = 5; // string 6 (0-indexed)
  final List<String> _current = List.generate(10, (i) => _targets[i] == 'D' ? 'C#' : _targets[i]);

  @override
  Widget build(BuildContext context) {
    final target = _targets[_selected];
    final current = _current[_selected];
    // ignore: unused_local_variable
    final inTune = current == target;

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
                final diagram = _buildDiagram();
                final panel = _buildPanel(target, current);
                if (c.maxWidth < 800) {
                  return SingleChildScrollView(child: Column(children: [diagram, const SizedBox(height: 16), panel]));
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: diagram),
                    const SizedBox(width: 20),
                    SizedBox(width: 300, child: panel)
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildDiagram() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(10, (i) {
              final active = i == _selected;
              return GestureDetector(
                onTap: () => setState(() => _selected = i),
                child: Column(children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: active ? AppColors.modeTuning : context.colors.background,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: active ? AppColors.modeTuning : context.colors.textSecondary.withValues(alpha: 0.4),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          color: active ? Colors.white : context.colors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ]),
              );
            }),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: CustomPaint(
              size: Size.infinite,
              painter: _StringsPainter(
                selected: _selected,
                color: AppColors.modeTuning,
                secondaryColor: context.colors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: context.colors.background,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              children: _notes.map((n) {
                final active = n == _current[_selected];
                return Chip(
                  label: Text(
                    n,
                    style: TextStyle(
                      color: active ? Colors.white : context.colors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: active ? AppColors.modeTuning : context.colors.surface,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanel(String target, String current) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      PanelCard(
        child: Column(children: [
          Text(AppStrings.get('mode_tuning'), style: TextStyle(color: context.colors.textSecondary, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            '${AppStrings.get('ready')} ${_selected + 1}',
            style: const TextStyle(color: AppColors.modeTuning, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(current, style: TextStyle(color: context.colors.textPrimary, fontSize: 36, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: TextStyle(color: context.colors.textSecondary, fontSize: 13),
              children: [
                const TextSpan(text: 'Target: '),
                TextSpan(text: target, style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold))
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(AppStrings.get('accuracy'), style: TextStyle(color: context.colors.textSecondary.withValues(alpha: 0.7), fontSize: 12)),
        ]),
      ),
      const SizedBox(height: 16),
      PanelCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(AppStrings.get('ready'), style: TextStyle(color: context.colors.textSecondary, fontSize: 13)),
          const SizedBox(height: 4),
          Text(AppStrings.get('mode_tuning_sub'), style: TextStyle(color: context.colors.textSecondary, fontSize: 13)),
        ]),
      ),
      const SizedBox(height: 16),
      ElevatedButton.icon(
        onPressed: () => setState(() => _current[_selected] = target),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.success,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        icon: const Icon(Icons.check),
        label: Text(AppStrings.get('ready'), style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      const SizedBox(height: 10),
      OutlinedButton.icon(
        onPressed: () => setState(() => _current[_selected] = _targets[_selected] == 'D' ? 'C#' : _targets[_selected]),
        icon: const Icon(Icons.refresh, size: 16),
        label: Text(AppStrings.get('restart')),
      ),
    ],
  );
}

class _StringsPainter extends CustomPainter {
  final int selected;
  final Color color;
  final Color secondaryColor;
  _StringsPainter({required this.selected, required this.color, required this.secondaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final pegSpacing = size.width / 11;
    final boxTop = size.height * 0.8;
    final boxCenterX = size.width / 2;
    for (int i = 0; i < 10; i++) {
      final startX = pegSpacing * (i + 1);
      final active = i == selected;
      final paint = Paint()
        ..color = active ? color : secondaryColor.withValues(alpha: 0.35)
        ..strokeWidth = active ? 2.4 : 1.2;
      canvas.drawLine(Offset(startX, 0), Offset(boxCenterX, boxTop), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StringsPainter old) => old.selected != selected;
}
