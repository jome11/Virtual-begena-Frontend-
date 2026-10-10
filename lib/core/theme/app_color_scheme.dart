import 'package:flutter/material.dart';

@immutable
class AppColorsExt extends ThemeExtension<AppColorsExt> {
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color accent;

  const AppColorsExt({
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.accent,
  });

  static const light = AppColorsExt(
    background: Color(0xFFF5F1E8),
    surface: Colors.white,
    textPrimary: Color(0xFF231E12),
    textSecondary: Color(0xFF6B5D3F),
    border: Color(0xFFE3D9BF),
    accent: Color(0xFF9A7B2E),
  );

  static const dark = AppColorsExt(
    background: Color(0xFF0C0B08),
    surface: Color(0xFF17140D),
    textPrimary: Color(0xFFF4EFE4),
    textSecondary: Color(0xFFC9BFA8),
    border: Color(0xFF2A2518),
    accent: Color(0xFFC9A24B),
  );

  @override
  AppColorsExt copyWith({
    Color? background,
    Color? surface,
    Color? textPrimary,
    Color? textSecondary,
    Color? border,
    Color? accent,
  }) {
    return AppColorsExt(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      border: border ?? this.border,
      accent: accent ?? this.accent,
    );
  }

  @override
  AppColorsExt lerp(ThemeExtension<AppColorsExt>? other, double t) {
    if (other is! AppColorsExt) return this;
    return AppColorsExt(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
    );
  }
}

extension AppColorsContextX on BuildContext {
  AppColorsExt get colors => Theme.of(this).extension<AppColorsExt>()!;
}
