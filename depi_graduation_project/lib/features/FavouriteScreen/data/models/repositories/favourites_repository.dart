// import '../favourite_model.dart';
//
// abstract class IFavoritesRepository {
//   Future<void> addFavorite(FavouriteModel favorite);
//   Future<void> removeFavorite(String? placeId, String userId);
//   Future<List<FavouriteModel>> getFavorites(String userId);
//   Future<bool> isFavorite(String placeId, String userId);
// }
import 'package:dartz/dartz.dart';
import 'package:whatsapp/core/errors/server_failure.dart';
import '../favourite_model.dart';

abstract class IFavoritesRepository {
  Future<Either<ServerFailure, void>> addFavorite(FavouriteModel favorite);
  Future<Either<ServerFailure, void>> removeFavorite(
    String? placeId,
    String? userId,
  );
  Future<Either<ServerFailure, List<FavouriteModel>>> getFavorites(
    String? userId,
  );
  Future<Either<ServerFailure, bool>> isFavorite(String placeId, String userId);
}
