import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp/core/utils/constants/app_constants.dart';

/// Prefs
/// --------------------------------
/// Simple wrapper around SharedPreferences.
/// Makes it easier to save & read small data locally (like login, onboarding, theme, etc.)
///
/// Example usage in main():
///   void main() async {
///     WidgetsFlutterBinding.ensureInitialized();
///     await Prefs.init();
///     runApp(MyApp());
///   }
///
/// Example usage for login:
///   await Prefs.setIsLoggedIn(true);
///   final loggedIn = Prefs.isLoggedIn(); // true
///
class Prefs {
  // SharedPreferences instance (singleton).
  static SharedPreferences? _instance;
  static bool _isInitialized = false;

  /// Must be called once before using Prefs (example: inside main()).
  static Future<void> init() async {
    if (!_isInitialized) {
      _instance = await SharedPreferences.getInstance();
      _isInitialized = true;
    }
  }
  
  /// Get the SharedPreferences instance. Throws if not initialized.
  static SharedPreferences get _prefs {
    if (!_isInitialized || _instance == null) {
      throw Exception('Prefs not initialized. Call Prefs.init() first.');
    }
    return _instance!;
  }

  // ==============================
  // === Generic Methods (base) ===
  // ==============================

  /// Save a boolean value.
  ///
  /// Example:
  ///   await Prefs.setBool('dark_mode', true);
  static Future<bool> setBool(String key, bool value) async {
    try {
      return await _prefs.setBool(key, value);
    } catch (e) {
      debugPrint('Error setting bool for key $key: $e');
      return false;
    }
  }

  /// Read a boolean value. Returns false if key not found.
  ///
  /// Example:
  ///   final darkMode = Prefs.getBool('dark_mode');
  ///   print(darkMode); // true
  static bool getBool(String key, {bool defaultValue = false}) {
    try {
      return _prefs.getBool(key) ?? defaultValue;
    } catch (e) {
      debugPrint('Error getting bool for key $key: $e');
      return defaultValue;
    }
  }

  /// Save a string value.
  ///
  /// Example:
  ///   await Prefs.setString('username', 'Karem');
  static Future<bool> setString(String key, String value) async {
    try {
      return await _prefs.setString(key, value);
    } catch (e) {
      debugPrint('Error setting string for key $key: $e');
      return false;
    }
  }

  /// Read a string value. Returns null if not found.
  ///
  /// Example:
  ///   final username = Prefs.getString('username');
  static String? getString(String key) {
    try {
      return _prefs.getString(key);
    } catch (e) {
      debugPrint('Error getting string for key $key: $e');
      return null;
    }
  }

  /// Save an integer value.
  ///
  /// Example:
  ///   await Prefs.setInt('user_age', 25);
  static Future<bool> setInt(String key, int value) async {
    try {
      return await _prefs.setInt(key, value);
    } catch (e) {
      debugPrint('Error setting int for key $key: $e');
      return false;
    }
  }

  /// Read an integer value. Returns null if not found.
  ///
  /// Example:
  ///   final age = Prefs.getInt('user_age');
  static int? getInt(String key) {
    try {
      return _prefs.getInt(key);
    } catch (e) {
      debugPrint('Error getting int for key $key: $e');
      return null;
    }
  }

  /// Save a double value.
  static Future<bool> setDouble(String key, double value) async {
    try {
      return await _prefs.setDouble(key, value);
    } catch (e) {
      debugPrint('Error setting double for key $key: $e');
      return false;
    }
  }

  /// Read a double value. Returns null if not found.
  static double? getDouble(String key) {
    try {
      return _prefs.getDouble(key);
    } catch (e) {
      debugPrint('Error getting double for key $key: $e');
      return null;
    }
  }

  /// Save a list of strings.
  static Future<bool> setStringList(String key, List<String> value) async {
    try {
      return await _prefs.setStringList(key, value);
    } catch (e) {
      debugPrint('Error setting string list for key $key: $e');
      return false;
    }
  }

  /// Read a list of strings. Returns null if not found.
  static List<String>? getStringList(String key) {
    try {
      return _prefs.getStringList(key);
    } catch (e) {
      debugPrint('Error getting string list for key $key: $e');
      return null;
    }
  }

  /// Remove a value by key.
  static Future<bool> remove(String key) async {
    try {
      return await _prefs.remove(key);
    } catch (e) {
      debugPrint('Error removing key $key: $e');
      return false;
    }
  }

  /// Clear all saved preferences.
  static Future<bool> clear() async {
    try {
      return await _prefs.clear();
    } catch (e) {
      debugPrint('Error clearing preferences: $e');
      return false;
    }
  }
  // =================================
  // === Specific Shortcuts (ready) ==
  // =================================

  /// Save onboarding flag.
  ///
  /// Example:
  ///   await Prefs.setSeenOnBoarding(true);
  static Future<void> setSeenOnBoarding(bool value) async =>
      await setBool(AppConstants.seenOnBoarding, value);

  /// Check if onboarding was seen.
  ///
  /// Example:
  ///   if (Prefs.hasSeenOnBoarding()) {
  ///     print("User already saw onboarding");
  ///   }
  static bool hasSeenOnBoarding() =>
      getBool(AppConstants.seenOnBoarding);

  /// Save login status.
  ///
  /// Example:
  ///   await Prefs.setIsLoggedIn(true);
  static Future<void> setIsLoggedIn(bool value) async =>
      await setBool(AppConstants.isLoggedIn, value);

  /// Check login status.
  ///
  /// Example:
  ///   if (Prefs.isLoggedIn()) {
  ///     print("Welcome back!");
  ///   }
  static bool isLoggedIn() =>
      getBool(AppConstants.isLoggedIn);
}
