import 'package:shared_preferences/shared_preferences.dart';

/// The logged-in user.
class SavedUser {
  final String name;
  final String email;

  const SavedUser({required this.name, required this.email});
}

/// Remembers who is logged in.
///
/// - [currentUser] lives in memory for the current app session.
/// - [save] also writes to the phone, so the user stays logged in next time
///   (used when "Remember me" is ticked).
/// - [clear] logs out (memory + phone).
class SessionStorage {
  static const _nameKey = 'session_name';
  static const _emailKey = 'session_email';

  /// User for the current app session (null = nobody logged in).
  static SavedUser? currentUser;

  /// Sets the current user. If [remember] is true it is also saved on the phone.
  static Future<void> save(SavedUser user, {required bool remember}) async {
    currentUser = user;
    if (!remember) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_nameKey, user.name);
      await prefs.setString(_emailKey, user.email);
    } catch (_) {
      // Saving is best-effort; the app still works without it.
    }
  }

  /// Loads the user saved on the phone (call once when the app starts).
  static Future<SavedUser?> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString(_emailKey);
      if (email == null) return null;
      currentUser = SavedUser(
        name: prefs.getString(_nameKey) ?? email.split('@').first,
        email: email,
      );
      return currentUser;
    } catch (_) {
      return null;
    }
  }

  /// Logs out and forgets the saved user.
  static Future<void> clear() async {
    currentUser = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_nameKey);
      await prefs.remove(_emailKey);
    } catch (_) {}
  }
}
