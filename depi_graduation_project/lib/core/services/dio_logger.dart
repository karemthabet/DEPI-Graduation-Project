import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:whatsapp/core/helper/app_logger.dart' show AppLogger;

/// 🔍 DioLogger: مسؤول عن طباعة تفاصيل الطلبات (Request/Response/Error)
/// بشكل منسق وجميل داخل الـ console.
class DioLogger extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final method = options.method;
    final url = options.uri.toString();
    final headers = options.headers;
    final body = options.data;

    AppLogger.info('🌐 [REQUEST] $method → $url');
    if (headers.isNotEmpty) {
      AppLogger.debug('🧾 Headers: ${jsonEncode(headers)}');
    }
    if (body != null && body.toString().isNotEmpty) {
      AppLogger.debug('📤 Body: ${jsonEncode(body)}');
    }
    AppLogger.log('──────────────────────────────────────────────');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final statusCode = response.statusCode;
    final statusMessage = response.statusMessage;
    final data = response.data;

    AppLogger.success(
      '✅ [RESPONSE] ${response.requestOptions.method} → ${response.requestOptions.uri}',
    );
    AppLogger.info('📊 Status: $statusCode $statusMessage');

    // إذا السيرفر رجع HTML بدل JSON (مثلاً redirect أو error من السيرفر)
    if (data is String && data.contains('<!DOCTYPE html>')) {
      AppLogger.warning(
        '⚠️ Response contains HTML (possible redirect or server issue)',
      );
    } else {
      AppLogger.info('📦 Data:\n${_prettyJson(data)}');
    }

    AppLogger.log('──────────────────────────────────────────────\n');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      '❌ [ERROR] ${err.requestOptions.method} → ${err.requestOptions.uri}',
    );
    AppLogger.error('🚨 Message: ${err.message}');
    if (err.response != null) {
      AppLogger.error('📊 Status: ${err.response?.statusCode}');
      AppLogger.error('📦 Error Data:\n${_prettyJson(err.response?.data)}');
    }
    AppLogger.log('──────────────────────────────────────────────\n');
    handler.next(err);
  }

  /// 🎨 دالة لترتيب JSON بطريقة جميلة في اللوج
  String _prettyJson(dynamic data) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(data);
    } catch (_) {
      return data.toString();
    }
  }
}
