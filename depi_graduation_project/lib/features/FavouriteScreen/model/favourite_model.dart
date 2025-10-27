class FavouriteCard {
  final String name;
  final String location;
  final double rating;
  final String imagePath;
  bool isFavorite;

  FavouriteCard({
    required this.name,
    required this.location,
    required this.rating,
    required this.imagePath,
    this.isFavorite = false,
  });
}
