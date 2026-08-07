import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class StatTile extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const StatTile({super.key, required this.label, required this.value, this.valueColor = AppColors.textPrimary});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 3))],
    ),
    child: Column(
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(color: valueColor, fontSize: 22, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
