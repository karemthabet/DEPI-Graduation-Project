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
