import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce_mobile_app/screens/home_screen.dart';
import 'package:e_commerce_mobile_app/theme/app_theme.dart';
import 'package:e_commerce_mobile_app/widgets/bottom_navigation.dart';
import 'package:e_commerce_mobile_app/widgets/category_selector.dart';
import 'package:e_commerce_mobile_app/widgets/flash_sale_card.dart';
import 'package:e_commerce_mobile_app/widgets/home_header.dart';
import 'package:e_commerce_mobile_app/widgets/product_card.dart';
import 'package:e_commerce_mobile_app/widgets/search_bar.dart';
import 'package:e_commerce_mobile_app/widgets/weekend_edit_banner.dart';

void main() {
  group('Clean Modern Shopping HomeScreen Tests', () {
    testWidgets('Renders all requested components on 347x657 viewport', (
      WidgetTester tester,
    ) async {
      // Set test viewport to exactly 347x657 as required
      tester.view.physicalSize = const Size(347, 657);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.lightTheme, home: const HomeScreen()),
      );
      await tester.pump();

      // 1. Header checks
      expect(find.byType(HomeHeaderWidget), findsOneWidget);
      expect(find.text('Welcome, Lee'), findsOneWidget);
      expect(find.text('Phnom Penh, Cambodia'), findsOneWidget);
      expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsWidgets);

      // 2. Search row
      expect(find.byType(CustomSearchBar), findsOneWidget);
      expect(find.text('Search clothes, shoes, bags...'), findsOneWidget);
      expect(find.byIcon(Icons.tune_rounded), findsOneWidget);

      // 3. Weekend Edit Promo Card
      expect(find.byType(WeekendEditBanner), findsOneWidget);
      expect(find.text('Weekend Edit'), findsOneWidget);
      expect(find.text('Fresh picks, better prices.'), findsOneWidget);
      expect(find.text('30% OFF'), findsOneWidget);
      expect(find.text('Claim coupon'), findsOneWidget);

      // 4. Shop by category horizontal list
      expect(find.byType(CategorySelector), findsOneWidget);
      expect(find.text('Shop by category'), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Fashion'), findsOneWidget);
      expect(find.text('Shoes'), findsOneWidget);
      expect(find.text('Electronics'), findsOneWidget);

      // 5. Flash Sale Card
      expect(find.byType(FlashSaleCard), findsOneWidget);
      expect(find.text('Flash Sale'), findsOneWidget);
      expect(find.text('Up to 70% off today'), findsOneWidget);

      // 6. Made for you Product Section
      expect(find.text('Made for you'), findsOneWidget);
      expect(find.byType(ProductCard), findsWidgets);

      // 7. Bottom Navigation Bar
      expect(find.byType(BottomNavigation), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Categories'), findsOneWidget);
      expect(find.text('Deals'), findsOneWidget);
      expect(find.text('Favorites'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);

      // Verify no RenderFlex overflow occurs on 347x657 screen
      expect(tester.takeException(), isNull);
    });

    testWidgets('Tapping category filters displayed products', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.lightTheme, home: const HomeScreen()),
      );
      await tester.pump();

      // Initially shows hoodie
      expect(find.text('Minimal Everyday Oversized Hoodie'), findsOneWidget);

      // Tap 'Shoes' category
      final shoesFinder = find.descendant(
        of: find.byType(CategorySelector),
        matching: find.text('Shoes'),
      );
      await tester.ensureVisible(shoesFinder);
      await tester.tap(shoesFinder);
      await tester.pump();

      // Only shoes should be visible
      expect(find.text('Retro Classic Court Sneakers'), findsOneWidget);
      expect(find.text('Minimal Everyday Oversized Hoodie'), findsNothing);
    });

    testWidgets('Tapping favorite heart toggles favorite and shows SnackBar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.lightTheme, home: const HomeScreen()),
      );
      await tester.pump();

      final heartFinders = find.byIcon(Icons.favorite_border_rounded);
      expect(heartFinders, findsWidgets);

      await tester.ensureVisible(heartFinders.first);
      await tester.tap(heartFinders.first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Saved'), findsOneWidget);
    });

    testWidgets('Claiming coupon shows coupon SnackBar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.lightTheme, home: const HomeScreen()),
      );
      await tester.pump();

      final couponBtn = find.text('Claim coupon');
      await tester.ensureVisible(couponBtn);
      await tester.tap(couponBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('WEEKEND30'), findsOneWidget);
    });

    testWidgets('Filter button opens bottom sheet modal', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.lightTheme, home: const HomeScreen()),
      );
      await tester.pump();

      final filterBtn = find.byIcon(Icons.tune_rounded);
      await tester.tap(filterBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Filter & Sort'), findsOneWidget);
      expect(find.text('Apply Filters'), findsOneWidget);

      // Close modal
      await tester.tap(find.text('Apply Filters'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('Filter & Sort'), findsNothing);
    });

    testWidgets('HomeScreen with showBottomNav: false hides bottom nav and handles callbacks', (
      WidgetTester tester,
    ) async {
      bool cartTapped = false;
      bool categoriesTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: HomeScreen(
            showBottomNav: false,
            onCartTap: () => cartTapped = true,
            onCategoriesTap: () => categoriesTapped = true,
          ),
        ),
      );
      await tester.pump();

      // BottomNavigation should NOT be present when showBottomNav is false
      expect(find.byType(BottomNavigation), findsNothing);

      // Tap bag icon in header
      final bagButton = find.byTooltip('Shopping bag');
      expect(bagButton, findsOneWidget);
      await tester.tap(bagButton);
      expect(cartTapped, isTrue);

      // Tap See all on category selector
      final seeAllButton = find.text('See all').first;
      await tester.ensureVisible(seeAllButton);
      await tester.tap(seeAllButton);
      expect(categoriesTapped, isTrue);
    });
  });
}
