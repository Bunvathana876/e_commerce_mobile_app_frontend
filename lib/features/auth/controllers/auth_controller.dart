import 'package:flutter/material.dart';
import '../../../core/storage/secure_storage.dart';

/// Simple state manager for authentication.
class AuthController extends ChangeNotifier {
  AuthController._();
  static final AuthController instance = AuthController._();

  SavedUser? get currentUser => SessionStorage.currentUser;
  bool get isLoggedIn => currentUser != null;

  Future<void> login({
    required String name,
    required String email,
    bool remember = false,
  }) async {
    final user = SavedUser(name: name, email: email);
    await SessionStorage.save(user, remember: remember);
    notifyListeners();
  }

  Future<void> logout() async {
    await SessionStorage.clear();
    notifyListeners();
  }

  Future<void> updateProfile({
    required String name,
    required String email,
  }) async {
    final user = SavedUser(name: name, email: email);
    await SessionStorage.save(user, remember: true);
    notifyListeners();
  }
}
