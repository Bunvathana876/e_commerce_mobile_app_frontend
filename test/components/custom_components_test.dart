import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce_mobile_app/components/badge/custom_badge.dart';
import 'package:e_commerce_mobile_app/components/button/custom_button.dart';

void main() {
  group('Custom Components Tests', () {
    testWidgets('CustomPrimaryButton displays text and reacts to tap', (
      tester,
    ) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPrimaryButton(
              text: 'Check Out',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Check Out'), findsOneWidget);
      await tester.tap(find.text('Check Out'));
      expect(tapped, isTrue);
    });

    testWidgets(
      'CustomPrimaryButton shows loading spinner when isLoading=true',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomPrimaryButton(
                text: 'Submit',
                isLoading: true,
                onPressed: () {},
              ),
            ),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets('StatusBadge displays correct text and style', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusBadge(
              label: 'Processing',
              backgroundColor: Colors.amber,
              textColor: Colors.black,
            ),
          ),
        ),
      );

      expect(find.text('Processing'), findsOneWidget);
    });
  });
}
