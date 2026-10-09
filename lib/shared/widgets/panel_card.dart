import 'package:flutter/material.dart';
import '../../core/theme/app_color_scheme.dart';

class PanelCard extends StatelessWidget {
  final Widget child;
  const PanelCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 8,
          offset: const Offset(0, 3),
        )
      ],
    ),
    child: Material(
      color: context.colors.surface,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    ),
  );
}
