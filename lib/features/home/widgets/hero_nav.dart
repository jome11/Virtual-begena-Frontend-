import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class HeroNav extends StatelessWidget {
  const HeroNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Image.asset(
          'assets/images/vb4.png',
          fit: BoxFit.contain,
        ),
        Positioned(
          bottom: 24,
          child: Wrap(
            spacing: 32,
            alignment: WrapAlignment.center,
            children: [
              _NavText(AppStrings.get('home'), onTap: () => context.go('/home')),
              _NavText(AppStrings.get('lessons'), onTap: () => context.go('/lessons')),
              _NavText(AppStrings.get('about'), onTap: () => context.go('/about')),
              _NavText(AppStrings.get('contact'), onTap: () => context.go('/contact')),
            ],
          ),
        ),
      ],
    );
  }
}

class _NavText extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const _NavText(this.title, {required this.onTap});

  @override
  State<_NavText> createState() => _NavTextState();
}

class _NavTextState extends State<_NavText> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.title,
          style: TextStyle(
            color: _isHovered ? AppColors.secondary : AppColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            shadows: const [
              Shadow(
                color: Colors.white,
                blurRadius: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
