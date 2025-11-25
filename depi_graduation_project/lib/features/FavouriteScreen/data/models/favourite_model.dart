class FavouriteModel {
  final String id;
  final String userId;
  final String? placeId;
  final String title;
  final String location;
  final String imageUrl;
  final String rating;

  FavouriteModel({
    required this.id,
    required this.userId,
    required this.placeId,
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.location,
  });

  factory FavouriteModel.fromSupabase(Map<String, dynamic> row) {
    return FavouriteModel(
      id: row['id'] ?? '',
      userId: row['user_id'] ?? '',
      placeId: row['place_id'],
      title: row['title'] ?? '',
      imageUrl: row['image_url'] ?? '',
      rating: row['rating'] ?? '',
      location: row['location'] ?? '',
    );
  }

  Map<String, dynamic> toSupabaseRow() {
    return {
      'id': id,
      'user_id': userId,
      'place_id': placeId,
      'title': title,
      'image_url': imageUrl,
      'rating': rating,
      'location': location,
    };
  }
}
