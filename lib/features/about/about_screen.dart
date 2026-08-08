import 'package:flutter/material.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../core/constants/app_strings.dart';
import '../../shared/widgets/nav_bar.dart';
import '../../shared/widgets/site_footer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
                      AppStrings.get('about'),
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
                          _Paragraph(
                            context,
                            AppStrings.get('about_lead'),
                            lead: true,
                          ),
                          _Heading(context, AppStrings.get('about_what_heading')),
                          _Paragraph(
                            context,
                            AppStrings.get('about_what_body'),
                          ),
                          _Heading(context, AppStrings.get('about_why_heading')),
                          _Paragraph(
                            context,
                            AppStrings.get('about_why_body'),
                          ),
                          _Heading(context, AppStrings.get('about_how_heading')),
                          _Paragraph(
                            context,
                            AppStrings.get('about_how_body'),
                          ),
                          _Heading(context, AppStrings.get('about_note_heading')),
                          _Paragraph(
                            context,
                            AppStrings.get('about_note_body'),
                          ),
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

class _Heading extends StatelessWidget {
  final BuildContext ctx;
  final String text;
  const _Heading(this.ctx, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 10),
      child: Text(
        text,
        style: TextStyle(
          color: ctx.colors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  final BuildContext ctx;
  final String text;
  final bool lead;
  const _Paragraph(this.ctx, this.text, {this.lead = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: ctx.colors.textSecondary,
        fontSize: lead ? 18 : 15,
        height: 1.6,
        fontWeight: lead ? FontWeight.w500 : FontWeight.normal,
      ),
    );
  }
}
