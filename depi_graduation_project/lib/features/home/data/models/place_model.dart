class PlaceModel {
  final String name;
  final String vicinity;
  final double? rating;
  final String category;
  final String placeId;
  final String? photoReference;
  final double lat;
  final double lng;

  final String? formattedAddress;
  final String? description;
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
      photoReference: json['photos'] != null && json['photos'].isNotEmpty
          ? json['photos'][0]['photo_reference']
          : null,
      lat: json['geometry']?['location']?['lat']?.toDouble() ?? 0.0,
      lng: json['geometry']?['location']?['lng']?.toDouble() ?? 0.0,
      formattedAddress: json['formatted_address'],
      description: json['editorial_summary']?['overview'],
      reviews: json['reviews'] != null
          ? (json['reviews'] as List)
              .map((r) => ReviewModel.fromJson(r))
              .toList()
          : null,
    );
  }

  static String _detectCategory(List<String> types) {
    // Priority-based categorization
    if (types.contains('museum')) return 'museum';
    if (types.contains('cafe')) return 'cafe';
    if (types.contains('restaurant') || types.contains('food')) return 'restaurant';
    if (types.contains('lodging') || types.contains('hotel')) return 'hotel';
    if (types.contains('park')) return 'park';
    if (types.contains('shopping_mall') || types.contains('shopping_center')) return 'shopping_mall';
    if (types.contains('church') || types.contains('mosque') || types.contains('synagogue') || 
        types.contains('hindu_temple') || types.contains('place_of_worship')) return 'historical';
    if (types.contains('tourist_attraction')) return 'tourist_attraction';
    
    // Default to tourist attraction for points of interest
    if (types.contains('point_of_interest')) return 'tourist_attraction';
    
    return 'other';
  }
}

class ReviewModel {
  final String authorName;
  final String text;
  final double? rating;

  ReviewModel({
    required this.authorName,
    required this.text,
    this.rating,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      authorName: json['author_name'] ?? 'Anonymous',
      text: json['text'] ?? '',
      rating: (json['rating'] is num) ? json['rating'].toDouble() : null,
    );
  }
}
