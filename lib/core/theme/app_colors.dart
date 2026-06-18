import 'package:flutter/material.dart';

/// Central color palette for the cybersecurity portfolio theme.
/// All colors derived from the spec's dark/glassmorphism cyber aesthetic.
class AppColors {
  AppColors._();

  // Primary brand colors
  static const Color cyberBlue = Color(0xFF00E5FF);
  static const Color cyberPurple = Color(0xFF7B61FF);
  static const Color cyberGreen = Color(0xFF00FF88);

  // Background layers (dark theme)
  static const Color bgDarkest = Color(0xFF050816);
  static const Color bgDark = Color(0xFF0A0F1C);
  static const Color bgMid = Color(0xFF101728);

  // Light theme backgrounds (for dark/light toggle feature)
  static const Color bgLight = Color(0xFFF4F7FB);
  static const Color bgLightCard = Color(0xFFFFFFFF);

  // Text colors
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textLightGrey = Color(0xFFC7D0E0);
  static const Color textMuted = Color(0xFF8993AB);
  static const Color textDark = Color(0xFF0A0F1C); // for light theme

  // Glass surface tints
  static const Color glassFillDark = Color(0x14FFFFFF); // white at 8%
  static const Color glassBorderDark = Color(0x33FFFFFF); // white at 20%
  static const Color glassFillLight = Color(0x0A000000);
  static const Color glassBorderLight = Color(0x22000000);

  // Status / utility
  static const Color success = cyberGreen;
  static const Color warning = Color(0xFFFFB020);
  static const Color danger = Color(0xFFFF4D6D);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [cyberBlue, cyberPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [cyberGreen, cyberBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient fullSpectrumGradient = LinearGradient(
    colors: [cyberBlue, cyberPurple, cyberGreen],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static LinearGradient backgroundGradient({bool isDark = true}) {
    if (!isDark) {
      return const LinearGradient(
        colors: [bgLight, bgLightCard],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
    return const LinearGradient(
      colors: [bgDarkest, bgDark, bgMid],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  // Glow shadows used throughout for the "futuristic" feel
  static List<BoxShadow> glow(Color color,
      {double blur = 24, double spread = 0}) {
    return [
      BoxShadow(
        color: color.withOpacity(0.45),
        blurRadius: blur,
        spreadRadius: spread,
      ),
    ];
  }
}
