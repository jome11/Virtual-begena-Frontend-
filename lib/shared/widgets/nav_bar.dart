import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/section_nav.dart';
import '../../core/theme/brand_palette.dart';
import '../../core/constants/app_strings.dart';
import 'theme_toggle_button.dart';

const _cta = Color(0xFF2563EB);

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
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        final width = MediaQuery.of(context).size.width;
        final wide = width >= 1200; // show the links in the bar
        final compact = width < 700; // phones: hide Sign In
        final howToLabel = lang == Language.en ? 'How to use' : 'እንዴት መጠቀም';

        return Container(
          decoration: BoxDecoration(
            color: brand.background,
            border: Border(
              bottom: BorderSide(color: brand.beige.withValues(alpha: 0.6)),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: wide ? 32 : 16, vertical: 12),
          child: Row(
            children: [
              Text(
                AppStrings.get('app_title'),
                style: TextStyle(
                  color: brand.amber,
                  fontSize: compact ? 17 : 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              if (wide)
                Expanded(
                  child: Center(
                    child: ValueListenableBuilder<SiteSection>(
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
                  ),
                )
              else ...[
                const Spacer(),
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
              ],
              const SizedBox(width: 4),
              const _LanguageToggle(),
              const SizedBox(width: 8),
              if (!compact) ...[
                OutlinedButton(
                  onPressed: () => context.go('/login'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: brand.ink,
                    side: BorderSide(color: brand.beige),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    AppStrings.get('sign_in'),
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              ElevatedButton(
                onPressed: () => context.go('/signup'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _cta,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? 12 : 18,
                    vertical: compact ? 10 : 12,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!compact) ...[
                      const Icon(Icons.rocket_launch_outlined, size: 18),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      AppStrings.get('get_started'),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: compact ? 12.5 : 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: brand.beige),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const ThemeToggleButton(),
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
              fontSize: 15,
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
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          backgroundColor:
              selected ? brand.amber.withValues(alpha: 0.18) : Colors.transparent,
          foregroundColor: selected ? brand.amber : brand.ink,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
