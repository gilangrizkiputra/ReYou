import 'package:shared_preferences/shared_preferences.dart';

class UserPreference {
  static const _keyUsername = 'username';

  static Future<void> saveUsername(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, name);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  static Future<bool> hasUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyUsername);
  }
}
