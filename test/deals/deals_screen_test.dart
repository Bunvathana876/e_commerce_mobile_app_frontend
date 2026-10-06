import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce_mobile_app/features/deals/screens/deals_screen.dart';
import 'package:e_commerce_mobile_app/features/cart/controllers/cart_controller.dart';
import 'package:e_commerce_mobile_app/features/wishlist/controllers/wishlist_controller.dart';

void main() {
  setUp(() {
    CartController.instance.clear();
    WishlistController.instance.clear();
  });

  group('DealsScreen Tests', () {
    testWidgets(
      'Renders Deals & Offers header, flash sale countdown, and filter chips',
      (tester) async {
        await tester.pumpWidget(const MaterialApp(home: DealsScreen()));

        expect(find.text('Deals & Offers'), findsOneWidget);
        expect(find.text('Exclusive daily discounts'), findsOneWidget);
        expect(find.text('FLASH SALE'), findsOneWidget);
        expect(find.text('Up to 70% Off Today'), findsOneWidget);
        expect(find.text('All Deals'), findsOneWidget);
        expect(find.text('🔥 Flash Sale'), findsOneWidget);
        expect(find.text('🏷️ 50% Off+'), findsOneWidget);
        expect(find.text('Deal of the Day 🔥'), findsOneWidget);
      },
    );

    testWidgets('Tapping filter chips filters deal products', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: DealsScreen()));

      // Tap 50% Off+ filter
      await tester.tap(find.text('🏷️ 50% Off+'));
      await tester.pumpAndSettle();

      expect(find.text('AeroLite Breathable Running Shoes'), findsOneWidget);
    });

    testWidgets('Claim Deal adds product to cart and updates controller', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: DealsScreen()));

      final claimButtons = find.widgetWithText(ElevatedButton, 'Claim Deal');
      expect(claimButtons, findsWidgets);

      await tester.drag(
        find.byType(SingleChildScrollView).first,
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();

      await tester.tap(claimButtons.first);
      await tester.pump();

      expect(CartController.instance.items.length, 1);
    });

    testWidgets('Tapping favorite heart adds deal to wishlist', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: DealsScreen()));

      final favoriteButtons = find.byIcon(Icons.favorite_border_rounded);
      expect(favoriteButtons, findsWidgets);

      await tester.tap(favoriteButtons.first);
      await tester.pump();

      expect(WishlistController.instance.products.length, 1);
    });
  });
}
