import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';
import 'theme_toggle_button.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        return Container(
          color: AppColors.brandCream,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          child: Row(
            children: [
              Text(
                AppStrings.get('app_title'),
                style: const TextStyle(
                  color: AppColors.brandInk,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              if (MediaQuery.of(context).size.width > 700) ...[
                _NavLink(label: AppStrings.get('home'), onTap: () => context.go('/home')),
                _NavLink(label: AppStrings.get('lessons'), onTap: () => context.go('/lessons')),
                _NavLink(label: AppStrings.get('about'), onTap: () => context.go('/about')),
                _NavLink(label: AppStrings.get('contact'), onTap: () => context.go('/contact')),
                const SizedBox(width: 8),
              ],
              const _LanguageToggle(),
              const SizedBox(width: 8),
              const ThemeToggleButton(),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => context.go('/login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandAmber,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                child: Text(
                  AppStrings.get('get_started'),
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LanguageToggle extends StatelessWidget {
  const _LanguageToggle();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        return TextButton(
          onPressed: () {
            languageNotifier.value = lang == Language.en ? Language.am : Language.en;
          },
          child: Text(
            lang == Language.en ? 'አማ' : 'EN',
            style: const TextStyle(
              color: AppColors.brandAmber,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        );
      },
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _NavLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14),
    child: TextButton(
      onPressed: onTap,
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.brandInk.withValues(alpha: 0.7),
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
