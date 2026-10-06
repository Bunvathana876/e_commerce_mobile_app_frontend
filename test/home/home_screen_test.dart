import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce_mobile_app/core/storage/secure_storage.dart';
import 'package:e_commerce_mobile_app/features/home/components/home_bottom_nav_bar.dart';
import 'package:e_commerce_mobile_app/features/home/components/home_categories_bar.dart';
import 'package:e_commerce_mobile_app/features/home/components/home_header.dart';
import 'package:e_commerce_mobile_app/features/home/screens/home_screen.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    SessionStorage.currentUser = null;
  });

  group('HomeScreen Tests', () {
    testWidgets(
      'HomeScreen renders header, search bar, carousel, categories, flash sale, products and bottom nav',
      (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

        // Header
        expect(find.text('Welcome, Alex 👋'), findsOneWidget);
        expect(find.text('Phnom Penh, Cambodia'), findsOneWidget);
        expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(HomeHeader),
            matching: find.byIcon(Icons.shopping_bag_outlined),
          ),
          findsOneWidget,
        );

        // Search Bar
        expect(find.text('Search clothes, shoes, bags...'), findsOneWidget);
        expect(find.byIcon(Icons.search_rounded), findsOneWidget);
        expect(find.byIcon(Icons.tune_rounded), findsOneWidget);

        // Promo Carousel
        expect(find.text('Autumn Sale 🍂'), findsOneWidget);
        expect(find.text('Shop Now'), findsOneWidget);

        // Categories
        expect(find.text('Categories'), findsOneWidget);
        expect(find.text('All'), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(HomeCategoriesBar),
            matching: find.text('Fashion'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byType(HomeCategoriesBar),
            matching: find.text('Shoes'),
          ),
          findsOneWidget,
        );

        // Flash Sale
        expect(find.text('Flash Sale Ends In'), findsOneWidget);

        // Popular Products
        expect(find.text('Popular Products'), findsOneWidget);
        expect(find.text('Casual Minimalist Hoodie'), findsOneWidget);
        expect(find.text('Urban Street Sneakers'), findsOneWidget);

        // Bottom Navigation Bar
        expect(find.text('Home'), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(HomeBottomNavBar),
            matching: find.byIcon(Icons.grid_view_rounded),
          ),
          findsOneWidget,
        );
        expect(
          find.byIcon(Icons.local_fire_department_rounded),
          findsOneWidget,
        );
        expect(find.byIcon(LucideIcons.heart), findsOneWidget);
        expect(find.byIcon(LucideIcons.shoppingBag), findsOneWidget);
        expect(find.byIcon(LucideIcons.user), findsOneWidget);
      },
    );

    testWidgets('Tapping category filters displayed products', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // Initially shows Casual Minimalist Hoodie
      expect(find.text('Casual Minimalist Hoodie'), findsOneWidget);

      // Tap 'Shoes' category
      final shoesCategoryFinder = find.descendant(
        of: find.byType(HomeCategoriesBar),
        matching: find.text('Shoes'),
      );
      await tester.ensureVisible(shoesCategoryFinder);
      await tester.tap(shoesCategoryFinder);
      await tester.pumpAndSettle();

      // Should show Urban Street Sneakers and not Hoodie
      expect(find.text('Urban Street Sneakers'), findsOneWidget);
      expect(find.text('Casual Minimalist Hoodie'), findsNothing);
    });

    testWidgets('Tapping Add to Cart updates cart counter and shows snackbar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // Initially cart count is 2 in header
      expect(
        find.descendant(of: find.byType(HomeHeader), matching: find.text('2')),
        findsOneWidget,
      );

      // Tap add button on first product
      final addButtons = find.byIcon(Icons.add_rounded);
      expect(addButtons, findsWidgets);
      await tester.ensureVisible(addButtons.first);
      await tester.tap(addButtons.first);
      await tester.pump();

      // Cart count should now be 3 in header
      expect(
        find.descendant(of: find.byType(HomeHeader), matching: find.text('3')),
        findsOneWidget,
      );
      expect(
        find.textContaining('Added "Casual Minimalist Hoodie" to cart!'),
        findsOneWidget,
      );
    });

    testWidgets('Tapping favorite heart toggles favorite state', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      final favoriteButtons = find.byIcon(Icons.favorite_border_rounded);
      expect(favoriteButtons, findsWidgets);

      // Tap first heart
      await tester.ensureVisible(favoriteButtons.first);
      await tester.tap(favoriteButtons.first);
      await tester.pump();

      // Now at least one filled favorite icon exists
      expect(find.byIcon(Icons.favorite_rounded), findsWidgets);
    });

    testWidgets('Tapping bottom navigation bar switches active tab', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // Tap Cart tab icon; its label should appear
      expect(find.text('Cart'), findsNothing);
      await tester.tap(find.byIcon(LucideIcons.shoppingBag));
      await tester.pumpAndSettle();

      expect(find.text('Cart'), findsOneWidget);
    });
  });
}
