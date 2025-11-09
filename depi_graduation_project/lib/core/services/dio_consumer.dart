import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:whatsapp/core/services/dio_logger.dart';
import '../errors/custom_exception.dart';
import '../errors/server_failure.dart';
import '../helper/app_logger.dart';
import '../services/api_service.dart';
import '../utils/constants/api_constants.dart';

class DioConsumer implements ApiService {
  final Dio dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  int _retryCount = 0;
  final int _maxRetryCount = 3;

  DioConsumer({required this.dio}) {
    dio.options
      ..baseUrl = ApiBase.baseUrl
      ..followRedirects = false
      ..connectTimeout = const Duration(seconds: 15)
      ..receiveTimeout = const Duration(seconds: 15)
      ..validateStatus = (status) => status != null && status < 500;

    dio.interceptors.add(DioLogger());

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, ErrorInterceptorHandler handler) async {
          if (_shouldRetry(e) && _retryCount < _maxRetryCount) {
            _retryCount++;
            AppLogger.warning('🔁 Retrying request ($_retryCount/$_maxRetryCount)...');
            await Future.delayed(const Duration(seconds: 2));
            try {
              final response = await dio.fetch(e.requestOptions);
              _retryCount = 0;
              return handler.resolve(response);
            } catch (_) {
              return handler.next(e);
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  bool _shouldRetry(DioException e) =>
      e.type == DioExceptionType.connectionError ||
      e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout;

  Future<Map<String, String>> _buildHeaders(Map<String, dynamic>? headers, bool withToken) async {
    final finalHeaders = <String, String>{
      'Api-Request-Signature': 'mobile-app-request',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Connection': 'keep-alive',
    };

    if (headers != null) {
      headers.forEach((key, value) => finalHeaders[key] = value.toString());
    }

    if (withToken) {
      final token = await _secureStorage.read(key: 'access_token');
      if (token != null && token.isNotEmpty) {
        finalHeaders['Authorization'] = 'Bearer $token';
      }
    }

    return finalHeaders;
  }

  @override
  Future get(String endPoint, {Map<String, dynamic>? queryParameters, Map<String, dynamic>? headers, bool withToken = true}) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: queryParameters,
        options: Options(headers: await _buildHeaders(headers, withToken)),
      );
      _retryCount = 0;
      return response.data;
    } on DioException catch (e) {
      final failure = ServerFailure.fromDioExcepiton(e);
      throw CustomException(message: failure.errMessage, statusCode: failure.statusCode);
    }
  }

  // POST
  @override
  Future post(String endPoint, {required Map<String, dynamic> data, Map<String, dynamic>? headers, bool isFormData = false, bool withToken = true}) async {
    try {
      final response = await dio.post(
        endPoint,
        data: isFormData ? FormData.fromMap(data) : data,
        options: Options(
          contentType: isFormData ? 'multipart/form-data' : 'application/json',
          headers: await _buildHeaders(headers, withToken),
          followRedirects: false,
        ),
      );
      _retryCount = 0;
      return response.data;
    } on DioException catch (e) {
      final failure = ServerFailure.fromDioExcepiton(e);
      throw CustomException(message: failure.errMessage, statusCode: failure.statusCode);
    }
  }

  // PUT
  @override
  Future put(String endPoint, {required Map<String, dynamic> data, Map<String, dynamic>? headers, bool isFormData = false, bool withToken = true}) async {
    try {
      final response = await dio.put(
        endPoint,
        data: isFormData ? FormData.fromMap(data) : data,
        options: Options(headers: await _buildHeaders(headers, withToken)),
      );
      _retryCount = 0;
      return response.data;
    } on DioException catch (e) {
      final failure = ServerFailure.fromDioExcepiton(e);
      throw CustomException(message: failure.errMessage, statusCode: failure.statusCode);
    }
  }

  // PATCH
  @override
  Future patch(String endPoint, {required Map<String, dynamic> data, Map<String, dynamic>? headers, bool isFormData = false, bool withToken = true}) async {
    try {
      final response = await dio.patch(
        endPoint,
        data: isFormData ? FormData.fromMap(data) : data,
        options: Options(headers: await _buildHeaders(headers, withToken)),
      );
      _retryCount = 0;
      return response.data;
    } on DioException catch (e) {
      final failure = ServerFailure.fromDioExcepiton(e);
      throw CustomException(message: failure.errMessage, statusCode: failure.statusCode);
    }
  }

  // DELETE
  @override
  Future delete(String endPoint, {Object? data, Map<String, dynamic>? headers, bool isFormData = false, bool withToken = true}) async {
    try {
      final response = await dio.delete(
        endPoint,
        data: isFormData && data is Map<String, dynamic> ? FormData.fromMap(data) : data,
        options: Options(headers: await _buildHeaders(headers, withToken)),
      );
      _retryCount = 0;
      return response.data;
    } on DioException catch (e) {
      final failure = ServerFailure.fromDioExcepiton(e);
      throw CustomException(message: failure.errMessage, statusCode: failure.statusCode);
    }
  }
}
