import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_strings.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, child) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.isDesktop(context)
                ? AppConstants.desktopHorizontalPadding
                : AppConstants.horizontalPadding,
          ),
          height: 80,
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.get('app_title'),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              Row(
                children: [
                  if (Responsive.isDesktop(context))
                    Row(
                      children: [
                        _NavLink(title: AppStrings.get('home'), onTap: () {}),
                        _NavLink(title: AppStrings.get('about'), onTap: () {}),
                        _NavLink(title: AppStrings.get('lessons'), onTap: () {}),
                        _NavLink(title: AppStrings.get('contact'), onTap: () {}),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                          ),
                          child: Text(AppStrings.get('get_started')),
                        ),
                      ],
                    ),
                  const SizedBox(width: 20),
                  const _LanguageToggle(),
                  if (!Responsive.isDesktop(context))
                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _LanguageToggle extends StatelessWidget {
  const _LanguageToggle();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, child) {
        return TextButton(
          onPressed: () {
            languageNotifier.value =
                lang == Language.en ? Language.am : Language.en;
          },
          child: Text(
            lang == Language.en ? 'አማ' : 'EN',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}

class _NavLink extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _NavLink({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextButton(
        onPressed: onTap,
        child: Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
