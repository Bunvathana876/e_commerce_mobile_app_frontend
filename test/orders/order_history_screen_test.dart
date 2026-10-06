import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce_mobile_app/features/cart/controllers/cart_controller.dart';
import 'package:e_commerce_mobile_app/features/home/data/home_mock_data.dart';
import 'package:e_commerce_mobile_app/features/orders/controllers/orders_controller.dart';
import 'package:e_commerce_mobile_app/features/orders/screens/order_history_screen.dart';

void main() {
  setUp(() {
    OrdersController.instance.clear();
  });

  testWidgets('OrderHistoryScreen shows empty state when no orders', (
    WidgetTester tester,
  ) async {
    bool shoppingTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: OrderHistoryScreen(onStartShopping: () => shoppingTapped = true),
      ),
    );

    expect(find.text('No orders yet'), findsOneWidget);
    expect(find.text('Start Shopping'), findsOneWidget);

    await tester.tap(find.text('Start Shopping'));
    await tester.pump();
    expect(shoppingTapped, isTrue);
  });

  testWidgets('OrderHistoryScreen displays placed orders', (
    WidgetTester tester,
  ) async {
    final product = mockProducts.first;
    final order = OrdersController.instance.place(
      items: [CartItem(product, quantity: 2)],
      total: (product.price * 2) + 5,
      address: 'Street 2004, Phnom Penh',
      paymentMethod: 'Cash on Delivery',
    );

    await tester.pumpWidget(const MaterialApp(home: OrderHistoryScreen()));

    expect(find.text('My Orders'), findsOneWidget);
    expect(find.text(order.id), findsOneWidget);
    expect(find.textContaining('Cash on Delivery'), findsOneWidget);
    expect(find.text('Processing'), findsWidgets);
  });
}
