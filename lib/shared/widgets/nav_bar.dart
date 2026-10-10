import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/section_nav.dart';
import '../../core/theme/brand_palette.dart';
import '../../core/constants/app_strings.dart';
import 'theme_toggle_button.dart';
import 'language_toggle.dart';

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
  Size get preferredSize => const Size.fromHeight(96);

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        final width = MediaQuery.of(context).size.width;
        final wide = width >= 1300;
        final compact = width < 700;
        final howToLabel = lang == Language.en ? 'How to use' : 'እንዴት መጠቀም';

        final logo = InkWell(
          onTap: () => context.go('/home'),
          child: Image.asset(
            Theme.of(context).brightness == Brightness.dark
                ? 'assets/images/logodarkmode.jpg'
                : 'assets/images/logolighmode.jpg',
            height: compact ? 60 : 76,
            fit: BoxFit.contain,
          ),
        );

        // Floating controls: sit directly on the page background.
        final controls = FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _LanguageToggle(),
              const SizedBox(width: 8),
              if (!compact) ...[
                OutlinedButton(
                  onPressed: () => context.go('/login'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: brand.ink,
                    side: BorderSide(color: brand.ink.withValues(alpha: 0.3)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text(
                    AppStrings.get('sign_in'),
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              ElevatedButton(
                onPressed: () => context.go('/signup'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: brand.amber,
                  foregroundColor: brand.background,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? 14 : 20,
                    vertical: compact ? 12 : 14,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                        fontSize: compact ? 13 : 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: brand.amber.withValues(alpha: 0.5)),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const ThemeToggleButton(),
              ),
            ],
          ),
        );

        // Glass pill: only the five links.
        final links = _Glass(
          radius: 28,
          padding: const EdgeInsets.all(6),
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
        );

        // Smaller screens: the links live in a glass menu button.
        final menu = _Glass(
          radius: 22,
          padding: EdgeInsets.zero,
          child: PopupMenuButton<String>(
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
        );

        return Padding(
          padding: EdgeInsets.fromLTRB(wide ? 24 : 12, 16, wide ? 24 : 12, 8),
          child: wide
              ? Row(
                  children: [
                    logo,
                    const Spacer(),
                    links,
                    const Spacer(),
                    Expanded(child: Align(alignment: Alignment.centerRight, child: controls)),
                  ],
                )
              : Row(
                  children: [
                    menu,
                    const SizedBox(width: 8),
                    logo,
                    const Spacer(),
                    Expanded(child: Align(alignment: Alignment.centerRight, child: controls)),
                  ],
                ),
        );
      },
    );
  }
}

/// Frosted-glass container (translucent + blur + light edge + soft shadow).
class _Glass extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsets padding;
  const _Glass({required this.child, required this.radius, required this.padding});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: dark ? 0.35 : 0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: dark ? 0.12 : 0.55),
                  Colors.white.withValues(alpha: dark ? 0.04 : 0.2),
                ],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: dark ? 0.18 : 0.7),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _LanguageToggle extends LanguageToggle {
  const _LanguageToggle();
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
