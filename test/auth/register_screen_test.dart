import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce_mobile_app/core/storage/secure_storage.dart';
import 'package:e_commerce_mobile_app/features/auth/screens/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    SessionStorage.currentUser = null;
  });

  group('RegisterScreen Tests', () {
    testWidgets('RegisterScreen renders all clean aesthetic UI elements', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));

      // Back button
      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);

      // Title
      expect(find.text('Create an Account?'), findsOneWidget);

      // Form fields
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byIcon(Icons.mail_outline), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsNWidgets(2));
      expect(find.byIcon(Icons.visibility_off_outlined), findsNWidgets(2));

      // Options
      expect(find.text('Remember me'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);

      // Action button
      expect(find.widgetWithText(ElevatedButton, 'Sign up'), findsOneWidget);

      // Logo
      expect(find.byType(Image), findsOneWidget);

      // Divider & Social logins
      expect(find.text('Or Log in with'), findsOneWidget);
      expect(find.byIcon(Icons.facebook), findsOneWidget);
      expect(find.byIcon(Icons.apple), findsOneWidget);

      // Footer
      expect(find.text('Already have an account? '), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('Password and Confirm Password toggles work independently', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));

      final toggles = find.byIcon(Icons.visibility_off_outlined);
      expect(toggles, findsNWidgets(2));

      await tester.tap(toggles.at(0));
      await tester.pump();

      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pump();

      expect(find.byIcon(Icons.visibility_outlined), findsNWidgets(2));
      expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);
    });

    testWidgets(
      'Register validation handles empty inputs and password mismatch',
      (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));

        final initialSignUpBtn = find.widgetWithText(ElevatedButton, 'Sign up');
        await tester.ensureVisible(initialSignUpBtn);
        await tester.tap(initialSignUpBtn);
        await tester.pump();

        expect(find.text('Please enter your full name'), findsOneWidget);
        expect(find.text('Please enter your email'), findsOneWidget);
        expect(find.text('Please enter your password'), findsOneWidget);

        final fields = find.byType(TextFormField);
        await tester.enterText(fields.at(0), 'Alex Doe');
        await tester.enterText(fields.at(1), 'alex@example.com');
        await tester.enterText(fields.at(2), 'password123');
        await tester.enterText(fields.at(3), 'mismatch456');

        final signUpBtn = find.widgetWithText(ElevatedButton, 'Sign up');
        await tester.ensureVisible(signUpBtn);
        await tester.tap(signUpBtn);
        await tester.pump();

        expect(find.text('Passwords do not match'), findsOneWidget);
      },
    );

    testWidgets('Successful registration triggers onSignUpSuccess callback', (
      WidgetTester tester,
    ) async {
      bool registered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: RegisterScreen(
            onSignUpSuccess: () {
              registered = true;
            },
          ),
        ),
      );

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Alex Doe');
      await tester.enterText(fields.at(1), 'alex@example.com');
      await tester.enterText(fields.at(2), 'password123');
      await tester.enterText(fields.at(3), 'password123');

      final signUpBtn = find.widgetWithText(ElevatedButton, 'Sign up');
      await tester.ensureVisible(signUpBtn);
      await tester.tap(signUpBtn);
      await tester.pump();

      expect(registered, isTrue);
      expect(find.text('Creating account for Alex Doe...'), findsOneWidget);
    });
  });
}
