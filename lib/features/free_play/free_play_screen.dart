import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/qenet.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/hand_tracking_service.dart';
import '../../shared/widgets/camera_panel.dart';
import '../../shared/widgets/camera_feed_view.dart';
import '../../shared/widgets/panel_card.dart';
import '../../shared/widgets/qenet_selector.dart';
import '../../shared/widgets/mode_app_bar.dart';
import '../../shared/widgets/camera_controls_panel.dart';

class FreePlayScreen extends StatefulWidget {
  final bool guest;
  const FreePlayScreen({super.key, this.guest = false});
  @override
  State<FreePlayScreen> createState() => _FreePlayScreenState();
}

class _FreePlayScreenState extends State<FreePlayScreen> {
  static const _trialSeconds = 180;
  Qenet _qenet = Qenet.selamta;
  bool _showStrings = false;
  Timer? _timer;
  int _left = _trialSeconds;
  bool _expired = false;

  @override
  void initState() {
    super.initState();
    handTrackingService.start();
    handTrackingService.setVirtualStrings(_showStrings);
    if (widget.guest) {
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (!mounted) return;
        setState(() => _left--);
        if (_left <= 0) {
          t.cancel();
          _expired = true;
          handTrackingService.stop();
          _showTrialOver();
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    if (!_expired) handTrackingService.stop();
    super.dispose();
  }

  void _showTrialOver() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Your free trial has ended'),
        content: const Text(
          'Create a free account to keep playing, track your progress, and unlock every practice mode.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go('/home');
            },
            child: const Text('Back to home'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go('/login');
            },
            child: const Text('Log in'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go('/signup');
            },
            child: const Text('Sign up free'),
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
            modeLabel: widget.guest
                ? 'FREE TRIAL'
                : AppStrings.get('mode_free_play').toUpperCase(),
            modeColor: AppColors.modeFreePlay,
            onBack: widget.guest ? () => context.go('/home') : null,
            leading: QenetSelector(selected: _qenet, onChanged: (q) => setState(() => _qenet = q)),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: LayoutBuilder(
              builder: (context, c) {
                final camera = CameraPanel(service: handTrackingService, readyChild: const CameraFeedView());
                final panel = Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.guest) ...[
                      _TrialBanner(secondsLeft: _left),
                      const SizedBox(height: 16),
                    ],
                    PanelCard(
                      child: Column(children: [
                        const Icon(Icons.music_note, color: AppColors.modeTuning, size: 32),
                        const SizedBox(height: 12),
                        Text(
                          AppStrings.get('mode_free_play_sub'),
                          style: TextStyle(
                            color: context.colors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          AppStrings.get('feature_2_desc'),
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
                          AppStrings.get('ready'),
                          style: TextStyle(color: context.colors.textSecondary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CameraControlsPanel(
                      showStrings: _showStrings,
                      onShowStringsChanged: (v) => setState(() => _showStrings = v),
                      modeColor: AppColors.modeFreePlay,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () => context.go(widget.guest ? '/home' : '/dashboard'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.danger,
                        side: const BorderSide(color: AppColors.danger),
                      ),
                      icon: const Icon(Icons.close, size: 16),
                      label: Text(AppStrings.get('exit')),
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
      },
    );
  }
}

class _TrialBanner extends StatelessWidget {
  final int secondsLeft;
  const _TrialBanner({required this.secondsLeft});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final m = (secondsLeft.clamp(0, 999) ~/ 60).toString();
    final s = (secondsLeft.clamp(0, 999) % 60).toString().padLeft(2, '0');
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.accent.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timer_outlined, size: 18, color: c.accent),
              const SizedBox(width: 8),
              Text('Free trial · $m:$s left',
                  style: TextStyle(
                      color: c.textPrimary, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 6),
          Text('Sign up to unlock all modes and save your progress.',
              style: TextStyle(color: c.textSecondary, fontSize: 12)),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => context.go('/signup'),
              child: const Text('Sign up free'),
            ),
          ),
        ],
      ),
    );
  }
}
