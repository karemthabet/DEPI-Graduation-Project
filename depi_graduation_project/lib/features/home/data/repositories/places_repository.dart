import '../models/place_model.dart';

abstract class PlacesRepository {
  Future<List<PlaceModel>> getNearbyPlaces();
  Future<Map<String, dynamic>> getPlaceDetails(String placeId);
}
