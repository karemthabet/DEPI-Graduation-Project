import '../../../../core/services/api_service.dart';
import '../../../../core/utils/constants/api_constants.dart';
import '../models/place_model.dart';

class PlacesRemoteDataSource {
  final ApiService apiService;

  PlacesRemoteDataSource({required this.apiService});

  Future<List<PlaceModel>> getNearbyPlaces({
    required double latitude,
    required double longitude,
  }) async {
    try {
      print('Fetching nearby places from API...');
      print(' Location: ($latitude, $longitude)');

      // Call the API
      final data =
          await apiService.get(
                ApiEndpoints.getNearbyPlaces(latitude, longitude),
                withToken: false,
              )
              as Map<String, dynamic>;

      // Check response status
      if (data['status'] == 'OK') {
        final results = data['results'] as List;
        final places =
            results
                .map((e) => PlaceModel.fromJson(e as Map<String, dynamic>))
                .toList();

        print(' Fetched ${places.length} places from API');

        return places;
      } else if (data['status'] == 'ZERO_RESULTS') {
        // No results in this location
        print(' No nearby places in this location');
        return [];
      } else {
        // API error
        final errorMessage = data['error_message'] ?? 'Unknown API error';
        print('❌ خطأ من API: $errorMessage');
        print('❌ API error: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ فشل جلب الأماكن القريبة: $e');
      print('❌ Failed to fetch nearby places: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getPlaceDetails({
    required String placeId,
  }) async {
    try {
      print('🌐 Fetching place details from API...');
      print(' Place ID: $placeId');

      // Call the API
      final data =
          await apiService.get(
                ApiEndpoints.getPlaceDetails(placeId),
                withToken: false,
              )
              as Map<String, dynamic>;

      // Check response status
      if (data['status'] == 'OK') {
        final result = data['result'] as Map<String, dynamic>;

        print(' Fetched place details from API');

        return result;
      } else if (data['status'] == 'NOT_FOUND') {
        // Place not found
        print(' Place not found');
        throw Exception('Place not found');
      } else {
        // API error
        final errorMessage = data['error_message'] ?? 'Unknown API error';
        print(' API error: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print(' Failed to fetch place details: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getRecommendedPlaces({
    required String placeId,
  }) async {
    try {
      print('🌐 Fetching recommended places from API...');

      // First: Get place details to know its location
      final placeDetails = await getPlaceDetails(placeId: placeId);

      // Extract geographic location
      final geometry = placeDetails['geometry'] as Map<String, dynamic>?;
      if (geometry == null) {
        throw Exception('Place geometry not found');
      }

      final location = geometry['location'] as Map<String, dynamic>?;
      if (location == null) {
        throw Exception('Place location not found');
      }

      final lat = (location['lat'] as num).toDouble();
      final lng = (location['lng'] as num).toDouble();

      print('Place location: ($lat, $lng)');

      // Second: Fetch nearby places from the same location
      final nearbyPlaces = await getNearbyPlaces(latitude: lat, longitude: lng);

      // Third: Filter places to remove the original place
      final recommendedPlaces =
          nearbyPlaces.where((place) => place.placeId != placeId).toList();

      print(' Fetched ${recommendedPlaces.length} recommended places');

      // Return data in same API format
      return {
        'status': 'OK',
        'results': recommendedPlaces.map((p) => p.toJson()).toList(),
        'based_on_place_id': placeId,
      };
    } catch (e) {
      print('❌ Failed to fetch recommended places: $e');
      rethrow;
    }
  }
}
