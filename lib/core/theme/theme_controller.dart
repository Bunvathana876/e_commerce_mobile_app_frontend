import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/colors.dart';

/// Manages application theme mode (Light / Dark) dynamically.
class ThemeController extends ChangeNotifier {
  ThemeController._();
  static final ThemeController instance = ThemeController._();

  static const String _themePrefKey = 'user_theme_mode';

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Loads saved theme setting from device storage.
  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(_themePrefKey);
      if (isDark != null) {
        _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
        notifyListeners();
      }
    } catch (_) {
      // Default to light if preference reading fails
    }
  }

  /// Toggles between light and dark mode.
  Future<void> toggleTheme() async {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themePrefKey, isDarkMode);
    } catch (_) {}
  }

  /// Sets specific theme mode.
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themePrefKey, isDarkMode);
    } catch (_) {}
  }
}

/// Centralized typography hierarchy for ShopPanda.
class AppTypography {
  AppTypography._();

  static TextStyle pageTitle({bool isDark = false}) => TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.4,
    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
  );

  static TextStyle sectionTitle({bool isDark = false}) => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
  );

  static TextStyle productName({bool isDark = false}) => TextStyle(
    fontSize: 13.5,
    fontWeight: FontWeight.w700,
    height: 1.25,
    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
  );

  static TextStyle price({Color? color}) => TextStyle(
    fontSize: 15.5,
    fontWeight: FontWeight.w800,
    color: color ?? AppColors.primary,
  );

  static TextStyle priceOriginal({bool isDark = false}) => TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.lineThrough,
    color: isDark ? AppColors.darkTextMuted : const Color(0xFF94A3B8),
  );

  static TextStyle body({bool isDark = false}) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.45,
    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
  );

  static TextStyle label({bool isDark = false}) => TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.w600,
    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
  );

  static TextStyle caption({bool isDark = false}) => TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
  );
}

/// AppTheme configuration for Light and Midnight Dark modes.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        surface: AppColors.surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardColor: Colors.white,
      dividerColor: AppColors.border,
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          letterSpacing: -0.4,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
          height: 1.45,
        ),
        bodyMedium: TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
          height: 1.4,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.textMuted,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        primary: AppColors.primary,
        surface: AppColors.darkSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardColor: AppColors.darkCard,
      dividerColor: AppColors.darkBorder,
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: AppColors.darkTextPrimary,
          letterSpacing: -0.4,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.darkTextPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.darkTextPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppColors.darkTextPrimary,
          height: 1.45,
        ),
        bodyMedium: TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w400,
          color: AppColors.darkTextSecondary,
          height: 1.4,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.darkTextPrimary,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.darkTextMuted,
        ),
      ),
    );
  }
}
