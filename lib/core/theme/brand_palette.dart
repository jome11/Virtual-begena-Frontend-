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
    amber: Color(0xFFB06401),
    rose: Color(0xFFD49E8D),
    beige: Color(0xFFDED1BD),
    background: Color(0xFFFAF6F2),
    surface: Colors.white,
    ink: Color(0xFF3A2E22),
    inkMuted: Color(0x993A2E22),
  );

  // "Candlelit manuscript" dark mode — warm near-black, not cold slate.
  static const dark = BrandPalette(
    amber: Color(0xFFE0A24C),
    rose: Color(0xFFC98A78),
    beige: Color(0xFF473C2F),
    background: Color(0xFF181209),
    surface: Color(0xFF241C13),
    ink: Color(0xFFF2E8D9),
    inkMuted: Color(0x99F2E8D9),
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
