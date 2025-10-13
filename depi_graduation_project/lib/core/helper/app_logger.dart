import 'package:logger/logger.dart';

/// 💬 AppLogger: نظام مخصص لطباعة اللوجات بألوان وإيموجيز
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 70,
      colors: true,
      printEmojis: true,
    ),
  );

  static bool _enabled = true;

  /// تفعيل أو إيقاف اللوجز
  static void setEnabled(bool value) {
    _enabled = value;
  }

  /// طباعة لوج عام
  static void log(String message, {dynamic error, StackTrace? stackTrace, String? tag}) {
    if (!_enabled) return;
    final logMessage = tag != null ? '[$tag] $message' : message;
    if (error != null) {
      _logger.e(logMessage, error: error, stackTrace: stackTrace);
    } else {
      _logger.i(logMessage);
    }
  }

  static void debug(dynamic message, {String? tag}) {
    if (!_enabled) return;
    final logMessage = tag != null ? '[$tag] $message' : message;
    _logger.d(logMessage);
  }

  static void info(dynamic message, {String? tag}) {
    if (!_enabled) return;
    final logMessage = tag != null ? '[$tag] $message' : message;
    _logger.i(logMessage);
  }

  static void warning(dynamic message, {dynamic error, StackTrace? stackTrace, String? tag}) {
    if (!_enabled) return;
    final logMessage = tag != null ? '[$tag] ⚠️ $message' : '⚠️ $message';
    _logger.w(logMessage, error: error, stackTrace: stackTrace);
  }

  static void error(dynamic message, {dynamic error, StackTrace? stackTrace, String? tag}) {
    if (!_enabled) return;
    final logMessage = tag != null ? '[$tag] ❌ $message' : '❌ $message';
    _logger.e(logMessage, error: error, stackTrace: stackTrace);
  }

  static void success(String message, {String? tag}) {
    if (!_enabled) return;
    final logMessage = tag != null ? '[$tag] ✅ $message' : '✅ $message';
    _logger.i(logMessage);
  }
}
