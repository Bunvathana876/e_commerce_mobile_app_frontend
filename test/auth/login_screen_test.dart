import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce_mobile_app/core/storage/secure_storage.dart';
import 'package:e_commerce_mobile_app/features/auth/screens/login_screen.dart';
import 'package:e_commerce_mobile_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    SessionStorage.currentUser = null;
  });

  group('LoginScreen Tests', () {
    testWidgets(
      'LoginScreen renders clean aesthetic UI elements and typography',
      (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());

        // Header and branding
        expect(find.text('Welcome to ShopPanda'), findsOneWidget);
        expect(find.text('Login now!'), findsOneWidget);

        // Fields
        expect(find.text('Email'), findsOneWidget);
        expect(find.text('Password'), findsOneWidget);
        expect(find.byIcon(Icons.mail_outline), findsOneWidget);
        expect(find.byIcon(Icons.lock_outline), findsOneWidget);
        expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

        // Options
        expect(find.text('Remember me'), findsOneWidget);
        expect(find.text('Forgot password?'), findsOneWidget);
        expect(find.byType(Checkbox), findsOneWidget);

        // Primary Action
        expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);

        // Logo
        expect(find.byType(Image), findsOneWidget);

        // Divider & Socials
        expect(find.text('Or Log in with'), findsOneWidget);
        expect(find.byIcon(Icons.facebook), findsOneWidget);
        expect(find.byIcon(Icons.apple), findsOneWidget);

        // Footer
        expect(find.text("Didn't have an account? "), findsOneWidget);
        expect(find.text('Create an account'), findsOneWidget);
      },
    );

    testWidgets('Password visibility toggle toggles obscureText and icon', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_outlined), findsNothing);

      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pump();

      expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });

    testWidgets('Remember me checkbox toggles state', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      final checkboxFinder = find.byType(Checkbox);
      expect(tester.widget<Checkbox>(checkboxFinder).value, false);

      await tester.tap(checkboxFinder);
      await tester.pump();

      expect(tester.widget<Checkbox>(checkboxFinder).value, true);
    });

    testWidgets('Validation triggers error messages on empty inputs', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pump();

      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('Successful validation triggers login callback', (
      WidgetTester tester,
    ) async {
      bool loginSuccessCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(
            onLoginSuccess: () {
              loginSuccessCalled = true;
            },
          ),
        ),
      );

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'test@example.com');
      await tester.enterText(textFields.at(1), 'securePassword123');

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pump();

      expect(loginSuccessCalled, isTrue);
      expect(find.text('Logging in as test@example.com...'), findsOneWidget);
    });

    testWidgets('Tapping Create an account navigates to RegisterScreen', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      final createAccountFinder = find.text('Create an account');
      await tester.ensureVisible(createAccountFinder);
      await tester.tap(createAccountFinder);
      await tester.pumpAndSettle();

      expect(find.text('Create an Account?'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Sign up'), findsOneWidget);
    });
  });
}
