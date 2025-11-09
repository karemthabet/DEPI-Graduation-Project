class ApiBase {
  static const String apiKey = 'AIzaSyDuccoSdICVDXCXY4Qz-HH9GjyIr6YWayY';
  static const String baseUrl = 'https://maps.googleapis.com/maps/api';
}

class ApiEndpoints {
  static String getNearbyPlaces(double lat, double lng) =>
      '/place/nearbysearch/json?location=$lat,$lng&radius=5000&type=tourist_attraction|museum|restaurant|cafe|park|shopping_mall|lodging&key=${ApiBase.apiKey}';

  static String getPlaceDetails(String placeId) =>
      '/place/details/json?place_id=$placeId&fields=name,rating,formatted_address,geometry,photos,website,formatted_phone_number,reviews,editorial_summary,opening_hours&key=${ApiBase.apiKey}';
}

class ApiCodes {
  static const int success = 200;
}
