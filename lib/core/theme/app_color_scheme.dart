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
    background: Color(0xFFF8F9FA),
    surface: Colors.white,
    textPrimary: Color(0xFF2C3E50),
    textSecondary: Color(0xFF7F8C8D),
    border: Color(0xFFE4E1D8),
    accent: Color(0xFFD4AF37),
  );

  static const dark = AppColorsExt(
    background: Color(0xFF13110E),
    surface: Color(0xFF1D1A16),
    textPrimary: Color(0xFFF1EDE4),
    textSecondary: Color(0xFFA79E8E),
    border: Color(0xFF322D26),
    accent: Color(0xFFD4AF37),
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
