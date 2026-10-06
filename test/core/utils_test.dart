import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce_mobile_app/core/utils/currency.dart';
import 'package:e_commerce_mobile_app/core/utils/validation.dart';

void main() {
  group('Currency Formatting Tests', () {
    test('formatCurrency formats whole dollars correctly', () {
      expect(formatCurrency(25.0), '\$25.00');
    });

    test('formatCurrency formats decimal dollars correctly', () {
      expect(formatCurrency(19.99), '\$19.99');
    });

    test('formatCurrency formats zero correctly', () {
      expect(formatCurrency(0.0), '\$0.00');
    });
  });

  group('Validation Tests', () {
    test('requiredField validates null and empty', () {
      expect(
        Validators.requiredField(null, fieldName: 'Name'),
        'Name is required',
      );
      expect(
        Validators.requiredField('', fieldName: 'Email'),
        'Email is required',
      );
      expect(Validators.requiredField('John', fieldName: 'Name'), isNull);
    });

    test('email validator checks format', () {
      expect(Validators.email(''), 'Email is required');
      expect(
        Validators.email('invalid-email'),
        'Please enter a valid email address',
      );
      expect(Validators.email('user@example.com'), isNull);
    });

    test('password validator checks minimum length', () {
      expect(Validators.password(''), 'Password is required');
      expect(
        Validators.password('123'),
        'Password must be at least 6 characters',
      );
      expect(Validators.password('secret123'), isNull);
    });

    test('phone validator checks format', () {
      expect(Validators.phone(''), 'Phone number is required');
      expect(Validators.phone('123'), 'Please enter a valid phone number');
      expect(Validators.phone('+855 12 345 678'), isNull);
    });
  });
}
