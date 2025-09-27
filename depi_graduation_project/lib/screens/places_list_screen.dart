import 'package:flutter/material.dart';
import '../models/place.dart';
import 'detail_screen.dart';

class PlacesListScreen extends StatelessWidget {
  final String category;
  final List<Place> places;

  const PlacesListScreen({super.key, required this.category, required this.places});

  @override
  Widget build(BuildContext context) {
    final categoryPlaces = places.where((p) => p.category == category).toList();
    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: ListView.builder(
        itemCount: categoryPlaces.length,
        itemBuilder: (context, index) {
          final place = categoryPlaces[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: place.photoReference != null
                  ? Image.network(
                      'https://maps.googleapis.com/maps/api/place/photo?maxwidth=100&photoreference=${place.photoReference}&key=AIzaSyDDNGD0MtxjNGA4xhOHZ9uOcJYjGOm0zTw',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.place, size: 60),
                    )
                  : const Icon(Icons.place, size: 60),
              title: Text(place.name),
              subtitle: Text(place.vicinity),
              trailing: place.rating != null ? Text('⭐ ${place.rating}') : null,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(place: place),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
