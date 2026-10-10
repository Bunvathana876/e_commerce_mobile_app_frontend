import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce_mobile_app/core/theme/theme_controller.dart';
import 'package:e_commerce_mobile_app/features/settings/screens/settings_screen.dart';

void main() {
  group('SettingsScreen Tests', () {
    testWidgets('renders all settings sections and tiles', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Check AppBar title
      expect(find.text('Settings'), findsOneWidget);

      // Check section headers
      expect(find.text('APPEARANCE'), findsOneWidget);
      expect(find.text('PREFERENCES'), findsOneWidget);
      expect(find.text('NOTIFICATIONS'), findsOneWidget);

      // Check initial settings tiles
      expect(find.text('Dark Mode'), findsOneWidget);
      expect(find.text('Display Currency'), findsOneWidget);
      expect(find.text('Push Notifications'), findsOneWidget);
      expect(find.text('Order Status Updates'), findsOneWidget);
      expect(find.text('Promotions & Discounts'), findsOneWidget);

      // Scroll to reveal lower sections
      await tester.scrollUntilVisible(
        find.text('SECURITY & STORAGE'),
        100,
        scrollable: find.byType(Scrollable),
      );
      expect(find.text('SECURITY & STORAGE'), findsOneWidget);
      expect(find.text('Biometric Quick Login'), findsOneWidget);
      expect(find.text('Clear Temporary Cache'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('ABOUT'),
        100,
        scrollable: find.byType(Scrollable),
      );
      expect(find.text('ABOUT'), findsOneWidget);
      expect(find.text('ShopPanda Version'), findsOneWidget);
    });

    testWidgets('toggles dark mode switch', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final darkModeSwitch = find.byWidgetPredicate(
        (widget) => widget is SwitchListTile && widget.title is Text && (widget.title as Text).data == 'Dark Mode',
      );
      expect(darkModeSwitch, findsOneWidget);

      // Tap dark mode toggle
      await tester.tap(darkModeSwitch);
      await tester.pumpAndSettle();
    });

    testWidgets('opens currency modal and changes currency', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Ensure Display Currency is visible
      await tester.scrollUntilVisible(
        find.text('Display Currency'),
        100,
        scrollable: find.byType(Scrollable),
      );
      await tester.pumpAndSettle();

      // Tap Display Currency
      await tester.tap(find.text('Display Currency'));
      await tester.pumpAndSettle();

      // Check modal content
      expect(find.text('Select Currency'), findsOneWidget);
      expect(find.text('Euro'), findsOneWidget);

      // Select Euro
      await tester.tap(find.text('EUR (€)'));
      await tester.pumpAndSettle();

      expect(find.text('EUR (€)'), findsWidgets);
    });

    testWidgets('opens clear cache dialog and clears', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll to Clear Temporary Cache
      await tester.scrollUntilVisible(
        find.text('Clear Temporary Cache'),
        100,
        scrollable: find.byType(Scrollable),
      );
      await tester.pumpAndSettle();

      // Tap Clear Cache
      await tester.tap(find.text('Clear Temporary Cache'));
      await tester.pumpAndSettle();

      expect(find.text('Clear App Cache?'), findsOneWidget);
      expect(find.text('Clear Now'), findsOneWidget);

      // Confirm clear
      await tester.tap(find.text('Clear Now'));
      await tester.pumpAndSettle();

      expect(find.text('Current cache size: 0 KB'), findsOneWidget);
    });
  });
}
