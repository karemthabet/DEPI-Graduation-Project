class CustomException implements Exception {
  final String message;
  final int? statusCode;

  CustomException({required this.message, this.statusCode});

  @override
  String toString() => 'CustomException: $message (code: $statusCode)';
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class UnexpectedException implements Exception {
  final String message;
  UnexpectedException(this.message);
}

class NotificationException implements Exception {
  final String message;
  NotificationException(this.message);
}
