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
    background: Color(0xFFF4F8FF),
    surface: Colors.white,
    textPrimary: Color(0xFF0B1F4B),
    textSecondary: Color(0xFF5B6B8C),
    border: Color(0xFFD6E2F7),
    accent: Color(0xFF2563EB),
  );

  static const dark = AppColorsExt(
    background: Color(0xFF060E24),
    surface: Color(0xFF0D1B3E),
    textPrimary: Color(0xFFE8F0FF),
    textSecondary: Color(0xFF8FA3C8),
    border: Color(0xFF1B2D5C),
    accent: Color(0xFF60A5FA),
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
