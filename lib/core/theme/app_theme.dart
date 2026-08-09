import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_color_scheme.dart';
import 'brand_palette.dart';

final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.light);

class AppTheme {
  static ThemeData get lightTheme => _build(AppColorsExt.light, Brightness.light);
  static ThemeData get darkTheme => _build(AppColorsExt.dark, Brightness.dark);

  static ThemeData _build(AppColorsExt colors, Brightness brightness) {
    final base = brightness == Brightness.light
        ? ThemeData.light()
        : ThemeData.dark();

    return base.copyWith(
      scaffoldBackgroundColor: colors.background,
      extensions: [
        colors,
        brightness == Brightness.light ? BrandPalette.light : BrandPalette.dark,
      ],
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).apply(
        bodyColor: colors.textPrimary,
        displayColor: colors.textPrimary,
      ),
      colorScheme: base.colorScheme.copyWith(
        primary: colors.accent,
        secondary: colors.accent,
        surface: colors.surface,
        brightness: brightness,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        iconTheme: IconThemeData(color: colors.textPrimary),
      ),
      dividerColor: colors.border,
    );
  }
}
