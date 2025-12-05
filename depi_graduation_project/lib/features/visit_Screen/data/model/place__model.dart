class Place {
  final String id;
  final String name;
  final String address;
  final String imageUrl;
  final double rating;
  final Map<String, dynamic> rawData;

  Place({
    required this.id,
    required this.name,
    required this.address,
    required this.imageUrl,
    required this.rating,
    required this.rawData,
  });

  Map<String, dynamic> toJson() => rawData;
}