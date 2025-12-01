import 'package:dartz/dartz.dart';
import '../../../../core/errors/server_failure.dart';
import '../models/place_model.dart';

abstract class PlacesRepository {
  Stream<Either<ServerFailure, List<PlaceModel>>> getNearbyPlaces();
  Stream<Either<ServerFailure, Map<String, dynamic>>> getPlaceDetails(
    String placeId,
  );
  Stream<Either<ServerFailure, Map<String, dynamic>>> getRecommendedPlaces(
    String placeId,
  );
}
