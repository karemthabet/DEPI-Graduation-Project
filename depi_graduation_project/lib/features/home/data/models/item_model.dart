class ItemModel {
  final String? id;
  final String name;
  final String image;
  final String rating;
  final String location;
  final String description;

  ItemModel({
    this.id,
    required this.name,
    required this.location,
    required this.image,
    required this.rating,
    required this.description,
  });

  // Add copyWith method for easier updates
  ItemModel copyWith({
    String? id,
    String? name,
    String? image,
    String? rating,
    String? location,
    String? description,
  }) {
    return ItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      description: description ?? this.description,
    );
  }
}
