import 'package:flutter/material.dart';

class BlueFadeBackground extends StatelessWidget {
  final Widget child;
  const BlueFadeBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: dark
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.5, 1.0],
                  colors: [Color(0xFF2A2924), Color(0xFF151410), Color(0xFF0C0D07)],
                )
              : const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [0.0, 0.55, 1.0],
                  colors: [Color(0xFFFCFBF8), Color(0xFFF2EEE5), Color(0xFFE8E1D3)],
                ),
        ),
        child: DecoratedBox(
          // Soft light from the top-right, like in your mockups.
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topRight,
              radius: 1.1,
              colors: [
                (dark ? const Color(0xFF3A3934) : Colors.white).withValues(alpha: dark ? 0.35 : 0.5),
                Colors.transparent,
              ],
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
