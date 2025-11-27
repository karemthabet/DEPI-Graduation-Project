import 'package:dartz/dartz.dart';
import '../../../../core/errors/server_failure.dart';
import '../models/place_model.dart';

abstract class PlacesRepository {
  Future<Either<ServerFailure, List<PlaceModel>>> getNearbyPlaces();
  Future<Either<ServerFailure, Map<String, dynamic>>> getPlaceDetails(String placeId);
  Future<Either<ServerFailure, Map<String, dynamic>>> getRecommendedPlaces(String placeId);
  
}
