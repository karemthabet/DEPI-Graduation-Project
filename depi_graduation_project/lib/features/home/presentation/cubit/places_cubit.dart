import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/errors/server_failure.dart';
import '../../data/models/place_model.dart';
import '../../data/repositories/places_repository.dart';
import '../../../../core/utils/constants/app_constants.dart';

part 'places_state.dart';

class PlacesCubit extends Cubit<PlacesState> {
  final PlacesRepository repository;

  PlacesCubit(this.repository) : super(PlacesInitial());

  Future<void> loadPlaces() async {
    emit(PlacesLoading());
    final result = await repository.getNearbyPlaces();
    result.fold((failure) => emit(PlacesError(failure: failure)), (places) {
      final categorized = _groupByCategory(places);
      final availableCategories = getAvailableCategories(categorized);
      final topRecommendations = getTopRecommendations(places, limit: 10);
      emit(
        PlacesLoaded(
          places: places,
          categorized: categorized,
          availableCategories: availableCategories,
          topRecommendations: topRecommendations,
        ),
      );
    });
  }

  Map<String, List<PlaceModel>> _groupByCategory(List<PlaceModel> places) {
    final Map<String, List<PlaceModel>> map = {};
    for (var p in places) {
      final category = p.category.toLowerCase();
      if (AppConstants.categories.containsKey(category)) {
        map.putIfAbsent(category, () => []).add(p);
      } else {
        map.putIfAbsent('others', () => []).add(p);
      }
    }
    return map;
  }

  Map<String, String> getAvailableCategories(
    Map<String, List<PlaceModel>> categorized,
  ) {
    final availableCategories = AppConstants.categories.entries
        .where(
          (entry) =>
              categorized.containsKey(entry.key) &&
              categorized[entry.key]!.isNotEmpty,
        )
        .toList();

    availableCategories.sort((a, b) {
      if (a.key == 'others') return 1;
      if (b.key == 'others') return -1;
      return 0;
    });

    return {for (var e in availableCategories) e.key: e.value};
  }

  List<PlaceModel> getTopRecommendations(
    List<PlaceModel> places, {
    int limit = 10,
  }) {
    final ratedPlaces = places.where((p) => p.rating != null).toList();
    ratedPlaces.sort((a, b) => b.rating!.compareTo(a.rating!));
    return ratedPlaces.take(limit).toList();
  }
}
