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

  //save last list for cache
  List<FavouriteModel> _cachedFavorites = [];

  FavoritesCubit({required this.repository}) : super(FavoritesInitial()) {
    _monitorInternetConnection();
  }

  void _monitorInternetConnection() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) {
      if (result.contains(ConnectivityResult.none)) {
        emit(FavoritesNoInternet());
      } else {
        // if state is FavoritesNoInternet or FavoritesError, load favorites
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

  Future<void> loadFavorites({bool forceReload = false}) async {
    // if there is cached data and forceReload is false
    if (_cachedFavorites.isNotEmpty && !forceReload) {
      emit(FavoritesLoaded(_cachedFavorites));
      return;
    }

    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      if (_cachedFavorites.isNotEmpty) {
        emit(FavoritesLoaded(_cachedFavorites));
      } else {
        emit(FavoritesNoInternet());
      }
      return;
    }

    if (SupabaseService.userId == null) {
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
        (favorites) {
          _cachedFavorites = favorites;
          emit(FavoritesLoaded(favorites));
        },
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
      // if there is cached data
      if (_cachedFavorites.isNotEmpty) {
        emit(FavoritesActionFailure(_cachedFavorites, 'no_internet'));
        emit(FavoritesLoaded(_cachedFavorites));
      } else {
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

    final isFav = _cachedFavorites.any((f) => f.placeId == place.placeId);

    try {
      if (isFav) {
        await repository.removeFavorite(place.placeId, SupabaseService.userId);
        _cachedFavorites =
            _cachedFavorites.where((f) => f.placeId != place.placeId).toList();
      } else {
        await repository.addFavorite(place);
        _cachedFavorites = [..._cachedFavorites, place];
      }
      emit(FavoritesLoaded(_cachedFavorites));
    } catch (e) {
      emit(FavoritesError(
          ServerFailure(errMessage: 'Error updating favourites')));
    }
  }

  bool isFavorite(String? placeId) {
    return _cachedFavorites.any((f) => f.placeId == placeId);
  }

  void clearFavorites() {
    _cachedFavorites = [];
    emit(FavoritesInitial());
  }
}
