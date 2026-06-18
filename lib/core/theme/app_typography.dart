import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography system. Uses Orbitron-style display font for headings
/// (via google_fonts 'Orbitron') and a clean readable sans for body text.
/// TODO: If you have licensed custom fonts (e.g. actual Orbitron ttf),
/// swap GoogleFonts.orbitron(...) calls for TextStyle(fontFamily: 'Orbitron', ...)
/// and register them in pubspec.yaml under flutter > fonts.
class AppTypography {
  AppTypography._();

  static TextTheme textTheme(bool isDark) {
    final Color base = isDark ? AppColors.textWhite : AppColors.textDark;
    final Color muted = isDark ? AppColors.textLightGrey : AppColors.textMuted;

    return TextTheme(
      displayLarge: GoogleFonts.orbitron(
        fontSize: 64,
        fontWeight: FontWeight.w700,
        color: base,
        letterSpacing: 1.2,
        height: 1.1,
      ),
      displayMedium: GoogleFonts.orbitron(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        color: base,
        letterSpacing: 1.0,
        height: 1.15,
      ),
      displaySmall: GoogleFonts.orbitron(
        fontSize: 34,
        fontWeight: FontWeight.w600,
        color: base,
        letterSpacing: 0.8,
      ),
      headlineLarge: GoogleFonts.orbitron(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: base,
      ),
      headlineMedium: GoogleFonts.orbitron(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: base,
      ),
      headlineSmall: GoogleFonts.rajdhani(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: base,
      ),
      titleLarge: GoogleFonts.rajdhani(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: base,
      ),
      titleMedium: GoogleFonts.rajdhani(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: base,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        color: muted,
        height: 1.6,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: muted,
        height: 1.55,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: muted,
      ),
      labelLarge: GoogleFonts.shareTechMono(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.cyberBlue,
        letterSpacing: 1.1,
      ),
      labelMedium: GoogleFonts.shareTechMono(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.cyberBlue,
        letterSpacing: 1.0,
      ),
    );
  }

  /// Monospace style for the terminal / hacker section.
  static TextStyle terminal({Color? color, double fontSize = 14}) {
    return GoogleFonts.shareTechMono(
      color: color ?? AppColors.cyberGreen,
      fontSize: fontSize,
      height: 1.5,
    );
  }
}
