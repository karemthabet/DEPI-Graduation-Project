import 'package:hive/hive.dart';

part 'cached_place_details_model.g.dart';

/// 📝 نموذج لحفظ تفاصيل مكان معين في الكاش
/// Model for caching place details
///
/// يحفظ تفاصيل مكان معين بناءً على place_id
/// Saves details of a specific place based on place_id
///
/// HiveType(typeId: 12) - معرف فريد لهذا النموذج في Hive
@HiveType(typeId: 12)
class CachedPlaceDetailsModel extends HiveObject {
  /// معرف المكان الفريد - Unique place identifier
  @HiveField(0)
  final String placeId;

  /// تفاصيل المكان كـ Map - Place details as Map
  /// يحتوي على جميع البيانات التي يرجعها API
  /// Contains all data returned by the API
  @HiveField(1)
  final Map<String, dynamic> details;

  /// وقت حفظ البيانات - Timestamp when data was cached
  @HiveField(2)
  final DateTime timestamp;

  CachedPlaceDetailsModel({
    required this.placeId,
    required this.details,
    required this.timestamp,
  });

  /// نسخ النموذج مع تعديل بعض القيم
  /// Copy model with modified values
  CachedPlaceDetailsModel copyWith({
    String? placeId,
    Map<String, dynamic>? details,
    DateTime? timestamp,
  }) {
    return CachedPlaceDetailsModel(
      placeId: placeId ?? this.placeId,
      details: details ?? this.details,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
