import 'package:hive/hive.dart';

part 'place_model.g.dart';

@HiveType(typeId: 1)
class PlaceModel {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String vicinity;
  @HiveField(2)
  final double? rating;
  @HiveField(3)
  final String category;
  @HiveField(4)
  final String placeId;
  @HiveField(5)
  final String? photoReference;
  @HiveField(6)
  final double lat;
  @HiveField(7)
  final double lng;
  @HiveField(8)
  final OpeningHours? openingHours;

  @HiveField(9)
  final String? formattedAddress;
  @HiveField(10)
  final String? description;
  @HiveField(11)
  final List<ReviewModel>? reviews;

  PlaceModel({
    required this.name,
    required this.vicinity,
    this.rating,
    required this.category,
    required this.placeId,
    this.photoReference,
    required this.lat,
    required this.lng,
    this.formattedAddress,
    this.description,
    this.reviews,
    this.openingHours,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    final List<String> types = List<String>.from(json['types'] ?? []);
    final String category = _detectCategory(types);

    return PlaceModel(
      name: json['name'] ?? 'Unknown',
      vicinity: json['vicinity'] ?? 'Unknown',
      rating: (json['rating'] is num) ? json['rating'].toDouble() : null,
      category: category,
      placeId: json['place_id'] ?? '',
      photoReference:
          json['photos'] != null && json['photos'].isNotEmpty
              ? json['photos'][0]['photo_reference']
              : null,
      lat: json['geometry']?['location']?['lat']?.toDouble() ?? 0.0,
      lng: json['geometry']?['location']?['lng']?.toDouble() ?? 0.0,
      formattedAddress: json['formatted_address'],
      description: json['editorial_summary']?['overview'],
      reviews:
          json['reviews'] != null
              ? (json['reviews'] as List)
                  .map((r) => ReviewModel.fromJson(r))
                  .toList()
              : null,
      openingHours:
          json['opening_hours'] != null
              ? OpeningHours.fromJson(json['opening_hours'])
              : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'vicinity': vicinity,
      'rating': rating,
      'category': category,
      'place_id': placeId,
      'photo_reference': photoReference,
      'lat': lat,
      'lng': lng,
      'formatted_address': formattedAddress,
      'description': description,
      'reviews': reviews?.map((r) => r.toJson()).toList(),
      'opening_hours': openingHours?.toJson(),
      'types': [
        category,
      ], // Store category as a type to be re-detected or handled
    };
  }

  static String _detectCategory(List<String> types) {
    // تصنيف الأماكن بناءً على الأولوية من الأكثر تحديداً للأقل

    // 1. المتاحف (أعلى أولوية للأماكن الثقافية)
    if (types.contains('museum')) return 'museum';

    // 2. المكتبات
    if (types.contains('library')) return 'library';

    // 3. السينما ودور العرض
    if (types.contains('movie_theater') || types.contains('cinema')) {
      return 'cinema';
    }

    // 4. المساجد ودور العبادة الإسلامية
    if (types.contains('mosque')) return 'mosque';

    // 5. الأماكن التاريخية والدينية
    if (types.contains('church') ||
        types.contains('synagogue') ||
        types.contains('hindu_temple') ||
        types.contains('place_of_worship')) {
      return 'historical';
    }

    // 6. المطاعم (قبل الكافيهات لأنها أكثر تحديداً)
    if (types.contains('restaurant') ||
        types.contains('food') ||
        types.contains('meal_takeaway') ||
        types.contains('meal_delivery')) {
      return 'restaurant';
    }

    // 7. الكافيهات
    if (types.contains('cafe') || types.contains('coffee_shop')) return 'cafe';

    // 8. الفنادق وأماكن الإقامة
    if (types.contains('lodging') ||
        types.contains('hotel') ||
        types.contains('resort') ||
        types.contains('hostel')) {
      return 'hotel';
    }

    // 9. الحدائق والمنتزهات
    if (types.contains('park') ||
        types.contains('amusement_park') ||
        types.contains('aquarium') ||
        types.contains('zoo')) {
      return 'park';
    }

    // 10. مراكز التسوق
    if (types.contains('shopping_mall') ||
        types.contains('shopping_center') ||
        types.contains('department_store')) {
      return 'shopping_mall';
    }

    // 11. المعالم السياحية (أولوية متوسطة)
    if (types.contains('tourist_attraction')) return 'tourist_attraction';

    // 12. نقاط الاهتمام العامة تُصنف كمعالم سياحية
    if (types.contains('point_of_interest')) return 'tourist_attraction';

    // 13. أماكن أخرى غير مصنفة
    return 'others';
  }
}

@HiveType(typeId: 2)
class OpeningHours {
  @HiveField(0)
  final bool openNow;

  OpeningHours({required this.openNow});

  factory OpeningHours.fromJson(Map<String, dynamic> json) {
    return OpeningHours(openNow: json['open_now'] ?? false);
  }

  Map<String, dynamic> toJson() {
    return {'open_now': openNow};
  }
}

@HiveType(typeId: 3)
class ReviewModel {
  @HiveField(0)
  final String authorName;
  @HiveField(1)
  final String text;
  @HiveField(2)
  final double? rating;

  ReviewModel({required this.authorName, required this.text, this.rating});

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      authorName: json['author_name'] ?? 'Anonymous',
      text: json['text'] ?? '',
      rating: (json['rating'] is num) ? json['rating'].toDouble() : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {'author_name': authorName, 'text': text, 'rating': rating};
  }
}
