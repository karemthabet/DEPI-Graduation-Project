import 'package:dio/dio.dart';
import 'package:whatsapp/core/errors/custom_exception.dart';
import 'package:whatsapp/core/errors/server_failure.dart';
import 'package:whatsapp/core/helper/app_logger.dart';

class ErrorHandler {
  static ServerFailure handle(Object error, [StackTrace? stackTrace]) {
    if (error is DioException) {
      final failure = ServerFailure.fromDioExcepiton(error);
      AppLogger.error('🌐 Dio Error: ${failure.errMessage} (${failure.statusCode})');
      return failure;
    } else if (error is CustomException) {
      AppLogger.error('💾 Backend Error: ${error.message} (${error.statusCode})');
      return ServerFailure(errMessage: error.message, statusCode: error.statusCode);
    } else {
      AppLogger.error('🔥 Unexpected Error: $error\n$stackTrace');
      return ServerFailure(errMessage: 'Unexpected error occurred', statusCode: 500);
    }
  }
}
