import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce_mobile_app/features/cart/controllers/cart_controller.dart';
import 'package:e_commerce_mobile_app/features/checkout/screens/checkout_screen.dart';
import 'package:e_commerce_mobile_app/features/home/data/home_mock_data.dart';
import 'package:e_commerce_mobile_app/features/orders/controllers/orders_controller.dart';

void main() {
  setUp(() {
    CartController.instance.clear();
    OrdersController.instance.clear();
  });

  testWidgets('CheckoutScreen renders form and places order successfully', (
    WidgetTester tester,
  ) async {
    final product = mockProducts.first;
    CartController.instance.add(product, quantity: 1);

    await tester.pumpWidget(const MaterialApp(home: CheckoutScreen()));

    expect(find.text('Checkout'), findsOneWidget);
    expect(find.text('Delivery details'), findsOneWidget);
    expect(find.text('Payment method'), findsOneWidget);

    // Enter delivery details
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Full name'),
      'John Doe',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Phone number'),
      '012345678',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Delivery address'),
      'Street 123, Toul Kork, Phnom Penh',
    );
    await tester.pumpAndSettle();

    // Scroll down to reveal order summary and place order button
    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();

    expect(find.text('Order summary'), findsOneWidget);
    expect(find.textContaining('Place Order'), findsOneWidget);

    // Tap Place Order button
    await tester.tap(find.textContaining('Place Order'));
    await tester.pumpAndSettle();

    // Success dialog appears
    expect(find.text('Order placed!'), findsOneWidget);
    expect(OrdersController.instance.orders.length, equals(1));
    expect(CartController.instance.isEmpty, isTrue);
  });
}
