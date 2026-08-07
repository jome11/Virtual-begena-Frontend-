import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const AnimatedButton({super.key, required this.text, required this.onTap});

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _isHovered ? Matrix4.identity().scaledByDouble(1.05, 1.05, 1.0, 1.0) : Matrix4.identity(),
        child: ElevatedButton(
          onPressed: widget.onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isHovered ? AppColors.secondary.withValues(alpha: 0.9) : AppColors.secondary,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: _isHovered ? 8 : 4,
          ),
          child: Text(
            widget.text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
