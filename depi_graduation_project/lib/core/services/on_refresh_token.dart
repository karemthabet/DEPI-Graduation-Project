import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:whatsapp/core/utils/constants/app_constants.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final GetStorage _box = GetStorage();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  AuthInterceptor(this.dio);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      try {
        // Try to get refresh token from secure storage first
        String? refreshToken = await _secureStorage.read(
          key: AppConstants.kToken,
        );

        // Fallback to GetStorage if not found in secure storage
        refreshToken ??= _box.read(AppConstants.kToken);

        if (refreshToken == null) {
          throw Exception('No refresh token found');
        }

        final response = await dio.post(
          'https://api.example.com/refresh-token',
          data: {'refresh_token': refreshToken},
        );

        final newAccessToken = response.data['access_token'] as String;

        // Save to both secure storage and GetStorage for redundancy
        await _secureStorage.write(
          key: AppConstants.kToken,
          value: newAccessToken,
        );
        await _box.write(AppConstants.kToken, newAccessToken);

        final requestOptions = err.requestOptions;
        requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

        final retryResponse = await dio.fetch(requestOptions);
        return handler.resolve(retryResponse);
      } catch (e) {
        return handler.reject(err);
      }
    }
    return handler.next(err);
  }
}
