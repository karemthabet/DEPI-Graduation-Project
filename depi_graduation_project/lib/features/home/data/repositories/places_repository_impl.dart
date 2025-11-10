import 'package:dartz/dartz.dart';
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

      final data =
          await apiService.get(
                ApiEndpoints.getNearbyPlaces(pos.latitude, pos.longitude),
              )
              as Map<String, dynamic>;

      if (data['status'] == 'OK') {
        final results = data['results'] as List;
        return results.map((e) => PlaceModel.fromJson(e)).toList();
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
