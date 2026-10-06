import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_commerce_mobile_app/core/theme/theme_controller.dart';
import 'package:e_commerce_mobile_app/core/constants/colors.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('ThemeController Tests', () {
    test('Initializes with default light theme and can toggle', () async {
      final controller = ThemeController.instance;
      await controller.setThemeMode(ThemeMode.light);

      expect(controller.isDarkMode, false);
      expect(controller.themeMode, ThemeMode.light);

      await controller.toggleTheme();
      expect(controller.isDarkMode, true);
      expect(controller.themeMode, ThemeMode.dark);

      await controller.toggleTheme();
      expect(controller.isDarkMode, false);
      expect(controller.themeMode, ThemeMode.light);
    });

    test('Loads saved dark theme from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({'user_theme_mode': true});
      final controller = ThemeController.instance;
      await controller.load();

      expect(controller.isDarkMode, true);
      expect(controller.themeMode, ThemeMode.dark);

      // Reset back to light
      await controller.setThemeMode(ThemeMode.light);
    });

    test('AppTheme generates light and dark themes with expected colors', () {
      final light = AppTheme.lightTheme;
      final dark = AppTheme.darkTheme;

      expect(light.brightness, Brightness.light);
      expect(dark.brightness, Brightness.dark);
      expect(dark.scaffoldBackgroundColor, AppColors.darkBackground);
      expect(dark.cardColor, AppColors.darkCard);
    });
  });
}
