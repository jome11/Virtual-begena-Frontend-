import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_color_scheme.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, child) {
        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/vb4.png',
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 30,
                right: 30,
                child: const _LanguageToggle(),
              ),
              Positioned(
                bottom: 80,
                left: 0,
                right: 0,
                child: Center(
                  child: _EnterButton(
                    onTap: () => context.go('/home'),
                  ),
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
      builder: (context, lang, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextButton(
            onPressed: () {
              languageNotifier.value =
                  lang == Language.en ? Language.am : Language.en;
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                lang == Language.en ? 'አማ' : 'EN',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EnterButton extends StatefulWidget {
  final VoidCallback onTap;
  const _EnterButton({required this.onTap});

  @override
  State<_EnterButton> createState() => _EnterButtonState();
}

class _EnterButtonState extends State<_EnterButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
          decoration: BoxDecoration(
            color: _hovering
                ? context.colors.accent
                : context.colors.accent.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: _hovering ? 0.3 : 0.15),
                blurRadius: _hovering ? 12 : 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            AppStrings.get('enter'),
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: languageNotifier.value == Language.am ? 'BelaBereka' : null,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
