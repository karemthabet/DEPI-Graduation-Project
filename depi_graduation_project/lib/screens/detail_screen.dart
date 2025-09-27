import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/place.dart';

class DetailScreen extends StatefulWidget {
  final Place place;

  const DetailScreen({super.key, required this.place});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Map<String, dynamic>? details;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    const apiKey = 'AIzaSyDDNGD0MtxjNGA4xhOHZ9uOcJYjGOm0zTw';
    final url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=${widget.place.placeId}&key=$apiKey';
    try {
      Dio dio = Dio();
      final response = await dio.get(url);
      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        setState(() {
          details = response.data['result'];
          loading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load details';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  String? getPhotoUrl() {
    if (widget.place.photoReference != null) {
      return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${widget.place.photoReference}&key=AIzaSyDDNGD0MtxjNGA4xhOHZ9uOcJYjGOm0zTw';
    }
    return null;
  }

  Future<void> _launchMaps() async {
    if (details != null && details!['geometry'] != null) {
      final lat = details!['geometry']['location']['lat'];
      final lng = details!['geometry']['location']['lng'];
      final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
      try {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } catch (e) {
        // Fallback to geo
        final fallbackUrl = 'geo:$lat,$lng?q=${Uri.encodeComponent(widget.place.name)}';
        try {
          await launchUrl(Uri.parse(fallbackUrl));
        } catch (e2) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('لا يمكن فتح خرائط Google: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.place.name)),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (getPhotoUrl() != null)
                        Image.network(getPhotoUrl()!),
                      const SizedBox(height: 16),
                      Text(widget.place.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('العنوان / Address: ${widget.place.vicinity}'),
                      if (widget.place.rating != null)
                        Text('التقييم / Rating: ⭐ ${widget.place.rating}'),
                      if (details != null) ...[
                        const SizedBox(height: 16),
                        if (details!['formatted_phone_number'] != null)
                          Text('الهاتف / Phone: ${details!['formatted_phone_number']}'),
                        if (details!['website'] != null)
                          Text('الموقع الإلكتروني / Website: ${details!['website']}'),
                        if (details!['opening_hours'] != null)
                          Text('مفتوح الآن / Open Now: ${details!['opening_hours']['open_now'] ? 'نعم / Yes' : 'لا / No'}'),
                        if (details!['price_level'] != null)
                          Text('مستوى السعر / Price Level: ${'💰' * (details!['price_level'] as int)}'),
                        if (details!['reviews'] != null && (details!['reviews'] as List).isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('تقييمات / Reviews:', style: TextStyle(fontWeight: FontWeight.bold)),
                              for (var review in (details!['reviews'] as List).take(3))
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Text('"${review['text']}" - ${review['author_name']}'),
                                ),
                            ],
                          ),
                      ],
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _launchMaps,
                        icon: const Icon(Icons.directions),
                        label: const Text('الذهاب إلى المكان عبر Google Maps'),
                      ),
                    ],
                  ),
                ),
    );
  }
}
