// lib/core/cached/secure_storage.dart

import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:whatsapp/core/helper/app_logger.dart';

/// ===================================================
/// SecureStorageService
/// ===================================================
/// This service is used to **store sensitive data securely**
/// (tokens, user credentials, onboarding flags, etc.)
///
///  It follows the Singleton pattern → only one instance is created.
///  Uses `flutter_secure_storage` which is encrypted.
///  Must call `init()` once before using it.
///
/// Example setup in main():
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await SecureStorageService.instance.init(); // init once
///   runApp(MyApp());
/// }
/// ```
///
/// Example usage:
/// ```dart
/// await SecureStorageService.instance.setString('token', 'abcd1234');
/// final token = await SecureStorageService.instance.getString('token');
/// print(token); // abcd1234
/// ```
class SecureStorageService {
  // === Singleton Instance ===
  static SecureStorageService? _instance;
  static SecureStorageService get instance =>
      _instance ??= SecureStorageService._();

  SecureStorageService._(); // private constructor

  // === Flutter Secure Storage Instance ===
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  bool _isInitialized = false;

  /// Initialize the service
  /// Ensures secure storage works before using it
  Future<void> init() async {
    if (_isInitialized) return;
    await _storage.containsKey(key: 'test_key'); // simple read
    _isInitialized = true;
    AppLogger.log('SecureStorage initialized');
  }

  /// Helper: check init() was called
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError(' Call SecureStorageService.init() first');
    }
  }

  // ==========================================
  // 🔧 Generic Methods (Save, Read, Remove, Clear)
  // ==========================================

  /// Save a String value
  ///
  /// Example:
  /// ```dart
  /// await SecureStorageService.instance.setString('username', 'Karem');
  /// ```
  Future<bool> setString(String key, String value) async {
    _ensureInitialized();
    await _storage.write(key: key, value: value);
    return true;
  }

  /// Get a String value (returns null if not found)
  ///
  /// Example:
  /// ```dart
  /// final name = await SecureStorageService.instance.getString('username');
  /// ```
  Future<String?> getString(String key, {String? defaultValue}) async {
    _ensureInitialized();
    return await _storage.read(key: key) ?? defaultValue;
  }

  /// Save a JSON object (convert Map → String)
  ///
  /// Example:
  /// ```dart
  /// await SecureStorageService.instance.setJson('profile', {'age': 25});
  /// ```
  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    return await setString(key, jsonEncode(value));
  }

  /// Get a JSON object (convert String → Map)
  ///
  /// Example:
  /// ```dart
  /// final profile = await SecureStorageService.instance.getJson('profile');
  /// print(profile?['age']); // 25
  /// ```
  Future<Map<String, dynamic>?> getJson(String key) async {
    final data = await getString(key);
    try {
      return data != null ? jsonDecode(data) : null;
    } catch (e) {
      developer.log('⚠️ Failed to decode JSON: $e', name: 'SecureStorage');
      return null;
    }
  }

  /// Remove a specific key
  ///
  /// Example:
  /// ```dart
  /// await SecureStorageService.instance.remove('username');
  /// ```
  Future<bool> remove(String key) async {
    _ensureInitialized();
    await _storage.delete(key: key);
    return true;
  }

  /// Clear ALL stored data
  ///
  /// Example:
  /// ```dart
  /// await SecureStorageService.instance.clearAll();
  /// ```
  // Save access token
  static Future<void> saveAccessToken(String token) async {
    await _storage.write(key: 'access_token', value: token);
  }

  // Get access token
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  // Delete access token (for logout)
  static Future<void> deleteAccessToken() async {
    await _storage.delete(key: 'access_token');
  }
  Future<bool> clearAll() async {
    _ensureInitialized();
    await _storage.deleteAll();
    return true;
  }
}
