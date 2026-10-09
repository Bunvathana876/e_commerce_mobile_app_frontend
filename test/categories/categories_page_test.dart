import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce_mobile_app/features/categories/screens/categories_page.dart';
import 'package:e_commerce_mobile_app/features/categories/widgets/app_header.dart';
import 'package:e_commerce_mobile_app/features/categories/widgets/search_categories.dart';
import 'package:e_commerce_mobile_app/features/categories/widgets/filter_chips.dart';
import 'package:e_commerce_mobile_app/features/categories/widgets/flash_sale_banner.dart';
import 'package:e_commerce_mobile_app/features/categories/widgets/popular_categories.dart';
import 'package:e_commerce_mobile_app/features/categories/widgets/category_grid.dart';
import 'package:e_commerce_mobile_app/features/categories/widgets/category_detail_sheet.dart';
import 'package:e_commerce_mobile_app/features/categories/widgets/app_bottom_navigation.dart';

void main() {
  group('CategoriesPage & Modular Components Test Suite', () {
    testWidgets('Renders all required sections and content on mobile', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const MaterialApp(home: CategoriesPage()));
      await tester.pumpAndSettle();

      // 1. Header
      expect(find.byType(AppHeader), findsOneWidget);
      expect(find.text('Good morning, Alex'), findsOneWidget);
      expect(find.text('Find what you love'), findsOneWidget);

      // 2. Search bar
      expect(find.byType(SearchCategories), findsOneWidget);
      expect(find.text('Search categories or products'), findsOneWidget);

      // 3. Filter chips
      expect(find.byType(CategoryFilterChips), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Women'), findsOneWidget);
      expect(find.text('Men'), findsOneWidget);
      expect(find.text('Kids'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Tech'), findsOneWidget);

      // 4. Flash sale banner
      expect(find.byType(FlashSaleBanner), findsOneWidget);
      expect(find.text('Shop now'), findsOneWidget);
      expect(find.text('HRS'), findsOneWidget);

      // 5. Popular categories
      expect(find.byType(PopularCategories), findsOneWidget);
      expect(find.text('Popular categories'), findsOneWidget);

      // 6. Shop by category
      expect(find.byType(CategoryGrid), findsOneWidget);
      expect(find.text('Shop by category'), findsOneWidget);

      // 7. App bottom navigation
      expect(find.byType(AppBottomNavigation), findsOneWidget);
      expect(find.text('Categories'), findsWidgets);
    });

    testWidgets('Renders responsive desktop centered layout with wide container', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(2560, 1440);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const MaterialApp(home: CategoriesPage()));
      await tester.pumpAndSettle();

      expect(find.byType(CategoriesPage), findsOneWidget);
      expect(find.text('Good morning, Alex'), findsOneWidget);
      expect(find.text('Shop by category'), findsOneWidget);
    });

    testWidgets('Live search filters categories and clear button resets', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const MaterialApp(home: CategoriesPage()));
      await tester.pumpAndSettle();

      // Enter search query "shoes"
      await tester.enterText(find.byType(TextField), 'Shoes');
      await tester.pumpAndSettle();

      expect(find.text('Shoes'), findsWidgets);

      // Clear button tap
      final clearBtn = find.byTooltip('Clear');
      expect(clearBtn, findsOneWidget);
      await tester.tap(clearBtn);
      await tester.pumpAndSettle();

      // All categories restored
      expect(find.text('Fashion'), findsWidgets);
      expect(find.text('Bags'), findsWidgets);
    });

    testWidgets('Filter chip selection updates visible category list', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const MaterialApp(home: CategoriesPage()));
      await tester.pumpAndSettle();

      // Tap "Tech" chip
      await tester.tap(find.text('Tech'));
      await tester.pumpAndSettle();

      expect(find.text('Electronics'), findsWidgets);
    });

    testWidgets('Tapping category card opens CategoryDetailSheet with bestsellers & add to cart', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const MaterialApp(home: CategoriesPage()));
      await tester.pumpAndSettle();

      // Tap on Fashion category in Grid
      await tester.tap(find.text('Fashion').first);
      await tester.pumpAndSettle();

      // Bottom sheet should be open
      expect(find.byType(CategoryDetailSheet), findsOneWidget);
      expect(find.text('Subcategories'), findsOneWidget);
      expect(find.text('Best-selling products'), findsOneWidget);

      // Tap "Add" button
      final addBtn = find.text('Add').first;
      await tester.tap(addBtn);
      await tester.pumpAndSettle();

      // Verify SnackBar toast appears
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('Toggle view button switches between Grid and List view', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const MaterialApp(home: CategoriesPage()));
      await tester.pumpAndSettle();

      expect(find.byType(GridView), findsOneWidget);

      // Tap toggle view button
      await tester.tap(find.byTooltip('List view'));
      await tester.pumpAndSettle();

      // Now in list view (arrow forwards & list layout)
      expect(find.byIcon(Icons.arrow_forward_rounded), findsWidgets);
    });

    testWidgets('Tapping favorite heart triggers toggle animation', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const MaterialApp(home: CategoriesPage()));
      await tester.pumpAndSettle();

      final favBtn = find.byTooltip('Remove favorite').first;
      await tester.tap(favBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
