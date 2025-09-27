class Place {
  final String name;
  final String vicinity;
  final String? rating;
  final String category;
  final String placeId;
  final String? photoReference;
  Place({
    required this.name,
    required this.vicinity,
    this.rating,
    required this.category,
    required this.placeId,
    this.photoReference,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    List<String> types = List<String>.from(json['types'] ?? []);
    String category = 'tourist_attraction'; // default
    if (types.contains('museum')) {
      category = 'museum';
    } else if (types.contains('historical_landmark') || types.contains('church') || types.contains('mosque')) {
      category = 'historical';
    } else if (types.contains('zoo')) {
      category = 'zoo';
    } else if (types.contains('park')) {
      category = 'park';
    } else if (types.contains('shopping_mall')) {
      category = 'shopping_mall';
    } else if (types.contains('movie_theater')) {
      category = 'movie_theater';
    } else if (types.contains('tourist_attraction')) {
      category = 'tourist_attraction';
    } else if (types.contains('restaurant') || types.contains('cafe') || types.contains('food')) {
      category = 'restaurant';
    } else if (types.contains('lodging')) {
      category = 'hotel';
    }
    return Place(
      name: json['name'] ?? 'Unknown',
      vicinity: json['vicinity'] ?? 'Unknown',
      rating: json['rating']?.toString(),
      category: category,
      placeId: json['place_id'] ?? '',
      photoReference: json['photos'] != null && json['photos'].isNotEmpty
          ? json['photos'][0]['photo_reference']
          : null,
    );
  }
}
