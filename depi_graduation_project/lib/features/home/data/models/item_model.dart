class ItemModel {
  final String? id;
  final String name;
  final String image;
  final String rating;
  final String location;
  final bool openNow;
  final String description;

  ItemModel({
    this.id,
    required this.name,
    required this.location,
    required this.image,
    required this.rating,
    required this.openNow,
    required this.description,
  });

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'] as String?,
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      image: map['image'] ?? '',
      rating: map['rating']?.toString() ?? '0',
      openNow: map['openNow'] ?? false,
      description: map['description'] ?? '',
    );
  }

  // copyWith method
  ItemModel copyWith({
    String? id,
    String? name,
    String? image,
    String? rating,
    String? location,
    String? description,
    bool? openNow,
  }) {
    return ItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      openNow: openNow ?? this.openNow,
      description: description ?? this.description,
    );
  }
}
