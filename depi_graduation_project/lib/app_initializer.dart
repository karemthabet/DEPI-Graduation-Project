import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:whatsapp/core/functions/hide_status_bar.dart';
import 'core/helper/app_logger.dart';

class AppInitializer {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  /// Initialize all required services for the app
  static Future<void> init() async {
    try {
      // Initialize storage
      await _initStorage();
      
      // Initialize logger
      _initLogger();
      hideStatusBar();
      
      AppLogger.info('تم تهيئة التطبيق بنجاح', tag: 'AppInitializer');
    } catch (e, stackTrace) {
      AppLogger.error('فشل في تهيئة التطبيق', 
          error: e, 
          stackTrace: stackTrace,
          tag: 'AppInitializer');
      rethrow;
    }
  }

  /// Initialize storage services
  static Future<void> _initStorage() async {
    try {
      // Initialize GetStorage
      await GetStorage.init();
      
      // Verify secure storage is available
      await _secureStorage.containsKey(key: 'test');
      
      AppLogger.debug('تم تهيئة التخزين بنجاح', tag: 'Storage');
    } catch (e, stackTrace) {
      AppLogger.error('فشل في تهيئة التخزين',
          error: e,
          stackTrace: stackTrace,
          tag: 'Storage');
      rethrow;
    }
  }

  /// Initialize logger configuration
  static void _initLogger() {
    // Enable/disable logs based on environment
    if (kDebugMode) {
      AppLogger.setEnabled(true);
    } else {
      AppLogger.setEnabled(false);
    }
    
    AppLogger.debug('تم تهيئة السجل', tag: 'Logger');
  }
}
