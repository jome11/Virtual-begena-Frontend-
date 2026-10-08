import 'package:flutter/material.dart';

@immutable
class BrandPalette extends ThemeExtension<BrandPalette> {
  final Color amber;
  final Color rose;
  final Color beige;
  final Color background;
  final Color surface;
  final Color ink;
  final Color inkMuted;

  const BrandPalette({
    required this.amber,
    required this.rose,
    required this.beige,
    required this.background,
    required this.surface,
    required this.ink,
    required this.inkMuted,
  });

  static const light = BrandPalette(
    amber: Color(0xFF2563EB),
    rose: Color(0xFF60A5FA),
    beige: Color(0xFFDBEAFE),
    background: Color(0xFFF4F8FF),
    surface: Colors.white,
    ink: Color(0xFF0B1F4B),
    inkMuted: Color(0x990B1F4B),
  );

  static const dark = BrandPalette(
    amber: Color(0xFF60A5FA),
    rose: Color(0xFF93C5FD),
    beige: Color(0xFF1E3A8A),
    background: Color(0xFF060E24),
    surface: Color(0xFF0D1B3E),
    ink: Color(0xFFE8F0FF),
    inkMuted: Color(0x99E8F0FF),
  );

  @override
  BrandPalette copyWith({
    Color? amber,
    Color? rose,
    Color? beige,
    Color? background,
    Color? surface,
    Color? ink,
    Color? inkMuted,
  }) =>
      BrandPalette(
        amber: amber ?? this.amber,
        rose: rose ?? this.rose,
        beige: beige ?? this.beige,
        background: background ?? this.background,
        surface: surface ?? this.surface,
        ink: ink ?? this.ink,
        inkMuted: inkMuted ?? this.inkMuted,
      );

  @override
  BrandPalette lerp(ThemeExtension<BrandPalette>? other, double t) {
    if (other is! BrandPalette) return this;
    return BrandPalette(
      amber: Color.lerp(amber, other.amber, t)!,
      rose: Color.lerp(rose, other.rose, t)!,
      beige: Color.lerp(beige, other.beige, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      inkMuted: Color.lerp(inkMuted, other.inkMuted, t)!,
    );
  }
}

extension BrandPaletteContextX on BuildContext {
  BrandPalette get brand => Theme.of(this).extension<BrandPalette>()!;
}
