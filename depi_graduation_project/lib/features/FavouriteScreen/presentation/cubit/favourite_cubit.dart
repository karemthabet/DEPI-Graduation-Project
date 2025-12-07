import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../supabase_service.dart';
import '../../data/models/favourite_model.dart';
import '../../data/models/repositories/favourites_repository.dart';
import 'favourite_state.dart';
import '../../../../core/errors/server_failure.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final IFavoritesRepository repository;

  FavoritesCubit({required this.repository}) : super(FavoritesInitial());

  Future<void> loadFavorites() async {

    if (SupabaseService.userId == null) {
      emit(FavoritesError(ServerFailure(errMessage: 'You must log in to see your favourites')));
      return;
    }

    emit(FavoritesLoading());

    try {
      final result = await repository.getFavorites(SupabaseService.userId);

      result.fold(
        (failure) => emit(FavoritesError(failure)),
        (favorites) => emit(FavoritesLoaded(favorites)),
      );
    } catch (e) {
      emit(FavoritesError(ServerFailure(errMessage: 'Error loading favourites')));
    }
  }

  Future<void> toggleFavorite(FavouriteModel place) async {
    if (SupabaseService.userId == null) {
      emit(FavoritesError(ServerFailure(errMessage: 'You must log in to update favourites')));
      return;
    }

    if (state is FavoritesLoaded) {
      final currentState = state as FavoritesLoaded;
      final isFav = currentState.favorites.any((f) => f.placeId == place.placeId);

      try {
        if (isFav) {
          await repository.removeFavorite(place.placeId, SupabaseService.userId);
          final updated = currentState.favorites.where((f) => f.placeId != place.placeId).toList();
          emit(FavoritesLoaded(updated));
        } else {
          await repository.addFavorite(place);
          final updated = [...currentState.favorites, place];
          emit(FavoritesLoaded(updated));
        }
      } catch (e) {
        emit(FavoritesError(ServerFailure(errMessage: 'Error updating favourites')));
      }
    }
  }

  bool isFavorite(String? placeId) {
    if (state is FavoritesLoaded) {
      return (state as FavoritesLoaded).favorites.any((f) => f.placeId == placeId);
    }
    return false;
  }
  void clearFavorites() {
    emit(FavoritesInitial());
  }
}
