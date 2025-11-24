import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:whatsapp/core/Cached/get_storage.dart';
import 'package:whatsapp/core/helper/base_repo.dart';
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
      final cachedPlacesJson = GetStoragePrefs.read<List>('cached_places');
      final cachedLat = GetStoragePrefs.read<double>('last_lat');
      final cachedLng = GetStoragePrefs.read<double>('last_lng');
      bool shouldFetchFromApi = true;
      if (cachedPlacesJson != null && cachedLat != null && cachedLng != null) {
        final distance = Geolocator.distanceBetween(
          pos.latitude,
          pos.longitude,
          cachedLat,
          cachedLng,
        );

        if (distance < 500) {
          shouldFetchFromApi = false;
        }
      }

      if (shouldFetchFromApi) {
        final data =
            await apiService.get(
                  ApiEndpoints.getNearbyPlaces(pos.latitude, pos.longitude),
                )
                as Map<String, dynamic>;

        if (data['status'] == 'OK') {
          final results = data['results'] as List;
          final places = results.map((e) => PlaceModel.fromJson(e)).toList();
          await GetStoragePrefs.write(
            'cached_places',
            places.map((e) => e.toJson()).toList(),
          );
          await GetStoragePrefs.write('last_lat', pos.latitude);
          await GetStoragePrefs.write('last_lng', pos.longitude);
          print('done cache');
          print(GetStoragePrefs.read('cached_places'));
          print('CACHED  = $cachedLat, $cachedLng');
          print(GetStoragePrefs.read('last_lat')?.runtimeType);

          return places;
        } else {
          throw Exception(data['error_message'] ?? 'Error loading places');
        }
      } else {
        print('get from cache');
        return cachedPlacesJson!.map((e) => PlaceModel.fromJson(e)).toList();
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
