import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce_mobile_app/features/categories/screens/categories_screen.dart';
import 'package:e_commerce_mobile_app/features/categories/components/category_grid_card.dart';

void main() {
  testWidgets('CategoriesScreen renders Visual Grid mode by default', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const MaterialApp(home: CategoriesScreen()));
    await tester.pumpAndSettle();

    // Verify Title and Subtitle with friendly smile
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Browse all departments'), findsOneWidget);
    expect(find.byIcon(Icons.sentiment_satisfied_alt_rounded), findsOneWidget);

    // Verify View Switcher Tabs
    expect(find.text('All Categories'), findsOneWidget);
    expect(find.text('Category Explorer'), findsOneWidget);

    // Verify Department Cards
    expect(find.byType(CategoryGridCard), findsWidgets);
    expect(find.text('Fashion & Apparel'), findsWidgets);
    expect(find.text('Shoes & Sneakers'), findsWidgets);
  });

  testWidgets(
    'Switching to Category Explorer displays rail and department products',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const MaterialApp(home: CategoriesScreen()));
      await tester.pumpAndSettle();

      // Tap Category Explorer tab
      await tester.tap(find.text('Category Explorer'));
      await tester.pumpAndSettle();

      // Should display Explorer layout with subcategory chips ("All Fashion", etc.)
      expect(find.text('All Fashion'), findsWidgets);
    },
  );

  testWidgets(
    'CategoriesScreen with initialCategoryId starts in Explorer mode',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(home: CategoriesScreen(initialCategoryId: 'shoes')),
      );
      await tester.pumpAndSettle();

      // Check that it opened in Explorer mode with 'Shoes' department
      expect(find.text('All Shoes'), findsWidgets);
    },
  );

  testWidgets('Search query filters categories', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const MaterialApp(home: CategoriesScreen()));
    await tester.pumpAndSettle();

    // Enter search text
    await tester.enterText(find.byType(TextField), 'Shoes');
    await tester.pumpAndSettle();

    // Should find Shoes & Sneakers
    expect(find.text('Shoes & Sneakers'), findsWidgets);
  });
}
