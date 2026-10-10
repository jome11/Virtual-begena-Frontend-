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
    amber: Color(0xFF9A7B2E),
    rose: Color(0xFFC9A24B),
    beige: Color(0xFFEDE6D6),
    background: Color(0xFFF5F1E8),
    surface: Colors.white,
    ink: Color(0xFF231E12),
    inkMuted: Color(0xB3231E12),
  );

  static const dark = BrandPalette(
    amber: Color(0xFFC9A24B),
    rose: Color(0xFFE8D5A3),
    beige: Color(0xFF2A2518),
    background: Color(0xFF0C0B08),
    surface: Color(0xFF17140D),
    ink: Color(0xFFF4EFE4),
    inkMuted: Color(0xB3F4EFE4),
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
