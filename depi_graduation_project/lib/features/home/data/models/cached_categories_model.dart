import 'package:hive/hive.dart';

part 'cached_categories_model.g.dart';

/// 📂 نموذج لحفظ قائمة الفئات المتاحة في الكاش
/// Model for caching available categories
///
/// يحفظ قائمة الفئات المتاحة (مطاعم، متاحف، إلخ)
/// Saves list of available categories (restaurants, museums, etc.)
///
/// HiveType(typeId: 13) - معرف فريد لهذا النموذج في Hive
@HiveType(typeId: 13)
class CachedCategoriesModel extends HiveObject {
  /// قائمة الفئات المتاحة - Available categories list
  /// Map<CategoryKey, CategoryName>
  /// مثال: {'restaurant': 'مطاعم', 'museum': 'متاحف'}
  @HiveField(0)
  final Map<String, String> categories;

  /// وقت حفظ البيانات - Timestamp when data was cached
  @HiveField(1)
  final DateTime timestamp;

  /// خط العرض للموقع الذي تم جلب البيانات منه
  /// Latitude of location where data was fetched
  @HiveField(2)
  final double latitude;

  /// خط الطول للموقع الذي تم جلب البيانات منه
  /// Longitude of location where data was fetched
  @HiveField(3)
  final double longitude;

  CachedCategoriesModel({
    required this.categories,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
  });

  /// نسخ النموذج مع تعديل بعض القيم
  /// Copy model with modified values
  CachedCategoriesModel copyWith({
    Map<String, String>? categories,
    DateTime? timestamp,
    double? latitude,
    double? longitude,
  }) {
    return CachedCategoriesModel(
      categories: categories ?? this.categories,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
