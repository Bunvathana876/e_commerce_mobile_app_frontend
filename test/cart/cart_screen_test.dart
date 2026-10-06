import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce_mobile_app/features/cart/controllers/cart_controller.dart';
import 'package:e_commerce_mobile_app/features/cart/screens/cart_screen.dart';
import 'package:e_commerce_mobile_app/features/home/data/home_mock_data.dart';

void main() {
  setUp(() {
    CartController.instance.clear();
  });

  testWidgets('CartScreen displays empty state when cart is empty', (
    WidgetTester tester,
  ) async {
    bool shoppingTapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: CartScreen(onStartShopping: () => shoppingTapped = true),
      ),
    );

    expect(
      find.text("Your cart is lonely! Let's find some deals"),
      findsOneWidget,
    );
    expect(find.text('Start Shopping'), findsOneWidget);

    await tester.tap(find.text('Start Shopping'));
    await tester.pump();
    expect(shoppingTapped, isTrue);
  });

  testWidgets(
    'CartScreen displays items, increments, decrements, and shows checkout',
    (WidgetTester tester) async {
      final product = mockProducts.first;
      CartController.instance.add(product, quantity: 1);

      await tester.pumpWidget(const MaterialApp(home: CartScreen()));

      expect(find.text('My Cart'), findsOneWidget);
      expect(find.text(product.name), findsOneWidget);
      expect(find.text('Checkout'), findsOneWidget);

      // Increment quantity
      final addButtons = find.byIcon(Icons.add_rounded);
      await tester.tap(addButtons.first);
      await tester.pump();
      expect(CartController.instance.totalCount, equals(2));

      // Decrement quantity
      final removeButtons = find.byIcon(Icons.remove_rounded);
      await tester.tap(removeButtons.first);
      await tester.pump();
      expect(CartController.instance.totalCount, equals(1));
    },
  );
}
