import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce_mobile_app/features/home/data/home_mock_data.dart';
import 'package:e_commerce_mobile_app/features/wishlist/controllers/wishlist_controller.dart';
import 'package:e_commerce_mobile_app/features/wishlist/screens/wishlist_screen.dart';

void main() {
  setUp(() {
    WishlistController.instance.clear();
  });

  testWidgets('WishlistScreen shows empty state when no items favorited', (
    WidgetTester tester,
  ) async {
    bool browseTapped = false;

    await tester.pumpWidget(
      MaterialApp(home: WishlistScreen(onBrowse: () => browseTapped = true)),
    );

    expect(find.text('No favorites yet'), findsOneWidget);
    expect(find.text('Browse Products'), findsOneWidget);

    await tester.tap(find.text('Browse Products'));
    await tester.pump();
    expect(browseTapped, isTrue);
  });

  testWidgets('WishlistScreen displays favorited products and allows removal', (
    WidgetTester tester,
  ) async {
    final product = mockProducts.first;
    WishlistController.instance.toggle(product.id);

    await tester.pumpWidget(const MaterialApp(home: WishlistScreen()));

    expect(find.text('Wishlist'), findsOneWidget);
    expect(find.text(product.name), findsOneWidget);

    // Tap favorite icon to remove
    final favIcon = find.byIcon(Icons.favorite_rounded);
    expect(favIcon, findsOneWidget);
    await tester.tap(favIcon);
    await tester.pump();

    // Now empty state should show
    expect(find.text('No favorites yet'), findsOneWidget);
  });
}
