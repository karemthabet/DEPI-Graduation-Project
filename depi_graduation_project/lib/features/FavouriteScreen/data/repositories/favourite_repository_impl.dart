import 'package:dartz/dartz.dart';
import 'package:whatsapp/core/errors/server_failure.dart';
import 'package:whatsapp/core/helper/base_repo.dart';
import 'package:whatsapp/features/FavouriteScreen/data/models/favourite_model.dart';
import 'package:whatsapp/supabase_service.dart';
import 'favourites_repository.dart';

class FavoritesRepositoryImpl extends BaseRepo implements IFavoritesRepository {
  final supabase = SupabaseService.client;

  @override
  Future<Either<ServerFailure, void>> addFavorite(
    FavouriteModel favorite,
  ) async {
    return safeCall(() async {
      await supabase.from('favorites').insert({
        'user_id': favorite.userId,
        'place_id': favorite.placeId,
        'title': favorite.title,
        'location': favorite.location,
        'image_url': favorite.imageUrl,
        'rating': favorite.rating,
      });
    });
  }

  @override
  Future<Either<ServerFailure, void>> removeFavorite(
    String? placeId,
    String ?userId,
  ) async {
    return safeCall(() async {
      await supabase
          .from('favorites')
          .delete()
          .eq('place_id', placeId!)
          .eq('user_id', userId!);
    });
  }

  @override
  Future<Either<ServerFailure, List<FavouriteModel>>> getFavorites(
    String? userId,
  ) async {
    return safeCall(() async {
      final response =
          await supabase.from('favorites').select().eq('user_id', userId!)
              as List<dynamic>;
      return response.map((e) => FavouriteModel.fromSupabase(e)).toList();
    });
  }

  @override
  Future<Either<ServerFailure, bool>> isFavorite(
    String placeId,
    String userId,
  ) async {
    return safeCall(() async {
      final response = await supabase
          .from('favorites')
          .select()
          .eq('user_id', userId)
          .eq('place_id', placeId);
      return response.isNotEmpty;
    });
  }
}
