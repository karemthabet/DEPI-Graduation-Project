import 'package:geolocator/geolocator.dart';

class LocationService {
  // Singleton
  LocationService._privateConstructor();
  static final LocationService instance = LocationService._privateConstructor();

  /// التحقق من تفعيل خدمة الموقع
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// التحقق من حالة الإذن
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// طلب إذن الوصول للموقع
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  /// فتح إعدادات الموقع
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  /// فتح إعدادات التطبيق
  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }

  /// التحقق الشامل من الموقع والأذونات
  Future<LocationStatus> checkLocationStatus() async {
    // التحقق من تفعيل خدمة الموقع
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationStatus.serviceDisabled;
    }

    // التحقق من الأذونات
    final LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      return LocationStatus.permissionDenied;
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationStatus.permissionDeniedForever;
    }

    return LocationStatus.granted;
  }

  /// الحصول على الموقع الحالي مع التحقق من الأذونات
  Future<Position> getCurrentLocation() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('خدمة الموقع غير مفعّلة. الرجاء تشغيل الـ GPS.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('تم رفض إذن الوصول إلى الموقع.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('تم رفض إذن الوصول إلى الموقع نهائيًا.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}

/// حالات الموقع والأذونات
enum LocationStatus {
  granted, // تم منح الإذن والموقع مفعل
  serviceDisabled, // خدمة الموقع غير مفعلة
  permissionDenied, // تم رفض الإذن
  permissionDeniedForever, // تم رفض الإذن نهائياً
}
