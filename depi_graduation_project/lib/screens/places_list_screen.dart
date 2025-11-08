import 'package:flutter/material.dart';
import 'package:whatsapp/features/home/data/models/place_model.dart';
import 'detail_screen.dart';

class PlacesListScreen extends StatelessWidget {
  final String category;
  final List<PlaceModel> places;

  const PlacesListScreen({
    super.key,
    required this.category,
    required this.places,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: ListView.builder(
        itemCount: places.length,
        itemBuilder: (context, i) {
          final p = places[i];
          return ListTile(
            leading: p.photoReference != null
                ? Image.network(
                    'https://maps.googleapis.com/maps/api/place/photo?maxwidth=100&photoreference=${p.photoReference}&key=AIzaSyDuccoSdICVDXCXY4Qz-HH9GjyIr6YWayY',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.place),
            title: Text(p.name),
            subtitle: Text(p.vicinity),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailScreen(place: p),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
