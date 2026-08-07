import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

class ModeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String modeLabel;
  final Color modeColor;
  final Widget? leading;
  final VoidCallback? onBack;

  const ModeAppBar({super.key, required this.modeLabel, required this.modeColor, this.leading, this.onBack});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) => AppBar(
    backgroundColor: AppColors.white,
    elevation: 0,
    titleSpacing: 20,
    title: Row(
      children: [
        const Flexible(
          child: Text(
            'Virtual Begena',
            style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold, fontSize: 18),
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
          child: Text(modeLabel, style: TextStyle(color: modeColor, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
      ),
      TextButton.icon(
        onPressed: onBack ?? () => context.go('/dashboard'),
        icon: const Icon(Icons.arrow_back, size: 16, color: AppColors.textSecondary),
        label: const Text('Back', style: TextStyle(color: AppColors.textSecondary)),
      ),
      const SizedBox(width: 8),
    ],
  );
}
