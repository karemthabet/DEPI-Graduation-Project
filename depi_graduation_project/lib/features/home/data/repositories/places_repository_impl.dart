import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:whatsapp/core/helper/base_repo.dart';
import '../models/cached_places_model.dart';
import 'package:whatsapp/core/services/api_service.dart';
import 'package:whatsapp/core/services/location_service.dart';
import 'package:whatsapp/core/utils/constants/api_constants.dart';
import '../models/place_model.dart';
import 'places_repository.dart';
import '../../../../core/errors/server_failure.dart';

class PlacesRepositoryImpl extends BaseRepo implements PlacesRepository {
  final ApiService apiService;

  PlacesRepositoryImpl({required this.apiService});

  @override
  Future<Either<ServerFailure, List<PlaceModel>>> getNearbyPlaces() async {
    return safeCall(() async {
      final pos = await LocationService.instance.getCurrentLocation();
      final box = Hive.box<CachedPlacesModel>('places_cache');

      // Check for cached places within 500m
      CachedPlacesModel? cachedEntry;
      for (var entry in box.values) {
        final distance = Geolocator.distanceBetween(
          pos.latitude,
          pos.longitude,
          entry.lat,
          entry.lng,
        );
        if (distance < 500) {
          cachedEntry = entry;
          break;
        }
      }

      if (cachedEntry != null) {
        print('Loaded from Hive cache');
        return cachedEntry.places;
      }

      // Fetch from API
      final data =
          await apiService.get(
                ApiEndpoints.getNearbyPlaces(pos.latitude, pos.longitude),
              )
              as Map<String, dynamic>;

      if (data['status'] == 'OK') {
        final results = data['results'] as List;
        final places = results.map((e) => PlaceModel.fromJson(e)).toList();
        print(places);

        // Save to Hive
        final newEntry = CachedPlacesModel(
          lat: pos.latitude,
          lng: pos.longitude,
          places: places,
        );
        await box.add(newEntry);
        print('Saved to Hive cache');

        return places;
      } else {
        throw Exception(data['error_message'] ?? 'Error loading places');
      }
    });
  }

  @override
  Future<Either<ServerFailure, Map<String, dynamic>>> getPlaceDetails(
    String placeId,
  ) async {
    return safeCall(() async {
      final data =
          await apiService.get(ApiEndpoints.getPlaceDetails(placeId))
              as Map<String, dynamic>;

      if (data['status'] == 'OK') {
        return data['result'];
      } else {
        throw Exception(data['error_message'] ?? 'Error loading place details');
      }
    });
  }
}
