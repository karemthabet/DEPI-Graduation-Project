import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/place_model.dart';
import '../../data/repositories/places_repository.dart';
import '../../../../core/errors/server_failure.dart';
part 'places_state.dart';

class PlacesCubit extends Cubit<PlacesState> {
  final PlacesRepository repository;

  PlacesCubit(this.repository) : super(PlacesInitial());

  Future<void> loadPlaces() async {
    emit(PlacesLoading());
    final result = await repository.getNearbyPlaces();

    result.fold(
      (failure) => emit(PlacesError(failure: failure)),
      (places) {
        final categorized = _groupByCategory(places);
        emit(PlacesLoaded(places: places, categorized: categorized));
      },
    );
  }

  Map<String, List<PlaceModel>> _groupByCategory(List<PlaceModel> places) {
    final Map<String, List<PlaceModel>> map = {};
    for (var p in places) {
      map.putIfAbsent(p.category, () => []).add(p);
    }
    return map;
  }

  Future<void> loadPlaceDetails(String placeId) async {
    emit(PlacesLoading());
    final result = await repository.getPlaceDetails(placeId);

    result.fold(
      (failure) => emit(PlacesError(failure: failure)),
      (details) => emit(PlaceDetailsLoaded(details: details)),
    );
  }
}
