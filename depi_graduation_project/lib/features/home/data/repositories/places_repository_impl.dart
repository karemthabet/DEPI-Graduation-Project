import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:whatsapp/core/services/location_service.dart';
import '../models/place_model.dart';
import 'places_repository.dart';

class PlacesRepositoryImpl extends PlacesRepository {
  final Dio dio = Dio();
  final String apiKey = 'AIzaSyDuccoSdICVDXCXY4Qz-HH9GjyIr6YWayY';

  @override
  Future<List<PlaceModel>> getNearbyPlaces() async {
    final pos = await LocationService.getCurrentLocation();

    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${pos.latitude},${pos.longitude}&radius=10000&key=$apiKey';

    final response = await dio.get(url);
    final data = jsonDecode(response.toString());

    if (response.statusCode == 200 && data['status'] == 'OK') {
      final results = data['results'] as List;
      return results.map((e) => PlaceModel.fromJson(e)).toList();
    } else {
      throw Exception(data['error_message'] ?? 'فشل تحميل الأماكن.');
    }
  }

  @override
@override
Future<Map<String, dynamic>> getPlaceDetails(String placeId) async {
  final url =
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=name,rating,formatted_address,geometry,photos,website,formatted_phone_number,reviews,editorial_summary&key=$apiKey';

  final response = await dio.get(url);
  final data = jsonDecode(response.toString());

  if (response.statusCode == 200 && data['status'] == 'OK') {
    return data['result'];
  } else {
    throw Exception(data['error_message'] ?? 'فشل تحميل تفاصيل المكان.');
  }
}

}
