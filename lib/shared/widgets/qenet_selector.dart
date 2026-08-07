import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/qenet.dart';

class QenetSelector extends StatelessWidget {
  final Qenet selected;
  final ValueChanged<Qenet> onChanged;

  const QenetSelector({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    children: Qenet.values.map((q) {
      final active = q == selected;
      return GestureDetector(
        onTap: () => onChanged(q),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: active ? q.color.withValues(alpha: 0.12) : AppColors.white,
            border: Border.all(color: active ? q.color : AppColors.textSecondary.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(q.label,
              style: TextStyle(color: active ? q.color : AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
      );
    }).toList(),
  );
}
