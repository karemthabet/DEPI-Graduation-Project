import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../supabase_service.dart';
import '../../data/models/favourite_model.dart';
import '../../data/repositories/favourites_repository.dart';
import 'favourite_state.dart';
import '../../../../core/errors/server_failure.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final IFavoritesRepository repository;
  StreamSubscription? _connectivitySubscription;
  final Connectivity _connectivity = Connectivity();

  FavoritesCubit({required this.repository}) : super(FavoritesInitial()) {
    _monitorInternetConnection();
  }

  void _monitorInternetConnection() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) {
      if (result.contains(ConnectivityResult.none)) {
        emit(FavoritesNoInternet());
      } else {
        if (state is FavoritesNoInternet || state is FavoritesError) {
          loadFavorites();
        }
      }
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }

  Future<void> loadFavorites() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      emit(FavoritesNoInternet());
      return;
    }

    if (SupabaseService.userId == null) {
      // If no user, maybe we don't emit error but just stay initial or empty?
      // But preserving existing behavior:
      emit(
        FavoritesError(
          ServerFailure(errMessage: 'You must log in to see your favourites'),
        ),
      );
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
      emit(
        FavoritesError(
          ServerFailure(errMessage: 'Error loading favourites'),
        ),
      );
    }
  }

  Future<void> toggleFavorite(FavouriteModel place) async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      if (state is FavoritesLoaded) {
        final currentFavorites = (state as FavoritesLoaded).favorites;
        // Emit failure then revert to keep the list visible but trigger listener
        emit(FavoritesActionFailure(currentFavorites, 'no_internet'));
        emit(FavoritesLoaded(currentFavorites));
      } else {
        // If not loaded yet, just show no internet screen
        emit(FavoritesNoInternet());
      }
      return;
    }

    if (SupabaseService.userId == null) {
      emit(
        FavoritesError(
          ServerFailure(errMessage: 'You must log in to update favourites'),
        ),
      );
      return;
    }

    if (state is FavoritesLoaded) {
      final currentState = state as FavoritesLoaded;
      final isFav =
          currentState.favorites.any((f) => f.placeId == place.placeId);

      try {
        if (isFav) {
          await repository.removeFavorite(
            place.placeId,
            SupabaseService.userId,
          );
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
          FavoritesError(
            ServerFailure(errMessage: 'Error updating favourites'),
          ),
        );
        // Revert to loaded state potentially?
        // Current implementation replaces list with Error screen.
        // This might not be desired for toggle.
        // But let's stick to existing behavior for server errors, only handling connectivity as requested.
      }
    }
  }

  bool isFavorite(String? placeId) {
    if (state is FavoritesLoaded) {
      return (state as FavoritesLoaded)
          .favorites
          .any((f) => f.placeId == placeId);
    }
    return false;
  }

  void clearFavorites() {
    emit(FavoritesInitial());
  }
}
