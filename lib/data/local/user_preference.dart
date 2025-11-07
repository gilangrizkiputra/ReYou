import 'package:shared_preferences/shared_preferences.dart';

class UserPreference {
  static const _onboardingKey = 'onboarding_seen';
  static const _keyUsername = 'username';

  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  static Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  static Future<bool> hasUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyUsername);
  }

  static Future<void> saveUsername(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, name);
  }
}
