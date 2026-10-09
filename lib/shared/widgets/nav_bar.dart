import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/section_nav.dart';
import '../../core/theme/brand_palette.dart';
import '../../core/constants/app_strings.dart';
import 'theme_toggle_button.dart';

/// On the one-page home: animate-scroll. Anywhere else: go home, then scroll.
void _goSection(BuildContext context, SiteSection s) {
  if (SectionNav.attached) {
    SectionNav.scrollTo(s);
  } else {
    context.go('/home?section=${s.name}');
  }
}

void _onMenuSelected(BuildContext context, String value) {
  if (value == 'shop') {
    context.go('/shop');
    return;
  }
  final section = SiteSection.values.firstWhere(
    (s) => s.name == value,
    orElse: () => SiteSection.home,
  );
  _goSection(context, section);
}

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        final isDesktop = MediaQuery.of(context).size.width > 900;
        final howToLabel = lang == Language.en ? 'How to use' : 'እንዴት መጠቀም';
        return Container(
          color: brand.background,
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16, vertical: 20),
          child: Row(
            children: [
              Text(
                AppStrings.get('app_title'),
                style: TextStyle(
                  color: brand.ink,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              if (isDesktop) ...[
                ValueListenableBuilder<SiteSection>(
                  valueListenable: SectionNav.active,
                  builder: (context, active, _) {
                    final current = SectionNav.attached ? active : null;
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _NavLink(
                          label: AppStrings.get('home'),
                          selected: current == SiteSection.home,
                          onTap: () => _goSection(context, SiteSection.home),
                        ),
                        _NavLink(
                          label: howToLabel,
                          selected: current == SiteSection.howTo,
                          onTap: () => _goSection(context, SiteSection.howTo),
                        ),
                        _NavLink(
                          label: AppStrings.get('shop'),
                          selected: false,
                          onTap: () => context.go('/shop'),
                        ),
                        _NavLink(
                          label: AppStrings.get('about'),
                          selected: current == SiteSection.about,
                          onTap: () => _goSection(context, SiteSection.about),
                        ),
                        _NavLink(
                          label: AppStrings.get('contact'),
                          selected: current == SiteSection.contact,
                          onTap: () => _goSection(context, SiteSection.contact),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(width: 8),
              ] else ...[
                PopupMenuButton<String>(
                  icon: Icon(Icons.menu_rounded, color: brand.ink),
                  onSelected: (value) => _onMenuSelected(context, value),
                  itemBuilder: (context) => [
                    PopupMenuItem(value: SiteSection.home.name, child: Text(AppStrings.get('home'))),
                    PopupMenuItem(value: SiteSection.howTo.name, child: Text(howToLabel)),
                    PopupMenuItem(value: 'shop', child: Text(AppStrings.get('shop'))),
                    PopupMenuItem(value: SiteSection.about.name, child: Text(AppStrings.get('about'))),
                    PopupMenuItem(value: SiteSection.contact.name, child: Text(AppStrings.get('contact'))),
                  ],
                ),
                const SizedBox(width: 4),
              ],
              const _LanguageToggle(),
              const SizedBox(width: 8),
              const ThemeToggleButton(),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => context.go('/login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: brand.amber,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: isDesktop ? 22 : 14, vertical: 13),
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
    final brand = context.brand;
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        return TextButton(
          onPressed: () {
            languageNotifier.value = lang == Language.en ? Language.am : Language.en;
          },
          child: Text(
            lang == Language.en ? 'አማ' : 'EN',
            style: TextStyle(
              color: brand.amber,
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
  final bool selected;
  final VoidCallback onTap;
  const _NavLink({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: TextButton(
        onPressed: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.only(bottom: 2),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected ? brand.amber : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? brand.amber : brand.ink.withValues(alpha: 0.7),
              fontSize: 13.5,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
