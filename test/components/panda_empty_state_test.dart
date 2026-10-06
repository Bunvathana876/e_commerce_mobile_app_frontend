import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce_mobile_app/components/empty_state/empty_state.dart';

void main() {
  group('PandaEmptyState Tests', () {
    testWidgets(
      'Renders cute panda empty state with title, message, and action button',
      (tester) async {
        bool buttonTapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PandaEmptyState(
                title: "Your cart is lonely! Let's find some deals",
                message: "Looks like you haven't added anything yet.",
                buttonText: "Start Shopping",
                onButtonTap: () {
                  buttonTapped = true;
                },
              ),
            ),
          ),
        );

        expect(
          find.text("Your cart is lonely! Let's find some deals"),
          findsOneWidget,
        );
        expect(
          find.text("Looks like you haven't added anything yet."),
          findsOneWidget,
        );
        expect(find.text("Start Shopping"), findsOneWidget);

        // Advance animation
        await tester.pump(const Duration(milliseconds: 500));

        await tester.tap(find.text("Start Shopping"));
        await tester.pump();

        expect(buttonTapped, isTrue);
      },
    );
  });
}
