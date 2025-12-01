import 'package:hive/hive.dart';
import 'place_model.dart';

part 'cached_top_recommendations_model.g.dart';

/// 🌟 نموذج لحفظ قائمة الأماكن الأعلى تقييماً في الكاش
/// Model for caching top recommended places
///
/// يحفظ قائمة الأماكن المُوصى بها بناءً على التقييمات
/// Saves list of recommended places based on ratings
///
/// HiveType(typeId: 11) - معرف فريد لهذا النموذج في Hive
@HiveType(typeId: 11)
class CachedTopRecommendationsModel extends HiveObject {
  /// قائمة الأماكن الأعلى تقييماً - List of top rated places
  @HiveField(0)
  final List<PlaceModel> topPlaces;

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

  CachedTopRecommendationsModel({
    required this.topPlaces,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
  });

  /// نسخ النموذج مع تعديل بعض القيم
  /// Copy model with modified values
  CachedTopRecommendationsModel copyWith({
    List<PlaceModel>? topPlaces,
    DateTime? timestamp,
    double? latitude,
    double? longitude,
  }) {
    return CachedTopRecommendationsModel(
      topPlaces: topPlaces ?? this.topPlaces,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
