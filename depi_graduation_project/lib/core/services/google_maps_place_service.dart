import 'package:dio/dio.dart';

class GoogleMapsPlaceService {
  final Dio dio = Dio();

  final String baseUrl = 'https://maps.googleapis.com/maps/api/place';
  final String apiKey = 'AIzaSyA3FifUzz1TsB2bknK0VARH_45PT_AuyMw';

  Future<List<dynamic>> fetchPredictions({
    required String input,
    required String sessionToken,
  }) async {
    try {
      final response = await dio.get(
        '$baseUrl/autocomplete/json',
        queryParameters: {
          'key': apiKey,
          'input': input,
          'sessiontoken': sessionToken,
          'components': 'country:eg',
        },
      );

      if (response.data['status'] == 'OK') {
        return response.data['predictions'];
      } else {
        return [];
      }
    } catch (_) {
      return [];
    }
  }

  Future<Map<String, dynamic>?> fetchPlaceDetails(String placeId) async {
    try {
      final response = await dio.get(
        '$baseUrl/details/json',
        queryParameters: {
          'key': apiKey,
          'place_id': placeId,
        },
      );

      if (response.data['status'] == 'OK') {
        return response.data['result'];
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }
}
