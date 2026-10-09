import 'package:flutter/material.dart';

/// App theme constants and Material 3 theme configurations.
class AppTheme {
  AppTheme._();

  // Primary colors
  static const Color primary = Color(0xFF2563EB); // Royal Blue
  static const Color primaryDark = Color(0xFF1E3A8A); // Deep Navy
  static const Color primaryLight = Color(0xFFDBEAFE); // Soft Ice Blue

  // Neutrals
  static const Color background = Color(0xFFF8FAFC); // Very soft neutral light
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF0F172A); // Navy dark text
  static const Color textSecondary = Color(0xFF64748B); // Slate secondary
  static const Color textMuted = Color(0xFF94A3B8); // Muted slate
  static const Color border = Color(0xFFE2E8F0); // Subtle hairline border

  // Accent & functional
  static const Color saleRed = Color(0xFFEF4444);
  static const Color starGold = Color(0xFFF59E0B);
  static const Color successGreen = Color(0xFF10B981);

  // Spacing constants
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 12.0;
  static const double spacingLg = 16.0;
  static const double spacingXl = 20.0;
  static const double spacingXxl = 24.0;

  // Radius constants
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
        primary: primary,
        surface: cardBackground,
      ),
      cardColor: cardBackground,
      dividerColor: border,
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: -0.4,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
      ),
    );
  }
}
