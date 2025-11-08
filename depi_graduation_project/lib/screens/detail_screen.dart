import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/features/home/data/models/place_model.dart';
import 'package:whatsapp/features/home/presentation/cubit/places_cubit.dart';

class DetailScreen extends StatelessWidget {
  final PlaceModel place;

  const DetailScreen({super.key, required this.place});

  Future<void> openInMaps(double lat, double lng) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PlacesCubit>();

    return Scaffold(
      appBar: AppBar(title: Text(place.name)),
      body: FutureBuilder<Map<String, dynamic>>(
        future: cubit.loadPlaceDetails(place.placeId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final details = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // صورة المكان
                if (place.photoReference != null)
                  Image.network(
                    'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${place.photoReference}&key=AIzaSyDuccoSdICVDXCXY4Qz-HH9GjyIr6YWayY',
                  ),

                const SizedBox(height: 10),

                // اسم المكان
                Text(
                  place.name,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                // العنوان الكامل
                if (details['formatted_address'] != null)
                  Text('📍 ${details['formatted_address']}'),

                // تقييم المكان
                if (place.rating != null)
                  Text('⭐ ${place.rating}'),

                const SizedBox(height: 16),

                // رقم الهاتف
                if (details['formatted_phone_number'] != null)
                  Text('📞 ${details['formatted_phone_number']}'),

                // الموقع الإلكتروني
                if (details['website'] != null)
                  Text('🌐 ${details['website']}'),

                const SizedBox(height: 16),

                // الوصف
                if (details['editorial_summary']?['overview'] != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(details['editorial_summary']['overview']),
                  ),

                // الريفيوز
                if (details['reviews'] != null && details['reviews'].isNotEmpty)
                  ...details['reviews'].map<Widget>((r) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                r['author_name'] ?? 'Anonymous',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              if (r['rating'] != null)
                                Text('⭐ ${r['rating']}'),
                              Text(r['text'] ?? ''),
                            ],
                          ),
                        ),
                      )),

                const SizedBox(height: 16),

                // زر فتح المكان في Google Maps
                ElevatedButton.icon(
                  onPressed: () => openInMaps(place.lat, place.lng),
                  icon: const Icon(Icons.map),
                  label: const Text('افتح في Google Maps'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
