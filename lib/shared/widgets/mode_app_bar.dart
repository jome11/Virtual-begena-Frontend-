import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_color_scheme.dart';
import 'theme_toggle_button.dart';

class ModeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String modeLabel;
  final Color modeColor;
  final Widget? leading;
  final VoidCallback? onBack;

  const ModeAppBar({
    super.key,
    required this.modeLabel,
    required this.modeColor,
    this.leading,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) => AppBar(
    backgroundColor: context.colors.surface,
    elevation: 0,
    titleSpacing: 20,
    title: Row(
      children: [
        Flexible(
          child: Text(
            'Virtual Begena',
            style: TextStyle(
              color: context.colors.accent,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (leading != null) ...[const SizedBox(width: 12), Flexible(flex: 2, child: leading!)],
      ],
    ),
    actions: [
      Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Text(
            modeLabel,
            style: TextStyle(color: modeColor, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
      ),
      const ThemeToggleButton(),
      TextButton.icon(
        onPressed: onBack ?? () => context.go('/dashboard'),
        icon: Icon(Icons.arrow_back, size: 16, color: context.colors.textSecondary),
        label: Text('Back', style: TextStyle(color: context.colors.textSecondary)),
      ),
      const SizedBox(width: 8),
    ],
  );
}
