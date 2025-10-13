class CustomException implements Exception {
  final String message;
  final int? statusCode;

  CustomException({required this.message, this.statusCode});

  @override
  String toString() => 'CustomException: $message (code: $statusCode)';
}
