class VisitItem {
  final int id;
  final String placeId;
  final String placeName;
  final String address;
  final String imageUrl;
  final double rating;
  final int visitDateId;
  final String? visitTime;
  final bool isCompleted;
  final String userId;

  VisitItem({
    required this.id,
    required this.placeId,
    required this.placeName,
    required this.address,
    required this.imageUrl,
    required this.rating,
    required this.visitDateId,
    this.visitTime,
    required this.isCompleted,
    required this.userId,
  });

  factory VisitItem.fromJson(Map<String, dynamic> json) {
    return VisitItem(
      id: json['id'],
      placeId: json['place_id'],
      placeName: json['placename'],
      address: json['adress'], // Note: Schema has 'adress'
      imageUrl: json['image_url'],
      rating: json['rating'] is String 
          ? double.tryParse(json['rating']) ?? 0.0 
          : (json['rating'] as num).toDouble(),
      visitDateId: json['visited_date_id'], // Note: Schema has 'visited_date_id'
      visitTime: json['visit_time'],
      isCompleted: json['iscompleted'] ?? false,
      userId: json['user_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'place_id': placeId,
      'placename': placeName,
      'adress': address, // Note: Schema has 'adress'
      'image_url': imageUrl,
      'rating': rating,
      'visited_date_id': visitDateId, // Note: Schema has 'visited_date_id'
      'visit_time': visitTime,
      'iscompleted': isCompleted,
      'user_id': userId,
    };
  }
}