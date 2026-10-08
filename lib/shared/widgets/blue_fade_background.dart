import 'package:flutter/material.dart';

class BlueFadeBackground extends StatelessWidget {
  final Widget child;
  const BlueFadeBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final colors = dark
        ? const [Color(0xFF0B1F4B), Color(0xFF0A1633), Color(0xFF060E24)]
        : const [Color(0xFFBFDBFE), Color(0xFFEAF2FF), Color(0xFFF8FBFF)];
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.45, 1.0],
            colors: colors,
          ),
        ),
        child: child,
      ),
    );
  }
}
