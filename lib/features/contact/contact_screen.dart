import 'package:flutter/material.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../core/constants/app_strings.dart';
import '../../shared/widgets/nav_bar.dart';
import '../../shared/widgets/site_footer.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

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
                  height: 400,
                  width: double.infinity,
                  color: context.colors.background.withValues(alpha: 0.6),
                  child: Center(
                    child: Text(
                      AppStrings.get('contact'),
                      style: TextStyle(
                        color: context.colors.textPrimary,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
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
