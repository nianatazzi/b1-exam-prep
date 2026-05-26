import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primaryGlow,
    required this.primaryDim,
    required this.primarySub,
    required this.secondarySub,
    required this.success,
    required this.successSub,
    required this.errorSub,
    required this.surfaceRaised,
    required this.surfaceOverlay,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.n50,
    required this.n100,
    required this.n200,
    required this.n300,
    required this.n400,
    required this.n500,
    required this.n600,
    required this.n900,
  });

  final Color primaryGlow;
  final Color primaryDim;
  final Color primarySub;
  final Color secondarySub;
  final Color success;
  final Color successSub;
  final Color errorSub;
  final Color surfaceRaised;
  final Color surfaceOverlay;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color n50;
  final Color n100;
  final Color n200;
  final Color n300;
  final Color n400;
  final Color n500;
  final Color n600;
  final Color n900;

  static const dark = AppColors(
    primaryGlow:    Color(0xFFC45DF6),
    primaryDim:     Color(0xFF7B12BC),
    primarySub:     Color(0xFF2A1040),
    secondarySub:   Color(0xFF3A2800),
    success:        Color(0xFF22C55E),
    successSub:     Color(0xFF0A2E18),
    errorSub:       Color(0xFF2E0A0A),
    surfaceRaised:  Color(0xFF211830),
    surfaceOverlay: Color(0xFF2D2240),
    textPrimary:    Color(0xFFF0EBF8),
    textSecondary:  Color(0xFF9585BB),
    textMuted:      Color(0xFF5A4878),
    n50:  Color(0xFFF7F5FA),
    n100: Color(0xFFEDE8F5),
    n200: Color(0xFFDDD5EE),
    n300: Color(0xFFBFB3D9),
    n400: Color(0xFF9585BB),
    n500: Color(0xFF6B5A8E),
    n600: Color(0xFF4A3A6E),
    n900: Color(0xFF1A0F2E),
  );

  @override
  AppColors copyWith({
    Color? primaryGlow,
    Color? primaryDim,
    Color? primarySub,
    Color? secondarySub,
    Color? success,
    Color? successSub,
    Color? errorSub,
    Color? surfaceRaised,
    Color? surfaceOverlay,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? n50,
    Color? n100,
    Color? n200,
    Color? n300,
    Color? n400,
    Color? n500,
    Color? n600,
    Color? n900,
  }) =>
      AppColors(
        primaryGlow:    primaryGlow    ?? this.primaryGlow,
        primaryDim:     primaryDim     ?? this.primaryDim,
        primarySub:     primarySub     ?? this.primarySub,
        secondarySub:   secondarySub   ?? this.secondarySub,
        success:        success        ?? this.success,
        successSub:     successSub     ?? this.successSub,
        errorSub:       errorSub       ?? this.errorSub,
        surfaceRaised:  surfaceRaised  ?? this.surfaceRaised,
        surfaceOverlay: surfaceOverlay ?? this.surfaceOverlay,
        textPrimary:    textPrimary    ?? this.textPrimary,
        textSecondary:  textSecondary  ?? this.textSecondary,
        textMuted:      textMuted      ?? this.textMuted,
        n50:  n50  ?? this.n50,
        n100: n100 ?? this.n100,
        n200: n200 ?? this.n200,
        n300: n300 ?? this.n300,
        n400: n400 ?? this.n400,
        n500: n500 ?? this.n500,
        n600: n600 ?? this.n600,
        n900: n900 ?? this.n900,
      );

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primaryGlow:    Color.lerp(primaryGlow,    other.primaryGlow,    t)!,
      primaryDim:     Color.lerp(primaryDim,     other.primaryDim,     t)!,
      primarySub:     Color.lerp(primarySub,     other.primarySub,     t)!,
      secondarySub:   Color.lerp(secondarySub,   other.secondarySub,   t)!,
      success:        Color.lerp(success,        other.success,        t)!,
      successSub:     Color.lerp(successSub,     other.successSub,     t)!,
      errorSub:       Color.lerp(errorSub,       other.errorSub,       t)!,
      surfaceRaised:  Color.lerp(surfaceRaised,  other.surfaceRaised,  t)!,
      surfaceOverlay: Color.lerp(surfaceOverlay, other.surfaceOverlay, t)!,
      textPrimary:    Color.lerp(textPrimary,    other.textPrimary,    t)!,
      textSecondary:  Color.lerp(textSecondary,  other.textSecondary,  t)!,
      textMuted:      Color.lerp(textMuted,      other.textMuted,      t)!,
      n50:  Color.lerp(n50,  other.n50,  t)!,
      n100: Color.lerp(n100, other.n100, t)!,
      n200: Color.lerp(n200, other.n200, t)!,
      n300: Color.lerp(n300, other.n300, t)!,
      n400: Color.lerp(n400, other.n400, t)!,
      n500: Color.lerp(n500, other.n500, t)!,
      n600: Color.lerp(n600, other.n600, t)!,
      n900: Color.lerp(n900, other.n900, t)!,
    );
  }
}
