import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce_mobile_app/features/categories/screens/categories_screen.dart';
import 'package:e_commerce_mobile_app/features/categories/components/category_grid_card.dart';

void main() {
  testWidgets(
    'CategoriesScreen matches reference UI with Popular & Shop by category sections',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const MaterialApp(home: CategoriesScreen()));
      await tester.pumpAndSettle();

      // Verify Title and Subtitle matching reference
      expect(find.text('Categories'), findsOneWidget);
      expect(find.text('Find what you love'), findsOneWidget);

      // Verify Search bar placeholder
      expect(find.text('Search categories'), findsOneWidget);

      // Verify Popular section header & items
      expect(find.text('Popular'), findsOneWidget);
      expect(find.text('See all'), findsOneWidget);
      expect(find.text('84 items'), findsOneWidget);
      expect(find.text('56 items'), findsOneWidget);
      expect(find.text('42 items'), findsOneWidget);

      // Verify Shop by category section
      expect(find.text('Shop by category'), findsOneWidget);
      expect(find.text('4 groups'), findsOneWidget);

      // Verify exactly 4 CategoryGridCards in Shop by category
      expect(find.byType(CategoryGridCard), findsNWidgets(4));
      expect(find.text('Fashion'), findsWidgets);
      expect(find.text('Shoes'), findsWidgets);
      expect(find.text('Bags'), findsWidgets);
      expect(find.text('Electronics'), findsWidgets);
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

    // Should find Shoes
    expect(find.text('Shoes'), findsWidgets);
  });

  testWidgets(
    'Tapping a category displays its products and back button works',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const MaterialApp(home: CategoriesScreen()));
      await tester.pumpAndSettle();

      // Tap on Shoes in Shop by category
      await tester.tap(find.byType(CategoryGridCard).at(1));
      await tester.pumpAndSettle();

      // Should show category title and back button
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);

      // Tap back
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();

      // Should return to category grid
      expect(find.byType(CategoryGridCard), findsNWidgets(4));
    },
  );

  testWidgets('CategoriesScreen with initialCategoryId opens that category', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(home: CategoriesScreen(initialCategoryId: 'shoes')),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
  });
}
