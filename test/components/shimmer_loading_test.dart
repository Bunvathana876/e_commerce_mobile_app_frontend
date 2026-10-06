import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce_mobile_app/components/shimmer/shimmer_loading.dart';

void main() {
  group('Shimmer / Skeleton Loading Component Tests', () {
    testWidgets('Renders Shimmer with child', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Shimmer(child: SizedBox(width: 100, height: 100)),
          ),
        ),
      );

      expect(find.byType(Shimmer), findsOneWidget);
      // Advance animation
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(ShaderMask), findsOneWidget);
    });

    testWidgets('Renders PromoBannerSkeleton', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: PromoBannerSkeleton())),
      );

      expect(find.byType(PromoBannerSkeleton), findsOneWidget);
      expect(find.byType(ShimmerBox), findsWidgets);
    });

    testWidgets('Renders ProductCardSkeleton and ProductGridSkeleton', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ProductGridSkeleton(itemCount: 4),
            ),
          ),
        ),
      );

      expect(find.byType(ProductGridSkeleton), findsOneWidget);
      expect(find.byType(ProductCardSkeleton), findsNWidgets(4));
    });
  });
}
