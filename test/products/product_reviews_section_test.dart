import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce_mobile_app/features/products/components/product_reviews_section.dart';

void main() {
  group('ProductReviewsSection Tests', () {
    final testReviews = [
      ProductReview(
        id: 'rev_1',
        author: 'Jessica Taylor',
        rating: 5,
        date: '2 days ago',
        comment: 'Absolutely love these shoes! Comfortable for all-day wear.',
        isVerified: true,
        helpfulCount: 14,
      ),
      ProductReview(
        id: 'rev_2',
        author: 'Michael Chen',
        rating: 4,
        date: '1 week ago',
        comment: 'Great quality, but size runs slightly large.',
        isVerified: false,
        helpfulCount: 5,
      ),
    ];

    testWidgets(
      'Renders reviews section with rating summary, verified buyer badge, and review list',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: ProductReviewsSection(
                  reviews: testReviews,
                  rating: 4.8,
                  reviewsCount: 124,
                  onWriteReview: () {},
                ),
              ),
            ),
          ),
        );

        expect(find.text('Customer Reviews'), findsOneWidget);
        expect(find.text('4.8'), findsOneWidget);
        expect(find.text('2 verified ratings'), findsOneWidget);
        expect(find.text('Jessica Taylor'), findsOneWidget);
        expect(find.text('Verified'), findsOneWidget);
        expect(find.text('Michael Chen'), findsOneWidget);
        expect(find.text('Write a Review'), findsOneWidget);
      },
    );

    testWidgets('Taps helpful increments count', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ProductReviewsSection(
                reviews: testReviews,
                rating: 4.8,
                reviewsCount: 124,
                onWriteReview: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Helpful (14)'), findsOneWidget);
      await tester.tap(find.text('Helpful (14)'));
      await tester.pump();
      expect(find.text('Helpful (15)'), findsOneWidget);
    });

    testWidgets('WriteReviewModal renders and submits new review', (
      tester,
    ) async {
      ProductReview? submittedReview;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (ctx) => WriteReviewModal(
                      onSubmit: (review) {
                        submittedReview = review;
                      },
                    ),
                  );
                },
                child: const Text('Open Modal'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      expect(find.text('Write a Review ✍️'), findsOneWidget);
      expect(find.text('Excellent! 🐼❤️'), findsOneWidget);
      expect(find.text('Your Name'), findsOneWidget);
      expect(find.text('Your Feedback'), findsOneWidget);

      // Enter name and review
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Sophia Green');
      await tester.enterText(
        textFields.at(1),
        'Incredible quality and fast shipping!',
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'Submit Review'));
      await tester.pumpAndSettle();

      expect(submittedReview, isNotNull);
      expect(submittedReview?.author, 'Sophia Green');
      expect(submittedReview?.comment, 'Incredible quality and fast shipping!');
      expect(submittedReview?.isVerified, isTrue);
    });
  });
}
