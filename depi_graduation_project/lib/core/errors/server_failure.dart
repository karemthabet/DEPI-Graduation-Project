import 'package:dio/dio.dart';

abstract class Failure {
  final String errMessage;
  final int? statusCode;

  Failure({required this.errMessage, this.statusCode});
}

class ServerFailure extends Failure {
  ServerFailure({required super.errMessage, super.statusCode});

  factory ServerFailure.fromDioExcepiton(DioException dioException) {
    final statusCode = dioException.response?.statusCode ?? 0;

    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure(
          errMessage: '⏳ Connection timeout',
          statusCode: statusCode,
        );
      case DioExceptionType.sendTimeout:
        return ServerFailure(
          errMessage: '📤 Send timeout',
          statusCode: statusCode,
        );
      case DioExceptionType.receiveTimeout:
        return ServerFailure(
          errMessage: '📥 Receive timeout',
          statusCode: statusCode,
        );
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          statusCode,
          dioException.response?.data,
        );
      case DioExceptionType.cancel:
        return ServerFailure(
          errMessage: '❌ Request cancelled',
          statusCode: statusCode,
        );
      case DioExceptionType.connectionError:
        return ServerFailure(
          errMessage: '🌐 Connection error',
          statusCode: statusCode,
        );
      default:
        return ServerFailure(
          errMessage: '⚠️ Unexpected network error',
          statusCode: statusCode,
        );
    }
  }

  /// ✅ استخراج الرسالة من رد السيرفر
  factory ServerFailure.fromResponse(int statusCode, dynamic response) {
    String message = 'Unexpected error';

    try {
      if (response is Map<String, dynamic>) {
        message =
            response['message'] ??
            response['error'] ??
            _extractFromErrors(response['errors']) ??
            'Unknown server error';
      } else if (response is String) {
        message = 'Server returned non-JSON response: $response';
      }
    } catch (_) {
      message = 'Error parsing server response';
    }

    return ServerFailure(errMessage: message, statusCode: statusCode);
  }

  static String? _extractFromErrors(dynamic errors) {
    if (errors is Map && errors.isNotEmpty) {
      final firstError = errors.values.first;
      if (firstError is List && firstError.isNotEmpty) {
        return firstError.first.toString();
      }
      if (firstError is String) return firstError;
    }
    return null;
  }
}
