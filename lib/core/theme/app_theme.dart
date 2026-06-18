import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Builds the full ThemeData for both dark (primary) and light modes.
class AppTheme {
  AppTheme._();

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.bgDarkest,
      primaryColor: AppColors.cyberBlue,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.cyberBlue,
        secondary: AppColors.cyberPurple,
        tertiary: AppColors.cyberGreen,
        surface: AppColors.bgMid,
        error: AppColors.danger,
      ),
      textTheme: AppTypography.textTheme(true),
      dividerColor: AppColors.glassBorderDark,
      iconTheme: const IconThemeData(color: AppColors.cyberBlue),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      splashColor: AppColors.cyberBlue.withOpacity(0.08),
      highlightColor: Colors.transparent,
    );
  }

  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.bgLight,
      primaryColor: AppColors.cyberPurple,
      colorScheme: const ColorScheme.light(
        primary: AppColors.cyberPurple,
        secondary: AppColors.cyberBlue,
        tertiary: AppColors.cyberGreen,
        surface: AppColors.bgLightCard,
        error: AppColors.danger,
      ),
      textTheme: AppTypography.textTheme(false),
      dividerColor: AppColors.glassBorderLight,
      iconTheme: const IconThemeData(color: AppColors.cyberPurple),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      splashColor: AppColors.cyberPurple.withOpacity(0.06),
      highlightColor: Colors.transparent,
    );
  }
}
