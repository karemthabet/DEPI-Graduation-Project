import 'package:bloc/bloc.dart';
import '../../data/models/favourite_model.dart';
import '../../data/models/repositories/favourites_repository.dart';
import 'favourite_state.dart';
import '../../../../core/errors/server_failure.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final IFavoritesRepository repository;
  final String userId;

  FavoritesCubit({required this.repository, required this.userId})
    : super(FavoritesInitial());

  Future<void> loadFavorites() async {
    emit(FavoritesLoading());
    final result = await repository.getFavorites(userId);

    result.fold(
      (failure) => emit(FavoritesError(failure)),
      (favorites) => emit(FavoritesLoaded(favorites)),
    );
  }

  // Add or remove a place from favorites
  Future<void> toggleFavorite(FavouriteModel place) async {
    if (state is FavoritesLoaded) {
      final currentState = state as FavoritesLoaded;
      final isFav = currentState.favorites.any(
        (f) => f.placeId == place.placeId,
      );

      try {
        if (isFav) {
          await repository.removeFavorite(place.placeId, userId);
          final updated = currentState.favorites
              .where((f) => f.placeId != place.placeId)
              .toList();
          emit(FavoritesLoaded(updated));
        } else {
          await repository.addFavorite(place);
          final updated = [...currentState.favorites, place];
          emit(FavoritesLoaded(updated));
        }
      } catch (e) {
        emit(
          FavoritesError(ServerFailure(errMessage: 'Error updating favorites')),
        );
      }
    }
  }

  // Check if a place is in favorites
  bool isFavorite(String? placeId) {
    if (state is FavoritesLoaded) {
      return (state as FavoritesLoaded).favorites.any(
        (f) => f.placeId == placeId,
      );
    }
    return false;
  }
}
