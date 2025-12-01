class ApiBase {
  static const String apiKey = 'AIzaSyA3FifUzz1TsB2bknK0VARH_45PT_AuyMw';
  static const String baseUrl = 'https://maps.googleapis.com/maps/api';
}

class ApiEndpoints {
  static String getNearbyPlaces(double lat, double lng) =>
      '/place/nearbysearch/json?location=$lat,$lng'
      '&radius=50000' // 50 كيلومتر -  للأماكن القريبة
      '&key=${ApiBase.apiKey}';

  static String getPlaceDetails(String placeId) =>
      '/place/details/json?place_id=$placeId&fields=name,rating,formatted_address,geometry,photos,website,formatted_phone_number,reviews,editorial_summary,opening_hours&key=${ApiBase.apiKey}';
}

class ApiCodes {
  static const int success = 200;
}
