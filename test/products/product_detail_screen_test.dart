import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce_mobile_app/components/input/custom_input.dart';
import 'package:e_commerce_mobile_app/features/cart/controllers/cart_controller.dart';
import 'package:e_commerce_mobile_app/features/home/data/home_mock_data.dart';
import 'package:e_commerce_mobile_app/features/products/screens/product_detail_screen.dart';
import 'package:e_commerce_mobile_app/features/wishlist/controllers/wishlist_controller.dart';

void main() {
  setUp(() {
    CartController.instance.clear();
    WishlistController.instance.clear();
  });

  testWidgets(
    'ProductDetailScreen displays details, increments quantity and adds to cart',
    (WidgetTester tester) async {
      final product = mockProducts.first;

      await tester.pumpWidget(
        MaterialApp(home: ProductDetailScreen(product: product)),
      );

      // Verify name and price
      expect(find.text(product.name), findsOneWidget);
      expect(find.text('Add to Cart'), findsOneWidget);

      // Verify initial quantity is 1
      expect(find.text('1'), findsWidgets);

      // Scroll to QuantityStepper to ensure it's visible
      final stepper = find.byType(QuantityStepper);
      await tester.ensureVisible(stepper);
      await tester.pumpAndSettle();

      // Tap increase quantity
      final addIcon = find.descendant(
        of: stepper,
        matching: find.byIcon(Icons.add_rounded),
      );
      await tester.tap(addIcon);
      await tester.pumpAndSettle();

      // Tap Add to Cart
      final addToCartBtn = find.text('Add to Cart');
      await tester.tap(addToCartBtn);
      await tester.pump();

      // Verify toast is shown and cart has items
      expect(
        find.textContaining('Added 2 × "${product.name}" to cart!'),
        findsOneWidget,
      );
      expect(CartController.instance.totalCount, equals(2));
    },
  );

  testWidgets('ProductDetailScreen toggles favorite state', (
    WidgetTester tester,
  ) async {
    final product = mockProducts.first;

    await tester.pumpWidget(
      MaterialApp(home: ProductDetailScreen(product: product)),
    );

    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
    await tester.tap(find.byIcon(Icons.favorite_border_rounded));
    await tester.pump();

    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
    expect(WishlistController.instance.contains(product.id), isTrue);
  });
}
