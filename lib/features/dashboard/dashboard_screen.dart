import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/auth_service.dart';
import 'widgets/feature_card.dart';
import 'widgets/streak_banner.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: authService,
      builder: (context, _) {
        return ValueListenableBuilder<Language>(
          valueListenable: languageNotifier,
          builder: (context, lang, child) {
            final items = [
              (AppStrings.get('mode_exercise'), AppStrings.get('mode_exercise_sub'), Icons.bolt_rounded, AppColors.modeExercise, '/exercise'),
              (AppStrings.get('mode_free_play'), AppStrings.get('mode_free_play_sub'), Icons.music_note_rounded, AppColors.modeFreePlay, '/free-play'),
              (AppStrings.get('mode_tuning'), AppStrings.get('mode_tuning_sub'), Icons.tune_rounded, AppColors.modeTuning, '/tuning'),
              (AppStrings.get('mode_mezmur_tenat'), AppStrings.get('mode_mezmur_tenat_sub'), Icons.library_music_rounded, AppColors.modeMezmurTenat, '/mezmur-tenat'),
              (AppStrings.get('mode_progress'), AppStrings.get('mode_progress_sub'), Icons.bar_chart_rounded, AppColors.modeProgress, '/progress'),
              (AppStrings.get('mode_training_plan'), AppStrings.get('mode_training_plan_sub'), Icons.psychology_alt_rounded, AppColors.modeTrainingPlan, '/training-plan'),
            ];

            return Scaffold(
              backgroundColor: context.colors.background,
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width > 1400 ? 80 : 32,
                    vertical: 24,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.get('dashboard_title'),
                          style: TextStyle(
                            color: context.colors.textPrimary,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          AppStrings.get('dashboard_subtitle'),
                          style: TextStyle(
                            color: context.colors.textSecondary.withValues(alpha: 0.9),
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 24),
                        StreakBanner(
                          username: authService.currentUsername ?? '—',
                          onSignOut: () async {
                            await authService.signOut();
                            if (context.mounted) context.go('/login');
                          },
                        ),
                        const SizedBox(height: 32),
                        LayoutBuilder(
                          builder: (context, c) {
                            int cols;
                            if (c.maxWidth > 1200) {
                              cols = 4;
                            } else if (c.maxWidth > 800) {
                              cols = 3;
                            } else if (c.maxWidth > 500) {
                              cols = 2;
                            } else {
                              cols = 1;
                            }
                            return GridView.count(
                              crossAxisCount: cols,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              mainAxisSpacing: 18,
                              crossAxisSpacing: 18,
                              childAspectRatio: cols == 1 ? 2.6 : 1.35,
                              children: items
                                  .map((i) => FeatureCard(
                                        label: i.$1,
                                        subtitle: i.$2,
                                        icon: i.$3,
                                        color: i.$4,
                                        onTap: () => context.go(i.$5),
                                      ))
                                  .toList(),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Text(
                            'v1.0.0',
                            style: TextStyle(
                              color: context.colors.textSecondary.withValues(alpha: 0.5),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
