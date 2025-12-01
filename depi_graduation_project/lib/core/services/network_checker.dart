import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

/// 🌐 خدمة فحص الاتصال بالإنترنت
/// Network connectivity checker service
///
/// تستخدم للتحقق من توفر الإنترنت قبل محاولة الاتصال بالـ API
/// Used to check internet availability before attempting API calls
class NetworkChecker {
  /// Singleton pattern للتأكد من وجود نسخة واحدة فقط
  /// Singleton pattern to ensure only one instance exists
  NetworkChecker._();
  static final NetworkChecker instance = NetworkChecker._();

  final Connectivity _connectivity = Connectivity();

  /// التحقق من وجود اتصال بالإنترنت
  /// Check if internet connection is available
  ///
  /// العائد - Returns:
  /// - true: يوجد اتصال بالإنترنت
  ///   true: Internet connection is available
  /// - false: لا يوجد اتصال بالإنترنت
  ///   false: No internet connection
  ///
  /// كيف يعمل:
  /// How it works:
  ///
  /// 1. يفحص نوع الاتصال (WiFi, Mobile, Ethernet)
  ///    Checks connection type (WiFi, Mobile, Ethernet)
  ///
  /// 2. إذا كان الاتصال "none" يعني لا يوجد إنترنت
  ///    If connection is "none" means no internet
  ///
  /// 3. يمكن أن يكون هناك اتصال بالشبكة لكن بدون إنترنت
  ///    There can be network connection but no internet access
  Future<bool> isConnected() async {
    try {
      final List<ConnectivityResult> connectivityResult =
          await _connectivity.checkConnectivity();

      // التحقق من أن القائمة ليست فارغة وأن النتيجة ليست "none"
      // Check that list is not empty and result is not "none"
      if (connectivityResult.isEmpty) {
        return false;
      }

      // إذا كانت القائمة تحتوي على "none" فقط، لا يوجد اتصال
      // If list contains only "none", there's no connection
      if (connectivityResult.length == 1 &&
          connectivityResult.first == ConnectivityResult.none) {
        return false;
      }

      // يوجد نوع اتصال (WiFi, Mobile, Ethernet)
      // There is a connection type (WiFi, Mobile, Ethernet)
      return true;
    } catch (e) {
      // في حالة حدوث خطأ، نفترض عدم وجود اتصال
      // In case of error, assume no connection
      return false;
    }
  }

  /// الاستماع لتغييرات حالة الاتصال
  /// Listen to connectivity changes
  ///
  /// العائد - Returns: Stream يرسل تحديثات عند تغيير حالة الاتصال
  ///                   Stream that emits updates when connectivity changes
  ///
  /// مثال على الاستخدام:
  /// Usage example:
  /// ```dart
  /// NetworkChecker.instance.onConnectivityChanged.listen((isConnected) {
  ///   if (isConnected) {
  ///     print('متصل بالإنترنت');
  ///   } else {
  ///     print('غير متصل بالإنترنت');
  ///   }
  /// });
  /// ```
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((results) {
      if (results.isEmpty) return false;
      if (results.length == 1 && results.first == ConnectivityResult.none) {
        return false;
      }
      return true;
    });
  }

  /// فحص الاتصال الفعلي بالإنترنت عن طريق محاولة الاتصال بخادم
  /// Check actual internet connection by attempting to connect to a server
  ///
  /// ملاحظة: هذا الفحص أكثر دقة لكنه أبطأ
  /// Note: This check is more accurate but slower
  ///
  /// العائد - Returns:
  /// - true: يوجد اتصال فعلي بالإنترنت
  ///   true: Actual internet connection exists
  /// - false: لا يوجد اتصال فعلي بالإنترنت
  ///   false: No actual internet connection
  Future<bool> hasInternetAccess() async {
    try {
      // محاولة الاتصال بـ Google DNS
      // Try to connect to Google DNS
      final dio = Dio();
      final response = await dio.get(
        'https://www.google.com',
        options: Options(
          receiveTimeout: const Duration(seconds: 5),
          sendTimeout: const Duration(seconds: 5),
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// الحصول على نوع الاتصال الحالي
  /// Get current connection type
  ///
  /// العائد - Returns: نوع الاتصال (WiFi, Mobile, Ethernet, None)
  ///                   Connection type (WiFi, Mobile, Ethernet, None)
  Future<ConnectivityResult> getConnectionType() async {
    try {
      final List<ConnectivityResult> results =
          await _connectivity.checkConnectivity();

      if (results.isEmpty || results.first == ConnectivityResult.none) {
        return ConnectivityResult.none;
      }

      return results.first;
    } catch (e) {
      return ConnectivityResult.none;
    }
  }

  /// التحقق من نوع اتصال معين
  /// Check for specific connection type
  ///
  /// مثال - Example:
  /// ```dart
  /// bool isWiFi = await NetworkChecker.instance.isConnectionType(ConnectivityResult.wifi);
  /// ```
  Future<bool> isConnectionType(ConnectivityResult type) async {
    final currentType = await getConnectionType();
    return currentType == type;
  }
}

/// 📊 حالات الاتصال بالشبكة
/// Network connection states
enum NetworkStatus {
  /// متصل بالإنترنت - Connected to internet
  connected,

  /// غير متصل بالإنترنت - Not connected to internet
  disconnected,

  /// يتم التحقق من الاتصال - Checking connection
  checking,
}
