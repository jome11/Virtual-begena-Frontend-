import 'package:flutter/material.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/qenet.dart';
import '../../core/constants/mezmur_data.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/hand_tracking_service.dart';
import '../../shared/widgets/camera_panel.dart';
import '../../shared/widgets/panel_card.dart';
import '../../shared/widgets/stat_tile.dart';
import '../../shared/widgets/mode_app_bar.dart';

class MezmurTenatScreen extends StatefulWidget {
  const MezmurTenatScreen({super.key});
  @override
  State<MezmurTenatScreen> createState() => _MezmurTenatScreenState();
}

enum _Step { qenet, song, practice }

class _MezmurTenatScreenState extends State<MezmurTenatScreen> {
  _Step _step = _Step.qenet;
  Qenet? _qenet;
  // ignore: unused_field
  MezmurSong? _song;
  final int _correct = 0;
  final int _wrong = 0;
  final int _progress = 0;
  static const _total = 42;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        return Scaffold(
          backgroundColor: context.colors.background,
          appBar: _step == _Step.practice
              ? ModeAppBar(
                  modeLabel: (_qenet ?? Qenet.selamta).label,
                  modeColor: (_qenet ?? Qenet.selamta).color,
                  onBack: () => setState(() => _step = _Step.song),
                )
              : ModeAppBar(
                  modeLabel: AppStrings.get('mode_mezmur_tenat').toUpperCase(),
                  modeColor: AppColors.modeMezmurTenat,
                ),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: _buildStep(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case _Step.qenet:
        return _qenetCard();
      case _Step.song:
        return _songCard();
      case _Step.practice:
        return Padding(padding: const EdgeInsets.all(20), child: _practicePanel());
    }
  }

  Widget _qenetCard() => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 420),
    child: PanelCard(
      child: Column(
        children: [
          const SizedBox(height: 8),
          Text(
            AppStrings.get('mode_mezmur_tenat'),
            style: TextStyle(
              color: AppColors.modeMezmurTenat,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(AppStrings.get('feature_1_title'), style: TextStyle(color: context.colors.textSecondary)),
          const SizedBox(height: 16),
          Divider(color: context.colors.border),
          const SizedBox(height: 16),
          ...Qenet.values.map((q) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: OutlinedButton(
              onPressed: () => setState(() {
                _qenet = q;
                _step = _Step.song;
              }),
              style: OutlinedButton.styleFrom(
                foregroundColor: q.color,
                side: BorderSide(color: q.color),
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size.fromHeight(50),
              ),
              child: Text(q.label, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          )),
        ],
      ),
    ),
  );

  Widget _songCard() {
    final songs = mezmurLibrary[_qenet ?? Qenet.selamta] ?? [];
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: PanelCard(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Text(
              AppStrings.get('mode_mezmur_tenat'),
              style: TextStyle(
                color: AppColors.modeMezmurTenat,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${(_qenet ?? Qenet.selamta).label} — ${AppStrings.get('feature_1_title').toUpperCase()}',
              style: TextStyle(
                color: context.colors.accent,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            Divider(color: context.colors.border),
            const SizedBox(height: 12),
            ...songs.map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => setState(() {
                  _song = s;
                  _step = _Step.practice;
                  handTrackingService.start();
                }),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: context.colors.textSecondary.withValues(alpha: 0.25)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.title,
                        style: TextStyle(
                          color: context.colors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        s.amharic,
                        style: TextStyle(color: context.colors.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            )),
            const SizedBox(height: 4),
            TextButton(
              onPressed: () => setState(() => _step = _Step.qenet),
              child: Text('← ${AppStrings.get('back')}'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _practicePanel() {
    return LayoutBuilder(
      builder: (context, c) {
        final camera = CameraPanel(service: handTrackingService);
        final sidebar = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PanelCard(
              child: Column(children: [
                Text(AppStrings.get('accuracy'), style: TextStyle(color: context.colors.textSecondary, fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  '$_progress/$_total',
                  style: TextStyle(
                    color: AppColors.modeMezmurTenat,
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
            StatTile(
              label: AppStrings.get('accuracy'),
              value: (_correct + _wrong) == 0 ? '0%' : '${(_correct / (_correct + _wrong) * 100).toStringAsFixed(0)}%',
              valueColor: AppColors.modeMezmurTenat,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(onPressed: () => setState(() {}), icon: const Icon(Icons.refresh, size: 16), label: Text(AppStrings.get('restart'))),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () {
                handTrackingService.stop();
                setState(() => _step = _Step.song);
              },
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger, side: const BorderSide(color: AppColors.danger)),
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
    );
  }
}
