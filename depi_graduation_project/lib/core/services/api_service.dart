abstract class ApiService {
  Future<dynamic> get(
    String endPoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool withToken = true,
  });

  Future<dynamic> post(
    String endPoint, {
    required Map<String, dynamic> data,
    Map<String, dynamic>? headers,
    bool isFormData = false,
    bool withToken = true,
  });

  Future<dynamic> patch(
    String endPoint, {
    required Map<String, dynamic> data,
    Map<String, dynamic>? headers,
    bool isFormData = false,
    bool withToken = true,
  });

  Future<dynamic> delete(
    String endPoint, {
    Object? data,
    Map<String, dynamic>? headers,
    bool isFormData = false,
    bool withToken = true,
  });

  Future<dynamic> put(
    String endPoint, {
    required Map<String, dynamic> data,
    Map<String, dynamic>? headers,
    bool isFormData = false,
    bool withToken = true,
  });
}
