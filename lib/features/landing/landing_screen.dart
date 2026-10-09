import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_strings.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _drift = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 28),
  )..repeat(reverse: true);

  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..forward();

  late final Animation<double> _fade =
      CurvedAnimation(parent: _intro, curve: Curves.easeOut);
  late final Animation<Offset> _rise = Tween<Offset>(
    begin: const Offset(0, 0.18),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _intro, curve: Curves.easeOutCubic));

  @override
  void dispose() {
    _drift.dispose();
    _intro.dispose();
    super.dispose();
  }

  Widget _zoom(Widget child) => ClipRect(
        child: AnimatedBuilder(
          animation: _drift,
          builder: (context, c) {
            final t = Curves.easeInOut.transform(_drift.value);
            return Transform.scale(scale: 1.0 + 0.07 * t, child: c);
          },
          child: child,
        ),
      );

  Widget _chips() => Wrap(
        alignment: WrapAlignment.center,
        spacing: 10,
        runSpacing: 10,
        children: [
          _GlassChip(icon: Icons.front_hand_rounded, label: AppStrings.get('lp_chip_1')),
          _GlassChip(icon: Icons.auto_awesome_rounded, label: AppStrings.get('lp_chip_2')),
          _GlassChip(icon: Icons.account_balance_rounded, label: AppStrings.get('lp_chip_3')),
        ],
      );

  Widget _actions(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _EnterButton(onTap: () => context.go('/home')),
          const SizedBox(height: 14),
          _TryButton(onTap: () => context.go('/try')),
          const SizedBox(height: 24),
          _chips(),
        ],
      );

  Widget _desktop(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _zoom(Image.asset('assets/images/vb4.png', fit: BoxFit.cover)),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 320,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFFEAF2FF).withValues(alpha: 0),
                    const Color(0xFFBFDBFE).withValues(alpha: 0.85),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 28,
          right: 28,
          child: FadeTransition(opacity: _fade, child: const _LanguageToggle()),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 40,
          child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(position: _rise, child: _actions(context)),
          ),
        ),
      ],
    );
  }

  Widget _mobile(BuildContext context, BoxConstraints c) {
    final top = MediaQuery.of(context).padding.top;
    final imageH = (c.maxHeight * 0.4).clamp(260.0, 320.0);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF9CC4F2), Color(0xFFDCEBFF), Color(0xFFF8FBFF)],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Image strip centred on the title, fading into the page colour
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: imageH,
            child: ShaderMask(
              shaderCallback: (rect) => const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.white, Colors.transparent],
                stops: [0.0, 0.7, 1.0],
              ).createShader(rect),
              blendMode: BlendMode.dstIn,
              child: _zoom(
                Image.asset('assets/images/vb4.png',
                    fit: BoxFit.cover, alignment: Alignment.center),
              ),
            ),
          ),
          Positioned(
            top: top + 12,
            right: 16,
            child: FadeTransition(opacity: _fade, child: const _LanguageToggle()),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: imageH - 8,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: FadeTransition(
                    opacity: _fade,
                    child: SlideTransition(position: _rise, child: _actions(context)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFEAF2FF),
          body: LayoutBuilder(
            builder: (context, c) {
              final narrow = c.maxWidth < 700 || c.maxHeight > c.maxWidth * 1.1;
              return narrow ? _mobile(context, c) : _desktop(context);
            },
          ),
        );
      },
    );
  }
}

class _GlassChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _GlassChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: const Color(0xFF1D4ED8)),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: const Color(0xFF0B1F4B),
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5,
                  fontFamily:
                      languageNotifier.value == Language.am ? 'BelaBereka' : null,
                ),
              ),
            ],
          ),
        ),
      ),
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
        return ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
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
                      color: Color(0xFF0B1F4B),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hover ? 1.06 : 1.0,
          duration: const Duration(milliseconds: 180),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
              ),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2563EB)
                      .withValues(alpha: _hover ? 0.55 : 0.35),
                  blurRadius: _hover ? 30 : 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.get('enter'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.3,
                    fontFamily:
                        languageNotifier.value == Language.am ? 'BelaBereka' : null,
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TryButton extends StatelessWidget {
  final VoidCallback onTap;
  const _TryButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Material(
          color: Colors.white.withValues(alpha: 0.55),
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.play_circle_outline_rounded,
                      size: 20, color: Color(0xFF1D4ED8)),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.get('try_free'),
                    style: TextStyle(
                      color: const Color(0xFF0B1F4B),
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      fontFamily:
                          languageNotifier.value == Language.am ? 'BelaBereka' : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
