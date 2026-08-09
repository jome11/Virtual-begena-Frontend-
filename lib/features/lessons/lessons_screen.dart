import 'package:flutter/material.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/content/begena_about_content.dart';
import '../../shared/widgets/nav_bar.dart';
import '../../shared/widgets/site_footer.dart';
import '../../shared/widgets/panel_card.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        return Scaffold(
          appBar: const NavBar(),
          backgroundColor: context.colors.background,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  width: double.infinity,
                  color: context.colors.background.withValues(alpha: 0.6),
                  child: Center(
                    child: Text(
                      AppStrings.get('lessons'),
                      style: TextStyle(
                        color: context.colors.textPrimary,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _AboutBegenaSection(lang: lang),
                          const SizedBox(height: 24),
                          _QenetCard(
                            title: AppStrings.get('qenet_selamta_title'),
                            description: AppStrings.get('qenet_selamta_desc'),
                          ),
                          const SizedBox(height: 12),
                          _QenetCard(
                            title: AppStrings.get('qenet_tezeta_title'),
                            description: AppStrings.get('qenet_tezeta_desc'),
                          ),
                          const SizedBox(height: 12),
                          _QenetCard(
                            title: AppStrings.get('qenet_anchihoye_title'),
                            description: AppStrings.get('qenet_anchihoye_desc'),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            AppStrings.get('practice_structure_heading'),
                            style: TextStyle(color: context.colors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          _ModeCard(
                            title: AppStrings.get('mode_exercise_full_title'),
                            description: AppStrings.get('mode_exercise_full_desc'),
                            color: AppColors.modeExercise,
                          ),
                          const SizedBox(height: 12),
                          _ModeCard(
                            title: AppStrings.get('mode_free_play_full_title'),
                            description: AppStrings.get('mode_free_play_full_desc'),
                            color: AppColors.warning,
                          ),
                          const SizedBox(height: 32),
                          Text(
                            AppStrings.get('tips_heading'),
                            style: TextStyle(color: context.colors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          _Tip(context, AppStrings.get('tip_calibrate')),
                          _Tip(context, AppStrings.get('tip_show_strings')),
                          _Tip(context, AppStrings.get('tip_start_selamta')),
                        ],
                      ),
                    ),
                  ),
                ),
                const SiteFooter(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AboutBegenaSection extends StatelessWidget {
  final Language lang;
  const _AboutBegenaSection({required this.lang});

  @override
  Widget build(BuildContext context) {
    final blocks = lang == Language.am ? begenaAboutAm : begenaAboutEn;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final block in blocks) ...[
          if (block.heading != null) ...[
            Text(
              block.heading!,
              style: TextStyle(
                  color: context.colors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
          ],
          if (block.paragraph != null) ...[
            Text(
              block.paragraph!,
              style: TextStyle(color: context.colors.textSecondary, fontSize: 15, height: 1.7),
            ),
            const SizedBox(height: 12),
          ],
          if (block.bullets != null) ...[
            for (final b in block.bullets!)
              Padding(
                padding: const EdgeInsets.only(bottom: 6, left: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.circle, size: 5, color: context.colors.accent),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(b,
                            style: TextStyle(
                                color: context.colors.textSecondary,
                                fontSize: 14.5,
                                height: 1.6))),
                  ],
                ),
              ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _QenetCard extends StatelessWidget {
  final String title;
  final String description;
  const _QenetCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return PanelCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: context.colors.accent, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(description, style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.5)),
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final String title;
  final String description;
  final Color color;
  const _ModeCard({required this.title, required this.description, required this.color});

  @override
  Widget build(BuildContext context) {
    return PanelCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 4, height: 48, color: color, margin: const EdgeInsets.only(right: 14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: context.colors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(description, style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tip extends StatelessWidget {
  final BuildContext ctx;
  final String text;
  const _Tip(this.ctx, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, size: 6, color: ctx.colors.accent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: TextStyle(color: ctx.colors.textSecondary, fontSize: 14, height: 1.5)),
          ),
        ],
      ),
    );
  }
}
