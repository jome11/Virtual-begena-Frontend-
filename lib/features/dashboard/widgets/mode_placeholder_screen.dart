import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_color_scheme.dart';

/// Shared placeholder shell for a mode screen. Each mode file just supplies
/// its title, emoji, and accent color — real logic gets built inside later
/// without needing to touch routing or this shell.
class ModePlaceholderScreen extends StatelessWidget {
  final String title;
  final String emoji;
  final Color color;

  const ModePlaceholderScreen({
    super.key,
    required this.title,
    required this.emoji,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: context.colors.textPrimary),
                    onPressed: () => context.go('/dashboard'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 48)),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Coming soon',
                      style: TextStyle(color: context.colors.textSecondary, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
