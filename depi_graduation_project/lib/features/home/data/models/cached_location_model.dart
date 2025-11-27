import 'package:hive/hive.dart';

part 'cached_location_model.g.dart';

/// 📍 نموذج لحفظ موقع المستخدم الأخير في الكاش
/// Model for caching user's last location
///
/// يستخدم هذا النموذج لحفظ آخر موقع تم جلب البيانات منه
/// This model is used to save the last location where data was fetched
///
/// HiveType(typeId: 10) - معرف فريد لهذا النموذج في Hive
@HiveType(typeId: 10)
class CachedLocationModel extends HiveObject {
  /// خط العرض - Latitude
  @HiveField(0)
  final double latitude;

  /// خط الطول - Longitude
  @HiveField(1)
  final double longitude;

  /// وقت حفظ الموقع - Timestamp when location was saved
  @HiveField(2)
  final DateTime timestamp;

  CachedLocationModel({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  /// نسخ النموذج مع تعديل بعض القيم
  /// Copy model with modified values
  CachedLocationModel copyWith({
    double? latitude,
    double? longitude,
    DateTime? timestamp,
  }) {
    return CachedLocationModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
