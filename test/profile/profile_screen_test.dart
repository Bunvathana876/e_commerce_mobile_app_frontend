import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce_mobile_app/core/storage/secure_storage.dart';
import 'package:e_commerce_mobile_app/features/auth/screens/login_screen.dart';
import 'package:e_commerce_mobile_app/features/profile/screens/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    SessionStorage.currentUser = null;
  });

  group('Saved login & ProfileScreen Tests', () {
    testWidgets('Remember me saves the user on the phone', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: LoginScreen(onLoginSuccess: () {})),
      );
      await tester.tap(find.byType(Checkbox));
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'sam@example.com');
      await tester.enterText(fields.at(1), 'secret123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      SessionStorage.currentUser = null;
      final loaded = await SessionStorage.load();
      expect(loaded?.email, 'sam@example.com');
    });

    testWidgets('ProfileScreen shows user info and logs out', (tester) async {
      SessionStorage.currentUser = const SavedUser(
        name: 'Sam Lee',
        email: 'sam@example.com',
      );
      await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

      expect(find.text('Sam Lee'), findsOneWidget);
      expect(find.text('sam@example.com'), findsOneWidget);
      expect(find.text('My Orders'), findsOneWidget);

      await tester.scrollUntilVisible(find.text('Log out'), 200);
      await tester.tap(find.text('Log out'));
      await tester.pumpAndSettle();

      expect(SessionStorage.currentUser, isNull);
      expect(find.text('Login now!'), findsOneWidget);
    });
  });
}
