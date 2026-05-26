import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract class AppTheme {
  static ThemeData get dark {
    const c = AppColors.dark;

    final textTheme = TextTheme(
      // Display — Geologica 800 / 32sp
      displayLarge: GoogleFonts.geologica(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.96,
        height: 1.1,
        color: c.textPrimary,
      ),
      // H1 — Geologica 700 / 24sp
      headlineLarge: GoogleFonts.geologica(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
        height: 1.2,
        color: c.textPrimary,
      ),
      // H2 — Geologica 600 / 20sp
      titleLarge: GoogleFonts.geologica(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
        height: 1.25,
        color: c.textPrimary,
      ),
      // H3 — Geologica 600 / 17sp
      titleMedium: GoogleFonts.geologica(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.17,
        height: 1.3,
        color: c.textPrimary,
      ),
      // Body Large — Manrope 400 / 16sp
      bodyLarge: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: c.textSecondary,
      ),
      // Body — Manrope 400 / 14sp
      bodyMedium: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: c.textSecondary,
      ),
      // Label — Manrope 500 / 13sp
      labelLarge: GoogleFonts.manrope(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.13,
        height: 1.4,
        color: c.textPrimary,
      ),
      // Caption — Manrope 400 / 12sp
      bodySmall: GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: c.textSecondary,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary:     Color(0xFFA01BF1),
        onPrimary:   Color(0xFFFFFFFF),
        secondary:   Color(0xFFFFA721),
        onSecondary: Color(0xFF1A0F2E),
        error:       Color(0xFFEF4444),
        onError:     Color(0xFFFFFFFF),
        surface:     Color(0xFF17102A),
        onSurface:   Color(0xFFF0EBF8),
      ),
      scaffoldBackgroundColor: const Color(0xFF0C0912),
      textTheme: textTheme,
      extensions: const [c],
    );
  }
}
